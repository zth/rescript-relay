import { FormatModule } from "relay-compiler";
import { processConcreteText } from "./utils/processConcreteText";

const formatGeneratedModule: FormatModule = ({
  moduleName,
  documentType,
  concreteText,
  typeText,
}) => {
  const preloadText =
    // @ts-ignore The type definitions are actually wrong from DefinitivelyTyped
    documentType === "ConcreteRequest" &&
    moduleName.toLowerCase().endsWith("query_graphql")
      ? `include RescriptRelay.MakeLoadQuery({
    type variables = Types.variables
    type loadedQueryRef = queryRef
    type response = Types.response
    type node = relayOperationNode
    let query = node
    let convertVariables = Internal.convertVariables
  });`
      : "";
  const { processedText, referencedNodes } = processConcreteText(concreteText);
  const rawRelayArtifactJs = `%raw(json\` ${processedText} \`)`;

  const lines = [
    typeText || "",
    ...(referencedNodes.length > 0
      ? /**
         * We "trick" ReScript into handling the imports of refetchable queries if they're present
         * in the generated artifact from the compiler (that the Relay compiler normally outputs
         * static requires for). We do this by:
         *
         * 1. Wrapping creating `node` into a function that returns the `%raw` content we're interested
         * in. This wrapping is necessary so that ReScript does not order the `%raw` block above
         * variable declarations we reference in the generated Relay output.
         *
         * 2. Passing in the reference to the node of each generated module present. We do nothing with
         * those arguments on the ReScript side but run them through our external identity function `reify`,
         * which gets rid of the "warning" from ReScript that they're unused.
         */
        [
          `%%private(let makeNode = (${referencedNodes
            .map(({ identifier }) => identifier)
            .join(", ")}): operationType => {`,
          ...referencedNodes.map(({ identifier }) => `  ignore(${identifier})`),
          `  ${rawRelayArtifactJs}`,
          `})`,
          `let node: operationType = makeNode(${referencedNodes
            .map(({ moduleName }) => `${moduleName}_graphql.node`)
            .join(", ")})`,
        ]
      : [`let node: operationType = ${rawRelayArtifactJs}`]),
    "",
    preloadText,
    "",
  ];
  return lines.join("\n");
};

module.exports = formatGeneratedModule;
