@ocaml.doc(
  "Abstract type for arguments, used when selecting fields on `RecordProxy` and friends when interacting with the store imperatively."
)
type arguments

@ocaml.doc("Abstract type for uploadables.

### Constructing an `uploadables`
Use `makeUploadable`: `makeUploadable({ \"someFile\": theFileYouWantToUpload })` to construct an `uploadables`, and then pass it to your mutation via the `uploadables` prop.

Please note that you'll need to handle _sending_ the uploadables to your server yourself in the network layer. [Here's an example](https://github.com/facebook/relay/issues/1844#issuecomment-316893590) in regular JS that you can adapt to ReScript as you need/want.")
type uploadables

@ocaml.doc(
  "If you see this, it means that all fields have been masked in this selection, which is why it contains no data. Relay uses [_data masking_](https://relay.dev/docs/en/thinking-in-relay.html#data-masking) to hide data you haven't explicitly asked for, even if it exists on the object."
)
type allFieldsMasked = {.}

@ocaml.doc(
  "Abstract helper type to signify something that could not be generated in a type-safe way."
)
type any

@ocaml.doc(
  "A query node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type queryNode<'node>

@ocaml.doc(
  "A fragment node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type fragmentNode<'node>

@ocaml.doc(
  "A mutation node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type mutationNode<'node>

@ocaml.doc(
  "A subscription node, used internally by Relay. These are runtime artifacts produced by the Relay compiler."
)
type subscriptionNode<'node>

@ocaml.doc("This type shows all of the fragments that has been spread on this particular object.")
type fragmentRefs<'fragments>

@ocaml.doc("The type of the id Relay uses to identify records in its store.")
type dataId

@ocaml.doc("Turns a `dataId` into a `string`.")
external dataIdToString: dataId => string = "%identity"

@ocaml.doc("Turns a `string` into a `dataId`.")
external makeDataId: string => dataId = "%identity"

@ocaml.doc("Construct an `arguments` object for use with certain Relay store APIs.

### Usage
Use it like this: `makeArguments({ \"someArgument\": someValue, \"anotherArgument\": anotherValue })`. Notice the \"\" surrounding the property names - these are important and tells ReScript that we want this to be a JS object.")
external makeArguments: {..} => arguments = "%identity"

@ocaml.doc(
  "Construct an `uploadables` object from a `Js.Dict` with your desired file format, that you can use for uploads via Relay."
)
external makeUploadables: Js.Dict.t<'file> => uploadables = "%identity"

@ocaml.doc(
  "Unwraps `uploadables` into a Js.Dict.t with your expected file type, so you can use that dict to attach the provided files to your request."
)
external unwrapUploadables: uploadables => Js.Dict.t<'file> = "%identity"

@ocaml.doc(
  "This generates a `dataId` for use on the _client_ side. However, this is farily low level, and what you're probably really looking for is `generateUniqueClientID` that'll let you generate a new, unique `dataId` that you can use for client side only records (like when doing optimistic updates)."
)
@module("relay-runtime")
external generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?, unit) => dataId =
  "generateClientID"

@ocaml.doc(
  "This generates a unique `dataId` that's safe to use on the _client_ side. Useful when doing optimistic updates and you need to create IDs that the optimistic update can use."
)
@module("relay-runtime")
external generateUniqueClientID: unit => dataId = "generateUniqueClientID"

@ocaml.doc("Checks whether the provided `dataId` is guaranteed to be a client side only id.")
@module("relay-runtime")
external isClientID: dataId => bool = "isClientID"

@ocaml.doc(
  "Relay feature flags. Mutate this record as soon as your application boots to enable/disable features."
)
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

@ocaml.doc(
  "Relay feature flags. Mutate this record as soon as your application boots to enable/disable features."
)
@module("relay-runtime")
external relayFeatureFlags: featureFlags = "RelayFeatureFlags"

@ocaml.doc("Representing all records in the store serialized to JSON in a way that you can use to re-hydrate the store. 

See `RecordSource.toJSON` for how to produce it.")
type recordSourceRecords = Js.Json.t

@ocaml.doc(
  "The `dataId` for the Relay store's root. Useful when for example referencing the `parentID` of a connection that's on the store root."
)
@module("relay-runtime")
external storeRootId: dataId = "ROOT_ID"

@ocaml.doc("The `type` for the Relay store's root `RecordProxy`.") @module("relay-runtime")
external storeRootType: string = "ROOT_TYPE"

@ocaml.doc("Internal, do not use.") @module("./utils")
external convertObj: ('a, Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>>, 'b, 'c) => 'd = "traverser"

@ocaml.doc(
  "Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store"
)
module RecordProxy: {
  @ocaml.doc(
    "Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store"
  )
  type t

  @ocaml.doc("Copies all fields from one `RecordProxy` to another.") @send
  external copyFieldsFrom: (t, ~sourceRecord: t) => unit = "copyFieldsFrom"

  @ocaml.doc("Gets the \`dataId\` for a particular record.") @send
  external getDataId: t => dataId = "getDataID"

  @ocaml.doc(
    "Gets a single linked record. A linked record is another object in the store, and not a scalar field like an int or float."
  )
  @send
  @return(nullable)
  external getLinkedRecord: (t, ~name: string, ~arguments: arguments=?, unit) => option<t> =
    "getLinkedRecord"

  @ocaml.doc(
    "Gets an array of linked records, for when a field is a list (meaning a link to multiple records)."
  )
  let getLinkedRecords: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<t>>>

  @ocaml.doc(
    "This returns an existing linked record, or creates one at the configured place if one does not already exist."
  )
  @send
  external getOrCreateLinkedRecord: (
    t,
    ~name: string,
    ~typeName: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "getOrCreateLinkedRecord"

  @ocaml.doc("Returns the `__typename` of this particular record.") @send
  external getType: t => string = "getType"

  @ocaml.doc("Returns a field value, expecting it to be a string.") @send @return(nullable)
  external getValueString: (t, ~name: string, ~arguments: arguments=?, unit) => option<string> =
    "getValue"

  @ocaml.doc("Returns a field value, expecting it to be an array of strings.")
  @send
  @return(nullable)
  external getValueStringArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<string>>> = "getValue"

  @ocaml.doc("Returns a field value, expecting it to be an int.") @send @return(nullable)
  external getValueInt: (t, ~name: string, ~arguments: arguments=?, unit) => option<int> =
    "getValue"

  @ocaml.doc("Returns a field value, expecting it to be an array of ints.") @send @return(nullable)
  external getValueIntArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<int>>> = "getValue"

  @ocaml.doc("Returns a field value, expecting it to be a float.") @send @return(nullable)
  external getValueFloat: (t, ~name: string, ~arguments: arguments=?, unit) => option<float> =
    "getValue"

  @ocaml.doc("Returns a field value, expecting it to be an array of floats.")
  @send
  @return(nullable)
  external getValueFloatArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<float>>> = "getValue"

  @ocaml.doc("Returns a field value, expecting it to be a boolean.") @send @return(nullable)
  external getValueBool: (t, ~name: string, ~arguments: arguments=?, unit) => option<bool> =
    "getValue"

  @ocaml.doc("Returns a field value, expecting it to be an array of booleans.")
  @send
  @return(nullable)
  external getValueBoolArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<bool>>> = "getValue"

  @ocaml.doc("Sets a `RecordProxy.t` as the linked record for a particular field.") @send
  external setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?, unit) => t =
    "setLinkedRecord"

  @ocaml.doc("Sets an array of `RecordProxy.t` as the linked records for a particular field.") @send
  external setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setLinkedRecords"

  @ocaml.doc("Sets a string as field value.") @send
  external setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @ocaml.doc("Sets an array of strings as field value.") @send
  external setValueStringArray: (
    t,
    ~value: array<string>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Sets an int as field value.") @send
  external setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @ocaml.doc("Sets an array of ints as field value.") @send
  external setValueIntArray: (
    t,
    ~value: array<int>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Sets a float as field value.") @send
  external setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @ocaml.doc("Sets an array of floats as field value.") @send
  external setValueFloatArray: (
    t,
    ~value: array<float>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Sets a boolean as field value.") @send
  external setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?, unit) => t =
    "setValue"

  @ocaml.doc("Sets an array of booleans as field value.") @send
  external setValueBoolArray: (
    t,
    ~value: array<bool>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Sets the field value to `undefined` (meaning Relay will treat it as missing data).")
  @send
  external setValueToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Sets the field value to `null`.") @send
  external setValueToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc(
    "Sets this linked record to `undefined` (meaning Relay will treat it as missing data)."
  )
  @send
  external setLinkedRecordToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Sets this linked record to `null`.") @send
  external setLinkedRecordToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc(
    "Sets the field holding these linked records to `undefined` (meaning Relay will treat it as missing data)."
  )
  @send
  external setLinkedRecordsToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Sets the field holding these linked records to `null`.") @send
  external setLinkedRecordsToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t = "setValue"

  @ocaml.doc("Invalidates this record.

Invalidating a record means that the _next_ time Relay evaluates this record, it'll be treated as missing.

_Beware_ that this doesn't mean that queries using this record will refetch immediately. Rather, it'll happen the next time the query _renders_. Have a look at `useSubscribeToInvalidationState`, that'll allow you to subscribe to whenever records are invalidated, if you're looking for a way to refetch immediately as something invalidates.")
  @send
  external invalidateRecord: t => unit = "invalidateRecord"
}

@ocaml.doc(
  "RecordSourceSelectorProxy and RecordSourceProxy are the two modules representing the store, with various capabilities."
)
module RecordSourceSelectorProxy: {
  @ocaml.doc("Type type representing a `RecordSourceSelectorProxy`.")
  type t

  @ocaml.doc("Creates a new `RecordProxy`.") @send
  external create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t = "create"

  @ocaml.doc("Deletes the `RecordProxy` with the provided `dataId`.") @send
  external delete: (t, ~dataId: dataId) => unit = "delete"

  @ocaml.doc("Returns the `RecordProxy` with the provided `dataId`, if it exists.")
  @send
  @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @ocaml.doc(
    "Returns the _root_ `RecordProxy`, meaning the `RecordProxy` holding your top level fields."
  )
  @send
  external getRoot: t => RecordProxy.t = "getRoot"

  @ocaml.doc(
    "Returns the `RecordProxy` for the `fieldName` at root. You should prefer using `RecordSourceSelectorProxy.getRoot()` and traverse from there if you need access to root fields rather than use this."
  )
  @send
  @return(nullable)
  external getRootField: (t, ~fieldName: string) => option<RecordProxy.t> = "getRootField"

  @ocaml.doc("Plural version of `RecordSourceSelectorProxy.getRootField`.")
  let getPluralRootField: (t, ~fieldName: string) => option<array<option<RecordProxy.t>>>

  @ocaml.doc(
    "Invalidates the entire store. This means that _at the next render_, the entire store will be treated as empty, meaning Relay will refetch everything it needs to show the view it's to show."
  )
  @send
  external invalidateStore: t => unit = "invalidateStore"
}

@ocaml.doc("ReadOnlyRecordSourceProxy is the store, but in read-only mode.")
module ReadOnlyRecordSourceProxy: {
  @ocaml.doc("Type type representing a `ReadOnlyRecordSourceProxy`.")
  type t

  @ocaml.doc("Returns the `RecordProxy` with the provided `dataId`, if it exists.")
  @send
  @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  @ocaml.doc(
    "Returns the _root_ `RecordProxy`, meaning the `RecordProxy` holding your top level fields."
  )
  @send
  external getRoot: t => RecordProxy.t = "getRoot"
}

@ocaml.doc("A missing field handler, which is a way of teaching Relay more about the relations in your schema, so it can fulfill more things from the cache. Read more [in this section of the Relay docs](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/).

Feed a list of missing field handlers into `Environment.make` if you want to use them.")
module MissingFieldHandler: {
  @@ocaml.warning("-30")

  @ocaml.doc(
    "A missing field handler, which is a way of teaching Relay more about the relations in your schema, so it can fulfill more things from the cache. Read more [in this section of the Relay docs](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/)."
  )
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

  let unwrapNormalizationArgument: normalizationArgumentWrapped => normalizationArgument

  type normalizationScalarField = {
    alias: Js.Nullable.t<string>,
    name: string,
    args: Js.Nullable.t<array<normalizationArgumentWrapped>>,
    storageKey: Js.Nullable.t<string>,
  }

  @ocaml.doc(
    "Make a `MissingFieldHandler.t` for scalar fields. Give this a handler function that returns `Js.null` (to indicate that data exists but is null), `Js.undefined` (to indicate data is still missing), or a scalar value (to indicate that the value exists even though it's not in the cache, and is the value you send back)."
  )
  let makeScalarMissingFieldHandler: (
    (
      normalizationScalarField,
      Js.Nullable.t<'record>,
      'args,
      ReadOnlyRecordSourceProxy.t,
    ) => 'scalarValue
  ) => t

  type normalizationLinkedField = {
    alias: Js.Nullable.t<string>,
    name: string,
    storageKey: Js.Nullable.t<string>,
    args: Js.Nullable.t<array<normalizationArgument>>,
    concreteType: Js.Nullable.t<string>,
    plural: bool,
    selections: array<Js.Json.t>,
  }

  @ocaml.doc(
    "Make a `MissingFieldHandler.t` for linked fields (other objects/records). Give this a handler function that returns `Js.null` (to indicate that the link exists but the linked record is null), `Js.undefined` (to indicate data is still missing), or a `dataId` of the record that is linked at this field."
  )
  let makeLinkedMissingFieldHandler: (
    (
      normalizationLinkedField,
      Js.Nullable.t<'record>,
      'args,
      ReadOnlyRecordSourceProxy.t,
    ) => Js.Nullable.t<dataId>
  ) => t

  @ocaml.doc(
    "Make a `MissingFieldHandler.t` for lists of linked fields (other objects/records). Give this a handler function that returns `Js.null` (to indicate that the link exists but the linked record is null), `Js.undefined` (to indicate data is still missing), or an array of `Js.Nullable.t<dataId>` where the `dataId`'s are the linked records/objects."
  )
  let makePluralLinkedMissingFieldHandler: (
    (
      normalizationLinkedField,
      Js.Nullable.t<'record>,
      'args,
      ReadOnlyRecordSourceProxy.t,
    ) => Js.Nullable.t<array<Js.Nullable.t<dataId>>>
  ) => t
}

@ocaml.doc(
  "Read the Relay docs section on [ConnectionHandler](https://relay.dev/docs/en/relay-store#connectionhandler)"
)
module ConnectionHandler: {
  @ocaml.doc(
    "For a `RecordProxy`, returns the `RecordProxy` that is at the connection config provided."
  )
  @module("relay-runtime")
  @scope("ConnectionHandler")
  @return(nullable)
  external getConnection: (
    ~record: RecordProxy.t,
    ~key: string,
    ~filters: arguments=?,
    unit,
  ) => option<RecordProxy.t> = "getConnection"

  @ocaml.doc("Creates an edge for a particular connection.")
  @module("relay-runtime")
  @scope("ConnectionHandler")
  external createEdge: (
    ~store: RecordSourceSelectorProxy.t,
    ~connection: RecordProxy.t,
    ~node: RecordProxy.t,
    ~edgeType: string,
  ) => RecordProxy.t = "createEdge"

  @ocaml.doc(
    "Inserts an edge into a connection _before_ the provided cursor. If no cursor is provided, it inserts the edge at the start of the connection list."
  )
  @module("relay-runtime")
  @scope("ConnectionHandler")
  external insertEdgeBefore: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeBefore"

  @ocaml.doc(
    "Inserts an edge into a connection _after_ the provided cursor. If no cursor is provided, it inserts the edge at the end of the connection list."
  )
  @module("relay-runtime")
  @scope("ConnectionHandler")
  external insertEdgeAfter: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit = "insertEdgeAfter"

  @ocaml.doc(
    "Deletes any edge from the connection where the node of the edge has the provided `dataId`. Please not that this _will not_ remove the actual node from the store. Use `RecordSourceSelectorProxy.delete` for that."
  )
  @module("relay-runtime")
  @scope("ConnectionHandler")
  external deleteNode: (~connection: RecordProxy.t, ~nodeId: dataId) => unit = "deleteNode"

  @ocaml.doc(
    "Constructs a `dataId` targeting a specific connection at a specific parent. Note that the generated module for every fragment with a `@connection` will have a `<moduleName>.Utils.connectionKey` representing the connection key of that particular `@connection`, that you should use with this."
  )
  @module("relay-runtime")
  @scope("ConnectionHandler")
  external getConnectionID: (dataId, string, 'filters) => dataId = "getConnectionID"
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

@ocaml.doc(
  "A Relay observable, used throughout Relay for delivering data, in particular when dealing with multiple payloads like with subscriptions or multipart responses like `@stream` or `@defer`."
)
module Observable: {
  @ocaml.doc("The type representing the observable.")
  type t<'response>

  @ocaml.doc("This sink can be used to give the observable new data.")
  type sink<'response> = {
    next: (. 'response) => unit,
    error: (. Js.Exn.t) => unit,
    complete: (. unit) => unit,
    closed: bool,
  }

  @ocaml.doc("A subscription for an observable, allowing you to unsubscribe if wanted.")
  type subscription = {
    unsubscribe: unit => unit,
    closed: bool,
  }

  @ocaml.doc("An observer of the observable.")
  type observer<'response>

  @ocaml.doc("Create an observer.") @obj
  external makeObserver: (
    ~start: @uncurry subscription => unit=?,
    ~next: @uncurry 'response => unit=?,
    ~error: @uncurry Js.Exn.t => unit=?,
    ~complete: @uncurry unit => unit=?,
    ~unsubscribe: subscription => unit=?,
    unit,
  ) => observer<'response> = ""

  @ocaml.doc(
    "Create a new observable, getting fed an `Observable.sink` for interacting with the observable, and optionally returning a `Observable.subscription` if you have things you want to unsubscribe from as the observable closes."
  )
  @module("relay-runtime")
  @scope("Observable")
  external make: (sink<'t> => option<subscription>) => t<'t> = "create"

  @ocaml.doc("Subscribe to the `Observable.t` using an observer.") @send
  external subscribe: (t<'t>, observer<'t>) => subscription = "subscribe"

  @ocaml.doc(
    "Turns an `Observable` into a promise. _Beware_ that reading the response in the resulting promise is currently _not safe_ due to some internals of how ReScript Relay works. This will be resolved in the future."
  )
  @send
  external toPromise: t<'t> => Js.Promise.t<'t> = "toPromise"
}

@ocaml.doc("Represents the network layer.")
module Network: {
  @ocaml.doc("The type representing an instantiated `NetworkLayer`.")
  type t

  @ocaml.doc(
    "The operation fed to the `NetworkLayer` when Relay wants to make a request. Please note that if you're using persisted queries, `id` will exist but `text` won't, and vice versa when not using persisted queries."
  )
  type operation = {
    id: string,
    text: string,
    name: string,
    operationKind: string,
  }

  @ocaml.doc("The shape of the function Relay expects for creating a subscription.")
  type subscribeFn = (operation, Js.Json.t, cacheConfig) => Observable.t<Js.Json.t>

  @ocaml.doc(
    "The shape of the function responsible for fetching data if you want to return a promise rather than an `Observable`."
  )
  type fetchFunctionPromise = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Js.Promise.t<Js.Json.t>

  @ocaml.doc(
    "The shape of the function responsible for fetching data if you want to return an `Observable`."
  )
  type fetchFunctionObservable = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Observable.t<Js.Json.t>

  @ocaml.doc("Create a new `NetworkLayer` using a fetch function that returns a promise.")
  @module("relay-runtime")
  @scope("Network")
  external makePromiseBased: (
    ~fetchFunction: fetchFunctionPromise,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"

  @ocaml.doc("Create a new `NetworkLayer` using a fetch function that returns an `Observable`.")
  @module("relay-runtime")
  @scope("Network")
  external makeObservableBased: (
    ~observableFunction: fetchFunctionObservable,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t = "create"
}

@ocaml.doc(
  "RecordSource is the source of records used by the store. Can be initiated with or without prior records; eg. hydrating the store with prior data."
)
module RecordSource: {
  @ocaml.doc("The type representing an instantiated `RecordSource`.")
  type t

  @ocaml.doc(
    "Create a new `RecordSource`. Here's where you pass an existing `recordSourceRecords` if you have existing records you want to hydrate the store with, when doing SSR or similar."
  )
  @module("relay-runtime")
  @new
  external make: (~records: recordSourceRecords=?, unit) => t = "RecordSource"

  @ocaml.doc(
    "Serializes the `RecordSource` into `recordSourceRecords` that you can use to rehydrate another store. Typically used for SSR."
  )
  @send
  external toJSON: t => recordSourceRecords = "toJSON"
}

@ocaml.doc("The actual store module, with configuration for the store.")
module Store: {
  @ocaml.doc("The type representing an instantiated `Store`.")
  type t

  @ocaml.doc("Creates a new `Store`.")
  let make: (
    ~source: RecordSource.t,
    ~gcReleaseBufferSize: /* `gcReleaseBufferSize` controls how many queries are allowed to be cached by default. Increase this to increase the size of the cache. */
    int=?,
    ~queryCacheExpirationTime: int=? /* `queryCacheExpirationTime` sets a TTL (time to live) for all queries. If that time passes, the data is considered stale and is evicted from the store. Default is no TTL. */,
    unit,
  ) => t

  @ocaml.doc("Gets the `RecordSource` for this `Store`.") @send
  external getSource: t => RecordSource.t = "getSource"

  @ocaml.doc(
    "Publishes _new_ records to this store. This is useful in particular with frameworks like Next.js where routes could preload data needed and then serialize that (using `RecordSource.toJSON`) and send it over the wire, but you already have a store instantiated client side. This will then allow you to publish those records into your existing store."
  )
  @send
  external publish: (t, RecordSource.t) => unit = "publish"

  @ocaml.doc(
    "Informes the store to stop its normal garbage collection processes. This prevents data being lost between calling relay's `fetchQuery` any serialization process (eg: toJSON)"
  )
  @send
  external holdGC: t => unit = "holdGC"
}

@ocaml.doc("Internal, do not use.")
type operationDescriptor

@ocaml.doc(
  "A disposable is something you can use to dispose of something when you don't use/need it anymore."
)
module Disposable: {
  @ocaml.doc("The type representing a `Disposable`.")
  type t

  @ocaml.doc("Dispose the `Disposable`.") @send external dispose: t => unit = "dispose"
}

@ocaml.doc(
  "A required field logger, which gets called when a field annotated with the @required directive was missing from the response"
)
module RequiredFieldLogger: {
  type kind = [#"missing_field.log" | #"missing_field.throw"]

  @ocaml.doc(
    "A required field logger, which gets called when a field annotated with the @required directive was missing from the response"
  )
  type t = (~kind: kind, ~owner: string, ~fieldPath: string) => unit
}

@ocaml.doc(
  "Module representing the environment, which you'll need to use and pass to various functions. Takes a few configuration options like store and network layer."
)
module Environment: {
  @ocaml.doc("The type representing an instantiated `Environment`.")
  type t

  @ocaml.doc("Create a new `Environment`.")
  let make: (
    ~network: Network.t,
    ~store: Store.t,
    ~getDataID: (
      ~nodeObj: {.."__typename": string, "id": string} as 'a,
      ~typeName: string,
    ) => string=?,
    ~treatMissingFieldsAsNull: bool=?,
    ~missingFieldHandlers: array<MissingFieldHandler.t>=?,
    ~requiredFieldLogger: RequiredFieldLogger.t=?,
    ~isServer: bool=?,
    unit,
  ) => t

  @ocaml.doc("Get the `Store` for this `Environment`.") @send
  external getStore: t => Store.t = "getStore"

  @ocaml.doc("Given an `operationDescriptor`, commits the corresponding payload.") @send
  external commitPayload: (t, operationDescriptor, 'payload) => unit = "commitPayload"

  @ocaml.doc("Given an `operationDescriptor`, retains the corresponding operation so any data referenced by it isn't garbage collected.
You should use the generated `Query.retain` function on your queries instead of using this directly.")
  @send
  external retain: (t, operationDescriptor) => Disposable.t = "retain"
}

@ocaml.doc("fetchPolicy controls how you want Relay to resolve your data.")
type fetchPolicy =
  | StoreOnly /* Resolve only from the store */
  | StoreOrNetwork /* Resolve from the store if all data is there, otherwise make a network request */
  | StoreAndNetwork /* Like StoreOrNetwork, but always make a request regardless of if the data was there initially or not */
  | NetworkOnly /* Always make a request, regardless of what's in the store */

@ocaml.doc("Internal, do not use.")
let mapFetchPolicy: option<fetchPolicy> => option<string>

@ocaml.doc(
  "The fetch policies allowed for fetching a query outside of React's render (as in `Query.fetch`)."
)
type fetchQueryFetchPolicy =
  | NetworkOnly
  | StoreOrNetwork

@ocaml.doc("Internal, do not use.")
let mapFetchQueryFetchPolicy: option<fetchQueryFetchPolicy> => option<string>

@ocaml.doc("An error from a mutation.")
type mutationError = {message: string}

@ocaml.doc("Context provider for the Relay environment.")
module Context: {
  @ocaml.doc("Type representing the context.")
  type t

  @ocaml.doc("The expected shape of the context.")
  type contextShape = {"environment": Environment.t}

  @ocaml.doc("The actual React context coming from Relay.") @module("react-relay")
  external context: React.Context.t<option<contextShape>> = "ReactRelayContext"

  @ocaml.doc(
    "The context provider you wrap your app in and pass your `Environment` for Relay to work."
  )
  module Provider: {
    @ocaml.doc(
      "The React component you wrap your app in and pass your `Environment` for Relay to work."
    )
    @react.component
    let make: (~environment: Environment.t, ~children: React.element) => React.element
  }
}

@ocaml.doc(
  "An exception saying that the environment could not be found in the context. Means you forgot to wrap your app in `<RescriptRelay.Context.Provider environment=RelayEnv.environment>`"
)
exception EnvironmentNotFoundInContext

@ocaml.doc("Hook for getting the current environment from context.")
let useEnvironmentFromContext: unit => Environment.t

@ocaml.doc("An exception detailing that a mutation failed.")
exception Mutation_failed(array<mutationError>)

@ocaml.doc("A way of committing a local update to the store.") @module("relay-runtime")
external commitLocalUpdate: (
  ~environment: Environment.t,
  ~updater: RecordSourceSelectorProxy.t => unit,
) => unit = "commitLocalUpdate"

@ocaml.doc(
  "Allows you to subscribe to when a record, connection, or even the store itself is invalidated, and then react to that."
)
@module("react-relay")
external useSubscribeToInvalidationState: (array<dataId>, unit => unit) => Disposable.t =
  "useSubscribeToInvalidationState"

@ocaml.doc(
  "Options valid when fetching a query outside of React's render method (like when using `Query.fetch`)."
)
type fetchQueryOptions = {
  networkCacheConfig: option<cacheConfig>,
  fetchPolicy: option<string>,
}

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
  let queryRefToPromise: C.loadedQueryRef => Js.Promise.t<Belt.Result.t<unit, unit>>
}
