import { CompilerContext, Schema } from "relay-compiler";
import * as RescriptRelayGenerator from "../RescriptRelayGenerator";
import generateRelaySchema from "./generateRelaySchema";
import parseGraphQLText from "./parseGraphQLText";

const generate = (testSchema: Schema) => (
  text: string,
  options?: any,
  extraDefs: string = ""
): string => {
  const { definitions, schema: extendedSchema } = parseGraphQLText(
    generateRelaySchema(testSchema, extraDefs),
    text
  );

  const ctx = new CompilerContext(extendedSchema)
    .addAll(definitions)
    .applyTransforms(RescriptRelayGenerator.transforms);

  return ctx
    .documents()
    .map(
      (doc: any) =>
        `// ${doc.name}.graphql\n${RescriptRelayGenerator.generate(
          extendedSchema,
          doc,
          {
            normalizationIR: ctx.get(doc.name),
            optionalInputFields: [],
            ...options,
          }
        )}`
    )
    .join("\n\n");
};

export default generate;
