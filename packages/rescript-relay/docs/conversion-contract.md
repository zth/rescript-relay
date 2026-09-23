# Conversion contract and audit

Coverage is not proof of correctness. This document distinguishes the intended
contract from historical behavior and limits of the input protocol. Tests must
assert the contract independently of the optimized implementation.

## Sources and scope

The audited compiler is submodule `ef6d68326a6661887a2a09fd12028f201e32d78f`:
`relay-typegen/src/rescript_ast.rs` (`ConverterInstructions`), `rescript.rs`
(`ast_to_prop_value`, `write_internal_assets`), and `rescript_utils.rs`
(`instruction_to_key_value_pair`). All checked-in generated artifacts were also
inspected. Legacy compiler opcodes are `c`, `ca`, `r`, `u`, `f`, and `b`;
`e` is retained for older artifacts. Nullable conversion happens implicitly,
regardless of historical `n`/`na` hints. Response/fragment conversion, variables,
provided variables, mutation/raw responses, and persisted queries use this API.

[PR #673](https://github.com/zth/rescript-relay/pull/673) independently replaces
path arrays with strings. Its regression cases are retained here, and its
implementation is included in the benchmark comparisons. Its reported real-app
measurements are separate evidence, not our local microbenchmark results.

## Supported data

- Plain, own enumerable string-keyed data records and arrays, including sparse
  arrays, null-prototype records, frozen inputs, and shared subtrees.
- Null and undefined normalize to the requested nullable sentinel. Missing
  properties remain missing; false, zero, empty strings, and option markers
  remain distinct. Converter outputs are opaque even when they are null,
  undefined, arrays, class instances, or objects containing nulls.
- Relay metadata beginning `__` is opaque, except `__id`, `__typename`, and
  `__relay_internal*` provided variables. Cycles in opaque metadata/scalars/JSON
  are allowed. Cycles in traversed GraphQL data, accessors, proxies, symbol-keyed
  selections, and invalid primitive roots are outside the GraphQL contract.
- No input, converter-produced object, instruction, or Relay store record may
  be mutated. Unchanged branches retain identity. Aliases may share input
  objects but conversions are path-specific, not memoized by object identity.
- Converter exceptions propagate unchanged. Siblings are processed in own
  property enumeration order and array elements in index order, once each.
  No callback-result or snapshot cache is permitted.

## Intended operations

| Operation | Semantics |
|---|---|
| Record | Visit fields once, preserving absent fields and opaque metadata. |
| List | Preserve holes; normalize null elements; apply the element plan once. |
| Scalar | Skip absent values/options; invoke callback once; never traverse its result. |
| Opaque JSON | Normalize the field's absence; preserve the entire present value by identity. |
| Fragment refs | Add two properties pointing at the same shallow raw snapshot; never recursively convert this generated snapshot. |
| Union | Select by the original `__typename`; on reads convert members before the union callback; on writes invoke the callback before member conversion. Root and nested unions obey the same order. Unknown types use the generated union callback. |
| Input reference | Unwrap `__$inputUnion` to its selected field, then use the named root's plan. Recursion follows data, not plan construction. |

A list containing array-valued custom scalars is distinct from a nested GraphQL
list. The protocol must preserve that distinction, not infer it from runtime
array shape. Null elements never reach a custom scalar's parse/serialize function;
they belong to the GraphQL nullable wrapper, not the scalar implementation.

## Problems found beyond coverage

1. Two existing tests explicitly blessed `parse(null)` / `serialize(null)` in
   scalar lists as "CURRENT BEHAVIOR". They characterized a bug, not the contract.
2. Joining paths with `_` aliases e.g. field `a_b` and nested fields `a.b`.
   String paths avoid allocations but cannot resolve this ambiguity.
3. `found_in_array: bool` loses nested list depth. The old `ca`/`b:a` protocol
   cannot distinguish nested GraphQL lists from array-valued scalars/JSON.
4. Root union callbacks historically run after traversal in both directions,
   unlike nested unions. Identity write callbacks hid the ordering mismatch.
5. Previous fixes addressed repeated traversal of recursive arrays, traversal of
   generated fragment snapshots, and one union element affecting its siblings.

## Redesign boundary

New artifacts use a versioned, lossless plan with path segments and explicit
list depth. Plans are prepared once at module initialization into reusable
converters; response conversion does not construct paths or decode opcodes.
Prepared converters snapshot their plan and callback bindings; mutating those
objects afterward is unsupported and must not silently change a prepared plan.
Legacy `traverser` remains available for already-generated artifacts, with its
ambiguous-path/list-depth limitations stated explicitly. New plans reject missing
callbacks/references and conflicting instructions during preparation.

## Validation layers

- Explicit shape, ordering, callback count, identity, exception, and nullability
  tables, including field-order and instruction-order permutations.
- A simple independent reference evaluator and deterministic generated plans/data;
  compare both outputs and callback traces, including round trips where invertible.
- Compiler tests for lossless paths and list depth, plus actual regenerated
  artifacts compiled through the PPX/ReScript toolchain.
- Mounted query/fragment/plural/store-update tests, existing mutation/subscription/
  pagination/resolver/catch/updatable tests, and separate persisted-query tests.
- Repeatable targeted mutation tests: each injected fault must cause a behavioral
  failure. Coverage thresholds are an additional gate, not the correctness oracle.
- Balanced benchmark comparisons against master, #673, and the first optimized
  implementation. Measure preparation separately from warm response conversion.

No finite suite proves all possible JavaScript behavior. Confidence depends on
this explicit supported contract, independent oracles, real integration tests,
and documented remaining limitations—not a claim of absolute certainty.

## Compiler and package verification

The compiler changes are in [draft zth/relay#40](https://github.com/zth/relay/pull/40),
pinned by this branch's submodule revision. All 35 compiler library tests pass.
The broader upstream Flow snapshot suite has 64 failures and 93 passes on both
the unchanged pinned compiler and this branch, with identical failing test names.
These existing failures remain outside this conversion change.

The runtime is tested through both CommonJS and native ESM release modules.
Run `yarn test:all` and `yarn test:conversion:mutations` from the package. The
mutation check runs isolated copies and requires behavioral test failures for
20 deliberately introduced faults; it does not claim a comprehensive mutation score.

## Generated size and sharing

Generated helper metadata and handles are private to each artifact. Equal plans
can be shared between directions, but callback maps and prepared handles remain
separate. Empty plans reuse the runtime's callback-free nullable converter, which
retains neither inputs nor application callbacks. The named version 2 plan format
and response semantics are unchanged. See [size measurements](../benchmarks/SIZE.md)
for complete generated-artifact bundles, separate gzip/Brotli totals, and CI budgets.

Compiler-generated callback keys may be short string IDs such as `"0"`. They are
local to a conversion's callback table, assigned deterministically across scalar
and union callbacks, and do not change response traversal. Public preparation
still accepts named callback keys. Plans may be shared, but callback bindings are
always prepared against their own table and snapshotted independently.

The compiler may omit list-depth hints when no special conversion operation
exists at or below that path. Generic nullable traversal handles those plain
lists. List wrappers around scalars, unions, references, opaque values, and
fragment-bearing records are retained. An entirely empty plan uses the shared
converter; named input references are never removed by this optimization.

Plural fragment roots apply their record plan to each element without a redundant
root list instruction. For plural fragments with `@catch`, each element is a
`CatchResult`, so the generated type is `array<CatchResult<fragment_t>>` and
custom scalar paths start inside each result's `value`. Mounted hook tests cover
nullable payloads, union/interface payloads, mixed success/error results, store
updates, and preservation
of the raw Relay store; a typed ReScript helper checks the generated wrapper.

## Custom scalar ordering follow-up

`utils-scalar-ordering-tests.js` enumerates all 120 orders of five sibling fields
(single array-backed scalar, scalar list, referenced input, nullable field, and
another scalar), with forward/reversed instruction order, both nullable
directions, and both legacy/prepared runtimes. Each of the 960 combinations runs
twice against frozen input, checking exact callback order/count, result identity,
source preservation, sparse lists, and continued sibling conversion.

Additional cases distinguish empty array-backed scalars from empty GraphQL
lists; preserve falsey/null/undefined/object/array/Date/option callback results at
root, field, and list positions; and verify that a failing list callback stops
later elements/siblings without poisoning a subsequent call. Mounted compiled
queries select the same mixed scalar/list fields in opposite orders and verify
read conversion, recursive variable serialization, write conversion, nullable
store updates, and raw-store preservation. Targeted mutations explicitly restore
the historical sibling early return and incorrectly normalize scalar results;
both must fail behavioral assertions.
