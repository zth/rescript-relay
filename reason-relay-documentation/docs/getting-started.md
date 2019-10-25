---
id: getting-started
title: Getting Started with Reason Relay
sidebar_label: Getting Started
---

Getting started with ReasonRelay is much like getting started with Relay, with a few additional steps.

## Installation

First things first - ReasonRelay _requires BuckleScript 6_. It will _not_ work with `bs-platform < 6.0.0`. It also requires `reason-react`, but you probably figured that out already.

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

Now, we're going to configure Relay. Add a `relay.config.js` to your project root with the following in it:

```js
// relay.config.js
module.exports = {
  src: "./src", // Path to the folder containing your Reason files
  schema: "./schema.graphql", // Path to the schema.graphql you've exported from your API
  artifactDirectory: "./src/__generated__" // The directory where all generated files will be emitted
};
```

All configuration options can be seen by running `yarn relay-compiler --help` in your project. Please note that ReasonRelay enforces two things that RelayJS does not enforce:

1. You must provide an `artifactDirectory`.
2. You cannot provide your own language plugin.

You can [read more about the Relay compiler here](https://relay.dev/docs/en/graphql-in-relay.html#relay-compiler).

### Development cycle of using Relay

Relay has a compiler that's responsible for taking all GraphQL operations defined in your code, analyze their relationships, check their validity, and compile them to generated files with thin artifacts that's what Relay actually use in runtime. Therefore, developing with Relay looks like this:

1. Write your Relay-code (your GraphQL operations)
2. Run the Relay Compiler

In addition to emitting runtime artifacts, the compiler also emits ReasonML types describing your operations and their relationships. So, remember the compiler! It needs to run. Luckily it's fast and it can be put in watch mode. More about that below.

> The ahead of time compilation is actually one of the things that make Relay great - it forces you to write GraphQL that can be statically analyzed, and therefore as much work as possible can be pushed from runtime to compile time, meaning that Relay can stay lean and performant.

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

There, we now have a Relay environment! The last thing we need to do before we can start making queries is to put our `environment` into React's context by wrapping our app in `<ReasonRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>` You're encouraged to put the context provider as far up the tree as possible. Here's an example:

```reason
ReactDOMRe.renderToElementWithId(
  <ReasonRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>
    <App />
  </ReasonRelay.Context.Provider>,
  "app",
);
```

There, we're actually all set and ready to go! Next thing up is to [make your first query](querying).
