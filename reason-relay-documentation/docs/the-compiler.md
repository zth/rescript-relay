---
id: the-compiler
title: The Compiler
sidebar_label: The Compiler
---

## A short introduction of the Relay Compiler

Relay's compiler is responsible for taking all GraphQL operations defined in your code, analyze their relationships and check their validity. It then compiles them to generated files containing optimized artifacts that Relay uses at runtime to make queries and understand the response. This means that Relay moves work like parsing and understanding how responses to queries are structured to compile time. A good example of how Relay treats performance as a core feature.

In addition to emitting runtime artifacts, the compiler also _emits ReasonML types through RescriptRelay's language plugin for the compiler_, describing your operations and their relationships. RescriptRelay takes these types and uses them to enforce type safety. This means that Relay and RescriptRelay can _guarantee type-safety_ when interacting with all data, and that you'll get a great developer experience through the tooling that types enable.

As said before, you really don't have to think about the generated artifacts as RescriptRelay does the heavy lifting of using them for you, but if you're interested, have a look at the files in your `artifactDirectory`.

You can [read more about the Relay compiler here](https://relay.dev/docs/en/graphql-in-relay.html#relay-compiler).

## How RescriptRelay uses the Relay compiler

When you run the compiler, you run `rescript-relay-compiler` and not `relay-compiler` - why is that? Well, it's because RescriptRelay ships a thin layer on top of `relay-compiler`, that sets up the configuration the Relay compiler needs to produce Reason automatically. It also enforces a more strict configuration of Relay that RescriptRelay needs to do its thing.
