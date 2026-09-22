const fs = require("fs");
const path = require("path");
const zlib = require("zlib");
const esbuild = require("esbuild");
const {buildConversionModules} = require("../../scripts/build-conversion-modules");
async function measure() {
  const output = path.join(__dirname, "output");
  buildConversionModules(path.join(output, "baseline"));
  const results = {};
  for (const [name, entry] of [
    ["baselineEsm", path.join(output, "baseline/utils.mjs")],
    ["candidateEsm", path.join(output, "utils.mjs")],
    ["baselineCjs", path.resolve(__dirname, "../../src/utils.js")],
    ["candidateCjs", path.join(output, "utils.cjs")],
  ]) {
    const result = await esbuild.build({entryPoints: [entry], bundle: true, minify: true, format: "esm", write: false});
    const bytes = result.outputFiles[0].contents;
    results[name] = {minified: bytes.length, gzip: zlib.gzipSync(bytes, {level: 9}).length, brotli: zlib.brotliCompressSync(bytes).length};
  }
  fs.writeFileSync(path.join(output, "size.json"), JSON.stringify({esbuild: esbuild.version, node: process.version, results}, null, 2) + "\n");
  console.table(results);
}
measure().catch(error => {console.error(error); process.exitCode = 1;});
