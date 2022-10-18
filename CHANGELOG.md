# master

# 1.0.2

## Bug Fixes

- `private` is now correctly marked as a reserved word.

## Improvements

- Add ReScript 10 compat in peerDependencies https://github.com/zth/rescript-relay/pull/397 @MoOx
- `makeConnectionId` helpers are now marked as `@live` to not trigger the dead code analysis.

# 1.0.1

## Bug Fixes

- Fix issue with custom scalar of JSON values being accidentally mangled https://github.com/zth/rescript-relay/pull/395 @tsnobip

# 1.0.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/rescript-relay/commit/5831c2f1f0f13eedc1cb60468c32fd32b2dc01d3)_

The time has finally come - RescriptRelay `1.0.0` is released! This version brings a ton of new features and improvements. One of the the big major things this release brings is that the ReScript type generation for the Relay compiler has been completely rewritten, and fully integrated into the new Relay Rust compiler. The RescriptRelay fork of the compiler is available and maintained [here])(https://github.com/zth/relay/tree/rescript-relay).

## Upgrade versions

- `react-relay` and `relay-runtime` to `>=14.1.0`
- `react` and `react-dom` to `>=18.0.0`

## Remove Packages

You can go ahead and remove these packages, that are no longer needed, as the compiler is now shipped in the main package:

- `relay-config`
- `relay-compiler`
- `graphql` (if you don't use it for anything else)

## Improvements

- The compiler itself should be _much_ faster than the old one. An order of magnitude faster. Especially for incremental compilation in watch mode.
- There's no longer any need to manually select `__typename` on interfaces and unions for RescriptRelay's sake, unless you actually want to use it yourself.
- We now support the `@required` directive from Relay, which is a new directive that lets you force non-nullability for nullable fields on the client side. You can then choose to throw an error if null values are encountered, or let the null value bubble up. Docs are coming soon.
- The errors reported by the compiler is now quite a lot better.
- Full support for `reanalyze` as all false positive dead code results from generated code are now suppressed.
- Bindings for `requiredFieldLogger` for logging when missing fields are encountered (kudos [Emilios1995](https://github.com/Emilios1995)).
- Improved utils for [dealing with enums](https://rescript-relay-documentation.vercel.app/docs/enums).
- `recordSourceRecords` is now typed as `Js.Json.t` rather than being abstract.
- Project now works in `"type": "module"` mode in `package.json` (kudos [cometkim](https://github.com/cometkim))
- The field name of the `id` field of the `Node` interface is now configurable via `schemaConfig: {nodeInterfaceIdField: "idNameHere"}`.
- Add support for experimental [Relay Resolvers](https://relay.dev/docs/next/guides/relay-resolvers). Undocumented so far, but looking at the [test](https://github.com/zth/rescript-relay/blob/master/packages/rescript-relay/__tests__/Test_relayResolvers.res) and [definition file](https://github.com/zth/rescript-relay/blob/master/packages/rescript-relay/__tests__/TestRelayUserResolver.res) should give you a hint of how it works.
- Support `@rescriptRelayIgnoreUnused` directive on fragment definitions to insert annotations that makes `reanalyze` consider all fields in the fragment used, even if they aren't.
- Support `@rescriptRelayAllowUnsafeEnum` directive on fields selecting enums, which will ignore safety measures for enums, meaning you won't need to add a catch all clause, etc. It'll essentially output the enum as an _input_ enum (as desribed in the docs).
- Support [provided variables](https://relay.dev/docs/api-reference/graphql-and-directives/#provided-variables). More info in the docs.
- Windows support! :tada:
- A `RelaySchemaAssets_graphql.res` is now emitted, containing type definitions for all enums and all input objects. This is designed to help with accessing and using enums and input objects outside of Relay's context. This means it'll be much easier to share makers for input objects, pass enums around, etc.
- Each fragment with a `@connection` now emits a `makeConnectionId` function that allows you to generate _type safe_ connection IDs. More on why this is useful in the documentation.

## Breaking changes

- The list of disallowed field names has been adapted to ReScript (it was never properly updated for ReScript when moving from ReasonML). This means that _some of your variable prop names might be renamed_. One example - if you previously had a variable in GraphQL called `$to`, you'd interact with that as `to_` in ReScript. This is because RescriptRelay would pin `to` as a reserved word, and rename it for you. But, `to` _isn't_ actually a keyword in ReScript (it was in ReasonML), so with this release, that `to_` in ReScript will be renamed to `to`. The fix is to just update all `to_` to `to` - let the compiler guide you!
- Using variable names that are reserved words in ReScript is now _disallowed at the Relay compiler level_. This means that Relay won't compile your project if you have variables whose names are reserved words. The fix is to simply rename the variables.
- `refetchVariables` now works as intended with regards to supplying only the variables you want _changed_ when refetching, as [detailed under `variables` here](https://relay.dev/docs/next/api-reference/use-refetchable-fragment/#return-value). This means that what was previously `makeRefetchVariables(~someValue=123, ())` should now be `makeRefetchVariables(~someValue=Some(123), ())`.
  Crash course:

  - `makeRefetchVariables(~someValue=Some(123), ())` means _refetch, use the same values for all variables that was used in the last fetch, but change `someValue` to `123`_.
  - `makeRefetchVariables(~someValue=None, ())` means _refetch, use the same values for all variables that was used in the last fetch, but change `someValue` to `null` (unsetting it)_.
  - `makeRefetchVariables()` means _refetch, use the same values for all variables that was used in the last fetch, change nothing_.

  This way you can surgically change only certain values when refetching, without having to keep track of the current values for the other values.

  More details on this [in the docs](https://rescript-relay-documentation.vercel.app/docs/refetching-and-loading-more-data#makerefetchvariables). Thanks to [@tsnobip](https://github.com/tsnobip) for fixing this!

- All enum type definitions now reside in `RelaySchemaAssets_graphql.enum_<yourEnumName>`, and are _not_ generated on the operation itself anymore. So, if you previously referred to the actual enum _type_, like `Fragment.Types.enum_MyFineEnum`, you'll now need to refer to that enum type as `RelaySchemaAssets_graphql.enum_MyFineEnum`.
- Input object fields with illegal names in ReScript previously had their maker function argument names suffixed with `_`, like `~type_: string`. This is now instead _prefixed_, like `~_type: string`. Prefixing like this instead of suffixing means we can ship fully zero cost maker functions, which we couldn't before for input objects with illegal field names.

## Assorted Changes and Fixes

- Add Environment isServer option @MoOx
- Remove rescript from dependencies @anmonteiro
- Add undocumented holdGC method on relay store @MoOx
- Fixed `setLinkedRecordToNull`, `setLinkedRecordToUndefined`, `setLinkedRecordsToNull` and `setLinkedRecordsToUndefined` methods by binding them to `setValue` instead of `setLinkedRecord/s`. Previously they were throwing an error because `setLinkedRecord/s` did not support "deleting" values using them. (@reck753)
- Fix long standing bug that would make whether connection helpers were emitted or not unreliable.

## 1.0.0 development changelog

- Fix bug in the new type safe connection ID makers where null default values wouldn't turn the variable into a `Js.Null.t<t>`, leading to type errors.
- Fix bug with connection handling where connections behind a `@include` or `@skip` directive would not be found.
- Move `getConnectionNodes` back into generated and auto included `Utils` module. This means that failing to generate `getConnectionNodes`, which can happen for various reasons, won't break the build, but rather not just emit the helper.

### rc.5

- Fix compat with `rescript@10.1.0-alpha.1`.

### rc.4

- _potentially breaking_ All enum type definitions now reside in `RelaySchemaAssets_graphql.enum_<yourEnumName>`, and are _not_ generated on the operation itself anymore. So, if you previously referred to the actual enum _type_, like `Fragment.Types.enum_MyFineEnum`, you'll now need to refer to that enum type as `RelaySchemaAssets_graphql.enum_MyFineEnum`.
- Fix bug in the new type safe connection ID makers where different types could end up in the same array, yielding type errors in ReScript.

### rc.3

- Fix bug in the new type safe connection ID makers where constant value `null` couldn't be used.

### rc.2

- Fix long standing bug that would make whether connection helpers were emitted or not unreliable.

### rc.1

- Restore half-broken connection helper function inlining.

### rc.0

- _potentially breaking_ `getConnectionNodes` and `connectionKey` is now located directly in the generated module, and not in a nested `Utils` module. `connectionKey` is also no longer exposed on the `Fragment` module, but only via the generated module for that fragment (`WhateverYourFragmentIsCalled_whatever_graphql.res`)
- Support [provided variables](https://relay.dev/docs/api-reference/graphql-and-directives/#provided-variables). More info in the docs.
- Windows support! :tada:
- Fixed `setLinkedRecordToNull`, `setLinkedRecordToUndefined`, `setLinkedRecordsToNull` and `setLinkedRecordsToUndefined` methods by binding them to `setValue` instead of `setLinkedRecord/s`. Previously they were throwing an error because `setLinkedRecord/s` did not support "deleting" values using them. (@reck753)
- A `RelaySchemaAssets_graphql.res` is now emitted, containing type definitions for all enums and all input objects. This is designed to help with accessing and using enums and input objects outside of Relay's context. This means it'll be much easier to share makers for input objects, pass enums around, etc.
- Each fragment with a `@connection` now emits a `makeConnectionId` function that allows you to generate _type safe_ connection IDs. More on why this is useful in the documentation.
- _breaking_ Input object fields with illegal names in ReScript previously had their maker function argument names suffixed with `_`, like `~type_: string`. This is now instead _prefixed_, like `~_type: string`. Prefixing like this instead of suffixing means we can ship fully zero cost maker functions, which we couldn't before for input objects with illegal field names.

## beta.26

- Upgrade Relay packages to version `14.1.0`.

## beta.25

- Change signature of preload function (router related).

## beta.24

- Fix compatibility with ReScript v10

## beta.23

- Add Environment isServer option @MoOx
- Fix incorrect react-relay peerDependencies version @MoOx
- Remove rescript from dependencies @anmonteiro
- Fix instantiation of Relay context @vikfroberg
- Add undocumented holdGC method on relay store @MoOx

### beta.22

- Fix locations for `%relay.deferredComponent` so jump-to-definition, hover etc works as expected (pointing to the dynamically imported module rather than what the PPX produces).
- Add links for `Operation` module in `Query`, `Mutation`, `Subscription` and `Fragment` ([XiNiHa](https://github.com/XiNiHa))

### beta.21

- Support formatting commented out operations in the CLI ([reck753](https://github.com/reck753)).
- Support `@rescriptRelayIgnoreUnused` directive on fragment definitions to insert annotations that makes `reanalyze` consider all fields in the fragment used, even if they aren't.
- Support `@rescriptRelayAllowUnsafeEnum` directive on fields selecting enums, which will ignore safety measures for enums, meaning you won't need to add a catch all clause, etc. It'll essentially output the enum as an _input_ enum (as desribed in the docs).

### beta.20

- Fix enums appearing in `@raw_response_type` (local query updates, optimistic responses) to be input enums.

### beta.19

- Fix top level node interface issue.

### beta.18

- Fix `useTransition` bindings, where `startTransition` broke after going to React 18. Kudos to [Emilios1995](https://github.com/Emilios1995) for researching and finding the issue!

### beta.17

- Upgrade to stable React 18

### beta.16

- Fix bug that caused issues when using unions in optimistic responses and `commitLocalPayload`.
- Add support for experimental [Relay Resolvers](https://relay.dev/docs/next/guides/relay-resolvers). Undocumented so far, but looking at the [test](https://github.com/zth/rescript-relay/blob/master/packages/rescript-relay/__tests__/Test_relayResolvers.res) and [definition file](https://github.com/zth/rescript-relay/blob/master/packages/rescript-relay/__tests__/TestRelayUserResolver.res) should give you a hint of how it works.

### beta.15

- Fixes for input objects.

### beta.14

- Fixes a few issues introduced in `beta.13`.
- The list of disallowed field names has been adapted to ReScript. This means that _some of your variable prop names might be renamed_. Check out the Breaking Changes section above for details.

### beta.13

- `refetchVariables` now works as intended with regards to supplying only the variables you want _changed_ when refetching, as [detailed under `variables` here](https://relay.dev/docs/next/api-reference/use-refetchable-fragment/#return-value). Check out the [docs](https://rescript-relay-documentation.vercel.app/docs/refetching-and-loading-more-data#makerefetchvariables).
- Make all object makers inlined. This should improve bundle size some.
- Support more Linux versions in CI (like the images Vercel uses).

### beta.12

- Make CLI work with `relay.config.cjs`.

### beta.11

- Another batch of experimental stuff... Nothing new in this version compared to `beta.9`.

### beta.10

- Sneaking out some experimental stuff... Nothing new in this version compared to `beta.9`.

### beta.9

- `recordSourceRecords` is now typed as `Js.Json.t` rather than being abstract.
- The field name of the `id` field of the `Node` interface is now configurable via `schemaConfig: {nodeInterfaceIdField: "idNameHere"}`.

### beta.8

- More fixes for conversion instructions in variables and input objects.
- Project now works in `"type": "module"` mode in `package.json` (kudos [cometkim](https://github.com/cometkim))

### beta.7

- Full support for `reanalyze` as all false positive dead code results from generated code are now suppressed.
- Bindings for `requiredFieldLogger` for logging when missing fields are encountered (kudos [Emilios1995](https://github.com/Emilios1995)).
- Fix bug with conversion instructions in variables with input instructions.

### beta.6

- Fix wrong enum type being printed in input objects
- Fix `__typename` not being automatically selected (and by that forcing a manual select) in some cases, even though it's not supposed to be required to select manually anymore

### beta.5

- Generate helpers for moving between unsafe enums coming from the server, and safe enums. Also, provide a "fromString" function for each enum used, that can be used to turn any string into your enum.
- Suppress dead code warnings _in most places_ when running `reanalyze` on a `rescript-relay` code base. Still a few things left to fix, that requires changes to reanalyze. But this should be much better than before.

### beta.4

- Revert JSON.parse micro optimization experiment.

### beta.3

- Fix issue with duplicate keys being printed in the conversion instructions.
- Get rid of the need of nullability conversion instructions, and infer them instead.

### beta.2

- Fix issue with recursive input objects not being converted correctly.

# 0.23.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/rescript-relay/commit/6e96dfafaec918b1d4e9519d3fcbf5e5c46be6c0)_

Finally, a new release! This brings the Relay version to 12, and the React version to 18 (in rc.1 at the time of writing). This release has a few breaking changes which are necessary as we're slowly approaching version 1.0.0 of RescriptRelay. Check the new "Migrations" section below for a few scripts you can run to help the migration.

## Upgrade versions

- `react-relay` to `12.0.0`
- `relay-compiler` to `12.0.0`
- `relay-config` to `12.0.0`
- `relay-runtime` to `12.0.0`

React to React 18 rc:

- `react` to `rc` (`yarn add react@rc`)
- `react-dom` to `rc`(`yarn add react-dom@rc`)

## Migrations

Want help migrating most of the changes in this release? Install [comby](https://comby.dev) and run the migrations below (paste them into your terminal at the root of your project). Comby will guide you through the proposed changes.

- `comby 'ReactExperimental.unstable_useDeferredValue(:[1])' 'ReactExperimental.useDeferredValue(:[1])' .res -matcher .re -exclude-dir node_modules -review`
- `comby 'ReactExperimental.renderConcurrentRootAtElementWithId' 'ReactDOMExperimental.renderConcurrentRootAtElementWithId' .res -matcher .re -exclude-dir node_modules -review`
- `comby 'let (:[1], :[2]) = ReactExperimental.unstable_useTransition()' 'let (:[2], :[1]) = ReactExperimental.useTransition()' .res -matcher .re -exclude-dir node_modules -review`

## Breaking changes

- Remove `reason-promise` (unless you're using it for something else yourself and want to keep it). We're waiting for the official new Promise bindings, but since they seem to be quite far away, we'll have to revert back to stock `Js.Promise` for now. This is because `reason-promise` clashes with other Promise bindings that people might want to use before the new official ones are actually shipped.
- `ReactExperimental.unstable_useTransition` is now called `ReactExperimental.useTransition`, and the order of the tuple that's returned has been reversed to align with the underlying API. This means that what was before `let (startTransition, isTransitioning) = ReactExperimental.unstable_useTransition()` is now `let (isTransitioning, startTransition) = ReactExperimental.useTransition()` (migration available above).
- `ReactExperimental.unstable_useDeferredValue` is now called `ReactExperimental.useDeferredValue` (migration available above).
- `ReactExperimental.renderConcurrentRootAtElementWithId` has moved to `ReactDOMExperimental`: `ReactDOMExperimental.renderConcurrentRootAtElementWithId` (migration available above).

## Fixes & misc

- You're now allowed to configure Relay via `package.json`.

# 0.22.0

This release brings a few `rescript-relay-cli` improvements under the hood, as well as the breaking (but very easily fixable) change of uncurrying the `sink` methods received back from `RescriptRelay.Observable.make`.

## Breaking changes

- Uncurry `sink` methods. What was previously `sink => sink.error(err)` etc should now instead be `sink => sink.error(. err)`.

## Fixes & misc

- Improvements to the `remove-unused-fields` CLI.

# 0.21.1

- A few bug fixes to the `remove-unused-fields` command in the CLI.

# 0.21.0

- Adds `rescript-relay-cli`, a CLI for removing unused fields and formatting GraphQL in your project. Read more [here](https://github.com/zth/rescript-relay/blob/master/packages/rescript-relay-cli/README.md) (especially look at `remove-unused-fields`).

# 0.20.1

Quick patch release fixing the Linux binaries that broke with the last release.

# 0.20.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/rescript-relay/commit/05e045c05eb704e6e102ebf2b361a9a16cef2fb5)_

Other than bug fixes, the major thing about this release is the fact that we've now moved to the new `rescript` package :tada:!

## Fixes & misc

- `getConnectioNodes` is now also generated for aliased connections.
- Fix bug with type gen for refetchable queries without arguments not working properly.
- `.mjs` extensions in Rescript are now handled properly (kudos @sgrove).
- We've now moved from `bs-platform` to `rescript`.

# 0.19.0

A quick release with a few fixes. More details below.

## Fixes & misc

- Turn off various warnings to ease creation of interface files. ([@tsnobip](https://github.com/tsnobip))
- Fix multiple `fragmentRefs` appearing in generated object maker functions when multiple fragment refs are present.

# 0.18.2

Another small patch release, fixing an annoying warning in the generated files, and adding bindings from Relay's [missing field handlers](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/).

## Fixes & misc

- Turn off warnings for unused opens in generated files.

## New bindings

- Bind `missingFieldHandlers` on `Environment`. Read [this section of the Relay docs](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/) for more information. Add custom ones by passing `array<MissingFieldHandler.t>` to `Environment.make`.

# 0.18.1

Minor patch release, removing an inline `require` to further enhance ES modules compability.

# 0.18.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/rescript-relay/commit/49bf382d80c71207a11fe9aa1271a7cf06a98817)_

## Fixes & misc

- Support ES6 imports for `@refetchable` queries. This for example allows the use of Vite and similar bundlers.

# 0.17.1

Small patch release, mainly fixing the broken `getConnectionID` binding.

## Fixes & misc

- Fix broken `getConnectionID` binding. It's now _properly_ exposed on `ConnectionHandler.getConnectionID`, so use that instead.
- Remove `getConnectionID` generation from PPX. Prefer `ConnectionHandler.getConnectionID`. Even though it's slightly more cumbersome, it's guaranteed to not give you dependency cycles.

# 0.17.0

Small release, mainly bringing stable references to functions produced by the PPX, and a fix for enums in input positions.

## Fixes & misc

- Every enum now gets an exact version output of itself too, and that exact version is now wired up to be used in variables and inputs, where it doesn't make sense to use the open enum we use for responses/fragments (that is open to enforce adding a catch-all case for any enums that the server might add in the future).
- All hooks produced by the PPX now have _stable references_ (or as stable as they can be), meaning you won't get a new function on each render for most of the callbacks and functions the PPX returns.

# 0.16.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/rescript-relay/commit/bfb904065c22bdfc1c5bd268704b8d061c7f85ec)_

Finally, we've renamed to `RescriptRelay`! In addition to that, Relay has also released their hook APIs as stable, which means that we for the first time in history can depend on a stable Relay version. Weehoo!

In general, this release will involve quite some renaming etc for you, but other than that, the actual breaking changes are minimal. Read the full changelog below for instructions and information about what exactly has changed.

## Upgrade versions

- `react-relay` to `11.0.0`
- `relay-compiler` to `11.0.0`
- `relay-config` to `11.0.0`
- `relay-runtime` to `11.0.0`

## Breaking changes

- `ReasonRelay` is now called `RescriptRelay` :tada:. Just search-and-replace `ReasonRelay` to `RescriptRelay`, and `reason-relay` to `rescript-relay`, and you should be fine.
- `defaultRenderPolicy` on `Environment` is gone. It defaults to `Partial` and will be removed in Relay centrally. Migration strategy: Just remove the config.
- `renderPolicy` is now 100% _gone_ from the API. Relay will remove this in the next release (everything will always be what as previously `Partial`), and there should be no practical downsides to using `Partial` as opposed to `Full`. Migration strategy: Remove any usage of `renderPolicy`.

## New bindings

- Any fragment with a `@connection` directive now also exposes a `Fragment.getConnectionID(parentDataId, maybeFilters)` function for making it very simple to construct a connection `dataId` for that particular fragment that can be used with things like `@appendNode` and friends.
- A `ReasonRelay.getConnectionID(parentDataId, connectionKey, 'filters)` is also exposed for the same reason as above, but should be avoided in any situation where the generated function from the fragment can be used.
- All generated _modules_ (so `SomeFragment_user_graphql.res` that's generated by the compiler)
- `SuspenseList` is now bound via `ReactExperimental` again since the current RescriptReact bindings to that is broken.

# 0.15.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/reason-relay/commit/5aea01a511f9c084a23a8db09c30bbecca59ca32)_

This is the final release before ReasonRelay will rename to RescriptRelay! Do this to upgrade:

1. We now depend on `@rescript/react` instead of `reason-react`. _Remove_ `reason-react` and add `@rescript/react@0.10.0`.
2. The compiler now outputs `res` instead of `re`. For this to work smoothly, you should _delete your entire `__generated__` directory_ and re-run the ReasonRelay compiler.

## Upgrade versions

_Remove_ `reason-react` and add `@rescript/react@0.10.0`.

## Breaking changes

- Internal functions generated by the PPX are now actually marked as private. This should not be a breaking change unless you somehow rely on things from the `Internal` module generated by each extension node, which you shouldn't be anyway.

## New bindings

- Bind `Environment.retain` (a way to ensure a specific query is not garbage collected). [@webican](https://github.com/webican)
- Add `Query.retain(~environment, ~variables)` as a way of retaining a query so it's not garbade collected. More info [in the Relay docs here](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#retaining-queries) on what that means.

## Fixes & misc

- Binaries are now statically linked on Linux, which means that build issues on things like Vercel and Netlify should now be gone. [@fakenickels](https://github.com/webican) (and honorary mention [bdj](https://github.com/bdj))
- The compiler now outputs `res` files and syntax instead of `re` syntax. In order to make this work smoothly, make sure you remove all contents of your `__generated__` folder before you re-run the Relay compiler after upgrading.
- Fix a bug where store updater directives on scalars (like `deletedUserId`) would not have their connection array arg type transformed from `string` to `dataId`.

# 0.14.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/reason-relay/commit/bf0599b7b5078ff73a4b91cfb30a6c742037852e)_

This release brings new versions of Relay and React, and a few other minor changes.

## Upgrade versions

- `react` to `0.0.0-experimental-4e08fb10c`
- `react-dom` to `0.0.0-experimental-4e08fb10c`
- `react-relay` to `0.0.0-experimental-4c4107dd`
- `relay-compiler` to `10.1.3`
- `relay-config` to `10.1.3`
- `relay-runtime` to `10.1.3`

## Breaking changes

- _BREAKING CHANGE_ Lists of connection ids passed into the store updater directives (@appendEdge, @appendNode, etc) are now properly typed a `array<ReasonRelay.dataId>` rather than `array<string>`.

## Fixes & misc

- `/* @generated */` JS comment is now preserved in the output, helping various tooling understand that the generated files are indeed generated.
- Prebuilt JS files are now shipped with the package to simplify building a project without needing to build your ReScript project again. _Warning_: This is not "officially" supported in the sense that if you use this, you're on your own. We still recommend you to always build your ReScript project before delivering it, and not relying on prebuilt files.
- Added comment to generated connection record types, giving a hint to use the generated `getConnectionNodes` helper for turning a connection into a list of non-nullable nodes.

# 0.13.0

_[Here's a commit showing a project being upgraded to this version](https://github.com/zth/reason-relay/commit/4c8fb3d36dfa84267cb28ffb081a30a9f55c6554)_

> Make sure you read the breaking changes below!

This release marks the start of ReasonRelay's journey towards two things:

1. Supporting the new Relay Rust compiler. While this release still uses the JS based compiler, it takes steps needed to support the Rust based compiler in the future.
2. Fully embracing ReScript.

Point 1 is something that you as a user will hopefully notice a minimal amount of churn from. But point 2 is important to address. In sum, the following will happen in the coming months:

- ReasonRelay will be renamed, probably to ReScriptRelay.
- ReasonML and ReScript syntax will continue to be supported for the foreseeable future, but I will focus my tooling and documentation efforts on ReScript.
- Docs will be converted to ReScript (this is 90% done).
- A dedicated VSCode extension I'm working on will be released, _only_ supporting ReScript syntax (sneak peak already released).
- Source files emitted by the compiler will eventually be converted to `.res` files rather than `.re` files.

The reason for all of this is simply that I believe ReScript is where the future is at, and I don't have the resources to focus my efforts on tooling etc for two syntaxes. I love ReasonML and its syntax, but I've still come to the conclusion that ReScript syntax is what will the most powerful alternative in the future.

[Check out the sneak peak release](https://reason-relay-documentation.zth.now.sh/docs/vscode-extension) of the dedicated VSCode extension.

## Breaking changes

- _BREAKING CHANGE_ Operations are now defined through a single extension node rather than multiple per operation type. `relay.fragment`, `relay.query` etc are now gone. What was previously `[%relay.fragment {| fragment Blabla on Blabla {....|}]` should now instead be: `[%relay {| fragment Blabla on Blabla {....|}]`.

Migration path: Install [`comby`](https://comby.dev/docs/get-started), and run this command in your root (for `.re` files): `comby '%relay.:[~(fragment|subscription|mutation|query)]' '%relay' -i .re -exclude-dir node_modules`, or this command for `.res` files: `comby '%relay.:[~(fragment|subscription|mutation|query)]' '%relay' -i .res -matcher .re -exclude-dir node_modules`. That will take care of migrating all of your extension points.

- _BREAKING CHANGE_ Add binding for passing `uploadables` to network fetch functions. This is breaking because it changes the signature of `fetchFunctionPromise` and `fetchFunctionObservable` to include another argument `uploadables`. Migration path: What was previously something like `let fetchQuery: ReasonRelay.Network.fetchFunctionPromise = (operation, variables, _cacheConfig) => {...}` should now be `let fetchQuery: ReasonRelay.Network.fetchFunctionPromise = (operation, variables, _cacheConfig, _uploadables) => {...}`. Read more in the API reference section of the docs. ([@hariroshan](https://github.com/hariroshan))

## New bindings

- Add back `Query.fetchPromised` to simplify working with SSR.
- Bind `id` in `operation` to allow using persisted queries. ([@hariroshan](https://github.com/hariroshan))

## Fixes & misc

- Almost the entire Reason codegen has moved from being JS based to Reason native. As a user you shouldn't really notice anything other than the builds being a bit quicker. This is mainly a preparation for the upcoming Relay Rust compiler.

# 0.12.1

A quick patch with a bug fix.

## Fixes & misc

- Fix a bug where `@raw_response_type` together with unions would crash the type generation.

# 0.12.0

This release packs a bunch of new, cool things! Full list of details below, but some highlights:

- Support for using ReasonRelay with ReScript ([@sorenhoyer](https://github.com/sorenhoyer))
- Relay `10.1.0`

[Check out this](https://github.com/zth/reason-relay/commit/f95bbf9d9eb35297e9b48dec2c098e48c391f8d6) for an example diff of upgrading a project.

This version also reverts back to shipping our own bindings for `ReactExperimental`. It's likely that React will remain in experimental for a while longer with concurrent mode, and we don't want to be tied to the bindings in `ReasonReact`, since they usually take a while to update. Hence this change.

A _big_ thanks to all contributors who's helped pack this release with great changes. It contains a bit of churn (and the coming releases probably will too), but hopefully nothing that isn't easily handled.

## Upgrade versions

- `react` to `0.0.0-experimental-4ead6b530`
- `react-dom` to `0.0.0-experimental-4ead6b530`
- `react-relay` to `0.0.0-experimental-c818bac3`
- `relay-compiler` to `10.1.0`
- `relay-config` to `10.1.0`
- `relay-runtime` to `10.1.0`
- `bs-platform` to `8.3.3` (recommended, but not required)

## FAQ

- If you get an error with `bs-platform` > `8.3.0` for code looking like this `let ReasonRelay.{data, hasNext} = ...`, just remove `ReasonRelay.` from that code and the error should be gone. Later versions of `bs-platform` now properly infer record destruction, which prior versions did not do.

## Breaking changes

- _BREAKING CHANGE_ Replace unsetValue with setValueToUndefined and setValueToNull [#105](https://github.com/zth/reason-relay/pull/105) ([@tsnobip](https://github.com/tsnobip))
- _BREAKING CHANGE_ Replace `React.useTransition(~config={timeoutMs: 5000}, ())` with `ReactExperimental.unstable_useTransition()` [#121](https://github.com/zth/reason-relay/pull/121) ([@sorenhoyer](https://github.com/sorenhoyer))
- _BREAKING CHANGE_ Replace `React.useDeferredValue` with `ReactExperimental.unstable_useDeferredValue` [#121](https://github.com/zth/reason-relay/pull/121) ([@sorenhoyer](https://github.com/sorenhoyer))
- _BREAKING CHANGE_ Replace `ReactDOMRe.Experimental.createRoot` with `ReactDOMExperimental.unstable_createRoot` [#121](https://github.com/zth/reason-relay/pull/121) ([@sorenhoyer](https://github.com/sorenhoyer))
- _BREAKING CHANGE_ Remove `Query.fetchPromised`. Users can convert the fetch to a promise themselves if needed. ([@zth](https://github.com/zth))
- _BREAKING CHANGE_ Remove `Mutation.commitMutationPromised`. Users can convert the mutation to a promise themselves if needed. ([@zth](https://github.com/zth))

## New bindings

- Bind `Store.publish()`, which allows you to publish a `RecordSource` to your current store. Useful for various SSR cases (think Next.js and similar). ([@zth](https://github.com/zth))
- Bind `readInlineData` for fragments annotated with `@inline` [#117](https://github.com/zth/reason-relay/pull/117) ([@zth](https://github.com/zth))
- Clean bindings, renamed internal raw types and functions with names ending with `Raw` [#105](https://github.com/zth/reason-relay/pull/105) ([@tsnobip](https://github.com/tsnobip))

## Fixes & misc

- Relay upgraded to `10.1.0` ([@zth](https://github.com/zth))
- Generate a `commitLocalPayload` for any query annotated with `@raw_response_type`, to allow comitting local only payloads in a type safe way. [#118](https://github.com/zth/reason-relay/pull/118) ([@zth](https://github.com/zth))
- Use abstract records instead of Js.t objects for a more robust type-check and to avoid undefined fields [#105](https://github.com/zth/reason-relay/pull/105) ([@tsnobip](https://github.com/tsnobip))
- Add support for parsing ReScript (.res) files [#115](https://github.com/zth/reason-relay/pull/115) ([@sorenhoyer](https://github.com/sorenhoyer))
- Move a bunch of things from the bindings to the PPX. This will simplify a lot of things, improve the type safety some, and pave the way for some pretty interesting upcoming editor tooling. ([@zth](https://github.com/zth))
- Remove `internal_cleanVariablesRaw`, since `bs-platform` since `7.3` does what that did by default. ([@zth](https://github.com/zth))

# 0.11.0

Another release, primarily to enable zero cost enums via `bs-platform` `8.2.0`. No new Relay version, and hopefully a managable amount of breaking changes.

[Check out this](https://github.com/zth/reason-relay/commit/7880e10aad73c8f302b5cb2eeef424c6d8fc8368) for an example diff of upgrading a project.

## Upgrade versions

- `bs-platform@^8.2.0` Note this _must_ be `8.2.0` as we rely on things from that release.

## Breaking changes

- _BREAKING CHANGE_ All enums are now zero cost as `bs-platform` > `8.2.0` models polyvariants without payloads as strings. This does however force us to remove the `FutureAddedValue(string)` case, but it's worth it in the long run.
  _Migration path_: Where you previously matched on `FutureAddedValue(_)`, now instead match on a default `_`. So `FutureAddedValue(_) => ...` becomes `_ => ...`. But hey, maybe you were using that string `FutureAddedValue` provided?! You can still get it, every module with enums will now contain `toString` functions for turning your enum into an actual string. If you have an enum called `OnlineStatus`, your module will have a function like `Fragment.onlineStatus_toString(enumGoesHere)`.
- _BREAKING CHANGE_ All `getConnectionNodes_path_to_connection` generated functions are now named just `getConnectionNodes`, since Relay only allows a single `@connection` per operation/fragment, which makes name clashes impossible.
  _Migration path_: Rename all calls to `getConnectionNodes_some_path_here` to just `getConnectionNodes`.
- _BREAKING CHANGE_ All `refetch` functions now properly return a `Disposable.t`.
  _Migration path_: Handle the new return properly, via `let _ = refetch(...)` or `refetch(...)->ignore` for example.

## New bindings

No new bindings this release.

## Fixes & misc

- Fixed a bug where `fragmentRefs` would produce a circular reference which can't be stringified.
- Types are now always emitted as recursive, fixing a bug where types wouldn't/can't be printed in the right order.

# 0.10.0

A new, fresh release! This brings Relay to version `10.0.1`, binds a bunch of new things, and changes a few APIs (and their implementations) to be more ergonomic.

I'd like to highlight contributions from [Arnarkari93](https://github.com/Arnarkari93), [tsnobip](https://github.com/tsnobip) and [wokalski](https://github.com/wokalski), who all have made significant and great contributions for this release.

[Check out this](https://github.com/zth/reason-relay/commit/8ed636db21a2de5648cc0ff85d2827997a195654) for an example diff of upgrading a project.

## Upgrade versions

- `reason-react@^0.9.1`
- `bs-platform@^8.0.3` (although anything > `7` should work)
- `react-relay` to `0.0.0-experimental-8058ef82`, the rest of the Relay packages to `10.0.1`

## Breaking changes

- Bindings in `ReactExperimental` for `Suspense`, `SuspenseList`, `ConcurrentModeRoot.render`, `createRoot` and `useTransition` have been moved to the official community bindings in [Reason-React](https://github.com/reasonml/reason-react).
  _Migration path_: Change `ReactExperimental` to just `React` for said modules and functions.
- Fragment refs are now typed through polymorphic variants. Previously, all fragment refs for an object would be retrieved by doing `someObject.getFragmentRefs()`. That call would return a `Js.t` object containing all fragment references, which would then be structurally matched to ensure fragment type safety. This is now replaced with a regular prop called `fragmentRefs` that'll appear on any object with fragments spread. This improves the experience of using fragments immensely.
  _Migration path_: Where you previously did `someObj.getFragmentRefs()` now do `someObj.fragmentRefs` instead.
- The top level `node` field is now enhanced by a) collapsing the union it was previously typed as if there's only one selection anyway, and b) automatically resolve any existing node from the cache through the `node` root field.
- `Query.fetch` and `Query.fetchPromised` now need to be applied with `()` unless all args are specified. Two new args have been added: `fetchPolicy`, which controls cache behavior at the store level, and `networkCacheConfig` which controls caching at the network layer.
  _Migration path_: Add a trailing `()` to all `Query.fetch` and `Query.fetchPromised` calls.
- What was previously called `Query.preload` is now called `Query.load`, to align with Relay's naming. The return type of `Query.load` has also been renamed to `queryRef` (from `preloadToken`), and all names related to that have been changed accordingly.
  _Migration path_: Change all `Query.preload` to `Query.load`.
- `Observable.make` returns the optional subscription object. The `sink` provided by `Observable` now also has the correct `complete` prop (`completed` -> `complete`). And, `Observable.t` now correctly takes a type param for the `'response`; `Observable.t('response)`.

## New bindings

- Add `toPromise` binding for `Observable`, allowing for an easy way of turning an observable into a promise.
- Bindings for `queryCacheExpirationTime` (setting an expiration time for all cache items in `ms`) when creating the store.
- Bind `useSubscribeToInvalidationState`, which allows listening and reacting to invalidations of records in the store.
- Bind and document `Query.useLoader`.
- Bind `RelayFeatureFlags`.

## Fixes & misc

- Cleaned up the bindings to Relay and their interface files to reduce runtime size
- Fix refetching with pagination when the parent queries have variables that are left unchanged in the refetch

# 0.9.2

- Automatic conversion of custom scalars! Heavily inspired by the upcoming `graphql_ppx` release which also has this, it's now possible to have ReasonRelay automatically convert your custom scalars at runtime. More info in the docs for custom scalars.

# 0.9.1

- Fix bug with `bs-platform >7.3.0`.

# 0.9.0

- _BREAKING CHANGE_ `preload` is now _only_ exposed via the generated module, not via what's generated by the PPX. This is to reduce confusion of which one to use. If you previously used `Query.preload`, you should now use `OperationNameOfYourQuery_graphql.preload`.
- `preloadToken` can now be converted to an observable _and_ a promise. This is paving the way for doing SSR efficiently.
- Fragments can now be on unions, which previously wasn't supported in ReasonRelay (but has always been valid in Relay itself). Thanks to [Arnar Kári Ágústsson](https://github.com/Arnarkari93) for finding this!
- _BREAKING CHANGE_ All variants of doing mutations will no longer get an optional `'response` in its `onComplete` handlers (or in the `Belt.Result.t` for `commitMutationPromised`). Thanks to [Renan](https://github.com/renanmav) for finding this issue, and for the initial fix.
- Fragments now have a `Fragment.useOpt` that take an _optional_ fragment ref object, and returns an _optional_ `'fragment`. This is useful for scenarios where you haven't fetched data for a fragment yet, but it still makes sense to have the fragment hook present in your render body. Pass `None` to `Fragment.useOpt` and you'll get `None` back.

# 0.8.3

- `preload` for queries are now exposed right on the raw generated GraphQL module coming from the Relay compiler, in addition to on the module generated from the PPX. This primarily paves the way for effective code splitting.

# 0.8.2

- Fix subscriptions function bindings, which was previously wrong (thanks @
  Arnarkari93 !)
- Fix bug when input objects contain circular dependencies.

# 0.8.1

- Fix "unused varible this" warning introduced in `0.8.0`.

# 0.8.0

- Enum + union definitions are now also inlined in the record they appear, to improve editor integrations/hints in the editor.
- _BREAKING CHANGE_ Tons of changes to APIs for interacting with the store. Too many to list, but they're mostly about changing APIs taking `options` to allow omitting the optional prop if you apply the function with `()`.
- _BREAKING CHANGE_ All generated types now reside in `YourModule.Types` and are named according to at what path they were found. This includes unions as well. So, if you were previously relying on using the generated types manually for annotation, you can now find them all inside of `YourModule.Types`, named after the path in the fragment/operation where they are located.
- A promise based version of `Query.fetch` called `fetchPromised` added. Also a promise based version of `Mutation.commitMutation` called `commitMutationPromised` added.
- `commitMutation` result type changed to the actual `'response` rather than `Js.Json.t`. However, this is actually unsafe, because `'response` _may_ have been altered by the `updater` of the mutation. However, this case is so uncommon that it's better to support the broad use case of accessing the actual `'response` in the complete handler.
- `reason-promise` is now a peer dependency.

# 0.7.0

- _BREAKING CHANGE_ `SchemaAssets.re` has been retired. If you were relying on code from there for converting enums to/from strings, you can now find equivalent functions attached on your `ModuleName.Operation.unwrap_enum_EnumName` (for string -> polymorphic variant) and `ModuleName.Operation.wrap_enum_EnumName` (polymorphic variant -> string). You may need to remove the old `SchemaAssets.re` manually.
- _BREAKING CHANGE_ `commitMutation` no longer returns a promise, but a `Disposable.t` instead. It now uses callbacks (which is how Relay handles this natively anyway) `onCompleted` and `onError` to indicate done/error states.
- _BREAKING CHANGE_ The `fetch` function generated by `[%relay.query]` no longer returns a promise, but rather uses a new callback `onResult` to deliver the result as a proper `Result.t`. If you previously did `Query.fetch(~environment, ~variables=...) |> Js.Promise.then_(res => ...)` you should now do `Query.fetch(~environment, ~variables=..., ~onResult=res => switch(res) { | Ok(res) => ... | Error(_) => ... })` and handle `Result.t` accordingly. This is part of an ongoing effort to remove the dependencies on promises, and to improve type inference which wasn't working out here before.
- _BREAKING CHANGE_ `FutureAddedValue(Js.Json.t)` for unions/interfaces is now `UnselectedUnionMember(string)` where `string` is the `__typename`, because... well, this makes more sense.

# 0.6.0

- Rename object properties if reserved words are encountered. E.g. `input SomeGraphQLInput { and: String! }` will now produce this type: `type someGraphQLInput = { [@bs.as "and"] and_: string }`.
- Emit maker functions for any input object with at least one optional prop. This is to greatly simplify working with complex input objects with lots of properties.
- Fix bug with `null` inputs wouldn't be properly filtered when refetching connections.
- _BREAKING CHANGE_ Rename unknown enum and union values to `FutureAddedValue(payload)` to align with convention discussed with the folks behind `graphql_ppx`.
- _BREAKING CHANGE_ Bind `RenderPolicy` for control over whether Relay is allowed to partially render the UI with the data it already has while fetching. This is a breaking change because it changes the signature for `Query.usePreloaded` from `usePreloaded(token)` to `usePreloaded(~token: token, ~renderPolicy: renderPolicy=?, ())`.
- Bind APIs for invalidating store records and the full store for forcing refetches etc. `RecordProxy.invalidateRecord` and `RecordSourceProxy.invalidateStore`.
- Bind `useMutation` from Relay experimental, giving us a cleaner and nicer hooks based API for doing mutations, rather than just `commitMutation`.
- _POTENTIALLY BREAKING CHANGE_ All record types for all GraphQL operations are now emitted with their name as the path they're found at joined together. Previously, I was being smart and setting the name to the simplest possible, but this will enable some smart tooling down the line.

# 0.5.3

- Fix bug where complex inputs (nested objects) were not automatically converted.
- `RecordProxy` now has functions for unsetting values `unsetValue/unsetLinkedRecord/unsetLinkedRecords`, for more fine-grained control of the cache.

# 0.5.2

- Inlines enum definition in generated files to improve code lens/view definition in editors. Previously, all that would show up when hovering an enum would be `SchemaAssets.Enum_enumName.t`, but now the full enum definition will show. This will work fine with `SchemaAssets` since polymorphic variants match structurally, so the definitions will be equivalent.
- Inlines union definition and references that in the local types, for the same reason as enums - improving code lens/view definition.
- Autogenerate helper function for turning a @connection into an array of nodes. This replaces the functionality of the previous `ReasonRelayUtils.collectConnectionNodes` that's no longer usable after moving from `Js.t` to records.
- _BREAKING CHANGE_ Move from manually unwrapping fragments via a unique function per record (Like `user->Fragment.unwrapFragment_user`) to instead using a function to each record called `getFragmentRefs()` that extracts the fragments refs needed. This means `user->Fragment.unwrapFragment_user` is now instead simply `user.getFragmentRefs()`. Should be much more ergonomic, and hopefully make more sense.

# 0.5.1

- Fix nasty bug with new record types generation and autodecoding where things nested inside of unions would not be autodecoded.

# 0.5.0

- Adds validation for illegal field names (reserved words and capitalized words are illegal as field names in Reason) to the Relay compiler.
- Moves validation of explicit `__typename` selection to Relay compiler, from the PPX.
- Upgrade to BuckleScript 7, and convert lots of things to use records instead of `Js.t` under the hood.
- _BREAKING CHANGE_ Add `'response` as second parameter to mutation/subscription `updater` functions. This was simply not bound before in ReasonRelay, but Relay has always provided it.
- _BREAKING CHANGE_ Change signature of `loadNext` / `loadPrevious` pagination functions to follow the convention of providing only the arguments wanted and applying the function manually via `unit`. This: `loadNext(~count=2, ~onComplete=None)` will now instead be applied like `loadNext(~count=2, ())`.
- _BREAKING CHANGE_ Replace module `SuspenseConfig` with simple record `suspenseConfig`.
- _BREAKING CHANGE_ Bump Relay versions to `8.0.0` and `react-relay` to `0.0.0-experimental-5f1cb628`.
- Fix bug with unused generated files not being deleted by the Relay compiler.
- Bind `generateClientID`, `generateUniqueClientID` and `isClientID` helpers.
- _SUPER BREAKING CHANGE_ All emitted types are now _records_ instead of _Js.t_, and `Js.Nullable.t`/enums/unions are now autoconverted with _no manual intervention needed_. This should _greatly_ simplify working with ReasonRelay.
- _BREAKING CHANGE_ Remove `collectConnectionNodes` from `ReasonRelayUtils`, since it operated on `Js.t` and nothing is typed as `Js.t` anymore.

# 0.4.4

- Moved `ReactSuspenseConfig` module to `ReactExperimental` and renamed it to simply `SuspenseConfig`.
- Added abstract type `recordSourceRecords` to represent the records from the store serialized to a saveable format.
- Allow passing initial `recordSourceRecords` to `RecordSource.make()`.
- Add full chain of methods needed to serialize the records from the store of the current environment, like: `environment->Environment.getStore->Store.getSource->RecordSource.toJSON`.

## 0.4.3

- _BREAKING CHANGE_ Added `gcReleaseBufferSize` to creation of store, which is breaking because it turns the signature for `make` from `RecordSource.t => t` to `(~source: RecordSource.t, ~gcReleaseBufferSize: option(int), ()) => t`.

## 0.4.2

- `ReactExperimental` is now included in the distributed package.

## 0.4.1

- ReasonRelay now depends on `react@experimental` and `react-dom@experimental`.
- Added `useTransition`, `useDeferredValue`, `<Suspense />`, `<SuspenseList />`, `createRoot` and `createRootAtElementWithId` experimental API bindings to `ReactExperimental`.
- Added `ReactExperimental` module for binding experimental React APIs.
