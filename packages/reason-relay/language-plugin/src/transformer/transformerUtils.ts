import { Node, Fragment, Selection, Argument, IRVisitor } from "relay-compiler";
import { operationType, printConfig } from "../generator/Types.gen";
import { GraphQLObjectType } from "graphql";

/**
 * Use this to extract info needed for Reason type generation, like info
 * about connections and other directives.
 */
export function extractOperationInfo(node: Node | Fragment): printConfig {
  let opInfo: printConfig = {};

  function visitWithPath(path: Array<string>, node: any) {
    IRVisitor.visit(node, {
      LinkedField(n) {
        /**
         * Extract connection directive info
         */
        const connDirective = n.directives.find(d => d.name === "connection");

        if (connDirective && !opInfo.connection) {
          let key = null;
          connDirective.args.forEach((a: Argument) => {
            if (a.name === "key" && a.value.kind === "Literal") {
              key = a.value.value as string;
            }
          });

          if (key) {
            opInfo = {
              ...opInfo,
              connection: {
                key,
                atObjectPath: [...path],
                fieldName: n.name
              }
            };
          }
        }

        path.push(n.name);
      },
      InlineFragment(n) {
        if (n.typeCondition.name) {
          n.selections.forEach(s => {
            visitWithPath([...path, n.typeCondition.name.toLowerCase()], s);
          });
        }
      }
    });
  }

  const rootType = node.kind === "Fragment" ? "fragment" : "response";

  if (!rootType) {
    return opInfo;
  }

  visitWithPath([rootType], node);

  return opInfo;
}

export function makeOperationDescriptor(node: Node | Fragment): operationType {
  if (node.kind === "Root") {
    switch (node.operation) {
      case "mutation":
        return {
          tag: "Mutation",
          value: node.name
        };
      case "query":
        return {
          tag: "Query",
          value: node.name
        };
      case "subscription":
        return {
          tag: "Subscription",
          value: node.name
        };
    }
  } else if (node.kind == "Fragment") {
    return {
      tag: "Fragment",
      value: [node.name, Boolean(node.metadata && node.metadata.plural)]
    };
  }

  throw new Error("Could not map root node. This should not happen.");
}
