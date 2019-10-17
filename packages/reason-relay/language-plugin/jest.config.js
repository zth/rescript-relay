module.exports = {
  roots: ["<rootDir>/src"],
  transform: {
    "^.+\\.jsx?$": require.resolve("babel-jest"),
    "^.+\\.tsx?$": "ts-jest"
  },
  transformIgnorePatterns: ["node_modules/(?!(bs-platform)/)"]
};
