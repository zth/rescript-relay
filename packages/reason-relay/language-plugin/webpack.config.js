const path = require("path");
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
  .BundleAnalyzerPlugin;

module.exports = {
  mode: "production",
  entry: "./src/index.ts",
  target: "node",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "reason-relay-language-plugin.js",
    library: "reason-relay-language-plugin",
    libraryTarget: "commonjs2"
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: "ts-loader"
      }
    ]
  },
  externals: [
    "graphql",
    "reason",
    "relay-compiler",
    "relay-compiler/lib",
    "relay-runtime",
    /^@babel\/.+$/,
    /^relay-compiler\/.+$/,
    "immutable"
  ],
  resolve: {
    extensions: [".ts", ".tsx", ".js"]
  },
  optimization: {
    // minimize: false
  },
  plugins: [
    // new BundleAnalyzerPlugin()
  ]
};
