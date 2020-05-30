module.exports = {
  schema: "./__tests__/schema.graphql",
  artifactDirectory: "./__tests__/__generated__",
  src: "./__tests__",
  language: require.resolve(
    "./language-plugin/dist/reason-relay-language-plugin"
  ),
  customScalars: {
    Datetime: "TestsUtils.Datetime",
  },
};
