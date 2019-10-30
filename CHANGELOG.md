# master

- _BREAKING CHANGE_ Added `gcReleaseBufferSize` to creation of store, which is breaking because it turns the signature for `make` from `RecordSource.t => t` to `(~source: RecordSource.t, ~gcReleaseBufferSize: option(int), ()) => t`.

## 0.4.2

- `ReactExperimental` is now included in the distributed package.

## 0.4.1

- ReasonRelay now depends on `react@experimental` and `react-dom@experimental`.
- Added `useTransition`, `useDeferredValue`, `<Suspense />`, `<SuspenseList />`, `createRoot` and `createRootAtElementWithId` experimental API bindings to `ReactExperimental`.
- Added `ReactExperimental` module for binding experimental React APIs.
