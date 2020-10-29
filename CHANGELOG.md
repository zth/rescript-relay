# Master

## Breaking changes

- _BREAKING CHANGE_ Replace unsetValue with setValueToUndefined and setValueToNull [#105](https://github.com/zth/reason-relay/pull/105) ([@tsnobip](https://github.com/tsnobip))

## New bindings

- Bind `readInlineData` for fragments annotated with `@inline` [#117](https://github.com/zth/reason-relay/pull/117) ([@zth](https://github.com/zth))
- Clean bindings, renamed internal raw types and functions with names ending with `Raw` [#105](https://github.com/zth/reason-relay/pull/105) ([@tsnobip](https://github.com/tsnobip))

## Fixes & misc

- Generate a `commitLocalPayload` for any query annotated with `@raw_response_type`, to allow comitting local only payloads in a type safe way. [#118](https://github.com/zth/reason-relay/pull/118) ([@zth](https://github.com/zth))
- Use abstract records instead of Js.t objects for a more robust type-check and to avoid undefined fields [#105](https://github.com/zth/reason-relay/pull/105) ([@tsnobip](https://github.com/tsnobip))
- Add support for parsing ReScript (.res) files [#115](https://github.com/zth/reason-relay/pull/115) ([@sorenhoyer](https://github.com/sorenhoyer))

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
