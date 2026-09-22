# ReScript runtime experiment

This ports both the prepared converter and the legacy traversal without changing
the shipping runtime. Performance is an adoption requirement, not an assumption.
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
```

Build with the repository's pinned ReScript and esbuild versions. The standalone
build bundles ESM and derives an equivalent CommonJS export boundary. It does not
add module wrappers or ReScript runtime dependencies to the measured candidate.
Tests resolve the actual shipping `src/utils.js` path to the candidate, including
imports made by compiled ReScript bindings. Native ESM/CommonJS parity is checked
separately. Existing tests remain unchanged.

Preliminary results: all 242 main tests pass; inlining legacy instruction lookups
removed most of its initial regression. Prepared object-heavy cases improved,
but opaque lists remained slower. Further measurements and the adoption decision
will be recorded here. Do not use this prototype as a shipping replacement.
