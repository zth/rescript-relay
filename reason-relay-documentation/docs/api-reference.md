---
id: api-reference
title: API Reference
sidebar_label: API Reference
---

_This section is currently very incomplete as we work on a way to autogenerate this from the Reason source files._

For now, please have a look at [this annotated interface file](https://github.com/zth/reason-relay/blob/master/packages/reason-relay/src/ReasonRelay.rei) in waiting for a proper API reference.

# Constants

Here's a reference of constants provided by ReasonRelay.

| Name            | Explanation                                                                                                                           |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `storeRootId`   | The `dataId` for the Relay store's root. Useful when for example referencing the `parentID` of a connection that's on the store root. |
| `storeRootType` | The `type` for the Relay store's root `RecordProxy`.                                                                                  |

# The store

## fetchPolicy

A variant for controlling how Relay resolves data.

| Variant value     | Description                                                                                                                                                     |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `StoreOnly`       | Only resolve data from the store, don't make a network request.                                                                                                 |
| `StoreOrNetwork`  | Resolve the data from the store if _all data is available in the store_, otherwise send a network request regardless of how much data's available in the store. |
| `StoreAndNetwork` | Render with data from the store if available, but always make a network request for new data regardless.                                                        |
| `NetworkOnly`     | Skip the store entirely and always make a network request for new data.                                                                                         |

## CacheConfig

A module representing a cache config. _Coming soon_.
