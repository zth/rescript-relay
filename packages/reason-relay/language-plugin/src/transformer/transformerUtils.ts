import { Node, Fragment, Argument, IRVisitor } from "relay-compiler";

type operationType = {
  tag: "Mutation" | "Subscription" | "Fragment" | "Query";
  value: string | [string, boolean];
};

type printConfig = {
  variablesHoldingConnectionIds?: null | string[];
  connection?: null | {
    key: string;
    atObjectPath: string[];
    fieldName: string;
  };
};

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
        const connDirective = n.directives.find((d) => d.name === "connection");

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
                fieldName: n.name,
              },
            };
          }
        }

        /**
         * Extract store updater directives
         */
        const storeUpdaterDirectivesWithConnectionsArg = n.directives.filter(
          (d) =>
            [
              "appendNode",
              "prependNode",
              "appendEdge",
              "prependEdge",
              "deleteEdge",
            ].includes(d.name)
        );

        if (storeUpdaterDirectivesWithConnectionsArg.length > 0) {
          storeUpdaterDirectivesWithConnectionsArg.forEach((d) => {
            const arg = d.args.find((a) => a.name === "connections");

            const argValue = arg?.value;

            if (argValue && argValue.kind === "Variable") {
              if (opInfo.variablesHoldingConnectionIds) {
                opInfo.variablesHoldingConnectionIds.push(
                  argValue.variableName
                );
              } else {
                opInfo.variablesHoldingConnectionIds = [argValue.variableName];
              }
            }
          });
        }

        path.push(n.name);
      },
      InlineFragment(n) {
        if (n.typeCondition.name) {
          n.selections.forEach((s) => {
            visitWithPath([...path, n.typeCondition.name.toLowerCase()], s);
          });
        }
      },
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
          value: node.name,
        };
      case "query":
        return {
          tag: "Query",
          value: node.name,
        };
      case "subscription":
        return {
          tag: "Subscription",
          value: node.name,
        };
    }
  } else if (node.kind == "Fragment") {
    return {
      tag: "Fragment",
      value: [node.name, Boolean(node.metadata && node.metadata.plural)],
    };
  }

  throw new Error("Could not map root node. This should not happen.");
}
