---
id: getting-started
title: Getting Started with Reason Relay
sidebar_label: Getting Started
---

Relay is made up of two parts:

1. The framework Relay that runs on the client and integrates with React.
2. The _Relay compiler_, that takes the GraphQL definitions you write and generate artifacts that Relay uses at runtime.

This means that the workflow for using Relay (and ReasonRelay by extension) is:

1. You write Relay code
2. The compiler finds and compiles your Relay code
3. Repeat

You really don't need to care too much about the generated artifacts though (ReasonRelay hides them pretty well from you), but remember the compiler! It needs to run. Luckily it's fast and it has an excellent watch mode.

## Installation

First things first - ReasonRelay _requires BuckleScript 6_. It will _not_ work with `bs-platform < 6.0.0`. It also requires `reason-react`, but you probably figured that out already. Currently we depend on Relay version 7. Lets start by installing the dependencies:

```bash
# Add reason-relay and dependencies to the project

yarn add reason-relay graphql relay-runtime@7.0.0 relay-compiler@7.0.0 react-relay@experimental relay-config@7.0.0
```

After you've installed the packages above, setup BuckleScript through your `bsconfig.json` like this:

```json
...
"ppx-flags": ["reason-relay/ppx"],
"bs-dependencies": ["reason-react", "reason-relay"],
...
```

## Configuring Relay

Lets configure Relay! Add a `relay.config.js` to your project root with the following in it:

```js
// relay.config.js
module.exports = {
  src: "./src", // Path to the folder containing your Reason files
  schema: "./schema.graphql", // Path to the schema.graphql you've exported from your API. Don't know what this is? run `npx get-graphql-schema http://path/to/my/graphql/server > schema.graphql` in your root
  artifactDirectory: "./src/__generated__" // The directory where all generated files will be emitted
};
```

> All configuration options can be seen by running `yarn relay-compiler --help` in your project.

Please note that ReasonRelay enforces two things that RelayJS does not enforce:

1. You must provide an `artifactDirectory`.
2. You cannot provide your own language plugin.

You can [read more about the Relay compiler here](https://relay.dev/docs/en/graphql-in-relay.html#relay-compiler).

#### Tangent: A short introduction of the Relay Compiler

Relay's compiler is responsible for taking all GraphQL operations defined in your code, analyze their relationships + check their validity, and compile them to generated files containing optimized artifacts that's what Relay actually use in runtime.

In addition to emitting runtime artifacts, the compiler also emits ReasonML types describing your operations and their relationships. ReasonRelay takes these types and uses them to enforce type safety.

You really don't have to think about the generated artifacts as ReasonRelay does the heavy lifting of using them for you, but if you're interested, have a look at the files in your `artifactDirectory`.

## Setting up the Relay environment

Next thing is setting up the Relay environment. The Relay environment consists of a network layer (responsible for dispatching your GraphQL queries) and a store (responsible for the cache and supplying your views with data). Setting it up looks like this:

```reason
// Check out and example of a fetchQuery function in the examples folder (link in the text below).
let fetchQuery = ...;

let network =
  ReasonRelay.Network.makePromiseBased(~fetchFunction=fetchQuery, ());

let environment =
  ReasonRelay.Environment.make(
    ~network,
    ~store=ReasonRelay.Store.make(ReasonRelay.RecordSource.make()),
    (),
  );
```

`fetchQuery` has the signature `ReasonRelay.Network.fetchFunctionPromise`, and you can find [an example of how that can look here in the example folder](https://github.com/zth/reason-relay/blob/master/example/src/RelayEnv.re).

## Almost ready to make some queries!

There, we now have a Relay environment! The last thing we need to do before we can start making queries is to put our `environment` into React's context by wrapping our app in `<ReasonRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>` You're encouraged to put the context provider as far up the tree as possible. Here's an example:

```reason
ReactDOMRe.renderToElementWithId(
  <ReasonRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>
    <App />
  </ReasonRelay.Context.Provider>,
  "app",
);
```

There, we're all set and ready to go! Next thing up is to [make your first query](querying).
