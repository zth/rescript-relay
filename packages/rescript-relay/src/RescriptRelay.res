type arguments
type allFieldsMasked = {.}

type any

type queryNode<'node>
type fragmentNode<'node>
type mutationNode<'node>
type subscriptionNode<'node>

type fragmentRefs<'fragments>
type resolverFragmentRefs<'fragments>
type updatableFragmentRefs<'fragments>

type dataId
type dataIdObject = {id: dataId}
type recordSourceRecords = JSON.t
type uploadables

module CatchResult = {
  type catchError = JSON.t

  @tag("ok")
  type t<'value> = | @as(true) Ok({value: 'value}) | @as(false) Error({errors: array<catchError>})

  let toOption = (t: t<'value>) =>
    switch t {
    | Ok({value}) => Some(value)
    | Error(_) => None
    }

  let toResult = (t: t<'value>): result<'value, array<catchError>> =>
    switch t {
    | Ok({value}) => Ok(value)
    | Error({errors}) => Error(errors)
    }
}

module SuspenseSentinel = {
  type t

  @module("relay-runtime") external suspend: t => 'any = "suspenseSentinel"
}

type liveStateCallback = unit => unit
type liveStateUnsubscribeCallback = unit => unit

type liveState<'value> = {
  read: SuspenseSentinel.t => 'value,
  subscribe: liveStateCallback => liveStateUnsubscribeCallback,
}

external dataIdToString: dataId => string = "%identity"
external makeDataId: string => dataId = "%identity"
external makeArguments: {..} => arguments = "%identity"
external makeUploadables: dict<'file> => uploadables = "%identity"
external unwrapUploadables: uploadables => dict<'file> = "%identity"

@module("relay-runtime/experimental")
external resolverDataInjector: ('a, 'b, 'c, 'd) => 'return = "resolverDataInjector"

@module("relay-runtime")
external generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?) => dataId =
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
external convertObj: ('a, dict<dict<dict<string>>>, 'b, 'c) => 'd = "traverser"

let optArrayOfNullableToOptArrayOfOpt: option<array<Nullable.t<'a>>> => option<
  array<option<'a>>,
> = x =>
  switch x {
  | None => None
  | Some(arr) => Some(arr->Belt.Array.map(Nullable.toOption))
  }

@module("relay-runtime") external storeRootId: dataId = "ROOT_ID"
@module("relay-runtime") external storeRootType: string = "ROOT_TYPE"

module RecordProxy = {
  type t

  @send
  external copyFieldsFrom: (t, ~sourceRecord: t) => unit = "copyFieldsFrom"

  @send external getDataId: t => dataId = "getDataID"

  @send @return(nullable)
  external getLinkedRecord: (t, ~name: string, ~arguments: arguments=?) => option<t> =
    "getLinkedRecord"

  @send @return(nullable)
  external getLinkedRecords: (t, string, option<arguments>) => option<array<Nullable.t<t>>> =
    "getLinkedRecords"

  let getLinkedRecords = (t, ~name, ~arguments=?): option<array<option<t>>> =>
    getLinkedRecords(t, name, arguments)->optArrayOfNullableToOptArrayOfOpt

  @send
  external getOrCreateLinkedRecord: (
    t,
    ~name: string,
    ~typeName: string,
    ~arguments: arguments=?,
  ) => t = "getOrCreateLinkedRecord"

  @send external getType: t => string = "getType"

  @send @return(nullable)
  external getValueString: (t, ~name: string, ~arguments: arguments=?) => option<string> =
    "getValue"

  @send @return(nullable)
  external getValueStringArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<string>>> = "getValue"

  @send @return(nullable)
  external getValueInt: (t, ~name: string, ~arguments: arguments=?) => option<int> = "getValue"

  @send @return(nullable)
  external getValueIntArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<int>>> = "getValue"

  @send @return(nullable)
  external getValueFloat: (t, ~name: string, ~arguments: arguments=?) => option<float> = "getValue"

  @send @return(nullable)
  external getValueFloatArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<float>>> = "getValue"

  @send @return(nullable)
  external getValueBool: (t, ~name: string, ~arguments: arguments=?) => option<bool> = "getValue"

  @send @return(nullable)
  external getValueBoolArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<bool>>> = "getValue"

  @send
  external setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?) => t =
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
  ) => t = "setValue"

  @send
  external setLinkedRecordToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  @send
  external setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
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
  ) => t = "setValue"

  @send
  external setLinkedRecordsToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  @send
  external setValueToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  @send
  external setValueToNull: (t, @as(json`null`) _, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  @send
  external setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  @send
  external setValueStringArray: (
    t,
    ~value: array<string>,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  @send
  external setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?) => t = "setValue"

  @send
  external setValueIntArray: (t, ~value: array<int>, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  @send
  external setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  @send
  external setValueFloatArray: (
    t,
    ~value: array<float>,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  @send
  external setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?) => t = "setValue"

  @send
  external setValueBoolArray: (
    t,
    ~value: array<bool>,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  @send external invalidateRecord: t => unit = "invalidateRecord"
}

module RecordSourceSelectorProxy = {
  type t

  @send
  external batchLiveStateUpdates: (t, unit => unit) => unit = "batchLiveStateUpdates"

  @send
  external create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t = "create"

  @send external delete: (t, ~dataId: dataId) => unit = "delete"

  @send @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @send external getRoot: t => RecordProxy.t = "getRoot"

  @send @return(nullable)
  external getRootField: (t, ~fieldName: string) => option<RecordProxy.t> = "getRootField"

  @send @return(nullable)
  external getPluralRootField: (t, ~fieldName: string) => option<array<Nullable.t<RecordProxy.t>>> =
    "getPluralRootField"

  let getPluralRootField = (t, ~fieldName): option<array<option<RecordProxy.t>>> =>
    getPluralRootField(t, ~fieldName)->optArrayOfNullableToOptArrayOfOpt

  @send external invalidateStore: t => unit = "invalidateStore"

  let invalidateRecordsByIds: (t, array<dataId>) => unit = (store, recordIds) => {
    recordIds->Array.forEach(dataId => {
      store->get(~dataId)->Belt.Option.forEach(r => r->RecordProxy.invalidateRecord)
    })
  }
}

module ReadOnlyRecordSourceProxy = {
  type t

  @send @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @send external getRoot: t => RecordProxy.t = "getRoot"
}

module MissingFieldHandler = {
  @@warning("-30")
  type t

  type normalizationArgumentWrapped = {kind: [#ListValue | #Literal | #ObjectValue | #Variable]}

  type rec normalizationListValueArgument = {
    name: string,
    items: array<Nullable.t<normalizationArgumentWrapped>>,
  }
  and normalizationLiteralArgument = {
    name: string,
    @as("type") type_: Nullable.t<string>,
    value: JSON.t,
  }
  and normalizationObjectValueArgument = {
    name: string,
    fields: Nullable.t<array<normalizationArgumentWrapped>>,
  }
  and normalizationVariableArgument = {
    name: string,
    @as("type") type_: Nullable.t<string>,
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
    alias: Nullable.t<string>,
    name: string,
    args: Nullable.t<array<normalizationArgumentWrapped>>,
    storageKey: Nullable.t<string>,
  }

  let makeScalarMissingFieldHandler = handle =>
    Obj.magic({
      "kind": #scalar,
      "handle": handle,
    })

  type normalizationLinkedField = {
    alias: Nullable.t<string>,
    name: string,
    storageKey: Nullable.t<string>,
    args: Nullable.t<array<normalizationArgument>>,
    concreteType: Nullable.t<string>,
    plural: bool,
    selections: array<JSON.t>,
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
  switch (Nullable.toOption(record), field["name"], Nullable.toOption(args["id"])) {
  | (Some(record), "node", argsId) if record->RecordProxy.getType == storeRootType => argsId
  | _ => None
  }
)

module ConnectionHandler = {
  @module("relay-runtime") @scope("ConnectionHandler") @return(nullable)
  external getConnection: (
    ~record: RecordProxy.t,
    ~key: string,
    ~filters: arguments=?,
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
  ) => unit = "insertEdgeBefore"

  @module("relay-runtime") @scope("ConnectionHandler")
  external insertEdgeAfter: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
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
  external ignore: t => unit = "%ignore"
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
    error: JsExn.t => unit,
    complete: unit => unit,
    closed: bool,
  }

  type observer<'response>

  @obj
  external makeObserver: (
    ~start: subscription => unit=?,
    ~next: 'response => unit=?,
    ~error: JsExn.t => unit=?,
    ~complete: unit => unit=?,
    ~unsubscribe: subscription => unit=?,
  ) => observer<'response> = ""

  @module("relay-runtime") @scope("Observable")
  external make: (sink<'response> => option<subscription>) => t<'response> = "create"

  @send
  external subscribe: (t<'response>, observer<'response>) => subscription = "subscribe"

  @send external toPromise: t<'t> => promise<'t> = "toPromise"

  external ignoreSubscription: subscription => unit = "%ignore"
}

module Network = {
  type t

  type codesplitsMetadata = (string, unit => unit)

  type operationMetadata = {codesplits?: array<codesplitsMetadata>}

  type operation = {
    id: Nullable.t<string>,
    text: Nullable.t<string>,
    name: string,
    operationKind: string,
    metadata: Nullable.t<operationMetadata>,
  }

  type subscribeFn = (operation, JSON.t, cacheConfig) => Observable.t<JSON.t>

  type fetchFunctionPromise = (
    operation,
    JSON.t,
    cacheConfig,
    Nullable.t<uploadables>,
  ) => promise<JSON.t>

  type fetchFunctionObservable = (
    operation,
    JSON.t,
    cacheConfig,
    Nullable.t<uploadables>,
  ) => Observable.t<JSON.t>

  @module("relay-runtime") @scope("Network")
  external makePromiseBased: (
    ~fetchFunction: fetchFunctionPromise,
    ~subscriptionFunction: subscribeFn=?,
  ) => t = "create"

  @module("relay-runtime") @scope("Network")
  external makeObservableBased: (
    ~observableFunction: fetchFunctionObservable,
    ~subscriptionFunction: subscribeFn=?,
  ) => t = "create"

  let preloadResources: (
    ~operation: operation,
    ~variables: JSON.t,
    ~response: JSON.t,
  ) => unit = %raw(`
function preloadResources(operation, variables, response) {
  let metadata = operation.metadata;
  if (metadata == null) return;
  let codesplits = metadata.codesplits;
  if (codesplits == null) return;
  let data = response.data;

  function pathExists(obj, path) {
    let current = obj;

    for (let i = 0; i < path.length; i++) {
      let segment = path[i];

      if (Array.isArray(current)) {
        return current.some((item) => pathExists(item, path.slice(i)));
      } else if (current != null && current.hasOwnProperty(segment)) {
        current = current[segment];
      } else if (current != null && (segment.startsWith("$$u$$") || segment.startsWith("$$i$$"))) {
        let isInterface = segment.startsWith("$$i$$");
        let expectedTypename = segment.slice(5);
        if (
          (
            !isInterface &&
            current.hasOwnProperty("__typename") &&
            current.__typename === expectedTypename) || 
          (
            isInterface &&
            current.hasOwnProperty("__is" + expectedTypename) &&
            current["__is" + expectedTypename] != null
          )
        ) {
          if (i + 1 === path.length) {
            // End
            return true;
          } else {
            continue;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    }

    return current != null;
  }

  function run() {
    for (let instruction of codesplits) {
      let path = instruction[0];
      let func = instruction[1];
      if (pathExists(data, path.split("."))) {
        func(variables);
      }
    }
  }

  if ("requestIdleCallback" in window) {
    requestIdleCallback(run);
  } else {
    setTimeout(() => {
      Promise.resolve().then(run);
    }, 1);
  }
}
`)
}

module RecordSource = {
  type t

  @module("relay-runtime") @new
  external make: (~records: recordSourceRecords=?) => t = "RecordSource"

  @send external toJSON: t => recordSourceRecords = "toJSON"
}

module Store = {
  type t

  type storeConfig = {
    gcReleaseBufferSize: option<int>,
    queryCacheExpirationTime: option<int>,
  }

  @module @new
  external makeLiveStoreCjs: (RecordSource.t, storeConfig) => t =
    "relay-runtime/lib/store/live-resolvers/LiveResolverStore"

  @module("relay-runtime/lib/store/live-resolvers/LiveResolverStore") @new
  external makeLiveStore: (RecordSource.t, storeConfig) => t = "default"

  @module("relay-runtime") @new
  external make: (RecordSource.t, storeConfig) => t = "Store"

  let make = (~source, ~gcReleaseBufferSize=?, ~queryCacheExpirationTime=?) =>
    make(
      source,
      {
        gcReleaseBufferSize,
        queryCacheExpirationTime,
      },
    )

  let makeLiveStore = (~source, ~gcReleaseBufferSize=?, ~queryCacheExpirationTime=?) =>
    makeLiveStore(
      source,
      {
        gcReleaseBufferSize,
        queryCacheExpirationTime,
      },
    )

  let _makeLiveStoreCjs = (~source, ~gcReleaseBufferSize=?, ~queryCacheExpirationTime=?) =>
    makeLiveStoreCjs(
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

module RelayFieldLogger = {
  @tag("kind")
  type arg =
    | @as("missing_required_field.log")
    MissingRequiredFieldLog({
        owner: string,
        fieldPath: string,
        uiContext: option<JSON.t>,
      })
    | @as("missing_required_field.throw")
    MissingRequiredFieldThrow({
        owner: string,
        fieldPath: string,
        uiContext: option<JSON.t>,
      })
    | @as("missing_expected_data.log")
    MissingExpectedData({
        owner: string,
        fieldPath: string,
        uiContext: option<JSON.t>,
      })
    | @as("missing_expected_data.throw")
    MissingExpectedDataThrow({
        owner: string,
        fieldPath: string,
        handled: bool,
        uiContext: option<JSON.t>,
      })
    | @as("relay_resolver.error")
    RelayResolverError({
        owner: string,
        fieldPath: string,
        error: JsExn.t,
        uiContext: option<JSON.t>,
      })

  type t = arg => unit
}

module Environment = {
  type t

  type environmentConfig<'a> = {
    network: Network.t,
    store: Store.t,
    getDataID?: (~nodeObj: 'a, ~typeName: string) => string,
    treatMissingFieldsAsNull?: bool,
    missingFieldHandlers: array<MissingFieldHandler.t>,
    relayFieldLogger?: RelayFieldLogger.t,
    isServer?: bool,
  }

  @module("relay-runtime") @new
  external make: environmentConfig<'a> => t = "Environment"

  let make = (
    ~network,
    ~store,
    ~getDataID=?,
    ~treatMissingFieldsAsNull=?,
    ~missingFieldHandlers=?,
    ~relayFieldLogger=?,
    ~isServer=?,
  ) =>
    make({
      network,
      store,
      ?getDataID,
      ?treatMissingFieldsAsNull,
      missingFieldHandlers: switch missingFieldHandlers {
      | Some(handlers) => handlers->Belt.Array.concat([nodeInterfaceMissingFieldHandler])
      | None => [nodeInterfaceMissingFieldHandler]
      },
      ?relayFieldLogger,
      ?isServer,
    })

  @send external getStore: t => Store.t = "getStore"
  @send
  external commitPayload: (t, operationDescriptor, 'payload) => unit = "commitPayload"
  @send external retain: (t, operationDescriptor) => Disposable.t = "retain"

  @module("relay-runtime")
  external commitLocalUpdate: (t, ~updater: RecordSourceSelectorProxy.t => unit) => unit =
    "commitLocalUpdate"

  @send external mapGet: (Map.t<'key, 'value>, 'key) => option<'value> = "get"

  type recordValue = {__ref: dataId}
  @get external _records: RecordSource.t => Map.t<string, dict<recordValue>> = "_records"

  let findAllConnectionIds = (environment: t, ~connectionKey: string, ~parentId: dataId) => {
    let ids = []
    switch environment->getStore->Store.getSource->_records->mapGet(parentId->dataIdToString) {
    | Some(value) =>
      value
      ->Dict.toArray
      ->Array.forEach(((key, v)) => {
        if key->String.startsWith("__" ++ connectionKey ++ "_connection") {
          let _ = ids->Array.push(v.__ref)
        }
      })
    | _ => ()
    }
    ids
  }

  let invalidateAllOfConnection = (
    environment: t,
    ~connectionKey: string,
    ~parentId: dataId,
    ~excludedIds=[],
  ) => {
    environment->commitLocalUpdate(~updater=store => {
      environment
      ->findAllConnectionIds(~connectionKey, ~parentId)
      ->Array.forEach(dataId => {
        if !(excludedIds->Array.includes(dataId)) {
          store
          ->RecordSourceSelectorProxy.get(~dataId)
          ->Belt.Option.forEach(r => r->RecordProxy.invalidateRecord)
        }
      })
    })
  }
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
      React.createElement(provider, {value: Some({"environment": environment}), children})
    }
  }
}

exception EnvironmentNotFoundInContext

let useEnvironmentFromContext = () => {
  let context = React.useContext(Context.context)

  switch context {
  | Some(ctx) => ctx["environment"]
  | None => throw(EnvironmentNotFoundInContext)
  }
}

type fetchPolicy =
  | @as("store-only") StoreOnly
  | @as("store-or-network") StoreOrNetwork
  | @as("store-and-network") StoreAndNetwork
  | @as("network-only") NetworkOnly

type fetchQueryFetchPolicy =
  | @as("network-only") NetworkOnly
  | @as("store-or-network") StoreOrNetwork

type fetchQueryOptions = {
  networkCacheConfig?: cacheConfig,
  fetchPolicy?: fetchPolicy,
}

type loadQueryConfig = {
  fetchKey: option<string>,
  fetchPolicy: option<fetchPolicy>,
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
  ) => C.loadedQueryRef = (
    ~environment,
    ~variables,
    ~fetchPolicy=?,
    ~fetchKey=?,
    ~networkCacheConfig=?,
  ) =>
    loadQuery(
      environment,
      C.query,
      variables->C.convertVariables,
      {
        fetchKey,
        fetchPolicy,
        networkCacheConfig,
      },
    )

  type rawPreloadToken<'response> = {source: Nullable.t<Observable.t<'response>>}
  external tokenToRaw: C.loadedQueryRef => rawPreloadToken<C.response> = "%identity"

  let queryRefToObservable = token => {
    let raw = token->tokenToRaw
    raw.source->Nullable.toOption
  }

  let queryRefToPromise = token => {
    Promise.make((resolve, _) => {
      switch token->queryRefToObservable {
      | None => resolve(Error())
      | Some(o) =>
        open Observable
        let _: subscription = o->subscribe(makeObserver(~complete=() => resolve(Ok())))
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
