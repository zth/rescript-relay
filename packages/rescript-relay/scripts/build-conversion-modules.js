#!/usr/bin/env node
// Keep CommonJS and ESM implementations identical. Fail if the source module
// boundary changes instead of producing a silently broken release artifact.
const fs = require("fs");
const path = require("path");
function buildConversionModules(destination) {
  fs.mkdirSync(destination, { recursive: true });
  for (const name of ["utils", "prepareConversion"]) {
    let source = fs.readFileSync(
      path.join(__dirname, "../src", name + ".js"),
      "utf8",
    );
    const exports = /module\.exports = \{([\w\s,]+)\};\s*$/;
    if (!exports.test(source))
      throw new Error("Unsupported conversion exports in " + name);
    source = source.replace(exports, "export {$1};\n");
    if (name === "utils") {
      const dependency =
        /const\s*\{\s*prepareConversion,\s*convertWithoutPlan,?\s*\}\s*=\s*require\("\.\/prepareConversion"\);/;
      if (!dependency.test(source))
        throw new Error("Missing prepared-converter import");
      source = source.replace(
        dependency,
        'import { prepareConversion, convertWithoutPlan } from "./prepareConversion.mjs";',
      );
    }
    fs.writeFileSync(path.join(destination, name + ".mjs"), source);
  }
}
if (require.main === module) {
  if (!process.argv[2])
    throw new Error("Usage: build-conversion-modules.js <output-directory>");
  buildConversionModules(path.resolve(process.argv[2]));
}
module.exports = { buildConversionModules };
