# Recorded local comparison

Baseline: `520cac4933c118a85cf0dffcd1a19a5dba34ad4f` (latest default branch when work began).
Candidate: the accompanying `src/utils.js` changes. Recorded 2026-09-21.

Both runs used v24.16.0, linux x64, AMD RYZEN AI MAX+ 395 w/ Radeon 8060S, 15 samples per case,
with a 40 ms calibration target. These runs were sequential, candidate
first, and reproduced the earlier baseline-first comparison. Times vary by
runtime and machine; these are local microbenchmark results, not guarantees.

| Case | Baseline median | Optimized median | Speedup | New output objects (before → after) |
|---|---:|---:|---:|---:|
| small fragment | 1.39 µs | 0.26 µs | 5.36× | 3 → 3 |
| unchanged object | 0.79 µs | 0.11 µs | 7.35× | 1 → 0 |
| nullable query | 2.15 µs | 0.43 µs | 5.03× | 3 → 3 |
| connection / 100 rows | 787.34 µs | 67.43 µs | 11.68× | 703 → 403 |
| plural fragment / 100 rows | 141.25 µs | 30.76 µs | 4.59× | 301 → 301 |
| union list / 100 rows | 229.87 µs | 62.56 µs | 3.67× | 302 → 302 |
| custom scalar list | 12.47 µs | 11.25 µs | 1.11× | 102 → 102 |
| opaque JSON list | 0.60 µs | 0.35 µs | 1.72× | 2 → 0 |
| recursive inputs | 359.82 µs | 30.62 µs | 11.75× | 203 → 103 |

Raw reports include p10/p90 spreads. See [benchmark instructions](../README.md)
for reproduction and the limits of the output-object count. Date construction
dominates the custom-scalar list case; its small timing difference is within the
observed noise. CPU profiling confirmed traversal, field dispatch, fragment
snapshot copying, and scalar callbacks as the remaining work.
