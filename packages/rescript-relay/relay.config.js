const PERSISTING = Boolean(process.env.ENABLE_PERSISTING);

module.exports = {
  schema: "./__tests__/schema.graphql",
  artifactDirectory: PERSISTING
    ? "./__tests_preloaded__/__generated__"
    : "./__tests__/__generated__",
  src: PERSISTING ? "./__tests_preloaded__" : "./__tests__",
  language: "rescript",
  customScalarTypes: {
    Datetime: "TestsUtils.Datetime",
    IntString: "TestsUtils.IntString",
    ObjectScalar1: "TestsUtils.ObjectScalar1",
    ObjectScalar2: "TestsUtils.ObjectScalar2",
    JSON: "JSON.t",
    Number: "TestsUtils.Number",
  },
  persistConfig: PERSISTING
    ? {
        file: "./persistedQueries.json",
        algorithm: "MD5",
      }
    : undefined,
};
