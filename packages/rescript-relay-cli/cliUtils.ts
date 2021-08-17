import {
  ASTNode,
  BREAK,
  FieldNode,
  FragmentDefinitionNode,
  OperationDefinitionNode,
  visit,
} from "graphql";
import { getLocator } from "locate-character";
import { format } from "prettier/standalone";
import * as parserGraphql from "prettier/parser-graphql";

export interface GraphQLSourceFromTag {
  content: string;
  start: number;
  end: number;
}

/**
 * A helper for extracting GraphQL operations from source via a regexp.
 * It assumes that the only thing the regexp matches is the actual content,
 * so if that's not true for your regexp you probably shouldn't use this
 * directly.
 */
export let makeExtractTagsFromSource =
  (regexp: RegExp): ((text: string) => Array<GraphQLSourceFromTag>) =>
  (text: string): Array<GraphQLSourceFromTag> => {
    const locator = getLocator(text);
    const sources: Array<GraphQLSourceFromTag> = [];
    let result;
    while ((result = regexp.exec(text)) !== null) {
      let start = locator(result.index);
      let end = locator(result.index + result[0].length);

      sources.push({
        content: result[0],
        start: start.character,
        end: end.character,
      });
    }

    return sources;
  };

const rescriptGraphQLTagsRegexp = new RegExp(
  /(?<=\%relay\([\s]*`)[\s\S.]+?(?=`[\s]*\))/g
);

export const extractGraphQLSourceFromReScript = makeExtractTagsFromSource(
  rescriptGraphQLTagsRegexp
);

export function prettify(str: string): string {
  return (
    format(str, {
      parser: "graphql",
      plugins: [parserGraphql],
    })
      /**
       * Prettier adds a new line to the output by design.
       * This circumvents that as it messes things up.
       */

      .replace(/^\s+|\s+$/g, "")
  );
}

export const padOperation = (operation: string, indentation: number): string =>
  operation
    .split("\n")
    .map((s: string) => " ".repeat(indentation) + s)
    .join("\n");

const initialWhitespaceRegexp = new RegExp(/^[\s]*(?=[\w])/g);
const endingWhitespaceRegexp = new RegExp(/[\s]*$/g);

export const findOperationPadding = (operation: string): number => {
  const initialWhitespace = (
    operation.match(initialWhitespaceRegexp) || []
  ).pop();
  const firstRelevantLine = (initialWhitespace || "").split("\n").pop();

  return firstRelevantLine ? firstRelevantLine.length : 0;
};

export const restoreOperationPadding = (
  operation: string,
  initialOperation: string
): string => {
  const endingWhitespace = (
    initialOperation.match(endingWhitespaceRegexp) || []
  ).join("");

  return (
    "\n" +
    padOperation(operation, findOperationPadding(initialOperation)) +
    endingWhitespace
  );
};

interface RemoveUnusedFieldsFromFragmentConfig {
  definition: FragmentDefinitionNode | OperationDefinitionNode;
  unusedFieldPaths: string[];
}

const isNodeInterfaceWithSingleMember = (
  definition: FragmentDefinitionNode | OperationDefinitionNode
) => {
  const nodeSelection = definition.selectionSet.selections.find(
    (d) => d.kind === "Field" && d.name.value === "node"
  );

  if (nodeSelection?.kind === "Field") {
    const inlineFragmentSelections =
      nodeSelection.selectionSet?.selections.filter(
        (s) => s.kind === "InlineFragment"
      );

    return inlineFragmentSelections?.length === 1;
  }

  return false;
};

const namedPathOfAncestors = (
  ancestors: ReadonlyArray<ASTNode | ReadonlyArray<ASTNode>> | null
): string =>
  (ancestors || [])
    .reduce((acc: string[], next) => {
      if (Array.isArray(next)) {
        return acc;
      }
      const node = next as ASTNode;

      switch (node.kind) {
        case "Field":
          return [...acc, node.name.value];
        case "InlineFragment":
          return [...acc, node.typeCondition?.name.value ?? ""];
        default:
          return acc;
      }
    }, [])
    .join("_");

interface getPathAssetsConfig {
  unusedFieldPaths: string[];
  fieldName: string;
  ancestors: ReadonlyArray<ASTNode | ReadonlyArray<ASTNode>> | null;
}

const getPathAssets = ({
  unusedFieldPaths,
  fieldName,
  ancestors,
}: getPathAssetsConfig) => {
  const namedPath = namedPathOfAncestors(ancestors);
  const path =
    namedPath === ""
      ? fieldName
      : [namedPathOfAncestors(ancestors), fieldName].join("_");

  const fieldNamePrefix = `${path}.`;
  const fieldsToRemove = unusedFieldPaths
    .filter((p) => p.startsWith(fieldNamePrefix))
    .map((p) => p.slice(fieldNamePrefix.length));

  return {
    fieldsToRemove,
    shouldRemoveFullSelection: unusedFieldPaths.includes(path),
    path,
    ancestorPath: namedPath,
  };
};

export const removeUnusedFieldsFromOperation = ({
  definition,
  unusedFieldPaths,
}: RemoveUnusedFieldsFromFragmentConfig):
  | FragmentDefinitionNode
  | OperationDefinitionNode
  | null => {
  let shouldRemoveEntireQuery = false;

  const processed = visit(definition, {
    InlineFragment(node, _a, _b, _c, ancestors) {
      // This handles selections directly on fragment spreads.
      if (node.typeCondition == null) return node;

      const namedPath = namedPathOfAncestors(ancestors);

      /**
       * Handle node interface special treatment, where RescriptRelay transforms
       * a selection on the Node interface to a single field instead of a union.
       */
      const nodeInterfaceSpecialTreatment =
        namedPath === "node" && isNodeInterfaceWithSingleMember(definition);

      const thisPath = nodeInterfaceSpecialTreatment
        ? namedPath
        : [namedPath, node.typeCondition.name.value]
            .filter((item) => item !== "")
            .join("_");

      const prefixedPath = `${thisPath}.`;
      const fieldsToRemoveOnInlineFragment = unusedFieldPaths
        .filter((p) => p.startsWith(prefixedPath))
        .map((p) => p.slice(prefixedPath.length));

      if (fieldsToRemoveOnInlineFragment.length > 0) {
        const shouldRemoveFragmentSpreads =
          fieldsToRemoveOnInlineFragment.includes("fragmentRefs");

        const newSelectionSet = {
          ...node.selectionSet,
          selections: node.selectionSet.selections.filter((selection) => {
            if (
              selection.kind === "FragmentSpread" &&
              shouldRemoveFragmentSpreads
            ) {
              return false;
            }

            if (selection.kind === "Field") {
              const fieldName = selection.alias?.value ?? selection.name.value;
              return !fieldsToRemoveOnInlineFragment.includes(fieldName);
            }

            return true;
          }),
        };

        if (newSelectionSet.selections.length === 0) {
          return null;
        }

        return {
          ...node,
          selectionSet: newSelectionSet,
        };
      }

      return node;
    },
    FragmentDefinition(node) {
      const fieldsToRemoveOnFragment = unusedFieldPaths.filter(
        (p) => !p.includes(".")
      );

      const shouldRemoveFragmentSpreads =
        fieldsToRemoveOnFragment.includes("fragmentRefs");

      if (fieldsToRemoveOnFragment.length > 0) {
        const newSelectionSet = {
          ...node.selectionSet,
          selections: node.selectionSet.selections.filter((selection) => {
            if (
              selection.kind === "FragmentSpread" &&
              shouldRemoveFragmentSpreads
            ) {
              return false;
            }

            if (selection.kind === "Field") {
              const fieldName = selection.alias?.value ?? selection.name.value;
              return !fieldsToRemoveOnFragment.includes(fieldName);
            }

            return true;
          }),
        };

        if (newSelectionSet.selections.length === 0) {
          shouldRemoveEntireQuery = true;
          return BREAK;
        }

        return {
          ...node,
          selectionSet: newSelectionSet,
        };
      }

      return node;
    },
    OperationDefinition(node) {
      if (node.operation !== "query") {
        return node;
      }

      const fieldsToRemoveOnQuery = unusedFieldPaths.filter(
        (p) => !p.includes(".")
      );

      const shouldRemoveFragmentSpreads =
        fieldsToRemoveOnQuery.includes("fragmentRefs");

      if (fieldsToRemoveOnQuery.length > 0) {
        const newSelectionSet = {
          ...node.selectionSet,
          selections: node.selectionSet.selections.filter((selection) => {
            if (
              selection.kind === "FragmentSpread" &&
              shouldRemoveFragmentSpreads
            ) {
              return false;
            }

            if (selection.kind === "Field") {
              const fieldName = selection.alias?.value ?? selection.name.value;
              return !fieldsToRemoveOnQuery.includes(fieldName);
            }

            return true;
          }),
        };

        if (newSelectionSet.selections.length === 0) {
          shouldRemoveEntireQuery = true;
          return BREAK;
        }

        return {
          ...node,
          selectionSet: newSelectionSet,
        };
      }

      return node;
    },
    Field(node, _key, _parent, _path, ancestors) {
      const fieldName = node.alias?.value ?? node.name.value;

      const { fieldsToRemove, shouldRemoveFullSelection } = getPathAssets({
        unusedFieldPaths,
        fieldName,
        ancestors,
      });

      if (shouldRemoveFullSelection) {
        return null;
      }

      if (fieldsToRemove.length > 0) {
        const shouldRemoveFragmentSpreads =
          fieldsToRemove.includes("fragmentRefs");

        const newSelections = node.selectionSet?.selections?.filter(
          (selection) => {
            if (
              selection.kind === "FragmentSpread" &&
              shouldRemoveFragmentSpreads
            ) {
              return false;
            }

            if (selection.kind === "Field") {
              const fieldName = selection.alias?.value ?? selection.name.value;

              return !fieldsToRemove.includes(fieldName);
            }

            return true;
          }
        );

        const typenameNode: FieldNode = {
          kind: "Field",
          name: {
            kind: "Name",
            value: "__typename",
          },
        };

        return {
          ...node,
          selectionSet: {
            kind: "SelectionSet",
            selections:
              /**
               * If there's no selections left, but the entire field isn't
               * scheduled for removal, add a dummy __typename to the selection.
               * This happens when a field is pattern matched on (for existance)
               * but no sub fields are selected.
               */
              newSelections?.length === 0 ? [typenameNode] : newSelections,
          },
        };
      }

      return node;
    },
  });

  if (shouldRemoveEntireQuery) {
    return null;
  }

  return processed;
};

export interface IRepresentation {
  type: "fragment" | "query";
  graphqlName: string;
  unusedFieldPaths: string[];
}

export interface IFragmentRepresentationWithSourceLocation
  extends IRepresentation {
  sourceLocation: string;
}

const graphqlNameRegexp = new RegExp(
  /(?<=__generated__\/)[A-Za-z_0-9]+(?=_graphql\.res)/g
);
const fieldPathRegexp = new RegExp(
  /(?<=Types\.(fragment|response)[_.])[A-Za-z_.0-9]+(?= )/g
);

const filterRegexp = new RegExp(/Types\.(fragment|response)/g);

export const processReanalyzeOutput = (output: string) => {
  const processed = output
    // Parse reanalyze output
    .split(/\n\n/g)

    // Filter out interesting records
    .filter((s) => s.match(filterRegexp))

    // Extract the target file names + actual unused fields (record names/patterns)
    .reduce((acc: Record<string, IRepresentation>, curr) => {
      const type = curr.includes("Types.fragment") ? "fragment" : "query";

      const graphqlName = curr.match(graphqlNameRegexp)?.[0];
      const fileName =
        graphqlName == null ? null : `${graphqlName}_graphql.res`;
      const fieldPath = curr.match(fieldPathRegexp)?.[0];

      // We only care about queries
      if (type === "query" && !graphqlName?.toLowerCase().endsWith("query")) {
        return acc;
      }

      // Ignore top level `id`, since Relay seems to add these when using
      // @refetchable, regardless of if they're used or not.
      if (fieldPath === "id") {
        return acc;
      }

      // Ignore `__typename`, since that's occasionally needed for unions etc.
      // This might change in the future, but right now it needs to be ignored.
      if (fieldPath?.endsWith("__typename")) {
        return acc;
      }

      if (graphqlName == null || fieldPath == null || fileName == null) {
        return acc;
      }

      acc[fileName] = acc[fileName] || {
        type,
        graphqlName: graphqlName,
        unusedFieldPaths: [],
      };
      acc[fileName].unusedFieldPaths.push(fieldPath);

      return acc;
    }, {});

  return processed;
};

export const maybePluralize = (str: string, num: number): string => {
  if (num === 1) {
    return `${num} ${str}`;
  }

  return `${num} ${str}s`;
};
