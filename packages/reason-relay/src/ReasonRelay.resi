type arguments
type uploadables
type allFieldsMasked = {.}

@ocaml.doc(
  `Abstract helper type to signify something that could not be generated in a type-safe way.`
)
type any

@ocaml.doc("
 * The type of the actual node that Relay uses for operations.
 ")
type queryNode<'node>
type fragmentNode<'node>
type mutationNode<'node>
type subscriptionNode<'node>

@ocaml.doc("
 * Helper to signify fragment references
 ")
type fragmentRefs<'fragments>

@ocaml.doc(
  `The type of the id Relay uses to identify records in its store.

## Getting \`dataId\`'s
You can get the dataId of anything by selecting \`__id\` in your query/fragment/mutation/subscription, like this:
\`\`\`graphql
fragment Avatar_user on User {
  __id # This is the data id
  firstName
  lastName
}
\`\`\`

If you have globally unique IDs in your graph, \`__id\` will always be the same as the regular \`id\`. However, as \`id\` is commonly modelled as a \`string\`,

## Converting between \`string\` and \`dataId\`
You'll often want to convert between \`string\` and \`dataId\`. You can do this by using \`ReasonRelay.makeDataId(yourStringHere)\` and \`ReasonRelay.dataIdToString(yourDataIdHere)\`.`
)
type dataId

@ocaml.doc(`Turns a \`dataId\` into a \`string\`.`)
external dataIdToString: dataId => string = "%identity"

@ocaml.doc(`Turns a \`string\` into a \`dataId\`.`)
external makeDataId: string => dataId = "%identity"

@ocaml.doc(`Construct an \`arguments\` object for use with certain Relay store APIs.`)
external makeArguments: {..} => arguments = "%identity"

@ocaml.doc(`Construct an \`uploadables\` object that you can use for uploads via Relay.`)
external makeUploadable: {..} => uploadables = "%identity"

@ocaml.doc(
  `This generates a \`dataId\` for use on the _client_ side. However, this is farily low level, and what you're probably really looking for is \`generateUniqueClientID\` that'll let you generate a new, unique \`dataId\` that you can use for client side only records (like when doing optimistic updates).`
)
@bs.module("relay-runtime")
external generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?, unit) => dataId =
  "generateClientID"

@ocaml.doc(
  `This generates a unique \`dataId\` that's safe to use on the _client_ side. Useful when doing optimistic updates and you need to create IDs that the optimistic update can use.`
)
@bs.module("relay-runtime")
external generateUniqueClientID: unit => dataId = "generateUniqueClientID"

@ocaml.doc(`Checks whether the provided \`dataId\` is guaranteed to be a client side only id.`)
@bs.module("relay-runtime")
external isClientID: dataId => bool = "isClientID"

// Relay feature flags
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

@bs.module("relay-runtime")
external relayFeatureFlags: featureFlags = "RelayFeatureFlags"

@ocaml.doc(
  `An abstract type representing all records in the store serialized to JSON in a way that you can use to re-hydrate the store.`
)
type recordSourceRecords

@@ocaml.doc(
  `The \`dataId\` for the Relay store's root. Useful when for example referencing the \`parentID\` of a connection that's on the store root.`
)
@bs.module("relay-runtime") external storeRootId: dataId = "ROOT_ID"

@ocaml.doc(`The \`type\` for the Relay store's root \`RecordProxy\`.`) @bs.module("relay-runtime")
external storeRootType: string = "ROOT_TYPE"

@bs.module("./utils")
external convertObj: ('a, Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>>, 'b, 'c) => 'd = "traverser"

@ocaml.doc(
  `Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store`
)
module RecordProxy: {
  type t

  @ocaml.doc(`Copies all fields from one RecordProxy to another.`) @bs.send
  external copyFieldsFrom: (t, ~sourceRecord: t) => unit = "copyFieldsFrom"

  @ocaml.doc(`Gets the \`dataId\` for a particular record.`) @bs.send
  external getDataId: t => dataId = "getDataID"

  @bs.send @bs.return(nullable)
  external getLinkedRecord: (t, ~name: string, ~arguments: arguments=?, unit) => option<t> =
    "getLinkedRecord"

  let getLinkedRecords: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<t>>>

  @bs.send
  external getOrCreateLinkedRecord: (
    t,
    ~name: string,
    ~typeName: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "getOrCreateLinkedRecord"

  @bs.send external getType: t => string = "getType"

  @bs.send @bs.return(nullable)
  external getValueString: (t, ~name: string, ~arguments: arguments=?, unit) => option<string> =
    "getValue"

  @bs.send @bs.return(nullable)
  external getValueStringArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<string>>> = "getValue"

  @bs.send @bs.return(nullable)
  external getValueInt: (t, ~name: string, ~arguments: arguments=?, unit) => option<int> =
    "getValue"

  @bs.send @bs.return(nullable)
  external getValueIntArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<int>>> = "getValue"

  @bs.send @bs.return(nullable)
  external getValueFloat: (t, ~name: string, ~arguments: arguments=?, unit) => option<float> =
    "getValue"

  @bs.send @bs.return(nullable)
  external getValueFloatArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<float>>> = "getValue"

  @bs.send @bs.return(nullable)
  external getValueBool: (t, ~name: string, ~arguments: arguments=?, unit) => option<bool> =
    "getValue"

  @bs.send @bs.return(nullable)
  external getValueBoolArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<bool>>> = "getValue"

  @bs.send
  external setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?, unit) => t =
    "setLinkedRecord"

  @bs.send
  external setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  @bs.send
  external setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @bs.send
  external setValueStringArray: (
    t,
    ~value: array<string>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @bs.send
  external setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @bs.send
  external setValueIntArray: (
    t,
    ~value: array<int>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @bs.send
  external setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @bs.send
  external setValueFloatArray: (
    t,
    ~value: array<float>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @bs.send
  external setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @bs.send
  external setValueBoolArray: (
    t,
    ~value: array<bool>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @bs.send
  external setValueToUndefined: (
    t,
    @bs.as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @bs.send
  external setValueToNull: (
    t,
    @bs.as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @bs.send
  external setLinkedRecordToUndefined: (
    t,
    @bs.as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecord"

  @bs.send
  external setLinkedRecordToNull: (
    t,
    @bs.as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecord"

  @bs.send
  external setLinkedRecordsToUndefined: (
    t,
    @bs.as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  @bs.send
  external setLinkedRecordsToNull: (
    t,
    @bs.as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  @bs.send external invalidateRecord: t => unit = "invalidateRecord"
}

@ocaml.doc(
  "
 * RecordSourceSelectorProxy and RecordSourceProxy are the two
 * modules representing the store, with various capabilities.
 "
)
module RecordSourceSelectorProxy: {
  type t

  @bs.send
  external create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t = "create"

  @bs.send external delete: (t, ~dataId: dataId) => unit = "delete"

  @bs.send @bs.return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @bs.send external getRoot: t => RecordProxy.t = "getRoot"

  @bs.send @bs.return(nullable)
  external getRootField: (t, ~fieldName: string) => option<RecordProxy.t> = "getRootField"

  let getPluralRootField: (t, ~fieldName: string) => option<array<option<RecordProxy.t>>>

  @bs.send external invalidateStore: t => unit = "invalidateStore"
}

module RecordSourceProxy: {
  type t

  @bs.send
  external create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t = "create"

  @bs.send external delete: (t, ~dataId: dataId) => unit = "delete"

  @bs.send @bs.return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @bs.send external getRoot: t => RecordProxy.t = "getRoot"

  @bs.send external invalidateStore: t => unit = "invalidateStore"
}

@ocaml.doc("
 * https://relay.dev/docs/en/relay-store#connectionhandler
 ")
module ConnectionHandler: {
  @bs.module("relay-runtime") @bs.scope("ConnectionHandler") @bs.return(nullable)
  external getConnection: (
    ~record: RecordProxy.t,
    ~key: string,
    ~filters: arguments=?,
    unit,
  ) => option<RecordProxy.t> = "getConnection"

  @bs.module("relay-runtime") @bs.scope("ConnectionHandler")
  external createEdge: (
    ~store: RecordSourceSelectorProxy.t,
    ~connection: RecordProxy.t,
    ~node: RecordProxy.t,
    ~edgeType: string,
  ) => RecordProxy.t = "createEdge"

  @bs.module("relay-runtime") @bs.scope("ConnectionHandler")
  external insertEdgeBefore: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeBefore"

  @bs.module("relay-runtime") @bs.scope("ConnectionHandler")
  external insertEdgeAfter: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeAfter"

  @bs.module("relay-runtime") @bs.scope("ConnectionHandler")
  external deleteNode: (~connection: RecordProxy.t, ~nodeId: dataId) => unit = "deleteNode"
}

@ocaml.doc("
 * NETWORK
 ")
type cacheConfig = {
  force: option<bool>,
  poll: option<int>,
  liveConfigId: option<string>,
  transactionId: option<string>,
}

@ocaml.doc("
 * A Relay observable, used for subscriptions and a few other things.
 ")
module Observable: {
  type t<'response>

  type sink<'response> = {
    next: 'response => unit,
    error: Js.Exn.t => unit,
    complete: unit => unit,
    closed: bool,
  }

  type subscription = {
    unsubscribe: unit => unit,
    closed: bool,
  }

  type observer<'response>

  @bs.obj
  external makeObserver: (
    ~start: subscription => unit=?,
    ~next: 'response => unit=?,
    ~error: Js.Exn.t => unit=?,
    ~complete: unit => unit=?,
    ~unsubscribe: subscription => unit=?,
    unit,
  ) => observer<'response> = ""

  @bs.module("relay-runtime") @bs.scope("Observable")
  external make: (sink<'t> => option<subscription>) => t<'t> = "create"

  @bs.send
  external subscribe: (t<'t>, observer<'t>) => subscription = "subscribe"

  @bs.send external toPromise: t<'t> => Promise.t<'t> = "toPromise"
}

@ocaml.doc("
 * Represents the network layer.
 ")
module Network: {
  type t

  type operation = {
    @ocaml.doc(
      " This will be available only when using persisted queries.
     * And id field will be of presisted query Id.
     * In other cases, it will be null "
    )
    id: string,
    @ocaml.doc(" When using persisted queries, text field will be null. ")
    text: string,
    name: string,
    operationKind: string,
  }

  type subscribeFn = (operation, Js.Json.t, cacheConfig) => Observable.t<Js.Json.t>

  type fetchFunctionPromise = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Js.Promise.t<Js.Json.t>

  type fetchFunctionObservable = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Observable.t<Js.Json.t>

  @bs.module("relay-runtime") @bs.scope("Network")
  external makePromiseBased: (
    ~fetchFunction: fetchFunctionPromise,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"

  @bs.module("relay-runtime") @bs.scope("Network")
  external makeObservableBased: (
    ~observableFunction: fetchFunctionObservable,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"
}

@ocaml.doc(
  "
 * RecordSource is the source of records used by the store.
 * Can be initiated with or without prior records; eg. hydrating
 * the store with prior data.
 "
)
module RecordSource: {
  type t
  @bs.module("relay-runtime") @bs.new
  external make: (~records: recordSourceRecords=?, unit) => t = "RecordSource"
  @bs.send external toJSON: t => recordSourceRecords = "toJSON"
}

@ocaml.doc("
 * The actual store module, with configuration for the store.
 ")
module Store: {
  type t
  let make: (
    ~source: RecordSource.t,
    ~gcReleaseBufferSize: int=?,
    ~queryCacheExpirationTime: int=?,
    unit,
  ) => t
  @bs.send external getSource: t => RecordSource.t = "getSource"
  @bs.send external publish: (t, RecordSource.t) => unit = "publish"
}

@ocaml.doc(
  "
 * renderPolicy controls if Relay is allowed to render partially available data or not.
 "
)
type renderPolicy =
  | Full // Always render the full result
  | Partial // Allow rendering any fragments that already have the data needed

let mapRenderPolicy: option<renderPolicy> => option<string>

@ocaml.doc("
 * Handle creating and using operation descriptors.
 ")
type operationDescriptor

@ocaml.doc(
  "
 * Module representing the environment, which you'll need to use and
 * pass to various functions. Takes a few configuration options like store
 * and network layer.
 "
)
module Environment: {
  type t

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

  @bs.send external getStore: t => Store.t = "getStore"
  @bs.send
  external commitPayload: (t, operationDescriptor, 'payload) => unit = "commitPayload"
}

@ocaml.doc(
  "
 * Disposable is a module you'll get back when issuing requests.
 * Disposable allow you to dispose of the request when/if you don't need
 * it anymore.
 "
)
module Disposable: {
  type t
  @bs.send external dispose: t => unit = "dispose"
}

@ocaml.doc("
 * fetchPolicy controls how you want Relay to resolve your data.
 ")
type fetchPolicy =
  | StoreOnly // Resolve only from the store
  | StoreOrNetwork // Resolve from the store if all data is there, otherwise make a network request
  | StoreAndNetwork // Like StoreOrNetwork, but always make a request regardless of if the data was there initially or not
  | NetworkOnly // Always make a request, discard what's in the store

let mapFetchPolicy: option<fetchPolicy> => option<string>

// specific for fetches on query
type fetchQueryFetchPolicy =
  | NetworkOnly
  | StoreOrNetwork

let mapFetchQueryFetchPolicy: option<fetchQueryFetchPolicy> => option<string>

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

@ocaml.doc("
 * MUTATION
 ")
type mutationError = {message: string}

@ocaml.doc("
 * Context provider for the Relay environment.
 ")
module Context: {
  type t
  type contextShape = {"environment": Environment.t}
  @bs.module("react-relay")
  external context: React.Context.t<option<contextShape>> = "ReactRelayContext"

  module Provider: {
    @react.component
    let make: (~environment: Environment.t, ~children: React.element) => React.element
  }
}

exception EnvironmentNotFoundInContext

@ocaml.doc("
 * Hook for getting the current environment from context.
 ")
let useEnvironmentFromContext: unit => Environment.t

exception Mutation_failed(array<mutationError>)

@ocaml.doc("
 * A way of committing a local update to the store.
 ") @bs.module("relay-runtime")
external commitLocalUpdate: (
  ~environment: Environment.t,
  ~updater: RecordSourceSelectorProxy.t => unit,
) => unit = "commitLocalUpdate"

// Subscribing to invalidation states of the store
@bs.module("react-relay/hooks")
external useSubscribeToInvalidationState: (array<dataId>, unit => unit) => Disposable.t =
  "useSubscribeToInvalidationState"

@ocaml.doc("
 * fetchQuery is used internally only.
 ")
type fetchQueryOptions = {
  networkCacheConfig: option<cacheConfig>,
  fetchPolicy: option<string>,
}
