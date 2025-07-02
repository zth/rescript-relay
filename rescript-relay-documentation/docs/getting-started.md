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

> There's a [starter repo for RescriptRelay](https://github.com/zth/rescript-relay-starter) that you're encouraged to use if you're starting completely fresh.

RescriptRelay requires `rescript >= 11.0.0`, `@rescript/react >= 0.12.0`, and as mentioned [here](#concurrent-mode-is-encouraged), it works best with React 18 (`react@18 react-dom@18`). It also **requires running ReScript in uncurried mode**. Let's start by installing the dependencies:

```bash title="Terminal"
# Add React 18
yarn add react@18 react-dom@18

# Add rescript-relay and dependencies to the project
# We currently depend on Relay version 18.2, so install that exact version
yarn add rescript-relay relay-runtime@18.2.0 react-relay@18.2.0
```

After you've installed the packages above, setup ReScript through your `rescript.json` (previously known as `bsconfig.json`) like this on _**MacOS**_ or _**Linux**_:

```json title="rescript.json"
...
"ppx-flags": ["rescript-relay/ppx"],
"bs-dependencies": ["@rescript/react", "rescript-relay"],
...
```

or like this on _**Windows**_:

```json title="rescript.json"
...
"ppx-flags": ["rescript-relay/ppx.exe"],
"bs-dependencies": ["@rescript/react", "rescript-relay"],
...
```

> Are you using VSCode? Make sure you install and use our [dedicated VSCode extension](vscode-extension). It'll make your life using RescriptRelay _much_ smoother.

## Configuring Relay

Add a `relay.config.js` to your project root with the following in it:

```js title="relay.config.js"
module.exports = {
  src: "./src", // Path to the folder containing your ReScript files
  schema: "./schema.graphql", // Path to the schema.graphql you've exported from your API. Don't know what this is? It's a saved introspection of what your schema looks like. You can run `npx get-graphql-schema http://path/to/my/graphql/server > schema.graphql` in your root to generate it
  artifactDirectory: "./src/__generated__", // The directory where all generated files will be emitted

  // You can add type definitions for custom scalars here.
  // Whenever a custom scalar is encountered, the type emitted will correspond to the definition defined here. You can then deal with the type as needed when accessing the data.
  customScalarTypes: {
    Datetime: "string",
    Color: "Color.t",
  },
};
```

> All configuration options can be seen by running `yarn relay-compiler --help` in your project.

> Read more about [custom scalars here.](custom-scalars)

Please note that RescriptRelay enforces that you provide an `artifactDirectory`.

We'll also add a script to our `package.json` to run the Relay compiler:

```json title="package.json"
...
"scripts": {
  "relay": "rescript-relay-compiler",
  "relay:watch": "rescript-relay-compiler --watch"
}
```

> Notice that we're calling `rescript-relay-compiler`, and not `relay-compiler`. This is because RescriptRelay adds a thin layer on top of the regular `relay-compiler`. Read more about [the Relay compiler and how RescriptRelay uses it here](the-compiler).

Now you have two scripts set up; one for running the compiler once, and one for running it in watch-mode.

You can go ahead and start it in watch mode right away (`yarn relay:watch`) in a separate terminal. _Please note that you'll need to be aware of the output from the compiler_ as it will tell you when there are issues you'll need to fix.

The Relay compiler is really awesome. If you're interested there's plenty more to read about the compiler and how RescriptRelay uses it [here](the-compiler).

## Setting up the Relay environment

Finally time for some actual code. Next thing is setting up the Relay environment. The Relay environment consists of a network layer responsible for dispatching your GraphQL queries, and a store responsible for storing data and supplying it to your components.

You're encouraged to put this in a separate file like `RelayEnv.res` or similar. Setting it up looks like this (using `@glennsl/rescript-fetch` for fetching, which you can find [installation instructions for here](https://github.com/glennsl/rescript-fetch)):

```rescript title="RelayEnv.res"
/* This is a Rescript's standard library, typically opened globally in rescript.json */
open RescriptCore

/**
 * A standard fetch that sends our operation and variables to the
 * GraphQL server, and then decodes and returns the response.
 */
let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = async (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  let resp = await fetch(
    "http://localhost:4000/graphql",
    {
      method: #POST,
      body: {
        "query": operation.text->Nullable.getOr(""),
        "variables": variables
      }
      ->JSON.stringifyAny
      ->Option.getExn
      ->Body.string,
      headers: Headers.fromObject({
        "content-type": "application/json",
        "accept": "application/json",
      }),
    },
  )

  if Response.ok(resp) {
    await Response.json(resp)
  } else {
    panic("Request failed: " ++ Response.statusText(resp))
  }
}

let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=fetchQuery)

let environment = RescriptRelay.Environment.make(
  ~network,
  ~store=RescriptRelay.Store.make(
    ~source=RescriptRelay.RecordSource.make(),
    ~gcReleaseBufferSize=10 /* This sets the query cache size to 10 */
  )
)
```

## Almost ready to make our first query

There, we now have a Relay environment! We only have two more things to fix before we can start making queries.

##### Adding our Relay environment to React's context

Your Relay environment needs to be available in React's context in your app. To fix that, wrap your app in a `<RescriptRelay.Context.Provider />`:

```rescript title="Index.res"
ReactDOMExperimental.renderConcurrentRootAtElementWithId(
  <RescriptRelay.Context.Provider environment=MyModuleWithTheRelayEnvironment.environment>
    <App />
  </RescriptRelay.Context.Provider>,
  "app",
)

```

## Time to make your first query

There, all set up and ready to go! Time to [make your first query](making-queries).

## Advanced

You really don't need to dive into the deep end of things just yet, but once you feel all set up and ready, you should read [this section on keeping your RescriptRelay codebase healthy](codebase-health-considerations).
