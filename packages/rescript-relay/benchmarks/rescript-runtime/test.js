#!/usr/bin/env node
const assert = require("assert/strict");
const path = require("path");
const {pathToFileURL} = require("url");
const {spawn} = require("child_process");
async function test() {
  const candidate = require("./output/utils.cjs");
  const esm = await import(pathToFileURL(path.join(__dirname, "output/utils.mjs")));
  assert.deepEqual(Object.keys(candidate).sort(), Object.keys(esm).sort());
  const {cases, converters} = require("../fixtures");
  for (const fixture of cases) {
    for (const nullable of [null, undefined]) {
      const convert = runtime => runtime.runConversion(runtime.prepareConversion(fixture.plan, converters, nullable), fixture.root);
      assert.deepEqual(convert(esm), convert(candidate), fixture.name);
      assert.deepEqual(esm.traverser(fixture.root, fixture.maps, converters, nullable), candidate.traverser(fixture.root, fixture.maps, converters, nullable), fixture.name);
      assert.deepEqual(esm.convertWithoutPlan(fixture.root, nullable), candidate.convertWithoutPlan(fixture.root, nullable), fixture.name);
    }
  }
  const config = {
    ...require("../../jest.config"),
    rootDir: path.resolve(__dirname, "../.."),
    bail: false,
    resolver: path.join(__dirname, "resolver.js"),
  };
  await new Promise((resolve, reject) => {
    const child = spawn(process.execPath, [require.resolve("jest/bin/jest"), "--config", JSON.stringify(config), "--runInBand"], {stdio: "inherit"});
    child.on("error", reject);
    child.on("exit", code => code === 0 ? resolve() : reject(new Error(`Jest exited ${code}`)));
  });
}
test().catch(error => {console.error(error); process.exitCode = 1;});
