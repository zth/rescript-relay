module.exports = {
  roots: ["<rootDir>/src"],
  transform: {
    "^.+\\.jsx?$": require.resolve("babel-jest"),
    "^.+\\.tsx?$": "ts-jest"
  },
  transformIgnorePatterns: ["node_modules/(?!(bs-platform)/)"],
  testMatch: ["**/__tests__/**/*.ts?(x)", "**/?(*.)+(spec|test).ts?(x)"]
};
