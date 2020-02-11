---
id: custom-scalars
title: Custom Scalars
sidebar_label: Custom Scalars
---

#### Recommended background reading

- [Scalars in GraphQL](https://graphql.org/learn/schema/#scalar-types)

## Custom Scalars in ReasonRelay
GraphQL allow you to define custom scalars that can be used throughout your schema. Since custom scalars are opaque to the client by default (meaning the server is the only one who know what they actually represent), you'll need a way of telling ReasonRelay what the client should interpret the custom scalar as.

Enter custom scalars.

### Defining Custom Scalars
Custom scalars are defined in the project's `relay.config.js` ([you can read more about `relay.config.js` here](getting-started#configuring-relay)). It's very simple, you just add a mapping from scalar name to type name, like below:

```js
// relay.config.js
module.exports = {
  customScalars: {
    Datetime: "string",
    Color: "Color.t"
  }
};
```

### Examples

Imagine this query:
```graphql
query SomeQuery {
  currentTime # Custom scalar: Datetime
  favoriteColor # Custom scalar: Color
}
```

If no definition for the custom scalars `Datetime` or `Color` were defined in `relay.config.js`, the generated types would look like this:

```reason
type response = {
  currentTime: ReasonRelay.any,
  favoriteColor: ReasonRelay.any
}
```

But, if we were to add definitions for the custom scalars like above, the generated type would instead look like this:

```reason
type response = {
  currentTime: string,
  favoriteColor: Color.t
}
```

Great, huh? This means you can model custom scalars any way you want.

### Finishing notes
Handling of custom scalars is *only at the type level*, which means whether they're valid or not is _entirely up to you_. This means that if you define a custom scalar as a `string` but what the server sends back is actually an `int`, you'll have runtime issues. So, please take great care in how you model your custom scalars.
