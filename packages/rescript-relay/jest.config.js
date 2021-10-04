module.exports = {
  testEnvironment: "jsdom",
  bail: true,
  testRegex: "/__tests__/.*-tests.js$",
  roots: ["<rootDir>/__tests__"],
  setupFilesAfterEnv: ["<rootDir>/__tests__/jestSetup.js"],
};
