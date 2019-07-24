# reason-relay
Bindings and a compiler plugin for using Relay with ReasonML.

_NOTE: This is alpha-grade software and various aspects of the API is likely to change in the near future. We're also missing support for a few core Relay features in waiting for the official Relay hooks based APIs. It is not recommended to use this for production apps yet, but you're welcome and encouraged to try it out and post your feedback._

Please refer to ARCHITECTURE.md for a more thorough overview of the different parts and the reasoning behind them.

## Getting started
*Requires BuckleScript 6 (currently in beta), Relay == 5.0.0 and React >= 16.8.1*

```
# Add reason-relay to the project
yarn add reason-relay

# You also need to make sure you have Relay and relay-hooks installed. NOTE: Babel and the Relay babel plugin is not needed if you only use ReasonRelay.

yarn add relay-hooks relay-runtime@5.0.0 relay-compiler@5.0.0 react-relay@5.0.0 
```

Add ReasonRelay bindings + PPX to `bsconfig.json`.

```
...
"ppx-flags": ["reason-relay/ppx"],
"bs-dependencies": ["reason-react", "reason-relay"],
...
```

_As of now_, the Relay compiler does not natively support what we need to make it 
work for emitting Reason types. Therefore, we ship a patched compiler that you can use.
It works the same way as the Relay compiler, _except_ you don't need to provide `--language` and you _must_ provide `--schema` via the CLI (not only via `relay.config.js` or similar).
 
Run the script via package.json like this: 
```
"scripts": {
  "relay": "reason-relay-compiler --src ./src --schema ./path/to/schema.graphql --artifactDirectory ./src/__generated__"
}

yarn relay
```

## Usage
_Check out the `examples` folder for a complete example of setup and usage of most features._

In general, the bindings closely matches how Relay itself works. However, there's a few opinionated 
choices made that are explained below. This documentation does not cover that much of how Relay works in general, and it's not going to be enough if you're new or inexperienced with Relay. In those cases, please look at the Relay documentation in parallel (https://relay.dev) and come back here for finding out how to do things in Reason.  

### Workflow
Just a quick overview of the workflow of using ReasonRelay, primarily for people unfamiliar with Relay:

1. Write GraphQL queries, fragments and mutations using `[%relay]` nodes.
2. Run the ReasonRelay compiler. This finds the `[%relay]` nodes and generates artifacts (types etc) for each node.
3. The ReasonRelay PPX transforms your `[%relay]` nodes into modules that you can use in your components.

So, write GraphQL -> Run the compiler -> Use the generated modules. 

### Setup
You'll need to create and expose and environment for Relay to use.
```reason
let fetchQuery = ...; // Check out RelayEnv.re in the examples folder for an example fetchQuery function using bs-fetch

let network = ReasonRelay.Network.makePromiseBased(fetchQuery); // Eventually we'll support makeObservableBased network too
let store = ReasonRelay.Store.make(ReasonRelay.RecordSource.make());

let environment = ReasonRelay.Environment.make(~network, ~store);
```

You'll then need to make sure you wrap your app with Relays context provider, feeding it 
your environment:

```reason
// Here, RelayEnv.re contains the environment setup, as in the above example
ReactDOMRe.renderToElementWithId(
  <ReasonRelay.Context.Provider environment=RelayEnv.environment>
    <App />
  </ReasonRelay.Context.Provider>,
  "app",
);
```

There, you're all set up!

### Queries, fragments and mutations
All Relay/GraphQL operations must be defined inside `[%relay]` nodes. One exists for each supported 
feature: `[%relay.query]`, `[%relay.fragment]`, `[%relay.mutation]`. 
You assign that node to a module, like:

```reason
module MyQuery = [%relay.query {|
  query SomeQuery { ... }
|}];
```
The _module name_ can be anything (`MyQuery` above). That's just a regular module. The GraphQL string 
you provide to the node however is subject to _all the normal Relay validations_, 
meaning the GraphQL string must follow Relay conventions of having a globally unique name matching the file name, following 
the operation/fragment naming convention, and so on.


### Queries
Queries are defined using `[%relay.query {| query YourQueryHere ... |}]`:

```reason  
module Query = [%relay.query {|
  query SomeOverviewQuery($id: ID!) {
    user(id: $id) {
      firstName
      friendCount
      ...SomeUserDisplayerComponent_user
    }
  }
|}];
```

This will be transformed into a module with roughly the following signature:

```
module Query = {
  // `use` is a React hook you can use in your components.
  let use = (~variables, ~dataFrom=?, ()) => queryResult;
  
  // `fetch` lets you fetch the query standalone, without going through a React component
  let fetch = (~environment: Environment.t, ~variables) => Js.Promise.t(response);
};
```

#### Use as hook: Query.use(~variables=..., ~dataFrom=...)
You can use the query as a hook inside of a React component:
```reason
[@react.component]
let make = (~userId) => {
  let query = Query.use(~variables={"id": userId}, ~dataFrom=StoreThenNetwork, ());
  
  switch (query) {
    | Loading => React.string("Loading...")
    | Error(err) => React.string("Error!")
    | Data(data) => switch (data##user |> Js.Nullable.toOption) {
      | Some(user) => React.string(user##firstName)
      | None => React.null
    | NoData => React.null 
}
```  

#### Use independently: Query.fetch(...)
You can also use the query as you'd use `fetchQuery` from Relay, fetching the query outside 
of a React component. Doing that looks like this:
```reason
Query.fetch(~environment=SomeModuleWithMyEnvironment.environment, ~variables={"id": userId})
  |> Js.Promise.then_(res => switch(res##user |> Js.Nullable.toOption) {
    | Some(user) => {
      ...
      Js.Promise.resolve();
    }
  )
```

### Fragments
_HINT:_ Check out `examples` in this code repo for a complete example of using fragments and queries together.

Fragments are only exposed through React hooks. You define a fragment using `[%relay.fragment {| fragment MyFragment_user on User { ... } |]`.
You then spread the fragment in your query just like normal. Using the fragment looks like this:

```reason
module BookFragment = [%relay.fragment
  {|
    fragment BookDisplayer_book on Book {
      title
      author
    }
  |}
];

/**
 * `book` passed to the component below is, just like "normal" Relay, 
 * and object from a query that contains the fragment spread.
 */

[@react.component]
let make = (~book as bookRef) => {
  let book = BookFragment.use(bookRef);
  ...
```

You can have as many fragments as you like in a component, but each must be defined 
separately. Fragments only expose a `use` hook, and nothing else.

### Mutations
Mutations are defined using `[%relay.mutation {| mutation YourMutationHere ... |}]`:

```reason
module UpdateBookMutation = [%relay.mutation
  {|
    mutation BookEditorUpdateMutation($input: UpdateBookInput!) {
      updateBook(input: $input) {
        book {
          title
          author
        }
      }
    }
  |}
];
```

This will be transformed into a module with roughly the following signature:

```
module UpdateBookMutation = {
  // `use` is a React hook you can use in your components.
  let use = () => (mutate, mutationStatus);
  
  // `commitMutation` lets you commit the mutation from anywhere, not tied to a React component.
  let commitMutation= (~environment: Environment.t, ~variables, ~optimisticResponse, ~updater ...) => Js.Promise.t(response);
};
```

Everything that Relay supports (optimistic updates etc) is also supported by ReasonRelay, except for
mutation updater configs. Please use the `updater` functionality for now when you need to update the store.

#### Use as hook: UpdateBookMutation.use()
You can use the mutation as a React hook:
```reason
[@react.component]
let make = (~bookId) => {
  let (mutate, mutationState) = UpdateBookMutation.use();
  
  ...
  mutate(
    ~variables={
      "input": {
        "clientMutationId": None,
        "id": bookId,
        "title": state.title,
        "author": state.author,
      },
    },
```

#### Use standalone: UpdateBookMutation.commitMutation(...)
Just like you'd use `commitMutation` from regular Relay, you can do the mutation from anywhere 
without needing to use a hook inside of a React component. `commitMutation` returns a promise that 
resolves with the mutation result.

```
UpdateBookMutation.commitMutation(
  ~environment=SomeModuleWithMyEnv.environment, 
  ~variables={
   "input": {
     "clientMutationId": None,
     "id": bookId,
     "title": state.title,
     "author": state.author,
   },
 },
) |> Js.Promise.then_(res => ...)
``` 

### Refetching
Right now, there are no bindings to simplify refetching (RefetchContainer in Relay). We are waiting for the official Relay hooks/suspense-based API before we make an actual binding for refetching.

Meanwhile, doing a normal `MyDefinedQuery.fetch(...)` should suffice for some scenarios.

### Connections/pagination
No bindings exist for PaginationContainer or a pagination hook either right now. Sadly there are no workarounds/alternatives 
(like with refetch) before we get the hooks/suspense based APIs from Relay itself. 

### Unions and Enums
Since Reason's type system is quite different to Flow/TypeScript, working with unions and enums works in a special way with ReasonReact.

#### Unions
Unions are fields in GraphQL that can return multiple GraphQL types. The field selections of each type is also potentially different for each 
used union. In Flow/TypeScript, this is handled by using union types that match on the `__typename` property that's always available on a union. Reason however does not have union types in the same sense. In order to get type-safety in Reason you'll therefore need to _unwrap_ the union.

Imagine a GraphQL union that looks like this:
```graphql
type SomeType {
  id: ID!
  name: String!
  age: Int!
}

type AnotherType {
  id: ID!
  count: Int!
  available: Boolean!
}

union SomeUnion = SomeType | AnotherType  
```

Now, the following Relay selection is made:
```reason
module Query = [%relay.query {|
  someUnionProp {
    __typename
    
    ... on SomeType {
      name
    }
    
    ... on AnotherType {
      count
    }
  }
|}
```

In this scenario, working with `someUnionProp` could be either a `SomeType` or `AnotherType`. With ReasonRelay, this will generate roughly the following (pseudo code):
```reason
module Union_someUnionProp = {
  type wrapped;
  let unwrap: wrapped => [ | `SomeType({. "name": string }) | `AnotherType({. "count": int }) | `UnmappedUnionMember ]
};

type response = {.
  "someUnionProp": Union_someUnionProp.wrapped
};
```

So, the actual node in the response is an abstract type `wrapped` that you'll need to unwrap, which will return a polymorphic variant 
with the data for each GraphQL type. All `Union_someUnionPropName` modules are available on the `Query` module where the Relay operation 
is defined. Unwrapping and using the data would then look like this:

```reason
switch (data##someUnionProp |> Query.Union_someUnionProp.unwrap) {
  | `SomeType(data) => React.string(data##name)
  | `AnotherType(data) => React.string("Count: " ++ string_of_int(data##count))
  | `UnmappedUnionMember => React.null
}
```

`UnmappedUnionMember` is a safety guard that you'll need to handle in case the server extends the union with something that you currently do not have code to handle. 

#### Enums
In the GraphQL response, enums are just strings that follow a defined schema. However, Reason does not have string literal enums. This means you'll need to unwrap enums in order to work with them. The compiler generates a file called `SchemaAssets.re` containing types and utils to interact with all enums in your schema.

Here's how you unwrap enums to work with them:
```reason
// someEnum is an enum MyEnum, with possible values SOME_VALUE | ANOTHER_VALUE
module Query = [%relay.query {|
  query SomeQuery {
    someEnum
  }
|}];
```

You then work with the enum this way:
```reason
switch(data##someEnum |> SchemaAssets.Enum_MyEnum.unwrap) {
  | `SOME_VALUE => React.string("Some value")
  | `ANOTHER_VALUE => React.string("Another value")
  | `FUTURE_ADDED_VALUE__=> React.null
};
```

Similar to unions, enums _always_ include a safety guard to force you to handle enum values that might be added after your code is deployed. In enums, that's an additional polymorphic variant `FUTURE_ADDED_VALUE__` that's added to each enum and returned whenever there's an unknown enum value matched.

#### Enums as inputs/variables
If you want to use enums as _input values_, whether it's as a variable for querying or as an input for a mutation, you'll need to _wrap_ the enum in order for it to be converted to something that can be sent to the server. `wrap` is a function that's generated for each of your enums. Example:

```reason
~variables={
  "myEnumValue": SchemaAssets.Enum_MyEnum.wrap(`SOME_VALUE)
}
```

### Interacting with the store
ReasonRelay exposes a full interface to interacting with the store. 

#### Updater functions for mutations
You can pass an updater function to mutations just like you'd normally do in Relay:

```reason
mutate(
~variables={
  ...
},
~updater=
  store => {
    // Open ReasonRelay to simplify using RecordSourceSelectorProxy and RecordProxy
    open ReasonRelay;

    let mutationRes =
      store
      |> RecordSourceSelectorProxy.getRootField(
           ~fieldName="addBook",
         );
         
     ...
 },
(),
);
```

#### commitLocalUpdate
`commitLocalUpdate` is exposed for committing local updates, and can be used like this:
```reason
commitLocalUpdate(~environment=SomeModuleWithMyEnv.environment, ~updater=store => {
  open ReasonRelay;
  let root = store |> RecordSourceSelectorProxy.getRoot;
  let someRootRecord = root |> RecordProxy.getLinkedRecord(~name="someFieldName", ~arguments=None);
  
  switch (someRootRecord) {
    | Some(recordProxy) => {      
      recordProxy |> RecordProxy.setValueString(~name="someFieldThatIsAString", ~value="New value", ~arguments=None);
    }
    | None => ...
  }
})
```

#### Note on getting and setting values from a RecordProxy
`RecordProxy`, the data type Relay exposes to update data in the store, saves field values as mixed types, 
meaning that `recordProxy.getValue("someKey")` in the JS version of Relay can return just about any type there is. 
However, Reason does not allow more than one type to be returned from a function call. So, in ReasonRelay, 
`getValue` and `setValue` is replaced with one function for each primitive type:
```reason
let someBoolValue = recordProxy |> RecordProxy.getValueBool(~name="someFieldThatIsABoolean", ~arguments=None);
let someStringValue = recordProxy |> RecordProxy.getValueString(~name="someFieldThatIsAString", ~arguments=None);
  
recordProxy |> RecordProxy.setValueInt(~name="someFieldThatIsAnInt", ~value=1, ~arguments=None);
recordProxy |> RecordProxy.setValueFloat(~name="someFieldThatIsAFloat", ~value=2.0, ~arguments=None);
```

## Developing
Instructions coming soon.
