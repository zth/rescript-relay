const PERSISTING = Boolean(process.env.ENABLE_PERSISTING);

module.exports = {
  testEnvironment: "jsdom",
  bail: true,
  testRegex: PERSISTING
    ? "/__tests_preloaded__/.*-tests.js$"
    : "/__tests__/.*-tests.js$",
  roots: PERSISTING
    ? ["<rootDir>/__tests_preloaded__"]
    : ["<rootDir>/__tests__"],
  setupFilesAfterEnv: ["<rootDir>/__tests__/jestSetup.js"],
};
