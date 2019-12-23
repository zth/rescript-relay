# master

- Adds validation for illegal field names (reserved words and capitalized words are illegal as field names in Reason) to the Relay compiler.
- Moves validation of explicit `__typename` selection to Relay compiler, from the PPX.
- Upgrade to BuckleScript 7, and convert lots of things to use records instead of `Js.t` under the hood.
- Add `'response` as second parameter to mutation/subscription `updater` functions. This was simply not bound before in ReasonRelay, but Relay has always provided it.

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
