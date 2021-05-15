module.exports = {
  roots: ["<rootDir>/src"],
  transform: {
    "^.+\\.jsx?$": require.resolve("babel-jest"),
    "^.+\\.tsx?$": "ts-jest",
  },
  testMatch: ["**/__tests__/**/*.ts?(x)", "**/?(*.)+(spec|test).ts?(x)"],
};
