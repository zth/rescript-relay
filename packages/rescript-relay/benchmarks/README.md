# Response conversion performance

Run from `packages/rescript-relay`:

```sh
yarn test:all
yarn test:conversion:mutations
yarn bench:conversion:prepared --output /tmp/conversion-after.json
```

`test:all` compiles the checked-in generated Relay artifacts and ReScript bindings,
then runs the mounted React/Relay tests, the separate persisted-query suite, and
utility tests with coverage thresholds. Build the PPX first as in the bindings CI
workflow (`opam install . --deps-only`, then `opam exec -- dune build
bin/RescriptRelayPpxApp.exe` in `rescript-relay-ppx`). No Relay compiler regeneration
is needed unless GraphQL selections change.

For a before/after comparison using the **same fixtures and harness**:

```sh
git show 520cac4933c118a85cf0dffcd1a19a5dba34ad4f:packages/rescript-relay/src/utils.js > /tmp/utils-before.cjs
yarn bench:conversion --implementation /tmp/utils-before.cjs --output /tmp/conversion-before.json
yarn bench:conversion:prepared --compare /tmp/conversion-before.json --output /tmp/conversion-after.json
```

For paired comparisons of equivalent prepared runtimes, extract both JavaScript
modules from the baseline revision and alternate their execution within each
sample. For example, to reproduce the latest JavaScript optimization:

```sh
mkdir -p /tmp/relay-conversion-before
git show 3de062b:packages/rescript-relay/src/utils.js > /tmp/relay-conversion-before/utils.js
git show 3de062b:packages/rescript-relay/src/prepareConversion.js > /tmp/relay-conversion-before/prepareConversion.js
node benchmarks/compare-conversion.js --baseline /tmp/relay-conversion-before/utils.js --output /tmp/paired-conversion.json
```

The paired harness checks complete output equality and input immutability, warms
both implementations, and collects 31 pairs with alternating execution order.
Reports retain every pair, source hashes, and host load. `--candidate <path>` can
select another runtime; `--legacy` compares the legacy API instead. It defaults
to prepared conversion and requires equivalent behavior from both implementations.
Historical runtimes with intentionally different semantics need the original
fixture-based harness above. Pairing reduces temporal bias, but does not remove
JIT or shared-host noise; also check separate processes and repeat measurements.

Run those commands sequentially on an otherwise idle machine, with the same Node
version. Repeat in reversed order to check for warmup, CPU frequency, or load
bias. `--samples` (default 15) and `--duration` (default 40 ms per sample) control
measurement length. Each case calibrates and warms up before collecting samples;
reports include median, p10/p90, throughput, runtime, CPU, and fixture version.
Fixtures cover both response reads and recursive input writes. Correctness and
input immutability are asserted before timing; expected results are independent
of the instruction interpreter. Raw fragment refs are verified by the tests,
not by comparing to older implementations that incorrectly traversed them.

`newOutputObjects` counts unique objects reachable from the output that were not
in the input, including arrays, dates, and fragment-ref snapshots. It is a stable
measure of output allocations, **not** total allocations, heap bytes, or peak
memory. It excludes temporary objects that are already unreachable. CI uploads
this report and conversion coverage; timings are informational, while correctness
and coverage failures block CI.

For CPU and GC investigation, `--cpu-time` records CPU nanoseconds alongside
elapsed time and retains individual samples in the JSON report. It uses the
current thread's CPU time when Node provides it; older Node versions fall back to
process CPU time, including worker threads. The report identifies which was used.
CPU time helps diagnose scheduling waits but still varies with frequency,
contention, GC and JIT behavior. It does not replace elapsed-time measurements.


```sh
node benchmarks/conversion.js --prepared --cpu-time --output /tmp/conversion-cpu.json
node --cpu-prof --cpu-prof-dir=/tmp benchmarks/conversion.js
node --trace-gc benchmarks/conversion.js > /tmp/conversion-gc.log
```

Open the CPU profile in a compatible profiler. Profile baseline and candidate
separately; profiling changes timings. These are conversion microbenchmarks,
not end-to-end React latency measurements. The mounted tests exercise actual
compiled query/fragment hooks and store updates without relying on timing.

## Implementation and compatibility

New compiler artifacts use version 2 plans: lossless path segments, explicit list
depths, and named scalar/union/reference operations. `prepareConversion` validates
and prepares each plan at module initialization. The response path runs composed
record, list, scalar and union functions without creating paths or interpreting
opcodes. Preparation time is recorded separately as `preparationNs`; it is not
included in warm conversion timings. Prepared converters snapshot callback
bindings and plan metadata; callback state and response data are never cached.

Lists and records use lazy copying and preserve unchanged branches. Scalar
outputs and JSON remain opaque. Both generated fragment-ref properties point to
one raw snapshot. Null list members bypass scalar callbacks. Union callbacks run
after member conversion for reads and before it for writes, including root unions.

The legacy `traverser` remains available for existing generated artifacts and can
be measured with `yarn bench:conversion`. It uses string paths and retains the
old protocol's ambiguous underscore paths and inability to encode nested list
depth. Regenerate artifacts with the matching compiler to use prepared plans.
New generated artifacts require this runtime; old generated artifacts still work
with it. See [the conversion contract](../docs/conversion-contract.md) for exact
semantics, intentional bug fixes, supported inputs, and validation boundaries.

The existing bindings already memoize conversions with `useMemo` keyed by the
Relay snapshot. The mounted regression tests verify unchanged rerenders reuse
that result and store updates produce freshly converted data. No hook-level
cache or dependency changes were needed.

See [bundle-size measurements and budgets](SIZE.md) for complete generated JS,
shared/separate bundles, gzip/Brotli reports, and reproduction commands.

A ReScript runtime port was evaluated but not adopted: it increased bundle size
and regressed some conversion workloads. The prototype and its measurements remain
available in [the experiment commit](https://github.com/zth/rescript-relay/tree/e1b12c732ea258f338defeed058061e8f78609e4/packages/rescript-relay/benchmarks/rescript-runtime).
The shipping runtime remains JavaScript.
