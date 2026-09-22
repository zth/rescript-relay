#!/usr/bin/env node
// Alternate order within each pair to reduce temporal bias. These are warm
// microbenchmarks, not end-to-end latency or proof of parity across JS engines.
const {performance} = require("perf_hooks");
const fs = require("fs");
const assert = require("assert/strict");
const os = require("os");
const crypto = require("crypto");
const v8 = require("v8");
const path = require("path");
const {cases, converters} = require("./fixtures");
const args = process.argv.slice(2);
const option = name => {
  const index = args.indexOf(name);
  return index < 0 ? undefined : args[index + 1];
};
if (!option("--baseline") || !option("--output")) {
  throw new Error("Usage: compare-conversion.js --baseline <utils.js> --output <report.json> [--candidate <utils.js>] [--legacy]");
}
const baselinePath = path.resolve(option("--baseline"));
const candidatePath = option("--candidate") ? path.resolve(option("--candidate")) : require.resolve("../src/utils");
const baseline = require(baselinePath);
const candidate = require(candidatePath);
const samples = 31;
const targetSampleMs = 20;
let sink;
function batch(convert, root, count) {
  const start = performance.now();
  for (let i = 0; i < count; i++) sink = convert(root);
  return (performance.now() - start) * 1e6 / count;
}
function median(values) {
  return [...values].sort((a, b) => a - b)[Math.floor(values.length / 2)];
}
function hash(filename) {
  return crypto.createHash("sha256")
    .update(fs.readFileSync(require.resolve(filename))).digest("hex");
}
function build(runtime, fixture, mode) {
  if (mode === "legacy") {
    return value => runtime.traverser(value, fixture.maps, converters, fixture.nullable);
  }
  if (Object.keys(fixture.plan.roots).length === 1 && fixture.plan.roots.__root.length === 0) {
    return value => runtime.convertWithoutPlan(value, fixture.nullable);
  }
  return runtime.prepareConversion(fixture.plan, converters, fixture.nullable);
}
const initialLoad = os.loadavg();
const results = [];
for (const mode of [args.includes("--legacy") ? "legacy" : "prepared"]) {
  for (const fixture of cases) {
    const before = v8.deserialize(v8.serialize(fixture.root));
    const original = build(baseline, fixture, mode);
    const ported = build(candidate, fixture, mode);
    assert.deepEqual(ported(fixture.root), original(fixture.root), fixture.name);
    let count = 100;
    while (Math.min(batch(original, fixture.root, count), batch(ported, fixture.root, count)) * count < targetSampleMs * 1e6) {
      count *= 2;
    }
    const measurements = [];
    for (let i = 0; i < samples; i++) {
      let baselineNs, candidateNs;
      if (i % 2) {
        candidateNs = batch(ported, fixture.root, count);
        baselineNs = batch(original, fixture.root, count);
      } else {
        baselineNs = batch(original, fixture.root, count);
        candidateNs = batch(ported, fixture.root, count);
      }
      measurements.push({baselineNs, candidateNs});
    }
    assert.deepEqual(fixture.root, before, fixture.name + ": input mutated");
    const result = {
      mode,
      name: fixture.name,
      count,
      baselineNs: median(measurements.map(sample => sample.baselineNs)),
      candidateNs: median(measurements.map(sample => sample.candidateNs)),
      ratio: median(measurements.map(sample => sample.candidateNs / sample.baselineNs)),
      samples: measurements,
    };
    results.push(result);
    console.log(mode, fixture.name, Math.round(result.baselineNs), Math.round(result.candidateNs), (result.ratio * 100 - 100).toFixed(1) + "%");
  }
}
function preparedHash(entry) {
  const filename = path.join(path.dirname(entry), "prepareConversion.js");
  return fs.existsSync(filename) ? hash(filename) : null;
}
const report = {
  fixtureVersion: 3,
  node: process.version,
  cpu: os.cpus()[0].model,
  cpuAffinity: os.platform() === "linux" ? fs.readFileSync("/proc/self/status", "utf8").match(/^Cpus_allowed_list:\s*(.+)$/m)[1] : null,
  samples,
  targetSampleMs,
  initialLoad,
  finalLoad: os.loadavg(),
  implementations: {baseline: baselinePath, candidate: candidatePath},
  sha256: {
    baseline: hash(baselinePath),
    preparedBaseline: preparedHash(baselinePath),
    candidate: hash(candidatePath),
    preparedCandidate: preparedHash(candidatePath),
    fixtures: hash("./fixtures"),
  },
  results,
};
fs.writeFileSync(option("--output"), JSON.stringify(report, null, 2) + "\n");
if (!sink) throw new Error("Missing benchmark result");
