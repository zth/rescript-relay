const path = require("path");
const nodeExternals = require("webpack-node-externals");

module.exports = {
  mode: "production",
  entry: "./src/index.ts",
  target: "node",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "index.js",
    libraryTarget: "commonjs2",
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: "ts-loader",
      },
    ],
  },
  externals: [nodeExternals()],
  resolve: {
    extensions: [".ts", ".tsx", ".js"],
  },
  node: {
    global: false,
    __filename: false,
    __dirname: false,
  },
};
