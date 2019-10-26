---
id: api-reference
title: API Reference
sidebar_label: API Reference
---

_This section is currently very incomplete as we work on a way to autogenerate this from the Reason source files._

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
