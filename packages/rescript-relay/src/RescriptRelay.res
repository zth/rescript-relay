type arguments
type allFieldsMasked = {.}

type any

type queryNode<'node>
type fragmentNode<'node>
type mutationNode<'node>
type subscriptionNode<'node>

type fragmentRefs<'fragments>

type dataId
type recordSourceRecords = Js.Json.t
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

type featureFlags = {
  @as("DELAY_CLEANUP_OF_PENDING_PRELOAD_QUERIES")
  mutable delayCleanupOfPendingPreloadQueries: bool,
  @as("ENABLE_CLIENT_EDGES")
  mutable enableClientEdges: bool,
  @as("ENABLE_VARIABLE_CONNECTION_KEY")
  mutable enableVariableConnectionKey: bool,
  @as("ENABLE_PARTIAL_RENDERING_DEFAULT")
  mutable enablePartialRenderingDefault: bool,
  @as("ENABLE_REACT_FLIGHT_COMPONENT_FIELD")
  mutable enableReactFlightComponentField: bool,
  @as("ENABLE_RELAY_RESOLVERS")
  mutable enableRelayResolvers: bool,
  @as("ENABLE_GETFRAGMENTIDENTIFIER_OPTIMIZATION")
  mutable enableGetFragmentIdentifierOptimization: bool,
  @as("ENABLE_FRIENDLY_QUERY_NAME_GQL_URL")
  mutable enableFriendlyQueryNameGqlUrl: bool,
  @as("ENABLE_LOAD_QUERY_REQUEST_DEDUPING")
  mutable enableLoadQueryRequestDeduping: bool,
  @as("ENABLE_DO_NOT_WRAP_LIVE_QUERY")
  mutable enableDoNotWrapLiveQuery: bool,
  @as("ENABLE_NOTIFY_SUBSCRIPTION")
  mutable enableNotifySubscription: bool,
  @as("ENABLE_CONTAINERS_SUBSCRIBE_ON_COMMIT")
  mutable enableContainersSubscribeOnCommit: bool,
  @as("ENABLE_QUERY_RENDERER_OFFSCREEN_SUPPORT")
  mutable enableQueryRendererOffscreenSupport: bool,
  @as("MAX_DATA_ID_LENGTH")
  mutable maxDataIdLength: option<int>,
  @as("REFACTOR_SUSPENSE_RESOURCE")
  mutable refactorSuspenseResource: bool,
  @as("STRING_INTERN_LEVEL")
  mutable stringInternLevel: int,
  @as("USE_REACT_CACHE")
  mutable useReactCache: bool,
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

  // `setLinkedRecord` can't be used for "deleting" linked record fields.
  // It throws an error if anything besides `record` is received:
  // https://github.com/facebook/relay/blob/bd2e4173ef726804b2ed4e76d88a7bcc1753c496/packages/relay-runtime/mutations/RelayRecordProxy.js#L92
  // However, `setValue` can be used for this purpose instead.
  @send
  external setLinkedRecordToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setLinkedRecordToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  // `setLinkedRecords` can't be used for "deleting" linked records.
  // It throws an error if anything besides an array of `records` is received:
  // https://github.com/facebook/relay/blob/bd2e4173ef726804b2ed4e76d88a7bcc1753c496/packages/relay-runtime/mutations/RelayRecordProxy.js#L140
  // However, `setValue` can be used for this purpose instead.
  @send
  external setLinkedRecordsToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @send
  external setLinkedRecordsToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

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

module ReadOnlyRecordSourceProxy = {
  type t

  @send @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @send external getRoot: t => RecordProxy.t = "getRoot"
}

module MissingFieldHandler = {
  @@ocaml.warning("-30")
  type t

  type normalizationArgumentWrapped = {kind: [#ListValue | #Literal | #ObjectValue | #Variable]}

  type rec normalizationListValueArgument = {
    name: string,
    items: array<Js.Nullable.t<normalizationArgumentWrapped>>,
  }
  and normalizationLiteralArgument = {
    name: string,
    @as("type") type_: Js.Nullable.t<string>,
    value: Js.Json.t,
  }
  and normalizationObjectValueArgument = {
    name: string,
    fields: Js.Nullable.t<array<normalizationArgumentWrapped>>,
  }
  and normalizationVariableArgument = {
    name: string,
    @as("type") type_: Js.Nullable.t<string>,
    variableName: string,
  }

  type normalizationArgument =
    | ListValue(normalizationListValueArgument)
    | Literal(normalizationLiteralArgument)
    | ObjectValue(normalizationObjectValueArgument)
    | Variable(normalizationVariableArgument)

  let unwrapNormalizationArgument = wrapped =>
    switch wrapped.kind {
    | #ListValue => ListValue(Obj.magic(wrapped))
    | #Literal => Literal(Obj.magic(wrapped))
    | #ObjectValue => ObjectValue(Obj.magic(wrapped))
    | #Variable => Variable(Obj.magic(wrapped))
    }

  type normalizationScalarField = {
    alias: Js.Nullable.t<string>,
    name: string,
    args: Js.Nullable.t<array<normalizationArgumentWrapped>>,
    storageKey: Js.Nullable.t<string>,
  }

  let makeScalarMissingFieldHandler = handle =>
    Obj.magic({
      "kind": #scalar,
      "handle": handle,
    })

  type normalizationLinkedField = {
    alias: Js.Nullable.t<string>,
    name: string,
    storageKey: Js.Nullable.t<string>,
    args: Js.Nullable.t<array<normalizationArgument>>,
    concreteType: Js.Nullable.t<string>,
    plural: bool,
    selections: array<Js.Json.t>,
  }

  let makeLinkedMissingFieldHandler = handle =>
    Obj.magic({
      "kind": #linked,
      "handle": handle,
    })

  let makePluralLinkedMissingFieldHandler = handle =>
    Obj.magic({
      "kind": #pluralLinked,
      "handle": handle,
    })
}

// This handler below enables automatic resolution of all cached items through the Node interface
let nodeInterfaceMissingFieldHandler = MissingFieldHandler.makeLinkedMissingFieldHandler((
  field,
  record,
  args,
  _store,
) =>
  switch (Js.Nullable.toOption(record), field["name"], Js.Nullable.toOption(args["id"])) {
  | (Some(record), "node", argsId) if record["__typename"] == storeRootType => argsId
  | _ => None
  }
)

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

  @module("relay-runtime") @scope("ConnectionHandler")
  external getConnectionID: (dataId, string, 'filters) => dataId = "getConnectionID"
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
    next: (. 'response) => unit,
    error: (. Js.Exn.t) => unit,
    complete: (. unit) => unit,
    closed: bool,
  }

  type observer<'response>

  @obj
  external makeObserver: (
    ~start: @uncurry subscription => unit=?,
    ~next: @uncurry 'response => unit=?,
    ~error: @uncurry Js.Exn.t => unit=?,
    ~complete: @uncurry unit => unit=?,
    ~unsubscribe: @uncurry subscription => unit=?,
    unit,
  ) => observer<'response> = ""

  @module("relay-runtime") @scope("Observable")
  external make: (sink<'response> => option<subscription>) => t<'response> = "create"

  @send
  external subscribe: (t<'response>, observer<'response>) => subscription = "subscribe"

  @send external toPromise: t<'t> => Js.Promise.t<'t> = "toPromise"
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
        gcReleaseBufferSize,
        queryCacheExpirationTime,
      },
    )

  @send external getSource: t => RecordSource.t = "getSource"
  @send external publish: (t, RecordSource.t) => unit = "publish"
  @send external holdGC: t => unit = "holdGC"
}

module RequiredFieldLogger = {
  type kind = [#"missing_field.log" | #"missing_field.throw"]

  type arg = {"kind": kind, "owner": string, "fieldPath": string}

  type js = arg => unit

  type t = (~kind: kind, ~owner: string, ~fieldPath: string) => unit

  let toJs: t => js = (f, arg) =>
    f(~kind=arg["kind"], ~owner=arg["owner"], ~fieldPath=arg["fieldPath"])
}

module Environment = {
  type t

  @deriving(abstract)
  type environmentConfig<'a> = {
    network: Network.t,
    store: Store.t,
    @optional
    getDataID: (~nodeObj: 'a, ~typeName: string) => string,
    @optional
    treatMissingFieldsAsNull: bool,
    missingFieldHandlers: array<MissingFieldHandler.t>,
    @optional
    requiredFieldLogger: RequiredFieldLogger.js,
    @optional
    isServer: bool,
  }

  @module("relay-runtime") @new
  external make: environmentConfig<'a> => t = "Environment"

  let make = (
    ~network,
    ~store,
    ~getDataID=?,
    ~treatMissingFieldsAsNull=?,
    ~missingFieldHandlers=?,
    ~requiredFieldLogger=?,
    ~isServer=?,
    (),
  ) =>
    make(
      environmentConfig(
        ~network,
        ~store,
        ~getDataID?,
        ~treatMissingFieldsAsNull?,
        ~missingFieldHandlers=switch missingFieldHandlers {
        | Some(handlers) => handlers->Belt.Array.concat([nodeInterfaceMissingFieldHandler])
        | None => [nodeInterfaceMissingFieldHandler]
        },
        ~requiredFieldLogger=?requiredFieldLogger->Belt.Option.map(RequiredFieldLogger.toJs),
        ~isServer?,
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

  module Provider = {
    @react.component
    let make = (~environment: Environment.t, ~children) => {
      let provider = React.Context.provider(context)
      React.createElement(
        provider,
        {"value": Some({"environment": environment}), "children": children},
      )
    }
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

@module("react-relay")
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
        fetchKey,
        fetchPolicy: fetchPolicy->mapFetchPolicy,
        networkCacheConfig,
      },
    )

  type rawPreloadToken<'response> = {source: Js.Nullable.t<Observable.t<'response>>}
  external tokenToRaw: C.loadedQueryRef => rawPreloadToken<C.response> = "%identity"

  let queryRefToObservable = token => {
    let raw = token->tokenToRaw
    raw.source->Js.Nullable.toOption
  }

  let queryRefToPromise = token => {
    Js.Promise.make((~resolve, ~reject as _) => {
      switch token->queryRefToObservable {
      | None => resolve(. Error())
      | Some(o) =>
        open Observable
        let _: subscription = o->subscribe(makeObserver(~complete=() => resolve(. Ok()), ()))
      }
    })
  }
}

type mutationError = {message: string}

exception Mutation_failed(array<mutationError>)

@module("relay-runtime")
external commitLocalUpdate: (
  ~environment: Environment.t,
  ~updater: RecordSourceSelectorProxy.t => unit,
) => unit = "commitLocalUpdate"

@module("react-relay")
external useSubscribeToInvalidationState: (array<dataId>, unit => unit) => Disposable.t =
  "useSubscribeToInvalidationState"
