---
id: the-compiler
title: The Compiler
sidebar_label: The Compiler
---

## A short introduction of the Relay Compiler

Relay's compiler is responsible for taking all GraphQL operations defined in your code, analyze their relationships and check their validity. It then compiles them to generated files containing optimized artifacts that Relay uses at runtime to make queries and understand the response. This means that Relay moves work like parsing and understanding how responses to queries are structured to compile time. A good example of how Relay treats performance as a core feature.

In addition to emitting runtime artifacts, the compiler also _emits ReasonML types through ReasonRelay's language plugin for the compiler_, describing your operations and their relationships. ReasonRelay takes these types and uses them to enforce type safety. This means that Relay and ReasonRelay can _guarantee type-safety_ when interacting with all data, and that you'll get a great developer experience through the tooling that types enable.

As said before, you really don't have to think about the generated artifacts as ReasonRelay does the heavy lifting of using them for you, but if you're interested, have a look at the files in your `artifactDirectory`.

You can [read more about the Relay compiler here](https://relay.dev/docs/en/graphql-in-relay.html#relay-compiler).

## How ReasonRelay uses the Relay compiler

When you run the compiler, you run `reason-relay-compiler` and not `relay-compiler` - why is that? Well, it's because ReasonRelay ships a thin layer on top of `relay-compiler`, and here's why:

1. The Relay compiler does not actually support everything we need to integrate Reason in it's current form. It's not much that needs changing, and there are open PRs that will make integration native ([PR#1](https://github.com/facebook/relay/pull/2866), [PR#2](https://github.com/facebook/relay/pull/2811), [PR#3](https://github.com/facebook/relay/pull/2810)). But for now we need to ship a forked compiler with the changes we need applied.
2. [Enums](enums) and [unions](unions) are handled in a special way in ReasonRelay, and the thin layer we add to the Relay compiler ensures that we always emit a file called `SchemaAssets.re` that contain tools for working with enums. You can read more about how enums are handled [here](enums).
