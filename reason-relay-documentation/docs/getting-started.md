---
id: getting-started
title: Getting Started with Reason Relay
sidebar_label: Getting Started
---

#### Recommended background reading

- [Getting started with ReasonReact](https://reasonml.github.io/reason-react/docs/en/installation) - _Note that ReasonRelay requires `bs-platform@6`_
- [A Guided Tour of Relay: Setup and Workflow](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#setup-and-workflow)

#### Want to follow along with code?

You're encouraged to follow along this walkthrough with a sample project of your own. The easiest way to get started is to clone [the ReasonRelay repository](https://github.com/zth/reason-relay), open the `example` folder and then follow [the instructions](https://github.com/zth/reason-relay/blob/master/example/README.md) to start the example locally.

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
  schema: "./schema.graphql", // Path to the schema.graphql you've exported from your API. Don't know what this is? It's a saved introspection of what your schema looks like. You can run `npx get-graphql-schema http://path/to/my/graphql/server > schema.graphql` in your root to generate it
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
  "relay:watch": "reason-relay-compiler --watch"
}
```

> Notice that we're calling `reason-relay-compiler`, and not `relay-compiler`. This is because there's a few things ReasonRelay need to do (like emitting a `SchemaAssets.re` file [for your enums](enums)) in addition to what the standard Relay compiler does.

Now you have two scripts set up; one for running the compiler once, and one for running it in watch-mode.

You can go ahead and start it in watch mode right away (`yarn relay:watch`) in a separate terminal. _Please note that you'll need to be aware of the output from the compiler_ as it will tell you when there are issues you'll need to fix.

#### Tangent: A short introduction of the Relay Compiler

Relay's compiler is responsible for taking all GraphQL operations defined in your code, analyze their relationships and check their validity. It then compiles them to generated files containing optimized artifacts that Relay uses at runtime to make queries and understand the response. This means that Relay moves work like parsing and understanding how responses to queries are structured to compile time. A good example of how Relay treats performance as a core feature.

In addition to emitting runtime artifacts, the compiler also _emits ReasonML types through ReasonRelay's language plugin for the compiler_, describing your operations and their relationships. ReasonRelay takes these types and uses them to enforce type safety. This means that Relay and ReasonRelay can _guarantee type-safety_ when interacting with all data, and that you'll get a great developer experience through the tooling that types enable.

As said before, you really don't have to think about the generated artifacts as ReasonRelay does the heavy lifting of using them for you, but if you're interested, have a look at the files in your `artifactDirectory`.

You can [read more about the Relay compiler here](https://relay.dev/docs/en/graphql-in-relay.html#relay-compiler).

## Setting up the Relay environment

Finally time for some actual code. Next thing is setting up the Relay environment. The Relay environment consists of a network layer responsible for dispatching your GraphQL queries, and a store responsible for storing data and supplying it to your components.

You're encouraged to put this in a separate file like `RelayEnv.re` or similar. Setting it up looks like this (using `bs-fetch` for fetching, which you can find [installation instructions for here](https://github.com/reasonml-community/bs-fetch)):

```reason
/* RelayEnv.re */
// This is just a custom exception to indicate that something went wrong.
exception Graphql_error(string);

/**
 * A standard fetch that sends our operation and variables to the
 * GraphQL server, and then decodes and returns the response.
 */
let fetchQuery: ReasonRelay.Network.fetchFunctionPromise =
  (operation, variables, _cacheConfig) =>
    Fetch.(
      fetchWithInit(
        "http://localhost:4000/graphql",
        Fetch.RequestInit.make(
          ~method_=Post,
          ~body=
            Js.Dict.fromList([
              ("query", Js.Json.string(operation##text)),
              ("variables", variables),
            ])
            |> Js.Json.object_
            |> Js.Json.stringify
            |> Fetch.BodyInit.make,
          ~headers=
            Fetch.HeadersInit.make({
              "content-type": "application/json",
              "accept": "application/json",
            }),
          (),
        ),
      )
      |> Js.Promise.then_(resp =>
           if (Response.ok(resp)) {
             Response.json(resp);
           } else {
             Js.Promise.reject(
               Graphql_error(
                 "Request failed: " ++ Response.statusText(resp),
               ),
             );
           }
         )
    );

let network =
  ReasonRelay.Network.makePromiseBased(~fetchFunction=fetchQuery, ());

let environment =
  ReasonRelay.Environment.make(
    ~network,
    ~store=ReasonRelay.Store.make(ReasonRelay.RecordSource.make()),
    (),
  );
```

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
