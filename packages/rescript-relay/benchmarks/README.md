# Response conversion performance

Run from `packages/rescript-relay`:

```sh
yarn test:all
yarn bench:conversion --output /tmp/conversion-after.json
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
yarn bench:conversion --compare /tmp/conversion-before.json --output /tmp/conversion-after.json
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

The converter carries encoded string prefixes instead of constructing and
joining path arrays per field. Plain scalar fields take a short path. Lists are
traversed once, each member independently, with lazy copying only when an element
changes. Objects likewise retain identity when nothing changes. Generated
fragment refs are attached while traversing the original object, so they stay raw
and are not visited as new data. Both fragment-ref properties share one snapshot.

This also removes the old extra recursive-array traversal and the list-wide
union flag that could cause untyped siblings to be skipped. Conversion does not
cache inputs, instruction maps, converter maps, or callback results. Changes to
those values remain visible on subsequent calls, without retaining Relay data.

Null/undefined handling, opaque JSON blocking, input unions, nested option
markers, custom scalar boundaries, and converter order are tested in both
directions. In particular, `ca` deliberately retains its existing `Array.map`
semantics: nonnull callbacks receive `(value, index, array)`. Null elements now bypass
the callback and normalize to the requested sentinel, as required by the
GraphQL list wrapper.
Unchanged roots and arrays may now be returned by identity; consumers must treat
converted responses as immutable, just like Relay snapshots.

The existing bindings already memoize conversions with `useMemo` keyed by the
Relay snapshot. The mounted regression tests verify unchanged rerenders reuse
that result and store updates produce freshly converted data. No hook-level
cache or dependency changes were needed.
