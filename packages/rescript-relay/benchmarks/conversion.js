#!/usr/bin/env node
const { performance } = require("perf_hooks");
const os = require("os");
const path = require("path");
const fs = require("fs");
const assert = require("assert/strict");
const v8 = require("v8");
const { cases, converters } = require("./fixtures");
const args = process.argv.slice(2);
const option = (name) => {
  const i = args.indexOf(name);
  return i < 0 ? undefined : args[i + 1];
};
const implementation = option("--implementation");
const { traverser } = require(
  implementation ? path.resolve(implementation) : "../src/utils",
);
const samples = Number(option("--samples") || 15);
const duration = Number(option("--duration") || 40);
if (
  !Number.isInteger(samples) ||
  samples < 3 ||
  !Number.isFinite(duration) ||
  duration <= 0
) {
  throw new Error(
    "Use --samples >= 3 and --duration > 0 (milliseconds per sample).",
  );
}
function dataOnly(value) {
  if (Array.isArray(value)) return value.map(dataOnly);
  if (!value || typeof value !== "object" || value instanceof Date)
    return value;
  return Object.fromEntries(
    Object.entries(value)
      .filter(
        ([key]) => key !== "fragmentRefs" && key !== "updatableFragmentRefs",
      )
      .map(([key, v]) => [key, dataOnly(v)]),
  );
}
function objects(value, seen = new Set()) {
  if (value && typeof value === "object" && !seen.has(value)) {
    seen.add(value);
    Object.values(value).forEach((v) => objects(v, seen));
  }
  return seen;
}
let sink;
function batch(fixture, count) {
  const start = performance.now();
  for (let i = 0; i < count; i++)
    sink = traverser(fixture.root, fixture.maps, converters, fixture.nullable);
  return performance.now() - start;
}
const results = cases.map((fixture) => {
  const before = v8.deserialize(v8.serialize(fixture.root));
  const converted = traverser(
    fixture.root,
    fixture.maps,
    converters,
    fixture.nullable,
  );
  assert.deepStrictEqual(dataOnly(converted), fixture.expected, fixture.name);
  assert.deepStrictEqual(
    fixture.root,
    before,
    fixture.name + ": input mutated",
  );
  const inputObjects = objects(fixture.root);
  const newOutputObjects = [...objects(converted)].filter(
    (v) => !inputObjects.has(v),
  ).length;
  // Calibrate outside the measured samples; warm the same call site first.
  let iterations = 100;
  while (batch(fixture, iterations) < duration) iterations *= 2;
  const values = Array.from(
    { length: samples },
    () => (batch(fixture, iterations) * 1e6) / iterations,
  ).sort((a, b) => a - b);
  const median = values[Math.floor(values.length / 2)];
  return {
    name: fixture.name,
    iterations,
    newOutputObjects,
    medianNs: median,
    p10Ns: values[Math.floor(values.length * 0.1)],
    p90Ns: values[Math.floor(values.length * 0.9)],
    opsPerSecond: 1e9 / median,
  };
});
const report = {
  fixtureVersion: 1,
  node: process.version,
  platform: `${os.platform()} ${os.arch()}`,
  cpu: os.cpus()[0].model,
  samples,
  durationMs: duration,
  implementation: implementation || "src/utils.js",
  results,
};
console.table(
  results.map((r) => ({
    case: r.name,
    "median ns": Math.round(r.medianNs),
    "p10 ns": Math.round(r.p10Ns),
    "p90 ns": Math.round(r.p90Ns),
    "ops/sec": Math.round(r.opsPerSecond),
    "new output objects": r.newOutputObjects,
  })),
);
const baseline = option("--compare");
if (baseline) {
  const previous = JSON.parse(fs.readFileSync(baseline, "utf8"));
  if (previous.fixtureVersion !== report.fixtureVersion)
    throw new Error("Benchmark fixture versions differ");
  console.table(
    results.map((r) => {
      const old = previous.results.find((x) => x.name === r.name);
      return {
        case: r.name,
        speedup: old ? (old.medianNs / r.medianNs).toFixed(2) + "x" : "n/a",
      };
    }),
  );
}
if (option("--output"))
  fs.writeFileSync(option("--output"), JSON.stringify(report, null, 2) + "\n");
// Keep the observable result alive through the timed loops.
if (!sink) throw new Error("Missing benchmark result");
