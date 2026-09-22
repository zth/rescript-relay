# Generated conversion bundle size

This measures **complete compiled JavaScript artifacts**, including Relay nodes,
conversion metadata, helper functions, and initialization calls. It replaces the
earlier metadata-only gzip estimate. esbuild 0.25.12 bundles/minifies a fixed set
of 129 pre-existing artifacts; gzip uses level 9 and Brotli uses quality 11.

Dependencies (React, Relay, bindings, custom scalar modules, and generated imports)
are external in every measurement. These are artifact-only bundles, **not a
production application build**. The combined case exports all artifacts in one
bundle. The separate case sums independently bundled/compressed artifacts. Real
code splitting and import usage will change the result. The shared runtime is
measured separately below and must not be counted once per artifact.

| Version | One bundle, minified | One bundle, gzip | One bundle, Brotli | Separate bundles, gzip | Separate bundles, Brotli |
|---|---:|---:|---:|---:|---:|
| Original (`520cac4`) | 284,957 | 37,573 | 26,976 | 119,093 | 106,076 |
| First prepared redesign (`e856b90`) | 313,772 | 41,628 | 29,248 | 126,052 | 112,258 |
| After size optimization | 277,982 | 36,961 | 26,651 | 119,154 | 105,719 |

All numbers are bytes. Relative to the first redesign, this saves 35,790 minified
bytes / 4,667 gzip bytes in the combined bundle, and 6,898 gzip bytes across the
separate bundles. Relative to the original, combined gzip is 612 bytes smaller;
separate gzip is 61 bytes larger. These totals do not promise that each individual
artifact shrinks; per-artifact sizes are included in the JSON reports.

## Changes

- Keep plans, callback maps, and prepared handles private, so the compiler does
  not export them as properties of each `Internal` object. Conversion functions
  remain available to the bindings.
- Share identical immutable plans within an artifact, including read/write
  directions. Their callback maps and prepared converters remain independent.
- Emit a call to a shared generic converter when no instructions are needed.
  This avoids allocating empty plans and preparing equivalent converters in each
  generated module. The shared converter retains no application data or callbacks.

The lossless, readable version 2 instruction format is unchanged. No minified
opcodes, dynamic code generation, global plan registry, or input memoization was
introduced. Nonempty prepared converters execute the same response traversal.

## Reproduction and CI

After building the PPX and compiling the bindings (`yarn build`), run:

```sh
yarn size:conversion --check --output /tmp/conversion-size.json
```

To compare a compiled package in another checkout:

```sh
yarn size:conversion --root /path/to/other/packages/rescript-relay --output /tmp/other-size.json
```

Both packages must use the same ReScript version and CommonJS output configuration.
For these reports, original artifacts came from `520cac4933c118a85cf0dffcd1a19a5dba34ad4f`
and the earlier redesign from `e856b90`; both were compiled with ReScript 12.3.0.
The measurement deliberately externalizes dependencies so the comparison isolates
compiler output. `size-fixtures.json` pins the identical set of selections, excluding
the new regression query and schema helper. Use separate worktrees or scratch
packages when compiling historical artifacts; do not overwrite current artifacts.

Bindings CI checks minified, gzip, and Brotli budgets for both bundle layouts and
uploads the report. Budgets allow 2% headroom over this result. Intentional changes
to fixture coverage, esbuild version, or budgets need review. The raw reports are
`results/size-original.json`, `results/size-before.json`, and `results/size-current.json`.

## Shared runtime

This conservatively includes both prepared conversion and the legacy compatibility
export, bundled once. The original runtime is extracted from `520cac4`; the previous
prepared runtime is extracted from `e856b90`.

| Runtime | Minified | Gzip | Brotli |
|---|---:|---:|---:|
| original | 2916 | 1144 | 1010 |
| before | 5605 | 2261 | 2041 |
| current | 5786 | 2330 | 2108 |

The runtime remains larger than the original because it supports both protocols.
Shared nullable converters add a small fixed cost while removing per-artifact
initialization code. There is no measured full-app bundle result yet.
