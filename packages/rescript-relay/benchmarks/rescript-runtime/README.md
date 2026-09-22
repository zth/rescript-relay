# ReScript runtime experiment

Decision: retain the shipping JavaScript runtime. This prototype ports both the
prepared converter and the legacy traversal, but does not preserve performance
across the measured cases and increases runtime bundle size.
The experiment is excluded from the package's ReScript sources and release build.

The conversion and preparation logic lives in `src/*.res`. Dynamic property
access is isolated in `RescriptRelay_ConversionInterop.res`. Three small raw-JS
object loops preserve allocation-free `for...in` traversal, property order,
metadata handling and lazy copying. ReScript's `Object.keys` alternative allocates
an array for each visited object; the initial direct port was slower. This is
therefore a hybrid port, not an entirely ReScript implementation.

From `packages/rescript-relay`:

```sh
node benchmarks/rescript-runtime/build.js
node benchmarks/rescript-runtime/test.js
ENABLE_PERSISTING=true node benchmarks/rescript-runtime/test.js
node benchmarks/conversion.js --prepared --implementation benchmarks/rescript-runtime/output/utils.cjs
node benchmarks/conversion.js --implementation benchmarks/rescript-runtime/output/utils.cjs
node benchmarks/rescript-runtime/compare.js benchmarks/rescript-runtime/output/comparison.json
node benchmarks/rescript-runtime/size.js
```

Build with the repository's pinned ReScript and esbuild versions. The standalone
build bundles ESM and derives an equivalent CommonJS export boundary. It does not
add module wrappers or ReScript runtime dependencies to the measured candidate.
Tests resolve the actual shipping `src/utils.js` path to the candidate, including
imports made by compiled ReScript bindings. Native ESM/CommonJS parity is checked
separately. Existing tests remain unchanged.

## Results and decision (2026-09-22)

All **243 existing tests pass** against the candidate: 242 main tests in 49 suites,
including the 139 utility tests and mounted Relay integration tests, plus the
separate persisted-query test. Native ESM/CommonJS exports also agree on all
benchmark fixtures in both directions. This establishes useful compatibility
evidence; it is not exhaustive correctness, a new coverage claim, or a completed
production rollout.

Three runs used Node 24.16.0 on AMD RYZEN AI MAX+ 395, with 31 alternating
baseline/candidate pairs per case. Each pair reverses execution order; calibration
and preparation are outside warm timings. All recorded comparisons use the same fixture
version and the JavaScript runtime from `b0f009a`. The JavaScript runtime has since
been optimized further; check out `3de062b` to reproduce these historical results,
or use the commands above to compare against the current runtime. The shared host was busy, so
small differences and individual timings are noisy. These are conversion
microbenchmarks, not app latency measurements or cross-engine guarantees.

The range below is the median paired **conversion-time change** in each run
(negative is faster):

| Case | Prepared port | Legacy port |
| --- | ---: | ---: |
| Small fragment | -16.5% to -8.9% | -3.6% to +0.9% |
| Connection, 100 rows | -21.7% to -17.9% | -3.0% to +0.4% |
| Plural fragment, 100 rows | -19.4% to -12.1% | -7.2% to +4.3% |
| Union list, 100 rows | -22.2% to -18.0% | +0.8% to +5.2% |
| Custom scalar list | -1.8% to +2.2% | +2.5% to +9.6% |
| Opaque JSON list | **+14.0% to +20.0%** | +2.1% to +4.5% |
| Recursive inputs | -14.3% to -2.3% | -4.4% to +4.1% |

All cases and source hashes are in [summary.json](results/summary.json); the final
run's individual measurements are in [paired-final.json](results/paired-final.json).
Earlier tuning removed most of the legacy port's initial regression by inlining
instruction lookups. Moving the prepared array converter into the preparation
scope did not resolve the opaque-list regression.

The object-heavy gains do not establish that ReScript itself is faster. The
prototype also specializes generic record traversal to avoid looking up fields
in an empty instruction dictionary, and its compiled generic array traversal is
inlined. Those changes could be investigated independently in JavaScript.

Equivalent complete ESM runtime bundles, retaining all four public exports and
minified with esbuild 0.25.12:

| Bytes | JavaScript | Hybrid ReScript | Increase |
| --- | ---: | ---: | ---: |
| Minified | 5,578 | 6,328 | 750 |
| Gzip | 2,238 | 2,638 | **400 (+17.9%)** |
| Brotli | 2,032 | 2,352 | 320 |

[Size details](results/size.json) also include equivalent CommonJS-entry bundles.
These numbers measure only the shared runtime; compiler-generated instructions
are unchanged. This experiment is not included in the release, so it adds no
production bundle bytes.

The hybrid approach needs substantial dynamic FFI and handwritten JS object
loops, so it has not clearly simplified maintenance either. Keep the prototype
isolated and retain the already-tested, optimized JavaScript implementation.
Future adoption needs to resolve the regressions, weigh the size/maintenance cost,
and validate supported JS engines; passing the existing tests alone is not enough.
