---
id: getting-started
title: Getting Started with Reason Relay
sidebar_label: Getting Started
---

#### Recommended background reading

- [Getting started with ReasonReact](https://reasonml.github.io/reason-react/docs/en/installation) - _Note that ReasonRelay requires `bs-platform@6`_
- [A Guided Tour of Relay: Setup and Workflow](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#setup-and-workflow)

#### Want to follow along with code?

You're encouraged to follow along this walkthrough with a sample project of your own. Although you won't be able to copy-paste everything from the sample code here (a lot of code is omitted), you're still encouraged to play with ReasonRelay locally as you read the documentation. If you're interested, do the following:

- Setup a new `reason-react` project using the "Getting started with ReasonReact" link above. _However, remember to install `bs-platform@6` instead of just `bs-platform`_.
- Install and run [graphql-client-example-server](https://github.com/zth/graphql-client-example-server), a basic GraphQL server with some sample data, supporting everything Relay ideally wants your server to support, and being runnable without any setup. Do the following: `npm install -g graphql-client-example-server && graphql-client-example-server` and you'll have the server up and running locally.

## Getting Started

Let's get started!

#### A short note on Relay

You can view Relay as being made up of two parts:

1. The framework Relay that runs on the client and integrates with React.
2. The _Relay compiler_, that takes the GraphQL definitions you write and generate artifacts _at build time_. These artifacts are then used by Relay at runtime.

This means that the workflow for using ReasonRelay is:

1. You write code including GraphQL definitions that Relay will use
2. The Relay compiler finds and compiles your Relay code
3. Repeat

You really don't need to care about the generated artifacts though, ReasonRelay hides them pretty well from you. But, remember the compiler! It needs to run. Luckily it's fast and it has an excellent watch mode.

## Installation

First thing's first - ReasonRelay _requires BuckleScript 6_. It will _not_ work with `bs-platform < 6.0.0`. It also requires `reason-react`, but you probably figured that out already. Currently we depend on Relay version 7. Let's start by installing the dependencies:

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

Add a `relay.config.js` to your project root with the following in it:

```js
// relay.config.js
module.exports = {
  src: "./src", // Path to the folder containing your Reason files
  schema: "./schema.graphql", // Path to the schema.graphql you've exported from your API. Don't know what this is? run `npx get-graphql-schema http://path/to/my/graphql/server > schema.graphql` in your root
  artifactDirectory: "./src/__generated__" // The directory where all generated files will be emitted
};
```

> All configuration options can be seen by running `yarn relay-compiler --help` in your project.

Please note that ReasonRelay enforces two things that regular Relay does not:

1. You must provide an `artifactDirectory`.
2. You cannot provide your own language plugin.

We'll also add a script to our `package.json` to run the Relay compiler:

```json
// package.json
...
"scripts": {
  "relay": "reason-relay-compiler",
  "relay:watch": "reason-relay-compiler --watch",
}
```

Now you have two scripts set up; one for running the compiler once, and one for running it in watch-mode.

You can go ahead and start it in watch mode right away (`yarn relay:watch`) in a separate terminal. _Please note that you'll need to be aware of the output from the compiler_ as it will tell you when there are issues you'll need to fix.

#### Tangent: A short introduction of the Relay Compiler

Relay's compiler is responsible for taking all GraphQL operations defined in your code, analyze their relationships and check their validity. It then compiles them to generated files containing optimized artifacts that's what Relay actually use in runtime to make queries and understand the responses.

In addition to emitting runtime artifacts, the compiler also _emits ReasonML types through ReasonRelay's language plugin for the compiler_, describing your operations and their relationships. ReasonRelay takes these types and uses them to enforce type safety.

As said before, you really don't have to think about the generated artifacts as ReasonRelay does the heavy lifting of using them for you, but if you're interested, have a look at the files in your `artifactDirectory`.

You can [read more about the Relay compiler here](https://relay.dev/docs/en/graphql-in-relay.html#relay-compiler).

## Setting up the Relay environment

Finally time for some actual code. Next thing is setting up the Relay environment. The Relay environment consists of a network layer responsible for dispatching your GraphQL queries, and a store responsible for storing data and supplying it to your components. Setting it up looks like this:

```reason
/* Check out an example of a fetchQuery function in the examples folder (link in the text below). */
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

`fetchQuery` has the signature `ReasonRelay.Network.fetchFunctionPromise`, and you can find [an example of how a fetchQuery function can look here in the example folder](https://github.com/zth/reason-relay/blob/master/example/src/RelayEnv.re).

## Almost ready to make our first query

There, we now have a Relay environment! The last thing we need to do before we can start making queries is to put our `environment` into React's context by wrapping our app in a `<ReasonRelay.Context.Provider />`:

```reason
/* Index.re */
ReactDOMRe.renderToElementWithId(
  <ReasonRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>
    <App />
  </ReasonRelay.Context.Provider>,
  "app",
);
```

All set and ready to go! Time to [make your first query](making-queries).
