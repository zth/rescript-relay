#!/usr/bin/env node
// Standalone experiment: never replaces the shipping runtime or release build.
const fs = require("fs");
const path = require("path");
const { spawn } = require("child_process");
const esbuild = require("esbuild");
async function build() {
  const compiler = path.resolve(__dirname, "../../node_modules/.bin/rescript");
  await new Promise((resolve, reject) => {
    const child = spawn(compiler, ["build"], {cwd: __dirname, stdio: "inherit"});
    child.on("error", reject);
    child.on("exit", code => code === 0 ? resolve() : reject(new Error(`ReScript exited ${code}`)));
  });
  const output = path.join(__dirname, "output");
  await esbuild.build({
    entryPoints: [path.join(__dirname, "entry.mjs")],
    bundle: true,
    format: "esm",
    outfile: path.join(output, "utils.mjs"),
  });
  const source = fs.readFileSync(path.join(output, "utils.mjs"), "utf8");
  const boundary = /export \{([\w\s,]+)\};\s*$/;
  if (!boundary.test(source)) throw new Error("Unexpected ESM export boundary");
  fs.writeFileSync(path.join(output, "utils.cjs"), source.replace(boundary, "module.exports = {$1};\n"));
}
build().catch(error => {console.error(error); process.exitCode = 1;});
