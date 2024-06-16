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
    JSON: "Js.Json.t",
    Number: "TestsUtils.Number",
  },
  featureFlags: {
    enable_relay_resolver_transform: true,
  },
  persistConfig: PERSISTING
    ? {
        file: "./persistedQueries.json",
        algorithm: "MD5",
      }
    : undefined,
};
