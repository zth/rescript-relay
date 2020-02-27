# master

- Rename object properties if reserved words are encountered. E.g. `input SomeGraphQLInput { and: String! }` will now produce this type: `type someGraphQLInput = { [@bs.as "and"] and_: string }`.
- Emit maker functions for any input object with at least one optional prop. This is to greatly simplify working with complex input objects with lots of properties.
- Fix bug with `null` inputs wouldn't be properly filtered when refetching connections.
- _BREAKING CHANGE_ Rename unknown enum and union values to `FutureAddedValue_(payload)` to align with convention discussed with the folks behind `graphql_ppx`.

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
