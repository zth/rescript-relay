@ocaml.doc(
  "Abstract type for arguments, used when selecting fields on `RecordProxy` and friends when interacting with the store imperatively.

### Using `arguments` to access fields on `RecordProxy`
_(note that this example is for `RecordProxy`, but it applies to any primitive in the store that takes arguments for fields)_
"
)
type arguments
// DOCEND

@ocaml.doc(
  "Abstract type for uploadables.

### Constructing an `uploadables`
Use `makeUploadable`: `makeUploadable({ \"someFile\": theFileYouWantToUpload })` to construct an `uploadables`, and then pass it to your mutation via the `uploadables` prop.

Please note that you'll need to handle _sending_ the uploadables to your server yourself in the network layer. [Here's an example](https://github.com/facebook/relay/issues/1844#issuecomment-316893590) in regular JS that you can adapt to ReScript as you need/want."
)
type uploadables
// DOCEND

@ocaml.doc(
  "If you see this, it means that all fields have been masked in this selection, which is why it contains no data. Relay uses [_data masking_](https://relay.dev/docs/en/thinking-in-relay.html#data-masking) to hide data you haven't explicitly asked for, even if it exists on the object.

### Were you expecting to see something here?
In most cases when you see this but expected to see actual data, you've spread one or more fragments into a mutation and forgot to add `@raw_response_type` to your mutation, like:

```graphql
mutation SomeMutation($input: SomeMutationInput!) @raw_response_type {
  ...
}
```

`@raw_response_type` ([documented here](https://relay.dev/docs/en/a-guided-tour-of-relay#optimistic-updates)) will make sure that you get access to _all_ the data when making optimistic updates.
"
)
type allFieldsMasked = {.}
// DOCEND

@ocaml.doc(
  "Abstract helper type to signify something that could not be generated in a type-safe way."
)
type any
// DOCEND

@ocaml.doc(
  "A query node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type queryNode<'node>
// DOCEND

@ocaml.doc(
  "A fragment node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type fragmentNode<'node>
// DOCEND

@ocaml.doc(
  "A mutation node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type mutationNode<'node>
// DOCEND

@ocaml.doc(
  "A subscription node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type subscriptionNode<'node>
// DOCEND

@ocaml.doc(
  "This type shows all of the fragments that has been spread on this particular object.

### Using fragments
Any time you spread a fragment in your GraphQL definition, a _fragment reference_ is created. To get the data for that fragment, you then pass `fragmentRefs` to that particlar component's `Fragment.use` hook. Example:

```rescript
/* SomeModule.res */
module Fragment = %relay(
  fragment SomeModule_user on User {
    id
    ...Avatar_url # This creates a _fragment reference_ on the fragment for `Avatar_user`
  }
)

@react.component
let make = (~user) => {
  let user = Fragment.use(user) /Ä This now has the data for the `SomeModule_user` fragment above. */

  /**
   * The line below passes `fragmentRefs` on `user` (this components fragment) to the Avatar component, 
   * which then uses that to retrieve its own fragment data.
   */
  <Avatar user={user.fragmentRefs} />
}
```"
)
type fragmentRefs<'fragments>
// DOCEND

@ocaml.doc(
  "The type of the id Relay uses to identify records in its store.

### Getting `dataId`'s
You can get the dataId of anything by selecting `__id` in your query/fragment/mutation/subscription, like this:
```graphql
fragment Avatar_user on User {
  __id # This is the data id
  firstName
  lastName
}
```

If you have globally unique IDs in your graph, `__id` will always be the same as the regular `id`. However, as `id` is commonly modelled as a `string`, selecting `__id` will conveniently give you a `dataId` directly that you can use to interact with the store.

### Converting between `string` and `dataId`
You'll often want to convert between `string` and `dataId`. You can do this by using `ReasonRelay.makeDataId` (`ReasonRelay.makeDataId(yourStringHere`) and `ReasonRelay.dataIdToString` (`ReasonRelay.dataIdToString(yourDataIdHere)`)."
)
type dataId
// DOCEND

@ocaml.doc("Turns a `dataId` into a `string`.")
external dataIdToString: dataId => string = "%identity"
// DOCEND

@ocaml.doc(
  "Turns a `string` into a `dataId`.

### Example
```rescript
module User = %relay(`
  fragment SomeModule_user on User {
    id
  }
`)

@react.component
let make = (~user) => {
  let user = Fragment.use(user)

  /* This converts `user.id` to a `dataId`, letting you use it to interact with the store. */
  let idAsDataId = ReasonRelay.makeDataId(user.id)
}
```"
)
external makeDataId: string => dataId = "%identity"
// DOCEND

@ocaml.doc(
  "Construct an `arguments` object for use with certain Relay store APIs.

### Usage
Use it like this: `makeArguments({ \"someArgument\": someValue, \"anotherArgument\": anotherValue })`. Notice the \"\" surrounding the property names - these are important and tells ReScript that we want this to be a JS object."
)
external makeArguments: {..} => arguments = "%identity"
// DOCEND

@ocaml.doc(
  "Construct an `uploadables` object that you can use for uploads via Relay.

### Usage
Use it like this: `makeUploadable({ \"someFile\": someFile, \"anotherFile\": anotherFile })`. Notice the \"\" surrounding the property names - these are important and tells ReScript that we want this to be a JS object."
)
external makeUploadable: {..} => uploadables = "%identity"
// DOCEND

@ocaml.doc(
  "This generates a `dataId` for use on the _client_ side. However, this is farily low level, and what you're probably really looking for is `generateUniqueClientID` that'll let you generate a new, unique `dataId` that you can use for client side only records (like when doing optimistic updates)."
)
@bs.module("relay-runtime")
external generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?, unit) => dataId =
  "generateClientID"
// DOCEND

@ocaml.doc(
  "This generates a unique `dataId` that's safe to use on the _client_ side. Useful when doing optimistic updates and you need to create IDs that the optimistic update can use."
)
@bs.module("relay-runtime")
external generateUniqueClientID: unit => dataId = "generateUniqueClientID"
// DOCEND

@ocaml.doc("Checks whether the provided `dataId` is guaranteed to be a client side only id.")
@bs.module("relay-runtime")
external isClientID: dataId => bool = "isClientID"
// DOCEND

@ocaml.doc(
  "Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.
  
### Example
```rescript
/* Make sure this runs before Relay is setup. */

ReasonRelay.featureFlags.enablePrecisTypeRefinement = true
```"
)
type featureFlags = {
  @bs.as("ENABLE_VARIABLE_CONNECTION_KEY")
  mutable enableVariableConnectionKey: bool,
  @bs.as("ENABLE_PARTIAL_RENDERING_DEFAULT")
  mutable enablePartialRenderingDefault: bool,
  @bs.as("ENABLE_RELAY_CONTAINERS_SUSPENSE")
  mutable enableRelayContainersSuspense: bool,
  @bs.as("ENABLE_PRECISE_TYPE_REFINEMENT")
  mutable enablePrecisTypeRefinement: bool,
}
// DOCEND

@ocaml.doc(
  "Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.

### Example
```rescript
/* Make sure this runs before Relay is setup. */

ReasonRelay.featureFlags.enablePrecisTypeRefinement = true
```"
)
@bs.module("relay-runtime")
external relayFeatureFlags: featureFlags = "RelayFeatureFlags"
// DOCEND

@ocaml.doc(
  "An abstract type representing all records in the store serialized to JSON in a way that you can use to re-hydrate the store. 

See `RecordSource.toJSON` for how to produce it."
)
type recordSourceRecords
// DOCEND

@ocaml.doc(
  "The `dataId` for the Relay store's root. Useful when for example referencing the `parentID` of a connection that's on the store root."
)
@bs.module("relay-runtime")
external storeRootId: dataId = "ROOT_ID"
// DOCEND

@ocaml.doc("The `type` for the Relay store's root `RecordProxy`.") @bs.module("relay-runtime")
external storeRootType: string = "ROOT_TYPE"
// DOCEND

@ocaml.doc("Internal, do not use.") @bs.module("./utils")
external convertObj: ('a, Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>>, 'b, 'c) => 'd = "traverser"
// DOCEND

@ocaml.doc(
  "Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store"
)
module RecordProxy: {
  @ocaml.doc(
    "Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store"
  )
  type t
  // DOCEND

  @ocaml.doc("Copies all fields from one `RecordProxy` to another.") @bs.send
  external copyFieldsFrom: (t, ~sourceRecord: t) => unit = "copyFieldsFrom"
  // DOCEND

  @ocaml.doc("Gets the \`dataId\` for a particular record.") @bs.send
  external getDataId: t => dataId = "getDataID"
  // DOCEND

  @ocaml.doc(
    "Gets a single linked record. A linked record is another object in the store, and not a scalar field like an int or float."
  )
  @bs.send
  @bs.return(nullable)
  external getLinkedRecord: (t, ~name: string, ~arguments: arguments=?, unit) => option<t> =
    "getLinkedRecord"
  // DOCEND

  @ocaml.doc(
    "Gets an array of linked records, for when a field is a list (meaning a link to multiple records)."
  )
  let getLinkedRecords: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<t>>>
  // DOCEND

  @ocaml.doc(
    "This returns an existing linked record, or creates one at the configured place if one does not already exist."
  )
  @bs.send
  external getOrCreateLinkedRecord: (
    t,
    ~name: string,
    ~typeName: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "getOrCreateLinkedRecord"
  // DOCEND

  @ocaml.doc("Returns the `__typename` of this particular record.") @bs.send
  external getType: t => string = "getType"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be a string.") @bs.send @bs.return(nullable)
  external getValueString: (t, ~name: string, ~arguments: arguments=?, unit) => option<string> =
    "getValue"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be an array of strings.")
  @bs.send
  @bs.return(nullable)
  external getValueStringArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<string>>> = "getValue"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be an int.") @bs.send @bs.return(nullable)
  external getValueInt: (t, ~name: string, ~arguments: arguments=?, unit) => option<int> =
    "getValue"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be an array of ints.")
  @bs.send
  @bs.return(nullable)
  external getValueIntArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<int>>> = "getValue"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be a float.") @bs.send @bs.return(nullable)
  external getValueFloat: (t, ~name: string, ~arguments: arguments=?, unit) => option<float> =
    "getValue"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be an array of floats.")
  @bs.send
  @bs.return(nullable)
  external getValueFloatArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<float>>> = "getValue"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be a boolean.") @bs.send @bs.return(nullable)
  external getValueBool: (t, ~name: string, ~arguments: arguments=?, unit) => option<bool> =
    "getValue"
  // DOCEND

  @ocaml.doc("Returns a field value, expecting it to be an array of booleans.")
  @bs.send
  @bs.return(nullable)
  external getValueBoolArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<bool>>> = "getValue"
  // DOCEND

  @ocaml.doc("Sets a `RecordProxy.t` as the linked record for a particular field.") @bs.send
  external setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?, unit) => t =
    "setLinkedRecord"
  // DOCEND

  @ocaml.doc("Sets an array of `RecordProxy.t` as the linked records for a particular field.")
  @bs.send
  external setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"
  // DOCEND

  @ocaml.doc("Sets a string as field value.") @bs.send
  external setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"
  // DOCEND

  @ocaml.doc("Sets an array of strings as field value.") @bs.send
  external setValueStringArray: (
    t,
    ~value: array<string>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"
  // DOCEND

  @ocaml.doc("Sets an int as field value.") @bs.send
  external setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"
  // DOCEND

  @ocaml.doc("Sets an array of ints as field value.") @bs.send
  external setValueIntArray: (
    t,
    ~value: array<int>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"
  // DOCEND

  @ocaml.doc("Sets a float as field value.") @bs.send
  external setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"
  // DOCEND

  @ocaml.doc("Sets an array of floats as field value.") @bs.send
  external setValueFloatArray: (
    t,
    ~value: array<float>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"
  // DOCEND

  @ocaml.doc("Sets a boolean as field value.") @bs.send
  external setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"
  // DOCEND

  @ocaml.doc("Sets an array of booleans as field value.") @bs.send
  external setValueBoolArray: (
    t,
    ~value: array<bool>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"
  // DOCEND

  @ocaml.doc("Sets the field value to `undefined` (meaning Relay will treat it as missing data).")
  @bs.send
  external setValueToUndefined: (
    t,
    @bs.as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"
  // DOCEND

  @ocaml.doc("Sets the field value to `null`.") @bs.send
  external setValueToNull: (
    t,
    @bs.as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"
  // DOCEND

  @ocaml.doc(
    "Sets this linked record to `undefined` (meaning Relay will treat it as missing data)."
  )
  @bs.send
  external setLinkedRecordToUndefined: (
    t,
    @bs.as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecord"
  // DOCEND

  @ocaml.doc("Sets this linked record to `null`.") @bs.send
  external setLinkedRecordToNull: (
    t,
    @bs.as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecord"
  // DOCEND

  @ocaml.doc(
    "Sets the field holding these linked records to `undefined` (meaning Relay will treat it as missing data)."
  )
  @bs.send
  external setLinkedRecordsToUndefined: (
    t,
    @bs.as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"
  // DOCEND

  @ocaml.doc("Sets the field holding these linked records to `null`.") @bs.send
  external setLinkedRecordsToNull: (
    t,
    @bs.as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"
  // DOCEND

  @ocaml.doc(
    "Invalidates this record.

Invalidating a record means that the _next_ time Relay evaluates this record, it'll be treated as missing.

_Beware_ that this doesn't mean that queries using this record will refetch immediately. Rather, it'll happen the next time the query _renders_. Have a look at `useSubscribeToInvalidationState`, that'll allow you to subscribe to whenever records are invalidated, if you're looking for a way to refetch immediately as something invalidates."
  )
  @bs.send
  external invalidateRecord: t => unit = "invalidateRecord"
  // DOCEND
}

@ocaml.doc(
  "RecordSourceSelectorProxy and RecordSourceProxy are the two modules representing the store, with various capabilities."
)
module RecordSourceSelectorProxy: {
  @ocaml.doc("Type type representing a `RecordSourceSelectorProxy`.")
  type t
  // DOCEND

  @ocaml.doc("Creates a new `RecordProxy`.") @bs.send
  external create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t = "create"
  // DOCEND

  @ocaml.doc("Deletes the `RecordProxy` with the provided `dataId`.") @bs.send
  external delete: (t, ~dataId: dataId) => unit = "delete"
  // DOCEND

  @ocaml.doc("Returns the `RecordProxy` with the provided `dataId`, if it exists.")
  @bs.send
  @bs.return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"
  // DOCEND

  @ocaml.doc(
    "Returns the _root_ `RecordProxy`, meaning the `RecordProxy` holding your top level fields."
  )
  @bs.send
  external getRoot: t => RecordProxy.t = "getRoot"
  // DOCEND

  @ocaml.doc(
    "Returns the `RecordProxy` for the `fieldName` at root. You should prefer using `RecordSourceSelectorProxy.getRoot()` and traverse from there if you need access to root fields rather than use this."
  )
  @bs.send
  @bs.return(nullable)
  external getRootField: (t, ~fieldName: string) => option<RecordProxy.t> = "getRootField"
  // DOCEND

  @ocaml.doc("Plural version of `RecordSourceSelectorProxy.getRootField`.")
  let getPluralRootField: (t, ~fieldName: string) => option<array<option<RecordProxy.t>>>
  // DOCEND

  @ocaml.doc(
    "Invalidates the entire store. This means that _at the next render_, the entire store will be treated as empty, meaning Relay will refetch everything it needs to show the view it's to show."
  )
  @bs.send
  external invalidateStore: t => unit = "invalidateStore"
  // DOCEND
}

@ocaml.doc(
  "Read the Relay docs section on [ConnectionHandler](https://relay.dev/docs/en/relay-store#connectionhandler)"
)
module ConnectionHandler: {
  @ocaml.doc(
    "For a `RecordProxy`, returns the `RecordProxy` that is at the connection config provided."
  )
  @bs.module("relay-runtime")
  @bs.scope("ConnectionHandler")
  @bs.return(nullable)
  external getConnection: (
    ~record: RecordProxy.t,
    ~key: string,
    ~filters: arguments=?,
    unit,
  ) => option<RecordProxy.t> = "getConnection"
  // DOCEND

  @ocaml.doc("Creates an edge for a particular connection.")
  @bs.module("relay-runtime")
  @bs.scope("ConnectionHandler")
  external createEdge: (
    ~store: RecordSourceSelectorProxy.t,
    ~connection: RecordProxy.t,
    ~node: RecordProxy.t,
    ~edgeType: string,
  ) => RecordProxy.t = "createEdge"
  // DOCEND

  @ocaml.doc(
    "Inserts an edge into a connection _before_ the provided cursor. If no cursor is provided, it inserts the edge at the start of the connection list."
  )
  @bs.module("relay-runtime")
  @bs.scope("ConnectionHandler")
  external insertEdgeBefore: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeBefore"
  // DOCEND

  @ocaml.doc(
    "Inserts an edge into a connection _after_ the provided cursor. If no cursor is provided, it inserts the edge at the end of the connection list."
  )
  @bs.module("relay-runtime")
  @bs.scope("ConnectionHandler")
  external insertEdgeAfter: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeAfter"
  // DOCEND

  @ocaml.doc(
    "Deletes any edge from the connection where the node of the edge has the provided `dataId`. Please not that this _will not_ remove the actual node from the store. Use `RecordSourceSelectorProxy.delete` for that."
  )
  @bs.module("relay-runtime")
  @bs.scope("ConnectionHandler")
  external deleteNode: (~connection: RecordProxy.t, ~nodeId: dataId) => unit = "deleteNode"
  // DOCEND
}

@ocaml.doc(
  "The cache config provided to the network layer. Relay won't do anything in particular with these, it's up to you to use them if you want inside of your `NetworkLayer`."
)
type cacheConfig = {
  force: option<bool>,
  poll: option<int>,
  liveConfigId: option<string>,
  transactionId: option<string>,
}
// DOCEND

@ocaml.doc(
  "A Relay observable, used throughout Relay for delivering data, in particular when dealing with multiple payloads like with subscriptions or multipart responses like `@stream` or `@defer`."
)
module Observable: {
  @ocaml.doc("The type representing the observable.")
  type t<'response>
  // DOCEND

  @ocaml.doc("This sink can be used to give the observable new data.")
  type sink<'response> = {
    next: 'response => unit,
    error: Js.Exn.t => unit,
    complete: unit => unit,
    closed: bool,
  }
  // DOCEND

  @ocaml.doc("A subscription for an observable, allowing you to unsubscribe if wanted.")
  type subscription = {
    unsubscribe: unit => unit,
    closed: bool,
  }
  // DOCEND

  @ocaml.doc("An observer of the observable.")
  type observer<'response>
  // DOCEND

  @ocaml.doc("Create an observer.") @bs.obj
  external makeObserver: (
    ~start: subscription => unit=?,
    ~next: 'response => unit=?,
    ~error: Js.Exn.t => unit=?,
    ~complete: unit => unit=?,
    ~unsubscribe: subscription => unit=?,
    unit,
  ) => observer<'response> = ""
  // DOCEND

  @ocaml.doc(
    "Create a new observable, getting fed an `Observable.sink` for interacting with the observable, and optionally returning a `Observable.subscription` if you have things you want to unsubscribe from as the observable closes."
  )
  @bs.module("relay-runtime")
  @bs.scope("Observable")
  external make: (sink<'t> => option<subscription>) => t<'t> = "create"
  // DOCEND

  @ocaml.doc("Subscribe to the `Observable.t` using an observer.") @bs.send
  external subscribe: (t<'t>, observer<'t>) => subscription = "subscribe"
  // DOCEND

  @ocaml.doc(
    "Turns an `Observable` into a promise. _Beware_ that reading the response in the resulting promise is currently _not safe_ due to some internals of how ReScript Relay works. This will be resolved in the future."
  )
  @bs.send
  external toPromise: t<'t> => Promise.t<'t> = "toPromise"
  // DOCEND
}

@ocaml.doc("Represents the network layer.")
module Network: {
  @ocaml.doc("The type representing an instantiated `NetworkLayer`.")
  type t
  // DOCEND

  @ocaml.doc(
    "The operation fed to the `NetworkLayer` when Relay wants to make a request. Please note that if you're using persisted queries, `id` will exist but `text` won't, and vice versa when not using persisted queries."
  )
  type operation = {
    id: string,
    text: string,
    name: string,
    operationKind: string,
  }
  // DOCEND

  @ocaml.doc("The shape of the function Relay expects for creating a subscription.")
  type subscribeFn = (operation, Js.Json.t, cacheConfig) => Observable.t<Js.Json.t>
  // DOCEND

  @ocaml.doc(
    "The shape of the function responsible for fetching data if you want to return a promise rather than an `Observable`."
  )
  type fetchFunctionPromise = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Js.Promise.t<Js.Json.t>
  // DOCEND

  @ocaml.doc(
    "The shape of the function responsible for fetching data if you want to return an `Observable`."
  )
  type fetchFunctionObservable = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Observable.t<Js.Json.t>
  // DOCEND

  @ocaml.doc("Create a new `NetworkLayer` using a fetch function that returns a promise.")
  @bs.module("relay-runtime")
  @bs.scope("Network")
  external makePromiseBased: (
    ~fetchFunction: fetchFunctionPromise,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"
  // DOCEND

  @ocaml.doc("Create a new `NetworkLayer` using a fetch function that returns an `Observable`.")
  @bs.module("relay-runtime")
  @bs.scope("Network")
  external makeObservableBased: (
    ~observableFunction: fetchFunctionObservable,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"
  // DOCEND
}

@ocaml.doc(
  "RecordSource is the source of records used by the store. Can be initiated with or without prior records; eg. hydrating the store with prior data."
)
module RecordSource: {
  @ocaml.doc("The type representing an instantiated `RecordSource`.")
  type t
  // DOCEND

  @ocaml.doc(
    "Create a new `RecordSource`. Here's where you pass an existing `recordSourceRecords` if you have existing records you want to hydrate the store with, when doing SSR or similar."
  )
  @bs.module("relay-runtime")
  @bs.new
  external make: (~records: recordSourceRecords=?, unit) => t = "RecordSource"
  // DOCEND

  @ocaml.doc(
    "Serializes the `RecordSource` into `recordSourceRecords` that you can use to rehydrate another store. Typically used for SSR."
  )
  @bs.send
  external toJSON: t => recordSourceRecords = "toJSON"
  // DOCEND
}

@ocaml.doc("The actual store module, with configuration for the store.")
module Store: {
  @ocaml.doc("The type representing an instantiated `Store`.")
  type t
  // DOCEND

  @ocaml.doc("Creates a new `Store`.")
  let make: (
    ~source: RecordSource.t,
    ~gcReleaseBufferSize: /* `gcReleaseBufferSize` controls how many queries are allowed to be cached by default. Increase this to increase the size of the cache. */
    int=?,
    ~queryCacheExpirationTime: int /* `queryCacheExpirationTime` sets a TTL (time to live) for all queries. If that time passes, the data is considered stale and is evicted from the store. Default is no TTL. */=?,
    unit,
  ) => t
  // DOCEND

  @ocaml.doc("Gets the `RecordSource` for this `Store`.") @bs.send
  external getSource: t => RecordSource.t = "getSource"
  // DOCEND

  @ocaml.doc(
    "Publishes _new_ records to this store. This is useful in particular with frameworks like Next.js where routes could preload data needed and then serialize that (using `RecordSource.toJSON`) and send it over the wire, but you already have a store instantiated client side. This will then allow you to publish those records into your existing store.

### Pseudo-example
```rescript
/* A Next.js route component */

@react.component
let make = (~serializedRecords: ReasonRelay.recordSourceRecords) => {
  let environment = ReasonRelay.useEnvironmentFromContext()

  /* Make sure we only run this once */
  React.useEffect2(() => {
    /* This will publish the records to the existing store */
    environment->ReasonRelay.Store.publish(serializedRecords)
    None
  }, (environment, serializedRecords))
}
```"
  )
  @bs.send
  external publish: (t, RecordSource.t) => unit = "publish"
  // DOCEND
}

@ocaml.doc(
  "renderPolicy controls if Relay is allowed to render partially available data or not. 

Relay rendering partial data means it will suspend at the _fragment level_ rather than at the _query level_ if a query does not exist in the cache. This has the implication that if a fragment can be reached because the data for that fragment already exists, Relay can allow that to render while waiting for new data."
)
type renderPolicy =
  /* Always render the full result */
  | Full
  /* Allow rendering any fragments that already have the data needed */
  | Partial
// DOCEND

@ocaml.doc("Internal, do not use.")
let mapRenderPolicy: option<renderPolicy> => option<string>
// DOCEND

@ocaml.doc("Handle creating and using operation descriptors.")
type operationDescriptor
// DOCEND

@ocaml.doc(
  "Module representing the environment, which you'll need to use and pass to various functions. Takes a few configuration options like store and network layer."
)
module Environment: {
  @ocaml.doc("The type representing an instantiated `Environment`.")
  type t
  // DOCEND

  @ocaml.doc("Create a new `Environment`.")
  let make: (
    ~network: Network.t,
    ~store: Store.t,
    ~getDataID: (
      ~nodeObj: {.."__typename": string, "id": string} as 'a,
      ~typeName: string,
    ) => string=?,
    ~defaultRenderPolicy: renderPolicy=?,
    ~treatMissingFieldsAsNull: bool=?,
    unit,
  ) => t
  // DOCEND

  @ocaml.doc("Get the `Store` for this `Environment`.") @bs.send
  external getStore: t => Store.t = "getStore"
  // DOCEND

  @ocaml.doc("Given an `operationDescriptor`, commits the corresponding payload.") @bs.send
  external commitPayload: (t, operationDescriptor, 'payload) => unit = "commitPayload"
  // DOCEND
}

@ocaml.doc(
  "A disposable is something you can use to dispose of something when you don't use/need it anymore."
)
module Disposable: {
  @ocaml.doc("The type representing a `Disposable`.")
  type t
  // DOCEND

  @ocaml.doc("Dispose the `Disposable`.") @bs.send external dispose: t => unit = "dispose"
  // DOCEND
}

@ocaml.doc("fetchPolicy controls how you want Relay to resolve your data.")
type fetchPolicy =
  | StoreOnly /* Resolve only from the store */
  | StoreOrNetwork /* Resolve from the store if all data is there, otherwise make a network request */
  | StoreAndNetwork /* Like StoreOrNetwork, but always make a request regardless of if the data was there initially or not */
  | NetworkOnly /* Always make a request, regardless of what's in the store */
// DOCEND

@ocaml.doc("Internal, do not use.")
let mapFetchPolicy: option<fetchPolicy> => option<string>
// DOCEND

@ocaml.doc(
  "The fetch policies allowed for fetching a query outside of React's render (as in `Query.fetch`)."
)
type fetchQueryFetchPolicy =
  | NetworkOnly
  | StoreOrNetwork
// DOCEND

@ocaml.doc("Internal, do not use.")
let mapFetchQueryFetchPolicy: option<fetchQueryFetchPolicy> => option<string>
// DOCEND

@ocaml.doc("An error from a mutation.")
type mutationError = {message: string}
// DOCEND

@ocaml.doc("Context provider for the Relay environment.")
module Context: {
  @ocaml.doc("Type representing the context.")
  type t
  // DOCEND

  @ocaml.doc("The expected shape of the context.")
  type contextShape = {"environment": Environment.t}
  // DOCEND

  @ocaml.doc("The actual React context coming from Relay.") @bs.module("react-relay")
  external context: React.Context.t<option<contextShape>> = "ReactRelayContext"
  // DOCEND

  @ocaml.doc(
    "The context provider you wrap your app in and pass your `Environment` for Relay to work."
  )
  module Provider: {
    @ocaml.doc(
      "The React component you wrap your app in and pass your `Environment` for Relay to work."
    )
    @react.component
    let make: (~environment: Environment.t, ~children: React.element) => React.element
    // DOCEND
  }
}

@ocaml.doc(
  "An exception saying that the environment could not be found in the context. Means you forgot to wrap your app in `<ReasonRelay.Context.Provider environment=RelayEnv.environment>`"
)
exception EnvironmentNotFoundInContext
// DOCEND

@ocaml.doc("Hook for getting the current environment from context.")
let useEnvironmentFromContext: unit => Environment.t
// DOCEND

@ocaml.doc("An exception detailing that a mutation failed.")
exception Mutation_failed(array<mutationError>)
// DOCEND

@ocaml.doc(
  "A way of committing a local update to the store.

### Example
Say you have fetched a user, and you want to (only locally) update that user's first name. You could use `commitLocalUpdate` to achieve that, roughly in the following way (beware that this is pseudo code):

```rescript
module User =  %relay(`
  fragment SomeModule_user on User {
    __id # This will return the `dataId` for this user, that we can use to update the store
    firstName
  }
`)

@react.component
let make = (~user) => {
  let user = User.use(user)

  React.useEffect1(() => {
    ReasonRelay.commitLocalUpdate(
      ~environment=RelayEnv.environment,
      ~updater=store => {
        switch store->ReasonRelay.RecordSourceSelectorProxy.get(user.__id) {
          | None => ()
          | Some(userRecordProxy) => 
            let _ = userRecordProxy->ReasonRelay.RecordProxy.setValueString(
              ~value=\"NewFirstName\",
              ~name=\"firstName\",
              ()
            )
        }
      }
    )
    None
  }, [user])
}
```"
)
@bs.module("relay-runtime")
external commitLocalUpdate: (
  ~environment: Environment.t,
  ~updater: RecordSourceSelectorProxy.t => unit,
) => unit = "commitLocalUpdate"
// DOCEND

@ocaml.doc(
  "Allows you to subscribe to when a record, connection, or even the store itself is invalidated, and then react to that.

### Example
```rescript

module Fragment = %relay(`
  fragment SomeComponent_user on User {
    __id # This will get use the data id for this user
    firstName
  }
`)

@react.component
let make = (~user) => {
  let user = Fragment.use(user)

  ReasonRelay.useSubscribeToInvalidationState([user.__id], () => {
    Js.log(\"user \" ++ user.firstName ++ \" was invalidated!\")
  })
}
```
"
)
@bs.module("react-relay/hooks")
external useSubscribeToInvalidationState: (array<dataId>, unit => unit) => Disposable.t =
  "useSubscribeToInvalidationState"
// DOCEND

@ocaml.doc(
  "Options valid when fetching a query outside of React's render method (like when using `Query.fetch`)."
)
type fetchQueryOptions = {
  networkCacheConfig: option<cacheConfig>,
  fetchPolicy: option<string>,
}
// DOCEND

module type MakeLoadQueryConfig = {
  type variables
  type loadedQueryRef
  type response
  type node
  let query: queryNode<node>
  let convertVariables: variables => variables
}

module MakeLoadQuery: (C: MakeLoadQueryConfig) =>
{
  let load: (
    ~environment: Environment.t,
    ~variables: C.variables,
    ~fetchPolicy: fetchPolicy=?,
    ~fetchKey: string=?,
    ~networkCacheConfig: cacheConfig=?,
    unit,
  ) => C.loadedQueryRef

  let queryRefToObservable: C.loadedQueryRef => option<Observable.t<C.response>>
  let queryRefToPromise: C.loadedQueryRef => Promise.t<Belt.Result.t<unit, unit>>
}
