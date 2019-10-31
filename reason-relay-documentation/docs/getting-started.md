---
id: getting-started
title: Getting Started with Reason Relay
sidebar_label: Getting Started
---

#### Recommended background reading

- [Getting started with ReasonReact](https://reasonml.github.io/reason-react/docs/en/installation) - _Note that ReasonRelay requires `bs-platform@6`_
- [A Guided Tour of Relay: Setup and Workflow](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#setup-and-workflow)

#### Want to follow along with code?

You're encouraged to follow along this walkthrough and play with the concepts through actual code if you can. The easiest way to get started is to use the example that's available in the ReasonRelay repository. Do the following:

- Clone [the ReasonRelay repository](https://github.com/zth/reason-relay)
- Open the `example` folder and then follow [the instructions](https://github.com/zth/reason-relay/blob/master/example/README.md) to start the example locally.

## Getting Started

Let's get started!

#### Concurrent Mode is required

There are currently no official bindings for the React experimental API's in `reason-react`. ReasonRelay therefore ships `ReactExperimental`, a module with bindings to suspense and concurrent mode-related React API's. You're encouraged to use this until there's an official alternative, which likely won't be shipped until React's API's are released as stable.

This means that you'll need to install the `experimental` version of React and ReactDOM. It also means that your app will need to _have concurrent mode enabled_. Depending on what dependencies you use, this may or may not be easy to enable for you in existing apps. Please [read more in the React documentation on Adopting Concurrent Mode](https://reactjs.org/docs/concurrent-mode-adoption.html).

#### A short note on the workflow of using Relay

You can view Relay as being made up of two parts:

1. The framework Relay that runs on the client and integrates with React.
2. The _Relay compiler_, that takes the GraphQL definitions you write and generate artifacts _at build time_. These artifacts are then used by Relay at runtime.

ReasonRelay adds a thin layer on top of the Relay compiler ([read more about that here](the-compiler)). This means that the workflow for using ReasonRelay is:

1. You write code including GraphQL definitions that Relay will use
2. The Relay compiler finds and compiles your Relay code
3. Repeat

You really don't need to care about the generated artifacts though, ReasonRelay hides them pretty well from you. But, remember the compiler! It needs to run. Luckily it's fast and it has an excellent watch mode.

## Installation

First thing's first - ReasonRelay _requires BuckleScript 6_. It will _not_ work with `bs-platform < 6.0.0`. It also requires `reason-react`, and as mentioned [here](#concurrent-mode-is-required), it requires `react@experimental react-dom@experimental`. Let's start by installing the dependencies:

```bash
# Add React and ReactDOM experimental versions
yarn add react@experimental react-dom@experimental

# Add reason-relay and dependencies to the project
# We currently depend on Relay version 7, so install that exact version
yarn add reason-relay graphql relay-runtime@7.0.0 relay-compiler@7.0.0 react-relay@experimental relay-config@7.0.0
```

After you've installed the packages above, setup BuckleScript through your `bsconfig.json` like this:

```json
...
"ppx-flags": ["reason-relay/ppx"],
"bs-dependencies": ["reason-react", "reason-relay"],
...
```

#### Using experimental React versions

You may need to tell `yarn` to prefer the experimental versions of React and ReactDOM by adding an entry to `resolutions` in `package.json`. This is because `reason-react` (and possibly other dependencies in your project) will depend on a stable React version, and we want to force _everyone_ to use the experimental React versions, or you might start getting nasty bugs and weird errors about conflicting React versions.

Ensure that only the experimental versions are used by doing the following:

1. Open `package.json` and look for `react` and `react-dom`. In the versions field you'll see something like `^0.0.0-experimental-f6b8d31a7` - copy that version number.
2. Add an entry for both `react` and `react-dom` with that version number to your `resolutions`. The final configuration should look something like this:

```json
...
"resolutions": {
    "react": "^0.0.0-experimental-f6b8d31a7",
    "react-dom": "^0.0.0-experimental-f6b8d31a7"
  }
}
```

Remember, the version number for `experimental` releases change pretty often, so _don't just copy from the code snippet above_, make sure you take the one you have in your own `package.json`.

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

> Notice that we're calling `reason-relay-compiler`, and not `relay-compiler`. This is because ReasonRelay adds a thin layer on top of the regular `relay-compiler`. Read more about [the Relay compiler and how ReasonRelay uses it here](the-compiler).

Now you have two scripts set up; one for running the compiler once, and one for running it in watch-mode.

You can go ahead and start it in watch mode right away (`yarn relay:watch`) in a separate terminal. _Please note that you'll need to be aware of the output from the compiler_ as it will tell you when there are issues you'll need to fix.

The Relay compiler is really awesome. If you're interested there's plenty more to read about the compiler and how ReasonRelay uses it [here](the-compiler).

## Setting up the Relay environment

Finally time for some actual code. Next thing is setting up the Relay environment. The Relay environment consists of a network layer responsible for dispatching your GraphQL queries, and a store responsible for storing data and supplying it to your components.

You're encouraged to put this in a separate file like `RelayEnv.re` or similar. Setting it up looks like this (using `bs-fetch` for fetching, which you can find [installation instructions for here](https://github.com/reasonml-community/bs-fetch)):

```reason
/* RelayEnv.re */

/* This is just a custom exception to indicate that something went wrong. */
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
        RequestInit.make(
          ~method_=Post,
          ~body=
            Js.Dict.fromList([
              ("query", Js.Json.string(operation##text)),
              ("variables", variables),
            ])
            |> Js.Json.object_
            |> Js.Json.stringify
            |> BodyInit.make,
          ~headers=
            HeadersInit.make({
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
    ~store=
      ReasonRelay.Store.make(~source=ReasonRelay.RecordSource.make(), ()),
    (),
  );
```

## Almost ready to make our first query

There, we now have a Relay environment! We only have two more things to fix before we can start making queries.

##### 1. Adding our Relay environment to React's context

Your Relay environment needs to be available in React's context in your app. To fix that, wrap your app in a `<ReasonRelay.Context.Provider />`:

```reason
/* Index.re */
ReactExperimental.renderConcurrentRootAtElementWithId(
  <ReasonRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>
    <App />
  </ReasonRelay.Context.Provider>,
  "app",
);
```

##### 2. Rendering your app in Concurrent Mode

We also have to render the app in concurrent mode. Check out how the example app is rendered above; we're using `ReactExperimental.renderConcurrentRootAtElementWithId`. As mentioned in [this section](#concurrent-mode-is-required), you have to render your app in [Concurrent Mode](https://reactjs.org/docs/concurrent-mode-intro.html) for ReasonRelay to work as intended. To simplify things before the API's are officially released, `ReactExperimental` ships with a function `renderConcurrentRootAtElementWithId` that takes `(React.element, string)`, where `React.element` is your app, and `string` is the ID of the DOM node you want to render into.

## Time to make your first query

There, all set up and ready to go! Time to [make your first query](making-queries).
