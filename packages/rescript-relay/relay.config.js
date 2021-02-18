module.exports = {
  schema: "./__tests__/schema.graphql",
  artifactDirectory: "./__tests__/__generated__",
  src: "./__tests__",
  language: require.resolve("./language-plugin/dist/index"),
  customScalars: {
    Datetime: "TestsUtils.Datetime",
  },
};
