# Architecture
This document covers the architecture of ReasonRelay and how it differs from Relay itself.

## High level overview
ReasonRelay is made up of primarily 3 parts:

### 1. Reason bindings for Relay
These can be found in `ReasonRelay.re` and binds most of Relay to Reason. It also binds to `relay-hooks` under the hood.

### 2. PPX
The PPX deals with various code transformation to simplify type-safe usage of Relay in Reason. This is found in `ReasonRelayPpx.re`. 

### 3. Patched Relay compiler + Reason language plugin for emitting Reason types
The Relay compiler does not natively support everything we need to have in order to make it work with emitting Reason types, so we ship a patched compiler. In addition to that, there's also a Reason language plugin that's responsible of taking the GraphQL selections from the Relay GraphQL tags and turning them into Reason types + whatever more is needed to make it work with Reason.

### Lifecycle overview
Lets look at the full lifecycle of using the various parts together. Imagine the following query inside of `MyComponent.re`:

```reason
module Query = [%relay.query {|
    query MyComponentQuery {
      viewer {
        firstName
        status
      }
    }
  |}
];
```

This uses the `[%relay.query]` tag to define a query, like you'd normally do inside of `graphql` tagged template literals in normal Relay. The following then happens:
1. You write that `[%relay.query]` and put it in a file `MyComponent.re`.
2. You run the Relay compiler. The compiler finds the `[%relay.query]` tag, extracts the content, validates it, and sends it to the Reason language compiler plugin. 
3. The Reason language plugin generates a file like `MyComponentQuery_graphql.re` inside of your generated folder. This file contains type information about the query, utils for unwrapping unions if there are any, and the raw data structure Relay uses at runtime to send/decode requests.
4. The Relay compiler we ship also produces a file called `SchemaAssets.re` inside of the generated folder. This file contains type information and utils for wrapping/unwrapping all enums in your schema.
5. The PPX transforms `module Query = [%relay.query {| query MyComponentQuery { ... } |}]` into something roughly like this:
````reason
module Query = {
  module Operation = MyComponentQuery_graphql;
  module UseQuery = ReasonRelay.MakeUseQuery({
    type variables = Operation.variables;
    type response = Operation.response;
    let node = Operation.node;
  });
  
  let use = UseQuery.use;
  let fetch = ...
}
````
...where the end effect is that this connects the `Query` module to the generated Relay artifact, and exposes a type safe `use` hook and `fetch` function for that particular query. 

So, to re-iterate: You write a query/fragment/mutation -> Relay finds and compiles that into an artifact -> The PPX transforms what you wrote into a consumable module.

## Reason bindings for Relay
A few things are worth noting of the bindings and how they're designed:

* We're not necessarily going for a 1-to-1 binding to Relay's API, but rather we're focusing on productivity in Reason. This means that we likely _won't bind things that would be very complicated in Reason_, if there's viable alternatives.
* As much as possible of what's in the bindings is hooks based. This means we won't bind the various Relay containers, the `QueryRenderer` component and so on.
* We prefer `data last` APIs in Reason (`someThing |> someFunc` vs `someThing->someFunc`). This is just a choice at this point, and might be changed before we hit stable if there's a good case for it. It's mostly for cohesiveness.
* We prefer exposing core primitives through type safe wrappers where possible. This means it's unlikely we'll ever expose the underlying `useQuery` hook, and instead we only expose `QueryModule.use` which is `useQuery` but wrapped in a type-safe way for that particular query.

Other than that, we aim to cover as much of Relay as we can, and we also don't mind adding our own, opinionated APIs on top, if it makes sense.

## PPX
The PPX provided by ReasonRelay is responsible for taking things like `module Query = [%relay.query {| ... |}]` and turning it into something usable. 

It uses `graphql_parser` and `ppx_tools`, which effectively enforces OCaml `>=4.03`. This is what made BuckleScript 6 a requirement.

## Relay compiler and the language plugin for Reason
As mentioned, we've needed to patch the compiler for now in order for it to work with Reason. The patch is fairly minor and the changes are mostly tied to changing the generated file suffix from `.graphql` to the Reason friendly `_graohql`, allowing `.bs.js` generated files to live inside of the generated folder, and a few other things. 
 PRs to Relay will follow in order for this behavior to eventually be supported via a plugin.
 
 This has the unfortunate side effect right now that we've had to pin the Relay compiler to a certain version, since we ship a built compiler. 

### The language plugin
The language plugin is what generate the actual types that make Relay usable in Reason. Things worth noting:
* It re-uses as much as possible from Relays official Flow plugin. This hasn't been that easy, but it's mostly to easy upgrades.
* It builds the Reason code using strings, not AST. Currently more productive to use strings for this use case. Might change in the future.
* It has a JS part and a Reason part. The ambition is to move more into Reason, and eventually just have a thin layer in JS that does what we must have JS for, and then delegates everything else to Reason. Not there yet though.   