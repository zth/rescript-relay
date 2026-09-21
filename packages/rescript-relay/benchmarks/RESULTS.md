# Prepared conversion benchmark results

Measured on v24.16.0, AMD RYZEN AI MAX+ 395 w/ Radeon 8060S. Each implementation ran sequentially in forward order, then reverse order; 15 samples per fixture, targeting 40 ms each. Ratios below span those two runs; these are local conversion microbenchmarks, not application latency improvements.

| Case | Prepared median (µs) | vs master | vs #673 | vs first optimization |
|---|---:|---:|---:|---:|
| small fragment | 0.112–0.121 | 11.51–11.58× | 3.10–3.27× | 2.09–2.33× |
| unchanged object | 0.059–0.062 | 12.80–13.24× | 3.49–3.52× | 1.75–1.97× |
| nullable query | 0.148–0.153 | 13.72–14.10× | 4.13–4.50× | 2.47–2.65× |
| connection / 100 rows | 20.724–24.012 | 30.91–35.23× | 11.43–13.73× | 2.66–3.06× |
| plural fragment / 100 rows | 15.192–16.458 | 8.62–9.50× | 2.23–2.88× | 1.64–2.15× |
| union list / 100 rows | 18.347–18.512 | 12.59–12.62× | 4.43–4.61× | 3.14–3.34× |
| custom scalar list | 12.116–12.560 | 0.88–0.94× | 0.89–0.94× | 0.89–0.92× |
| opaque JSON list | 0.447–0.460 | 1.22–1.24× | 1.47–1.48× | 0.76–0.78× |
| recursive inputs | 16.373–18.089 | 19.19–20.18× | 6.43–7.95× | 1.49–1.81× |

Ratios above 1 mean prepared conversion was faster. Date construction dominates the custom-scalar fixture: prepared conversion is slightly slower there. Opaque JSON lists are faster than master/#673 but slower than the first legacy optimization. The new representation fixes ambiguous paths and nested-list semantics in addition to avoiding per-response instruction lookup.

Preparation is outside the timed response path; per-fixture `preparationNs` is reported separately in each prepared JSON file. It is an average over 1,000 preparations, not a startup-latency measurement. `newOutputObjects` counts reachable output objects, not total temporary allocations or retained memory.

Sources:

- `master`: `520cac4933c118a85cf0dffcd1a19a5dba34ad4f`, extracted `src/utils.js`.
- `pr-673`: `c451c1afb3193550586f80b36b46b84c8965d355`, extracted `src/utils.js`.
- `first-pass`: `3770abc`, extracted `src/utils.js`.
- `legacy` / `prepared`: the runtime checked in alongside these reports.

Use the current fixture-version 2 reports named `forward-*.json` and `reverse-*.json` for comparisons. Earlier `baseline.json`, `optimized.json`, and `pr-673.json` are historical fixture-version 1 measurements and must not be mixed with them. See [the benchmark guide](README.md) for commands.
