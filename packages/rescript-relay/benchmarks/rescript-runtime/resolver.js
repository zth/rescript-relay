const path = require("path");
const runtime = path.resolve(__dirname, "../../src/utils.js");
const candidate = path.resolve(__dirname, "output/utils.cjs");
module.exports = (request, options) => {
  const resolved = options.defaultResolver(request, options);
  return resolved === runtime ? candidate : resolved;
};
