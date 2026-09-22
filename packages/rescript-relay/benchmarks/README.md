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

For CPU and GC investigation:

```sh
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

See the [ReScript runtime experiment](rescript-runtime/README.md) for a tested
port of both converters, paired timing results, bundle measurements, and the
reason the shipping runtime remains JavaScript.
