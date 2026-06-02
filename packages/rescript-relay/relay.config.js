module.exports = {
  schema: "./__tests__/schema.graphql",
  artifactDirectory: "./__tests__/__generated__",
  src: "./__tests__",
  language: "rescript",
  customScalarTypes: {
    Datetime: "TestsUtils.Datetime",
    IntString: "TestsUtils.IntString",
    JSON: "Js.Json.t",
    Number: "TestsUtils.Number",
  },
  schemaExtensions: ["./__tests__"],
};
