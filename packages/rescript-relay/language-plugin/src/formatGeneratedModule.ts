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

  const lines = [
    typeText || "",
    ...referencedNodes
      .map(
        ({ moduleName, identifier }) => `let ${identifier} = ${moduleName}.node;`
      ),
    `let node: operationType = %raw(json\` ${processedText} \`)`,
    "",
    preloadText,
    ""
  ];
  return lines.join("\n");
};

module.exports = formatGeneratedModule;
