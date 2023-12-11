---
  id: relay-resolvers
  title: Relay Resolvers
  sidebar_label: Relay Resolvers
---

#### Recommended background reading
- [Relay Resolvers](https://relay.dev/docs/guides/relay-resolvers/)


## Enabling Experimental Resolvers
Relay Resolvers are still considered experimental. To use them you must ensure that the `ENABLE_RELAY_RESOLVERS`` runtime feature flag is enabled, and that the `enable_relay_resolver_transform`` feature flag is enabled in your project’s Relay config file.

```js
// relay.config.js
module.exports = {
//...
  featureFlags: {
    enable_relay_resolver_transform: true,
  },

//...
};
```

```js
//SomeComponent.res
RescriptRelay.relayFeatureFlags.enableRelayResolvers = true

@react.component
let make = () => {
  //
}
```


## Basic Example
```js
// UserGreetingResolver
/**
 * @RelayResolver
 *
 * @onType User
 * @fieldName greeting
 * @rootFragment GreetingResolver
 *
 * A User Greeting
 */
type t = string

module Fragment = %relay(`
  fragment UserGreetingResolver on User {
    firstName
    lastName
}
`)

let default = Fragment.makeRelayResolver(({firstName, lastName}) => Some(`Hello ${firstName} ${lastNamee}!`))

```




## Using Relay Resolvers
Relay Resolvers utilize special conventions in order to add a new field onto a type.

Rescript Relay Resolvers actively lean on Rescript's type inference to simplify the resolver boilerplate. Still, a resolver type must be explicitly defined with `type t`.

### FileName
Resolver files must end with the word `Resolver` for the relay compiler to compile them

- ❌ ~~ResolveUserGreeting.res~~
- ❌ ~~GenerateUserGreetingField.res~~
- ✅ UserGreetingResolver.res

### Docblock
The Relay compiler looks for the following fields in any docblocks that includes @RelayResolver:

- **@RelayResolver (required)**
- **@rootFragment (optional)** The name of the fragment read by readFragment
- **@deprecated (optional)** Indicates that the field is deprecated. May be optionally followed text giving the reason that the field is deprecated.

The docblock may also contain free text. This free text will be used as the field’s human-readable description, which will be surfaced in Relay’s editor support on hover and in autocomplete results.
```
/**
 * @RelayResolver
 *
 * @onType User
 * @fieldName greeting
 * @rootFragment UserGreetingResolver *Note* this matches our filename
 *
 * The status of a todo
*/
 ```

### Relay Resolver Conventions
In order for Relay to be able to call a Relay Resolver, it must conform to a set of conventions:

- The resolver must have a type `t` defined.
- The resolver must read its fragment using the special `makeRelayResolver` function.
- The resolver function must be pure.
- The resolver’s return value must be immutable.
- The resolver return type must be of `option<t>`

Unlike server resolvers, Relay Resolvers may return any Rescript value, however it must be wrapped in `Option`. This includes functions, arrays, tuples, variants, etc. However, we generally encourage having Relay Resolvers return scalar values and only returning more complex JavaScript values (like functions) as an escape hatch.

## Passing arguments to resolver fields
For resolvers, we support two ways of defining field arguments:

- **GraphQL:** Arguments that are defined via `@argumentDefinitions`` on the resolver's fragment.
- **JS Runtime:** Arguments that can be passed directly to the resolver function.
You can also combine these, and define arguments on the fragment and on the resolver's field itself, Relay will validate the naming (these arguments have to have different names), and pass GraphQL arguments to fragment, and JS arguments to the resolver's function.

### Defining Resolver field with Fragment Arguments
```js
// UserGreetingResolver.res
/**
* @RelayResolver
* @rootFragment UserGreetingResolver
*/

module Fragment = %relay(`
  fragment UserGreetingResolver on User
   @argumentDefinitions(someArg: {type: "String"}) {
    greeting(someArg: $someArg){
      __typename
    }
  }
`)

let default = Fragment.makeRelayResolver(({greeting}) => Some(greeting.__typemame))
```

### Using Resolver field with arguments for Fragment
```js

module Query = %relay(
  `Query MyQuery($id: ID, $greetingText: String) {
    node(id:$id)
      ... on User {
        greeting(custonText: $greetingText)
      }
  }
`
)

@react.component
let make = () => {
  let data = Query.use(~variables={
      id: "abc123",
      someArg:"Waasssaaaap?"
    })

  switch queryData.node {
  | Some(user) => <div> {React.string(user.greeting)} </div>
  | None => React.null
  }
}
```

### Defining Resolver field with Runtime (JS) Arguments
Relay resolvers also support runtime arguments that are not visible/passed to fragments, but are passed to the resolver function itself.

You can define these fragments using GraphQL’s Schema Definition Language in the @fieldName

```
//TODO

```