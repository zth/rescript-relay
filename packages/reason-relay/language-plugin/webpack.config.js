const path = require("path");
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
  .BundleAnalyzerPlugin;
const nodeExternals = require("webpack-node-externals");

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
    nodeExternals({
      whitelist: [
        /bs-flow-parser/,
        /tablecloth-bucklescript/,
        /bs-sedlex/,
        /ppx-sedlex/,
        /bs-platform/,
        /bs-gen/,
        /invariant/
      ]
    })
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
