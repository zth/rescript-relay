const path = require("path");

module.exports = {
  entry: "./src/Index.bs.js",
  mode: "development",
  output: {
    path: path.join(__dirname, "dist"),
    filename: "index.js"
  }
};
