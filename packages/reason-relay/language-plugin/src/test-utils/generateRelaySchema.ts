import { IRTransforms, Schema } from "relay-compiler";
const getLanguagePlugin = require("../index");

const generateRelaySchema = (testSchema: Schema, extraDefs: string = "") =>
  testSchema.extend([
    ...IRTransforms.schemaExtensions,
    ...getLanguagePlugin().schemaExtensions,
    extraDefs,
  ]);

export default generateRelaySchema;
