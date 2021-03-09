type arguments
type allFieldsMasked = {.}

type any

type queryNode<'node>
type fragmentNode<'node>
type mutationNode<'node>
type subscriptionNode<'node>

type fragmentRefs<'fragments>

type dataId
type recordSourceRecords
type uploadables

external dataIdToString: dataId => string = "%identity"
external makeDataId: string => dataId = "%identity"
external makeArguments: {..} => arguments = "%identity"
external makeUploadables: Js.Dict.t<'file> => uploadables = "%identity"
external unwrapUploadables: uploadables => Js.Dict.t<'file> = "%identity"

@module("relay-runtime")
external generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?, unit) => dataId =
  "generateClientID"

@module("relay-runtime")
external generateUniqueClientID: unit => dataId = "generateUniqueClientID"

@module("relay-runtime")
external isClientID: dataId => bool = "isClientID"

@module("relay-runtime")
external getConnectionID: (dataId, string, 'filters) => dataId = "getConnectionID"

type featureFlags = {
  @as("ENABLE_VARIABLE_CONNECTION_KEY")
  mutable enableVariableConnectionKey: bool,
  @as("ENABLE_PARTIAL_RENDERING_DEFAULT")
  mutable enablePartialRenderingDefault: bool,
  @as("ENABLE_RELAY_CONTAINERS_SUSPENSE")
  mutable enableRelayContainersSuspense: bool,
  @as("ENABLE_PRECISE_TYPE_REFINEMENT")
  mutable enablePrecisTypeRefinement: bool,
}

@module("relay-runtime")
external relayFeatureFlags: featureFlags = "RelayFeatureFlags"

@module("./utils")
external convertObj: ('a, Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>>, 'b, 'c) => 'd = "traverser"

let optArrayOfNullableToOptArrayOfOpt: option<array<Js.Nullable.t<'a>>> => option<
  array<option<'a>>,
> = x =>
  switch x {
  | None => None
  | Some(arr) => Some(arr->Belt.Array.map(Js.Nullable.toOption))
  }

@module("relay-runtime") external storeRootId: dataId = "ROOT_ID"
@module("relay-runtime") external storeRootType: string = "ROOT_TYPE"

module RecordProxy = {
  type t

  @send
  external copyFieldsFrom: (t, ~sourceRecord: t) => unit = "copyFieldsFrom"

  @send external getDataId: t => dataId = "getDataID"

  @send @return(nullable)
  external getLinkedRecord: (t, ~name: string, ~arguments: arguments=?, unit) => option<t> =
    "getLinkedRecord"

  @send @return(nullable)
  external getLinkedRecords: (t, string, option<arguments>) => option<array<Js.Nullable.t<t>>> =
    "getLinkedRecords"

  let getLinkedRecords = (t, ~name, ~arguments=?, ()): option<array<option<t>>> =>
    getLinkedRecords(t, name, arguments)->optArrayOfNullableToOptArrayOfOpt

  @send
  external getOrCreateLinkedRecord: (
    t,
    ~name: string,
    ~typeName: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "getOrCreateLinkedRecord"

  @send external getType: t => string = "getType"

  @send @return(nullable)
  external getValueString: (t, ~name: string, ~arguments: arguments=?, unit) => option<string> =
    "getValue"

  @send @return(nullable)
  external getValueStringArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<string>>> = "getValue"

  @send @return(nullable)
  external getValueInt: (t, ~name: string, ~arguments: arguments=?, unit) => option<int> =
    "getValue"

  @send @return(nullable)
  external getValueIntArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<int>>> = "getValue"

  @send @return(nullable)
  external getValueFloat: (t, ~name: string, ~arguments: arguments=?, unit) => option<float> =
    "getValue"

  @send @return(nullable)
  external getValueFloatArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<float>>> = "getValue"

  @send @return(nullable)
  external getValueBool: (t, ~name: string, ~arguments: arguments=?, unit) => option<bool> =
    "getValue"

  @send @return(nullable)
  external getValueBoolArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<bool>>> = "getValue"

  @send
  external setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?, unit) => t =
    "setLinkedRecord"

  @send
  external setLinkedRecordToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecord"

  @send
  external setLinkedRecordToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecord"

  @send
  external setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  @send
  external setLinkedRecordsToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  @send
  external setLinkedRecordsToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  @send
  external setValueToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setValueToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @send
  external setValueStringArray: (
    t,
    ~value: array<string>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @send
  external setValueIntArray: (
    t,
    ~value: array<int>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @send
  external setValueFloatArray: (
    t,
    ~value: array<float>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @send
  external setValueBoolArray: (
    t,
    ~value: array<bool>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send external invalidateRecord: t => unit = "invalidateRecord"
}

module RecordSourceSelectorProxy = {
  type t

  @send
  external create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t = "create"

  @send external delete: (t, ~dataId: dataId) => unit = "delete"

  @send @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @send external getRoot: t => RecordProxy.t = "getRoot"

  @send @return(nullable)
  external getRootField: (t, ~fieldName: string) => option<RecordProxy.t> = "getRootField"

  @send @return(nullable)
  external getPluralRootField: (
    t,
    ~fieldName: string,
  ) => option<array<Js.Nullable.t<RecordProxy.t>>> = "getPluralRootField"

  let getPluralRootField = (t, ~fieldName): option<array<option<RecordProxy.t>>> =>
    getPluralRootField(t, ~fieldName)->optArrayOfNullableToOptArrayOfOpt

  @send external invalidateStore: t => unit = "invalidateStore"
}

module ConnectionHandler = {
  @module("relay-runtime") @scope("ConnectionHandler") @return(nullable)
  external getConnection: (
    ~record: RecordProxy.t,
    ~key: string,
    ~filters: arguments=?,
    unit,
  ) => option<RecordProxy.t> = "getConnection"

  @module("relay-runtime") @scope("ConnectionHandler")
  external createEdge: (
    ~store: RecordSourceSelectorProxy.t,
    ~connection: RecordProxy.t,
    ~node: RecordProxy.t,
    ~edgeType: string,
  ) => RecordProxy.t = "createEdge"

  @module("relay-runtime") @scope("ConnectionHandler")
  external insertEdgeBefore: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeBefore"

  @module("relay-runtime") @scope("ConnectionHandler")
  external insertEdgeAfter: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeAfter"

  @module("relay-runtime") @scope("ConnectionHandler")
  external deleteNode: (~connection: RecordProxy.t, ~nodeId: dataId) => unit = "deleteNode"
}

type operationDescriptor

module Disposable = {
  type t

  @send external dispose: t => unit = "dispose"
}

type cacheConfig = {
  force: option<bool>,
  poll: option<int>,
  liveConfigId: option<string>,
  transactionId: option<string>,
}

module Observable = {
  type t<'response>

  type subscription = {
    unsubscribe: unit => unit,
    closed: bool,
  }

  type sink<'response> = {
    next: 'response => unit,
    error: Js.Exn.t => unit,
    complete: unit => unit,
    closed: bool,
  }

  type observer<'response>

  @obj
  external makeObserver: (
    ~start: subscription => unit=?,
    ~next: 'response => unit=?,
    ~error: Js.Exn.t => unit=?,
    ~complete: unit => unit=?,
    ~unsubscribe: subscription => unit=?,
    unit,
  ) => observer<'response> = ""

  @module("relay-runtime") @scope("Observable")
  external make: (sink<'response> => option<subscription>) => t<'response> = "create"

  @send
  external subscribe: (t<'response>, observer<'response>) => subscription = "subscribe"

  @send external toPromise: t<'t> => Promise.t<'t> = "toPromise"
}

module Network = {
  type t

  type operation = {
    id: string,
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

  @module("relay-runtime") @scope("Network")
  external makePromiseBased: (
    ~fetchFunction: fetchFunctionPromise,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"

  @module("relay-runtime") @scope("Network")
  external makeObservableBased: (
    ~observableFunction: fetchFunctionObservable,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"
}

module RecordSource = {
  type t

  @module("relay-runtime") @new
  external make: (~records: recordSourceRecords=?, unit) => t = "RecordSource"

  @send external toJSON: t => recordSourceRecords = "toJSON"
}

module Store = {
  type t

  type storeConfig = {
    gcReleaseBufferSize: option<int>,
    queryCacheExpirationTime: option<int>,
  }

  @module("relay-runtime") @new
  external make: (RecordSource.t, storeConfig) => t = "Store"

  let make = (~source, ~gcReleaseBufferSize=?, ~queryCacheExpirationTime=?, ()) =>
    make(
      source,
      {
        gcReleaseBufferSize: gcReleaseBufferSize,
        queryCacheExpirationTime: queryCacheExpirationTime,
      },
    )

  @send external getSource: t => RecordSource.t = "getSource"
  @send external publish: (t, RecordSource.t) => unit = "publish"
}

module Environment = {
  type t

  type missingFieldHandlers

  @deriving(abstract)
  type environmentConfig<'a> = {
    network: Network.t,
    store: Store.t,
    @optional
    getDataID: (~nodeObj: 'a, ~typeName: string) => string,
    @optional
    treatMissingFieldsAsNull: bool,
    missingFieldHandlers: missingFieldHandlers,
  }

  @module("relay-runtime") @new
  external make: environmentConfig<'a> => t = "Environment"

  let make = (~network, ~store, ~getDataID=?, ~treatMissingFieldsAsNull=?, ()) =>
    make(
      environmentConfig(
        ~network,
        ~store,
        ~getDataID?,
        ~treatMissingFieldsAsNull?,
        // This handler below enables automatic resolution of all cached items through the Node interface
        ~missingFieldHandlers=%raw(
          `
            [
              {
                kind: "linked",
                handle: function(field, record, args, store) {
                  if (
                    record != null &&
                    record.__typename === require("relay-runtime").ROOT_TYPE &&
                    field.name === "node" &&
                    args.hasOwnProperty("id")
                  ) {
                    return args.id;
                  }
                }
              }
            ]
          `
        ),
        (),
      ),
    )

  @send external getStore: t => Store.t = "getStore"
  @send
  external commitPayload: (t, operationDescriptor, 'payload) => unit = "commitPayload"
  @send external retain: (t, operationDescriptor) => Disposable.t = "retain"
}

module Context = {
  type t

  type contextShape = {"environment": Environment.t}

  @module("react-relay")
  external context: React.Context.t<option<contextShape>> = "ReactRelayContext"
  let provider = React.Context.provider(context)

  module Provider = {
    @react.component
    let make = (~environment: Environment.t, ~children) =>
      React.createElement(
        provider,
        {"value": Some({"environment": environment}), "children": children},
      )
  }
}

exception EnvironmentNotFoundInContext

let useEnvironmentFromContext = () => {
  let context = React.useContext(Context.context)

  switch context {
  | Some(ctx) => ctx["environment"]
  | None => raise(EnvironmentNotFoundInContext)
  }
}

type fetchPolicy =
  | StoreOnly
  | StoreOrNetwork
  | StoreAndNetwork
  | NetworkOnly

let mapFetchPolicy = x =>
  switch x {
  | Some(StoreOnly) => Some("store-only")
  | Some(StoreOrNetwork) => Some("store-or-network")
  | Some(StoreAndNetwork) => Some("store-and-network")
  | Some(NetworkOnly) => Some("network-only")
  | None => None
  }

type fetchQueryFetchPolicy =
  | NetworkOnly
  | StoreOrNetwork

let mapFetchQueryFetchPolicy = x =>
  switch x {
  | Some(StoreOrNetwork) => Some("store-or-network")
  | Some(NetworkOnly) => Some("network-only")
  | None => None
  }

type fetchQueryOptions = {
  networkCacheConfig: option<cacheConfig>,
  fetchPolicy: option<string>,
}

type loadQueryConfig = {
  fetchKey: option<string>,
  fetchPolicy: option<string>,
  networkCacheConfig: option<cacheConfig>,
}

@module("react-relay/hooks")
external loadQuery: (Environment.t, queryNode<'a>, 'variables, loadQueryConfig) => 'queryResponse =
  "loadQuery"

module type MakeLoadQueryConfig = {
  type variables
  type loadedQueryRef
  type response
  type node
  let query: queryNode<node>
  let convertVariables: variables => variables
}

module MakeLoadQuery = (C: MakeLoadQueryConfig) => {
  let load: (
    ~environment: Environment.t,
    ~variables: C.variables,
    ~fetchPolicy: fetchPolicy=?,
    ~fetchKey: string=?,
    ~networkCacheConfig: cacheConfig=?,
    unit,
  ) => C.loadedQueryRef = (
    ~environment,
    ~variables,
    ~fetchPolicy=?,
    ~fetchKey=?,
    ~networkCacheConfig=?,
    (),
  ) =>
    loadQuery(
      environment,
      C.query,
      variables->C.convertVariables,
      {
        fetchKey: fetchKey,
        fetchPolicy: fetchPolicy->mapFetchPolicy,
        networkCacheConfig: networkCacheConfig,
      },
    )

  type rawPreloadToken<'response> = {source: Js.Nullable.t<Observable.t<'response>>}
  external tokenToRaw: C.loadedQueryRef => rawPreloadToken<C.response> = "%identity"

  let queryRefToObservable = token => {
    let raw = token->tokenToRaw
    raw.source->Js.Nullable.toOption
  }

  let queryRefToPromise = token => {
    let (promise, resolve) = Promise.pending()

    switch token->queryRefToObservable {
    | None => resolve(Error())
    | Some(o) =>
      let _: Observable.subscription = o->{
        open Observable
        subscribe(makeObserver(~complete=() => resolve(Ok()), ()))
      }
    }

    promise
  }
}

type mutationError = {message: string}

exception Mutation_failed(array<mutationError>)

@module("relay-runtime")
external commitLocalUpdate: (
  ~environment: Environment.t,
  ~updater: RecordSourceSelectorProxy.t => unit,
) => unit = "commitLocalUpdate"

@module("react-relay/hooks")
external useSubscribeToInvalidationState: (array<dataId>, unit => unit) => Disposable.t =
  "useSubscribeToInvalidationState"
