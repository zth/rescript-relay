---
id: getting-started
title: Getting Started with RescriptRelay
sidebar_label: Getting Started
---

#### Recommended background reading

- [Getting started with RescriptReact](https://rescript-lang.org/docs/react/latest/introduction)
- [A Guided Tour of Relay: Setup](https://relay.dev/docs/guided-tour/)

[**Join our Discord**](https://discord.gg/wzj4EN8XDc)

#### Want to follow along with code?

You're encouraged to follow along this walkthrough and play with the concepts through actual code if you can. The easiest way to get started is to use the example that's available in the RescriptRelay repository. Do the following:

- Clone [the RescriptRelay repository](https://github.com/zth/rescript-relay)
- Open the `example` folder and then follow [the instructions](https://github.com/zth/rescript-relay/blob/master/example/README.md) to start the example locally.

## Getting Started

Let's get started!

#### Concurrent Mode is encouraged

You will have the absolute best experience using RescriptRelay in concurrent mode, so you can enjoy the full benefits of the new React and Relay APIs. However, _everything will work_ without concurrent mode too.

##### Extra bindings for experimental APIs with no official bindings yet

Not all new APIs from React are currently bound in the official `@rescript/react` bindings. RescriptRelay therefore ships `ReactExperimental` and `ReactDOMExperimental`, modules with a few bindings to suspense and concurrent mode-related React API's with no official bindings yet. You're encouraged to use this until there's an official alternative.

This means that you'll need React 18 (in `rc` at the time of writing) and ReactDOM.

#### A short note on the workflow of using Relay

You can view Relay as being made up of two parts:

1. The framework Relay that runs on the client and integrates with React.
2. The _Relay compiler_, that takes the GraphQL definitions you write and generate artifacts _at build time_. These artifacts are then used by Relay at runtime.

RescriptRelay adds a thin layer on top of the Relay compiler ([read more about that here](the-compiler)). This means that the workflow for using RescriptRelay is:

1. You write code including GraphQL definitions that Relay will use
2. The Relay compiler finds and compiles your Relay code
3. Repeat

You really don't need to care about the generated artifacts though, RescriptRelay hides them pretty well from you. But, remember the compiler! It needs to run. Luckily it's fast and it has an excellent watch mode.

## Installation

RescriptRelay requires `rescript >= 10.1`, `@rescript/react >= 0.11.0`, and as mentioned [here](#concurrent-mode-is-encouraged), it works best with React 18 (`react@18 react-dom@18`). Let's start by installing the dependencies:

```bash
# Add React 18
yarn add react@18 react-dom@18

# Add rescript-relay and dependencies to the project
# We currently depend on Relay version 15, so install that exact version
yarn add rescript-relay relay-runtime@15.0.0 react-relay@15.0.0
```

After you've installed the packages above, setup ReScript through your `bsconfig.json` like this:

```json
...
"ppx-flags": ["rescript-relay/ppx"],
"bs-dependencies": ["@rescript/react", "rescript-relay"],
...
```

> Are you using VSCode? Make sure you install and use our [dedicated VSCode extension](vscode-extension). It'll make your life using RescriptRelay _much_ smoother.

#### Using React 18

You may need to tell `yarn` to prefer the React 18 versions of React and ReactDOM by adding an entry to `resolutions` in `package.json`. This is because `@rescript/react` (and possibly other dependencies in your project) will depend on a stable React version, and we want to force _everyone_ to use the experimental React versions, or you might start getting nasty bugs and weird errors about conflicting React versions.

Ensure that only the new React 18 versions are used by doing the following:

1. Open `package.json` and look for `react` and `react-dom`. In the versions field you'll see something like `18.0.0` - copy that version number.
2. Add an entry for both `react` and `react-dom` with that version number to your `resolutions`. The final configuration should look something like this:

```json
...
"resolutions": {
    "react": "18.0.0",
    "react-dom": "18.0.0"
  }
}
```

## Configuring Relay

Add a `relay.config.js` to your project root with the following in it:

```js
// relay.config.js
module.exports = {
  src: "./src", // Path to the folder containing your ReScript files
  schema: "./schema.graphql", // Path to the schema.graphql you've exported from your API. Don't know what this is? It's a saved introspection of what your schema looks like. You can run `npx get-graphql-schema http://path/to/my/graphql/server > schema.graphql` in your root to generate it
  artifactDirectory: "./src/__generated__", // The directory where all generated files will be emitted

  // You can add type definitions for custom scalars here.
  // Whenever a custom scalar is encountered, the type emitted will correspond to the definition defined here. You can then deal with the type as needed when accessing the data.
  customScalars: {
    Datetime: "string",
    Color: "Color.t",
  },
};
```

> All configuration options can be seen by running `yarn relay-compiler --help` in your project.

> Read more about [custom scalars here.](custom-scalars)

Please note that RescriptRelay enforces two things that regular Relay does not:

1. You must provide an `artifactDirectory`.
2. You cannot provide your own language plugin.

We'll also add a script to our `package.json` to run the Relay compiler:

```json
// package.json
...
"scripts": {
  "relay": "rescript-relay-compiler",
  "relay:watch": "rescript-relay-compiler --watch"
}
```

> Notice that we're calling `rescript-relay-compiler`, and not `relay-compiler`. This is because RescriptRelay adds a thin layer on top of the regular `relay-compiler`. Read more about [the Relay compiler and how RescriptRelay uses it here](the-compiler).

Now you have two scripts set up; one for running the compiler once, and one for running it in watch-mode.

You can go ahead and start it in watch mode right away (`yarn relay:watch`) in a separate terminal. _Please note that you'll need to be aware of the output from the compiler_ as it will tell you when there are issues you'll need to fix.

> Using VSCode? Our [dedicated VSCode extension](vscode-extension) will run the Relay compiler for you automatically. Check it out!

The Relay compiler is really awesome. If you're interested there's plenty more to read about the compiler and how RescriptRelay uses it [here](the-compiler).

## Setting up the Relay environment

Finally time for some actual code. Next thing is setting up the Relay environment. The Relay environment consists of a network layer responsible for dispatching your GraphQL queries, and a store responsible for storing data and supplying it to your components.

You're encouraged to put this in a separate file like `RelayEnv.re` or similar. Setting it up looks like this (using `bs-fetch` for fetching, which you can find [installation instructions for here](https://github.com/reasonml-community/bs-fetch)):

```rescript
/* RelayEnv.res */

/* This is just a custom exception to indicate that something went wrong. */
exception Graphql_error(string)

/**
 * A standard fetch that sends our operation and variables to the
 * GraphQL server, and then decodes and returns the response.
 */
let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  fetchWithInit(
    "http://localhost:4000/graphql",
    RequestInit.make(
      ~method_=Post,
      ~body=Js.Dict.fromList(list{
        ("query", Js.Json.string(operation.text)),
        ("variables", variables),
      })
      ->Js.Json.object_
      ->Js.Json.stringify
      ->BodyInit.make,
      ~headers=HeadersInit.make({
        "content-type": "application/json",
        "accept": "application/json",
      }),
      (),
    ),
  ) |> Js.Promise.then_(resp =>
    if Response.ok(resp) {
      Response.json(resp)
    } else {
      Js.Promise.reject(Graphql_error("Request failed: " ++ Response.statusText(resp)))
    }
  )
}

let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=fetchQuery, ())

let environment = RescriptRelay.Environment.make(
  ~network,
  ~store=RescriptRelay.Store.make(
    ~source=RescriptRelay.RecordSource.make(),
    ~gcReleaseBufferSize=10, /* This sets the query cache size to 10 */
    (),
  ),
  (),
)
```

## Almost ready to make our first query

There, we now have a Relay environment! We only have two more things to fix before we can start making queries.

##### 1. Adding our Relay environment to React's context

Your Relay environment needs to be available in React's context in your app. To fix that, wrap your app in a `<RescriptRelay.Context.Provider />`:

```rescript
/* Index.res */
ReactDOMExperimental.renderConcurrentRootAtElementWithId(
  <RescriptRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>
    <App />
  </RescriptRelay.Context.Provider>,
  "app",
)

```

##### 2. Rendering your app in Concurrent Mode

We also have to render the app in concurrent mode. Check out how the example app is rendered above; we're using `ReactDOMExperimental.renderConcurrentRootAtElementWithId`. As mentioned in [this section](#concurrent-mode-is-encouraged), you have to render your app in [Concurrent Mode](https://reactjs.org/docs/concurrent-mode-intro.html) for RescriptRelay to work as intended. To simplify things before the API's are officially released, `ReactDOMExperimental` ships with a function `renderConcurrentRootAtElementWithId` that takes `(React.element, string)`, where `React.element` is your app, and `string` is the ID of the DOM node you want to render into.

## Time to make your first query

There, all set up and ready to go! Time to [make your first query](making-queries).

## Advanced

You really don't need to dive into the deep end of things just yet, but once you feel all set up and ready, you should read [this section on keeping your RescriptRelay codebase healthy](codebase-health-considerations).
