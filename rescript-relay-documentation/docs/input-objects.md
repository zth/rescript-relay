---
id: input-objects
title: Input Objects
sidebar_label: Input Objects
---

## Input objects in RescriptRelay

All input objects in your schema will have their types (and maker functions) emitted into the generated file `RelaySchemaAssets_graphql.res`. This means you'll have access to the type definition of all of your input objects regardless of what you're doing. Handy if you're for example making general functions to produce various input objects.

### `null` in input objects

You can refer to the page on [variables](variables#rescriptrelaynullablevariables) if you need to send an explicit `null` as the value of a prop in an input object.
