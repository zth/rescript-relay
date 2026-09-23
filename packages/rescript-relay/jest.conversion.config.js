const config = require("./jest.config");
module.exports = {
  ...config,
  bail: false,
  testRegex: "/__tests__/utils.*-tests.js$",
  roots: ["<rootDir>/__tests__"],
  collectCoverage: true,
  collectCoverageFrom: ["src/utils.js", "src/prepareConversion.js"],
  coverageDirectory: "<rootDir>/coverage/conversion",
  coverageThreshold: {
    "./src/prepareConversion.js": {
      branches: 95,
      functions: 100,
      lines: 100,
      statements: 98,
    },
    "./src/utils.js": {
      branches: 95,
      functions: 100,
      lines: 100,
      statements: 98,
    },
  },
};
