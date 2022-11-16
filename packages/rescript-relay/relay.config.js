module.exports = {
  schema: "./__tests__/schema.graphql",
  artifactDirectory: "./__tests__/__generated__",
  src: "./__tests__",
  language: "rescript",
  customScalars: {
    Datetime: "TestsUtils.Datetime",
    IntString: "TestsUtils.IntString",
    JSON: "Js.Json.t",
    SomeRecord: "TestsUtils.SomeRecord",
  },
  featureFlags: {
    enable_relay_resolver_transform: true,
  },
};
