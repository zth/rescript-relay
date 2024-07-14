---
id: custom-scalars
title: Custom Scalars
sidebar_label: Custom Scalars
---

#### Recommended background reading

- [Scalars in GraphQL](https://graphql.org/learn/schema/#scalar-types)

## Custom Scalars in RescriptRelay

GraphQL allow you to define custom scalars that can be used throughout your schema. In RescriptRelay, you can handle custom scalars in 3 different ways:

1. Map custom scalars to an existing type. This is useful if you have something that doesn't need decoding, like a `Color` scalar that's really just a `string`.
2. Map custom scalars to an _abstract_ type. This is useful when you have a custom scalar like a `Cursor` that you shouldn't touch on the client, but just pass on as-is.
3. Have RescriptRelay _automatically_ convert your custom scalar values for you at runtime. This is useful when you have a custom scalar like `Datetime` which you know you'll always want to convert to a `Js.Date.t` at runtime, and want to avoid the hassle of doing that manually.

### Defining Custom Scalars

Custom scalars are defined in the project's `relay.config.js` ([you can read more about `relay.config.js` here](getting-started#configuring-relay)). It's pretty simple, you just add a mapping from scalar name to a custom scalar value. Let's cover all 3 use cases outlined above in an example:

```js
// relay.config.js
module.exports = {
  customScalarTypes: {
    // This just maps all `Color` scalars to `string`.
    // This is useful _when you know it's in fact a string_, and
    // when you know you'll want to interact with the custom scalar
    // as a string at runtime.
    Color: "string",

    // This maps the `Cursor` scalar to an abstract type. Remember,
    // you'll need to point out an actual, existing type here.
    // In this example, we've created a file in our project called
    // CustomScalars.re that just define the abstract type shown below.
    //
    // This is useful when you _don't want anyone to touch the custom
    // scalar at runtime_. In this example, a Cursor should be opaque,
    // meaning the client should never manipulate it. An abstract type
    // helps enforce that.
    Cursor: "CustomScalars.cursor",

    // By instead setting a _module name_ (denoted by the fact that
    // Datetime in Utils.Datetime is capitalized, meaning it's a module
    // and not a type), RescriptRelay will automatically convert your
    // value for you at runtime. We'll expand on this below.
    Datetime: "Utils.Datetime",
  },
};
```

#### Automatic decoding and encoding of values

Expanding on the `Datetime` example above, whenever you want RescriptRelay to automatically convert a custom scalar for you at runtime, do this:

1. As in the example above, define the custom scalar mapping as a _module_. This is decided by that what the mapping points to is a capitalized name, which in ReScript means it's a module.
2. Make sure the module you're pointing to exists in your project, and implements this signature:

```rescript
module YourCustomScalarModuleName: {
  type t /* This can be anything */
  let parse: Js.Json.t => t /* Going from a raw JSON value to your type t */
  let serialize: t => Js.Json.t /* Going from type t to a raw JSON value */
}
```

It's of course fine to have more functions and types on your custom scalar module, but it needs to _at least_ have the signature above.

Let's finish this off with some examples.

### Examples

Imagine this query:

```graphql
query SomeQuery {
  currentTime # Custom scalar: Datetime
  favoriteColor # Custom scalar: Color
}
```

If no definition for the custom scalars `Datetime` or `Color` were defined in `relay.config.js`, the generated types would look like this:

```rescript
type response = {
  currentTime: RescriptRelay.any,
  favoriteColor: RescriptRelay.any,
}

```

But, if we were to add the following definitions for the custom scalars:

```javascript
// relay.config.js
module.exports = {
  ...
  customScalarTypes: {
    Color: "string",
    Datetime: "Utils.Datetime"
  }
}
```

The response would instead look like this:

```rescript
type response = {
  currentTime: Utils.Datetime.t,
  favoriteColor: string,
}

```

_...and_ `currentTime` would _always_ be automatically converted using `Utils.Datetime.parse`, and serialized using `Utils.Datetime.serialize` if it ever needs to be sent back to the server in a mutation, variables etc. But you don't need to think about that, it all happens automatically.

Great, huh? This means you can model custom scalars any way you want and that makes sense for your use case.
