/**Abstract type for arguments, used when selecting fields on `RecordProxy` and friends when interacting with the store imperatively.*/
type arguments

/**Abstract type for uploadables.

### Constructing an `uploadables`
Use `makeUploadable`: `makeUploadable({ "someFile": theFileYouWantToUpload })` to construct an `uploadables`, and then pass it to your mutation via the `uploadables` prop.

Please note that you'll need to handle _sending_ the uploadables to your server yourself in the network layer. [Here's an example](https://github.com/facebook/relay/issues/1844#issuecomment-316893590) in regular JS that you can adapt to ReScript as you need/want.*/
type uploadables

/**If you see this, it means that all fields have been masked in this selection, which is why it contains no data. Relay uses [_data masking_](https://relay.dev/docs/en/thinking-in-relay.html#data-masking) to hide data you haven't explicitly asked for, even if it exists on the object.*/
type allFieldsMasked = {.}

/**Abstract helper type to signify something that could not be generated in a type-safe way.*/
type any

/**A query node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.*/
type queryNode<'node>

/**A fragment node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.*/
type fragmentNode<'node>

/**A mutation node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.*/
type mutationNode<'node>

/**A subscription node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.*/
type subscriptionNode<'node>

/**This type shows all of the fragments that has been spread on this particular object.*/
type fragmentRefs<'fragments>

/**This type shows the Relay resolver fragment that has been spread on this particular object.*/
type resolverFragmentRefs<'fragments>

/**This type shows all of the updatable fragments that has been spread on this particular object.*/
type updatableFragmentRefs<'fragments>

/**The type of the id Relay uses to identify records in its store.*/
type dataId

type dataIdObject = {id: dataId}

/** A module for results originating from the @catch directive. */
module CatchResult: {
  /** The shape of an error caught via @catch. */
  type catchError = JSON.t

  /** The result type for @catch. */
  @tag("ok")
  type t<'value> =
    | @as(true) Ok({value: 'value})
    | @as(false) Error({errors: array<catchError>})

  /** Convert a @catch result to option. */
  let toOption: t<'value> => option<'value>

  /** Convert a @catch result to result. */
  let toResult: t<'value> => result<'value, array<catchError>>
}

module SuspenseSentinel: {
  type t

  @module("relay-runtime") external suspend: t => 'any = "suspenseSentinel"
}

type liveStateCallback = unit => unit
type liveStateUnsubscribeCallback = unit => unit

type liveState<'value> = {
  read: SuspenseSentinel.t => 'value,
  subscribe: liveStateCallback => liveStateUnsubscribeCallback,
}

@module("relay-runtime/experimental")
external resolverDataInjector: ('a, 'b, 'c, 'd) => 'return = "resolverDataInjector"

/**Turns a `dataId` into a `string`.*/
external dataIdToString: dataId => string = "%identity"

/**Turns a `string` into a `dataId`.*/
external makeDataId: string => dataId = "%identity"

/**Construct an `arguments` object for use with certain Relay store APIs.

### Usage
Use it like this: `makeArguments({ "someArgument": someValue, "anotherArgument": anotherValue })`. Notice the "" surrounding the property names - these are important and tells ReScript that we want this to be a JS object.*/
external makeArguments: {..} => arguments = "%identity"

/**Construct an `uploadables` object from a `Js.Dict` with your desired file format, that you can use for uploads via Relay.*/
external makeUploadables: dict<'file> => uploadables = "%identity"

/**Unwraps `uploadables` into a Js.Dict.t with your expected file type, so you can use that dict to attach the provided files to your request.*/
external unwrapUploadables: uploadables => dict<'file> = "%identity"

/**
  Generates a client-side `dataId` derived from an existing record.

  This is a low-level function for creating deterministic client IDs. For most use cases,
  prefer `generateUniqueClientID` which creates globally unique identifiers.

  ## Parameters
  - `dataId`: The base record ID to derive from
  - `storageKey`: A unique key for this derived record
  - `index`: Optional index for array-like derived records

  ## Examples

  ```rescript
  // Create a client ID for a cached query result
  let derivedId = RescriptRelay.generateClientID(
    ~dataId=user.__id,
    ~storageKey="cached_search_results",
  )
  ```
*/
@module("relay-runtime")
external generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?) => dataId =
  "generateClientID"

/**
  Generates a globally unique client-side `dataId`.

  Creates a new unique identifier safe for client-side records. Primarily used for
  optimistic updates where you need temporary IDs before server confirmation.

  ## Examples

  ```rescript
  // Use in optimistic response
  mutate(
    ~variables={...},
    ~optimisticResponse={
      userCreated: Some({
        user: {
          id: RescriptRelay.generateUniqueClientID(),
          name: "New User",
          __typename: #User,
        }
      })
    }
  )
  
  ```
*/
@module("relay-runtime")
external generateUniqueClientID: unit => dataId = "generateUniqueClientID"

/**Checks whether the provided `dataId` is guaranteed to be a client side only id.*/
@module("relay-runtime")
external isClientID: dataId => bool = "isClientID"

/**Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.*/
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

/**Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.*/
@module("relay-runtime")
external relayFeatureFlags: featureFlags = "RelayFeatureFlags"

/**Representing all records in the store serialized to JSON in a way that you can use to re-hydrate the store. 

See `RecordSource.toJSON` for how to produce it.*/
type recordSourceRecords = JSON.t

/**The `dataId` for the Relay store's root. Useful when for example referencing the `parentID` of a connection that's on the store root.*/
@module("relay-runtime")
external storeRootId: dataId = "ROOT_ID"

/**The `type` for the Relay store's root `RecordProxy`.*/
@module("relay-runtime")
external storeRootType: string = "ROOT_TYPE"

/**Internal, do not use.*/
@module("./utils")
external convertObj: ('a, dict<dict<dict<string>>>, 'b, 'c) => 'd = "traverser"

/**Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store*/
module RecordProxy: {
  /**Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store*/
  type t

  /**
    Copies all fields from a source record to the current record.

    Performs a shallow copy of all field values from the source record to the target record.
    Useful for duplicating record data or applying bulk updates.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Parameters
    - `sourceRecord`: The record to copy fields from

    ## Examples

    ```rescript
    // Copy from newUser to existing user record
    userRecord->RescriptRelay.RecordProxy.copyFieldsFrom(~sourceRecord=newUser)
    ```
  */
  @send
  external copyFieldsFrom: (t, ~sourceRecord: t) => unit = "copyFieldsFrom"

  /**
    Gets the unique identifier for this record.

    Returns the `dataId` that Relay uses to identify this record in the store.
    Every record in Relay has a unique `dataId`.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Examples

    ```rescript
    let userId = userRecord->RescriptRelay.RecordProxy.getDataId
    Console.log("User ID: " ++ RescriptRelay.dataIdToString(userId))
    ```
  */
  @send
  external getDataId: t => dataId = "getDataID"

  /**
    Gets a linked record (object) field.

    Retrieves another record that is linked from this record. Returns `None` if
    the field doesn't exist or is null.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Parameters
    - `name`: The field name to retrieve
    - `arguments`: Optional arguments for parameterized fields

    ## Examples

    ```rescript
    // Get user's profile
    let profile = userRecord->RescriptRelay.RecordProxy.getLinkedRecord(~name="profile")
    
    // Get user's post with specific ID
    let post = userRecord->RescriptRelay.RecordProxy.getLinkedRecord(
      ~name="post",
      ~arguments=RescriptRelay.makeArguments({"id": postId})
    )
    ```
  */
  @send @return(nullable)
  external getLinkedRecord: (t, ~name: string, ~arguments: arguments=?) => option<t> =
    "getLinkedRecord"

  /**Gets an array of linked records, for when a field is a list (meaning a link to multiple records).*/
  let getLinkedRecords: (t, ~name: string, ~arguments: arguments=?) => option<array<option<t>>>

  /**This returns an existing linked record, or creates one at the configured place if one does not already exist.*/
  @send
  external getOrCreateLinkedRecord: (
    t,
    ~name: string,
    ~typeName: string,
    ~arguments: arguments=?,
  ) => t = "getOrCreateLinkedRecord"

  /**Returns the `__typename` of this particular record.*/
  @send
  external getType: t => string = "getType"

  /**Returns a field value, expecting it to be a string.*/
  @send @return(nullable)
  external getValueString: (t, ~name: string, ~arguments: arguments=?) => option<string> =
    "getValue"

  /**Returns a field value, expecting it to be an array of strings.*/
  @send @return(nullable)
  external getValueStringArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<string>>> = "getValue"

  /**Returns a field value, expecting it to be an int.*/
  @send @return(nullable)
  external getValueInt: (t, ~name: string, ~arguments: arguments=?) => option<int> = "getValue"

  /**Returns a field value, expecting it to be an array of ints.*/
  @send @return(nullable)
  external getValueIntArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<int>>> = "getValue"

  /**Returns a field value, expecting it to be a float.*/
  @send @return(nullable)
  external getValueFloat: (t, ~name: string, ~arguments: arguments=?) => option<float> = "getValue"

  /**Returns a field value, expecting it to be an array of floats.*/
  @send @return(nullable)
  external getValueFloatArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<float>>> = "getValue"

  /**Returns a field value, expecting it to be a boolean.*/
  @send @return(nullable)
  external getValueBool: (t, ~name: string, ~arguments: arguments=?) => option<bool> = "getValue"

  /**Returns a field value, expecting it to be an array of booleans.*/
  @send @return(nullable)
  external getValueBoolArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
  ) => option<array<option<bool>>> = "getValue"

  /**
    Sets a linked record for a field.

    Links another record to this record at the specified field. The linked record
    must already exist in the store.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Parameters
    - `record`: The record to link
    - `name`: The field name to set
    - `arguments`: Optional arguments for parameterized fields

    ## Examples

    ```rescript
    // Link a profile to a user
    let _ = userRecord->RescriptRelay.RecordProxy.setLinkedRecord(
      ~record=profileRecord,
      ~name="profile"
    )
    ```
  */
  @send
  external setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?) => t =
    "setLinkedRecord"

  /**
    Sets an array of linked records for a field.

    Links multiple records to this record at the specified field. Use `None` for
    null entries in the array.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Parameters
    - `records`: Array of records to link (with optional null entries)
    - `name`: The field name to set
    - `arguments`: Optional arguments for parameterized fields

    ## Examples

    ```rescript
    // Set user's posts
    let _ = userRecord->RescriptRelay.RecordProxy.setLinkedRecords(
      ~records=[Some(post1), None, Some(post3)],
      ~name="posts"
    )
    ```
  */
  @send
  external setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setLinkedRecords"

  /**Sets a string as field value.*/
  @send
  external setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  /**Sets an array of strings as field value.*/
  @send
  external setValueStringArray: (
    t,
    ~value: array<string>,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Sets an int as field value.*/
  @send
  external setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?) => t = "setValue"

  /**Sets an array of ints as field value.*/
  @send
  external setValueIntArray: (t, ~value: array<int>, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  /**Sets a float as field value.*/
  @send
  external setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  /**Sets an array of floats as field value.*/
  @send
  external setValueFloatArray: (
    t,
    ~value: array<float>,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Sets a boolean as field value.*/
  @send
  external setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?) => t = "setValue"

  /**Sets an array of booleans as field value.*/
  @send
  external setValueBoolArray: (
    t,
    ~value: array<bool>,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Sets the field value to `undefined` (meaning Relay will treat it as missing data).*/
  @send
  external setValueToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Sets the field value to `null`.*/
  @send
  external setValueToNull: (t, @as(json`null`) _, ~name: string, ~arguments: arguments=?) => t =
    "setValue"

  /**Sets this linked record to `undefined` (meaning Relay will treat it as missing data).*/
  @send
  external setLinkedRecordToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Sets this linked record to `null`.*/
  @send
  external setLinkedRecordToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Sets the field holding these linked records to `undefined` (meaning Relay will treat it as missing data).*/
  @send
  external setLinkedRecordsToUndefined: (
    t,
    @as(json`undefined`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Sets the field holding these linked records to `null`.*/
  @send
  external setLinkedRecordsToNull: (
    t,
    @as(json`null`) _,
    ~name: string,
    ~arguments: arguments=?,
  ) => t = "setValue"

  /**Invalidates this record.

Invalidating a record means that the _next_ time Relay evaluates this record, it'll be treated as missing.

_Beware_ that this doesn't mean that queries using this record will refetch immediately. Rather, it'll happen the next time the query _renders_. Have a look at `useSubscribeToInvalidationState`, that'll allow you to subscribe to whenever records are invalidated, if you're looking for a way to refetch immediately as something invalidates.*/
  @send
  external invalidateRecord: t => unit = "invalidateRecord"
}

/**RecordSourceSelectorProxy and RecordSourceProxy are the two modules representing the store, with various capabilities.*/
module RecordSourceSelectorProxy: {
  /**Type type representing a `RecordSourceSelectorProxy`.*/
  type t

  @send
  external batchLiveStateUpdates: (t, unit => unit) => unit = "batchLiveStateUpdates"

  /**
    Creates a new record in the store.

    Creates a new record with the specified ID and type. The record will be empty
    initially - use `RecordProxy` methods to populate its fields.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Parameters
    - `dataId`: Unique identifier for the new record
    - `typeName`: GraphQL type name for the record

    ## Examples

    ```rescript
    // Create optimistic user record
    let newUser = store->RescriptRelay.RecordSourceSelectorProxy.create(
      ~dataId=RescriptRelay.generateUniqueClientID(),
      ~typeName="User"
    )
    
    let _ = newUser->RescriptRelay.RecordProxy.setValueString(~value="John Doe", ~name="name")
    ```
  */
  @send
  external create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t = "create"

  /**
    Deletes a record from the store.

    Removes the record with the specified ID from the store. Any references to
    this record from other records will become null.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Parameters
    - `dataId`: The ID of the record to delete

    ## Examples

    ```rescript
    // Delete a user record
    store->RescriptRelay.RecordSourceSelectorProxy.delete(~dataId=userId)
    ```
  */
  @send
  external delete: (t, ~dataId: dataId) => unit = "delete"

  /**
    Gets a record from the store by ID.

    Retrieves an existing record from the store. Returns `None` if the record
    doesn't exist.

    ⚠️ **Note**: This is a low-level, non-type-safe API. Use with caution and prefer higher-level operations when possible.

    ## Parameters
    - `dataId`: The ID of the record to retrieve

    ## Examples

    ```rescript
    switch store->RescriptRelay.RecordSourceSelectorProxy.get(~dataId=userId) {
    | Some(userRecord) => 
      // Work with the user record
      let _ = userRecord->RescriptRelay.RecordProxy.setValueBool(~value=true, ~name="isActive")
    | None => 
      // Record doesn't exist
      ()
    }
    ```
  */
  @send @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  /**Returns the _root_ `RecordProxy`, meaning the `RecordProxy` holding your top level fields.*/
  @send
  external getRoot: t => RecordProxy.t = "getRoot"

  /**Returns the `RecordProxy` for the `fieldName` at root. You should prefer using `RecordSourceSelectorProxy.getRoot()` and traverse from there if you need access to root fields rather than use this.*/
  @send @return(nullable)
  external getRootField: (t, ~fieldName: string) => option<RecordProxy.t> = "getRootField"

  /**Plural version of `RecordSourceSelectorProxy.getRootField`.*/
  let getPluralRootField: (t, ~fieldName: string) => option<array<option<RecordProxy.t>>>

  /**Invalidates the entire store. This means that _at the next render_, the entire store will be treated as empty, meaning Relay will refetch everything it needs to show the view it's to show.*/
  @send
  external invalidateStore: t => unit = "invalidateStore"

  /**Invalidates each of the provided records by their ID, if they exist. */
  let invalidateRecordsByIds: (t, array<dataId>) => unit
}

/**ReadOnlyRecordSourceProxy is the store, but in read-only mode.*/
module ReadOnlyRecordSourceProxy: {
  /**Type type representing a `ReadOnlyRecordSourceProxy`.*/
  type t

  /**Returns the `RecordProxy` with the provided `dataId`, if it exists.*/
  @send @return(nullable)
  external get: (t, ~dataId: dataId) => option<RecordProxy.t> = "get"

  /**Returns the _root_ `RecordProxy`, meaning the `RecordProxy` holding your top level fields.*/
  @send
  external getRoot: t => RecordProxy.t = "getRoot"
}

/**A missing field handler, which is a way of teaching Relay more about the relations in your schema, so it can fulfill more things from the cache. Read more [in this section of the Relay docs](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/).

Feed a list of missing field handlers into `Environment.make` if you want to use them.*/
module MissingFieldHandler: {
  @tag("kind")
  type rec normalizationArgument =
    | ListValue({name: string, items: array<null<normalizationArgument>>})
    | Literal({name: string, @as("type") type_: nullable<string>, value: JSON.t})
    | ObjectValue({name: string, fields: array<normalizationArgument>})
    | Variable({name: string, @as("type") type_: nullable<string>, variableName: string})

  type normalizationScalarField = {
    alias: nullable<string>,
    name: string,
    args: nullable<array<normalizationArgument>>,
    storageKey: nullable<string>,
  }

  type normalizationLinkedField = {
    alias: nullable<string>,
    name: string,
    storageKey: nullable<string>,
    args: nullable<array<normalizationArgument>>,
    concreteType: nullable<string>,
    plural: bool,
    selections: array<JSON.t>,
  }

  /**A missing field handler, which is a way of teaching Relay more about the relations in your schema, so it can fulfill more things from the cache. Read more [in this section of the Relay docs](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/).*/
  @tag("kind")
  type rec t =
    /** a `MissingFieldHandler.t` for scalar fields. Give this a handler function that returns `null` (to indicate that data exists but is null), `undefined` (to indicate data is still missing), or a scalar value (to indicate that the value exists even though it's not in the cache, and is the value you send back).*/
    | @as("scalar")
    Scalar({
        handle: (
          normalizationScalarField,
          nullable<'record>,
          'args,
          ReadOnlyRecordSourceProxy.t,
        ) => nullable<'scalarValue>,
      }): t
    /** a `MissingFieldHandler.t` for linked fields (other objects/records). Give this a handler function that returns `null` (to indicate that the link exists but the linked record is null), `undefined` (to indicate data is still missing), or a `dataId` of the record that is linked at this field.*/
    | @as("linked")
    Linked({
        handle: (
          normalizationLinkedField,
          nullable<'record>,
          'args,
          ReadOnlyRecordSourceProxy.t,
        ) => nullable<dataId>,
      }): t
    /** a `MissingFieldHandler.t` for lists of linked fields (other objects/records). Give this a handler function that returns `null` (to indicate that the link exists but the linked array of records is null), `undefined` (to indicate data is still missing), or an array of `nullable<dataId>` where the `dataId`'s are the linked records/objects.*/
    | @as("pluralLinked")
    PluralLinked({
        handle: (
          normalizationLinkedField,
          nullable<'record>,
          'args,
          ReadOnlyRecordSourceProxy.t,
        ) => nullable<array<nullable<dataId>>>,
      }): t

  /**Make a `MissingFieldHandler.t` for scalar fields. Give this a handler function that returns `null` (to indicate that data exists but is null), `undefined` (to indicate data is still missing), or a scalar value (to indicate that the value exists even though it's not in the cache, and is the value you send back).*/
  let makeScalarMissingFieldHandler: (
    (
      normalizationScalarField,
      Nullable.t<'record>,
      'args,
      ReadOnlyRecordSourceProxy.t,
    ) => Nullable.t<'scalarValue>
  ) => t

  /**Make a `MissingFieldHandler.t` for linked fields (other objects/records). Give this a handler function that returns `null` (to indicate that the link exists but the linked record is null), `undefined` (to indicate data is still missing), or a `dataId` of the record that is linked at this field.*/
  let makeLinkedMissingFieldHandler: (
    (
      normalizationLinkedField,
      Nullable.t<RecordProxy.t>,
      'args,
      ReadOnlyRecordSourceProxy.t,
    ) => Nullable.t<dataId>
  ) => t

  /**Make a `MissingFieldHandler.t` for lists of linked fields (other objects/records). Give this a handler function that returns `null` (to indicate that the link exists but the linked array of records is null), `undefined` (to indicate data is still missing), or an array of `nullable<dataId>` where the `dataId`'s are the linked records/objects.*/
  let makePluralLinkedMissingFieldHandler: (
    (
      normalizationLinkedField,
      Nullable.t<RecordProxy.t>,
      'args,
      ReadOnlyRecordSourceProxy.t,
    ) => Nullable.t<array<Nullable.t<dataId>>>
  ) => t
}

/**
  Utilities for working with Relay connections.

  Connections are Relay's way of handling paginated lists. These utilities help you
  manipulate connection data in the store, such as adding/removing edges and getting
  connection records.

  Read the [Relay ConnectionHandler docs](https://relay.dev/docs/en/relay-store#connectionhandler) for more details.
*/
module ConnectionHandler: {
  /**
    Gets a connection record from a parent record.

    Retrieves the connection record for a specific connection key and optional filters.
    Returns `None` if the connection doesn't exist.

    ## Parameters
    - `record`: The parent record containing the connection
    - `key`: The connection key (from `@connection(key: "...")`)
    - `filters`: Optional filter arguments used in the connection

    ## Examples

    ```rescript
    // Get user's friends connection
    let friendsConnection = RescriptRelay.ConnectionHandler.getConnection(
      ~record=userRecord,
      ~key=UserFriends_user_graphql.connectionKey,
    )
    ```
  */
  @module("relay-runtime") @scope("ConnectionHandler") @return(nullable)
  external getConnection: (
    ~record: RecordProxy.t,
    ~key: string,
    ~filters: arguments=?,
  ) => option<RecordProxy.t> = "getConnection"

  /**
    Creates an edge record for a connection.

    Creates a new edge that can be inserted into a connection. The edge wraps
    a node and provides cursor information for pagination.

    💡 **Tip**: For most cases, prefer using declarative directives like `@appendNode` or `@prependNode` in your mutations instead of manually managing edges.

    ## Parameters
    - `store`: The store to create the edge in
    - `connection`: The connection this edge belongs to
    - `node`: The node (record) to wrap in this edge
    - `edgeType`: The GraphQL type name for the edge

    ## Examples

    ```rescript
    // Create edge for new friend
    let newEdge = RescriptRelay.ConnectionHandler.createEdge(
      ~store,
      ~connection=friendsConnection,
      ~node=newFriendRecord,
      ~edgeType="UserEdge"
    )
    ```
  */
  @module("relay-runtime") @scope("ConnectionHandler")
  external createEdge: (
    ~store: RecordSourceSelectorProxy.t,
    ~connection: RecordProxy.t,
    ~node: RecordProxy.t,
    ~edgeType: string,
  ) => RecordProxy.t = "createEdge"

  /**
    Inserts an edge before a specific cursor or at the beginning.

    Adds an edge to the connection before the specified cursor position.
    If no cursor is provided, the edge is inserted at the start of the list.

    💡 **Tip**: For most cases, prefer using declarative directives like `@prependEdge` in your mutations instead of manually inserting edges.

    ## Parameters
    - `connection`: The connection to insert into
    - `newEdge`: The edge to insert
    - `cursor`: Optional cursor to insert before

    ## Examples

    ```rescript
    // Insert at beginning
    RescriptRelay.ConnectionHandler.insertEdgeBefore(
      ~connection=friendsConnection,
      ~newEdge=friendEdge
    )
    
    // Insert before specific cursor
    RescriptRelay.ConnectionHandler.insertEdgeBefore(
      ~connection=friendsConnection,
      ~newEdge=friendEdge,
      ~cursor="cursor123"
    )
    ```
  */
  @module("relay-runtime") @scope("ConnectionHandler")
  external insertEdgeBefore: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
  ) => unit = "insertEdgeBefore"

  /**
    Inserts an edge after a specific cursor or at the end.

    Adds an edge to the connection after the specified cursor position.
    If no cursor is provided, the edge is inserted at the end of the list.

    💡 **Tip**: For most cases, prefer using declarative directives like `@appendEdge` in your mutations instead of manually inserting edges.

    ## Parameters
    - `connection`: The connection to insert into
    - `newEdge`: The edge to insert
    - `cursor`: Optional cursor to insert after

    ## Examples

    ```rescript
    // Insert at end
    RescriptRelay.ConnectionHandler.insertEdgeAfter(
      ~connection=friendsConnection,
      ~newEdge=friendEdge
    )
    ```
  */
  @module("relay-runtime") @scope("ConnectionHandler")
  external insertEdgeAfter: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
  ) => unit = "insertEdgeAfter"

  /**
    Removes a node from a connection by its ID.

    Deletes any edge from the connection where the edge's node has the specified ID.
    Note: This only removes the edge, not the actual node record from the store.

    💡 **Tip**: For most cases, prefer using declarative directives like `@deleteEdge` in your mutations instead of manually removing edges.

    ## Parameters
    - `connection`: The connection to remove from
    - `nodeId`: The ID of the node to remove

    ## Examples

    ```rescript
    // Remove friend from connection
    RescriptRelay.ConnectionHandler.deleteNode(
      ~connection=friendsConnection,
      ~nodeId=friendId
    )
    ```
  */
  @module("relay-runtime") @scope("ConnectionHandler")
  external deleteNode: (~connection: RecordProxy.t, ~nodeId: dataId) => unit = "deleteNode"

  /**
    Generates a connection's unique data ID.

    Constructs the internal ID that Relay uses to identify a specific connection
    on a specific parent with specific filters.

    💡 **Tip**: For connections with arguments, the generated fragment module includes a type-safe `getConnectionId` function. For example, `UserPosts_user_graphql.getConnectionId(~status="PUBLISHED")`.

    ## Parameters
    - Parent record's data ID
    - Connection key string
    - Filter arguments object

    ## Examples

    ```rescript
    // Get connection ID for user's filtered posts
    let connectionId = RescriptRelay.ConnectionHandler.getConnectionID(
      userId,
      UserPosts_user_graphql.connectionKey,
      {"status": "PUBLISHED"}
    )
    
    // A type-safe version is also available for each fragment defined. Prefer using that.
    let connectionId = UserPosts_user_graphql.getConnectionId(~status=PUBLISHED)
    ```
  */
  @module("relay-runtime") @scope("ConnectionHandler")
  external getConnectionID: (dataId, string, 'filters) => dataId = "getConnectionID"
}

/**The cache config provided to the network layer. Relay won't do anything in particular with these, it's up to you to use them if you want inside of your `NetworkLayer`.*/
type cacheConfig = {
  force: option<bool>,
  poll: option<int>,
  liveConfigId: option<string>,
  transactionId: option<string>,
}

/**A Relay observable, used throughout Relay for delivering data, in particular when dealing with multiple payloads like with subscriptions or multipart responses like `@stream` or `@defer`.*/
module Observable: {
  /**The type representing the observable.*/
  type t<'response>

  /**This sink can be used to give the observable new data.*/
  type sink<'response> = {
    next: 'response => unit,
    error: JsExn.t => unit,
    complete: unit => unit,
    closed: bool,
  }

  /**A subscription for an observable, allowing you to unsubscribe if wanted.*/
  type subscription = {
    unsubscribe: unit => unit,
    closed: bool,
  }

  /**An observer of the observable.*/
  type observer<'response>

  /**Create an observer.*/
  @obj
  external makeObserver: (
    ~start: subscription => unit=?,
    ~next: 'response => unit=?,
    ~error: JsExn.t => unit=?,
    ~complete: unit => unit=?,
    ~unsubscribe: subscription => unit=?,
  ) => observer<'response> = ""

  /**Create a new observable, getting fed an `Observable.sink` for interacting with the observable, and optionally returning a `Observable.subscription` if you have things you want to unsubscribe from as the observable closes.*/
  @module("relay-runtime") @scope("Observable")
  external make: (sink<'t> => option<subscription>) => t<'t> = "create"

  /**Subscribe to the `Observable.t` using an observer.*/
  @send
  external subscribe: (t<'t>, observer<'t>) => subscription = "subscribe"

  /**Turns an `Observable` into a promise. _Beware_ that reading the response in the resulting promise is currently _not safe_ due to some internals of how ReScript Relay works. This will be resolved in the future.*/
  @send
  external toPromise: t<'t> => promise<'t> = "toPromise"

  /**Ignore this subscription.*/
  external ignoreSubscription: subscription => unit = "%ignore"
}

/**
  Network layer configuration for Relay.

  The network layer defines how Relay makes requests to your GraphQL server.
  You must provide fetch and optionally subscription functions to handle
  queries, mutations, and subscriptions.
*/
module Network: {
  type codesplitsMetadata = (string, unit => unit)

  type operationMetadata = {codesplits?: array<codesplitsMetadata>}

  /**The type representing an instantiated network layer.*/
  type t

  /**
    Information about a GraphQL operation being executed.

    Contains the operation details that your fetch function will receive.
    For persisted queries, `id` exists but `text` is empty. For regular queries,
    `text` contains the query string but `id` is empty.

    ## Fields
    - `id`: Persisted query ID (if using persisted queries)
    - `text`: GraphQL query text (if not using persisted queries)
    - `name`: Operation name
    - `operationKind`: "query", "mutation", or "subscription"
    - `metadata`: Optional operation metadata
  */
  type operation = {
    /** The operation ID. Set if persisted queries are enabled, otherwise not set. */
    id: Nullable.t<string>,
    /** The operation text. Not set for persisted queries, or if this is a client-only query that will not make a network request. */
    text: Nullable.t<string>,
    /** The operation name. */
    name: string,
    /** The operation kind. */
    operationKind: string,
    /** Optional operation metadata. */
    metadata: Nullable.t<operationMetadata>,
  }

  /**
    Function signature for handling GraphQL subscriptions.

    ## Parameters
    - `operation`: The subscription operation details
    - `variables`: JSON variables for the subscription
    - `cacheConfig`: Cache configuration options

    ## Returns
    Observable that emits subscription data over time
  */
  type subscribeFn = (operation, JSON.t, cacheConfig) => Observable.t<JSON.t>

  /**
    Function signature for fetching data using promises.

    ## Parameters
    - `operation`: The operation details
    - `variables`: JSON variables for the operation
    - `cacheConfig`: Cache configuration options
    - `uploadables`: Optional file uploads

    ## Returns
    Promise that resolves to the GraphQL response
  */
  type fetchFunctionPromise = (
    operation,
    JSON.t,
    cacheConfig,
    Nullable.t<uploadables>,
  ) => promise<JSON.t>

  /**
    Function signature for fetching data using observables.

    ## Parameters
    - `operation`: The operation details
    - `variables`: JSON variables for the operation
    - `cacheConfig`: Cache configuration options
    - `uploadables`: Optional file uploads

    ## Returns
    Observable that emits the GraphQL response
  */
  type fetchFunctionObservable = (
    operation,
    JSON.t,
    cacheConfig,
    Nullable.t<uploadables>,
  ) => Observable.t<JSON.t>

  /**
    Creates a network layer using a promise-based fetch function.

    Most common way to create a network layer. Your fetch function should
    make HTTP requests to your GraphQL endpoint and return promises.

    ## Parameters
    - `fetchFunction`: Function that returns promises for GraphQL requests
    - `subscriptionFunction`: Optional function for handling subscriptions
  */
  @module("relay-runtime") @scope("Network")
  external makePromiseBased: (
    ~fetchFunction: fetchFunctionPromise,
    ~subscriptionFunction: subscribeFn=?,
  ) => t = "create"

  /**
    Creates a network layer using an observable-based fetch function.

    Use this when you need more control over the request lifecycle or want to
    handle streaming responses like `@defer` and `@stream`.

    ## Parameters
    - `observableFunction`: Function that returns observables for GraphQL requests
    - `subscriptionFunction`: Optional function for handling subscriptions
  */
  @module("relay-runtime") @scope("Network")
  external makeObservableBased: (
    ~observableFunction: fetchFunctionObservable,
    ~subscriptionFunction: subscribeFn=?,
  ) => t = "create"

  /**
    Preloads resources based on operation response.

    Internal function for resource preloading. Used by Relay's code splitting
    and resource preloading features.
  */
  let preloadResources: (~operation: operation, ~variables: JSON.t, ~response: JSON.t) => unit
}

/**
  The RecordSource - storage for normalized GraphQL records.

  RecordSource is the underlying storage mechanism that holds normalized GraphQL
  records. It can be initialized empty or with existing data for hydration scenarios
  like SSR. The store uses a RecordSource to persist and retrieve cached data.
*/
module RecordSource: {
  /**The type representing a RecordSource instance.*/
  type t

  /**
    Creates a new RecordSource.

    Can be initialized empty or with existing record data for hydration.
    When doing SSR, you'll typically create an empty RecordSource on the server,
    populate it with data, serialize it, and then recreate it on the client.

    ## Parameters
    - `records`: Optional existing records to initialize with

    ## Examples

    ```rescript
    // Create empty RecordSource
    let source = RescriptRelay.RecordSource.make()

    // Create RecordSource with existing data (e.g., from SSR)
    let hydratedSource = RescriptRelay.RecordSource.make(
      ~records=serverSideRecords
    )
    ```
  */
  @module("relay-runtime") @new
  external make: (~records: recordSourceRecords=?) => t = "RecordSource"

  /**
    Serializes the RecordSource to JSON.

    Converts all records in the source to a JSON representation that can be
    transmitted or stored. Commonly used for SSR to send server-side cached
    data to the client.

    ## Returns
    JSON object containing all normalized records

    ## Examples

    ```rescript
    // Serialize for SSR
    let serverRecords = recordSource->RescriptRelay.RecordSource.toJSON
    
    // Send to client or store in localStorage
    let serialized = Js.Json.stringify(serverRecords)
    ```
  */
  @send
  external toJSON: t => recordSourceRecords = "toJSON"
}

/**
  The Relay Store - manages normalized GraphQL data caching.

  The Store handles data normalization, caching, garbage collection, and provides
  interfaces for reading and writing data. It works with a RecordSource to persist
  the actual record data.
*/
module Store: {
  /**The type representing a Relay store instance.*/
  type t

  /**
    Creates a new standard Relay store.

    The store manages normalized data and provides caching with configurable
    garbage collection and TTL settings.

    ## Parameters
    - `source`: RecordSource containing the initial data
    - `gcReleaseBufferSize`: Number of queries to keep cached (default: 10)
    - `queryCacheExpirationTime`: TTL in milliseconds for cached queries (default: no TTL)

    ## Examples

    ```rescript
    let store = RescriptRelay.Store.make(
      ~source=RescriptRelay.RecordSource.make(),
      ~gcReleaseBufferSize=20,  // Keep 20 queries cached
      ~queryCacheExpirationTime=5 * 60 * 1000,  // 5 minute TTL
    )
    ```
  */
  let make: (
    ~source: RecordSource.t,
    ~gcReleaseBufferSize: int=?,
    ~queryCacheExpirationTime: int=?,
  ) => t

  /**
    Creates a new live store with real-time capabilities.

    Similar to the standard store but with enhanced support for live queries
    and real-time data updates. Only needed if you're using Relay Resolvers.

    ℹ️ **Note**: Use this only when you need Relay Resolvers. For most applications, the standard `make` function is sufficient.

    ## Parameters
    - `source`: RecordSource containing the initial data
    - `gcReleaseBufferSize`: Number of queries to keep cached (default: 10)
    - `queryCacheExpirationTime`: TTL in milliseconds for cached queries (default: no TTL)

    ## Examples

    ```rescript
    let liveStore = RescriptRelay.Store.makeLiveStore(
      ~source=RescriptRelay.RecordSource.make(),
      ~gcReleaseBufferSize=15,
    )
    ```
  */
  let makeLiveStore: (
    ~source: RecordSource.t,
    ~gcReleaseBufferSize: int=?,
    ~queryCacheExpirationTime: int=?,
  ) => t

  /**Internal CommonJS version of makeLiveStore. Use `makeLiveStore` instead.*/
  let _makeLiveStoreCjs: (
    ~source: RecordSource.t,
    ~gcReleaseBufferSize: int=?,
    ~queryCacheExpirationTime: int=?,
  ) => t

  /**
    Gets the RecordSource from this store.

    Provides access to the underlying record source for advanced operations
    like serialization or direct record access.

    ## Examples

    ```rescript
    let source = store->RescriptRelay.Store.getSource
    let serialized = source->RescriptRelay.RecordSource.toJSON
    ```
  */
  @send
  external getSource: t => RecordSource.t = "getSource"

  /**
    Publishes new records to the store.

    Merges new record data into the existing store. Particularly useful for
    SSR scenarios where you need to hydrate client-side stores with server data.

    ## Parameters
    - `source`: RecordSource containing new records to publish

    ## Examples

    ```rescript
    // Hydrate client store with server data
    let serverRecords = RescriptRelay.RecordSource.make(~records=serverData)
    store->RescriptRelay.Store.publish(serverRecords)
    ```
  */
  @send
  external publish: (t, RecordSource.t) => unit = "publish"

  /**
    Temporarily disables garbage collection.

    Prevents the store from cleaning up cached data. Useful when you need to
    ensure data persistence during operations like serialization.

    ## Examples

    ```rescript
    // Hold GC during serialization
    store->RescriptRelay.Store.holdGC
    let serialized = store->RescriptRelay.Store.getSource->RescriptRelay.RecordSource.toJSON
    // GC will resume automatically
    ```
  */
  @send
  external holdGC: t => unit = "holdGC"
}

/**Internal, do not use.*/
type operationDescriptor

/**A disposable is something you can use to dispose of something when you don't use/need it anymore.*/
module Disposable: {
  /**The type representing a `Disposable`.*/
  type t

  /**Dispose the `Disposable`.*/
  @send
  external dispose: t => unit = "dispose"

  /**Ignore this disposable.*/
  external ignore: t => unit = "%ignore"
}

/**A required field logger, which gets called when a field annotated with the @required directive was missing from the response*/
module RelayFieldLogger: {
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

  /**A required field logger, which gets called when a field annotated with the @required directive was missing from the response*/
  type t = arg => unit
}

/**
  The Relay Environment - the central hub for Relay operations.

  The Environment coordinates between the network layer, store, and other Relay
  components. It manages data fetching, caching, and normalization. You typically
  create one Environment per application and pass it to Relay components.
*/
module Environment: {
  /**The type representing a Relay environment instance.*/
  type t

  /**
    Creates a new Relay Environment.

    The Environment requires a network layer and store at minimum. Additional
    configuration options allow you to customize caching, error handling,
    and data normalization behavior.

    ## Parameters
    - `network`: Network layer for making GraphQL requests
    - `store`: Store for caching normalized data
    - `getDataID`: Optional custom function for generating record IDs
    - `treatMissingFieldsAsNull`: Whether missing fields should be treated as null
    - `missingFieldHandlers`: Array of handlers for filling in missing data
    - `relayFieldLogger`: Optional logger for field-level events
    - `isServer`: Whether this environment is running on the server

    ## Examples

    ```rescript
    let environment = RescriptRelay.Environment.make(
      ~network=myNetworkLayer,
      ~store=RescriptRelay.Store.make(
        ~source=RescriptRelay.RecordSource.make()
      ),
      ~treatMissingFieldsAsNull=false,
    )
    ```
  */
  let make: (
    ~network: Network.t,
    ~store: Store.t,
    ~getDataID: (
      ~nodeObj: {.."__typename": string, "id": string} as 'a,
      ~typeName: string,
    ) => string=?,
    ~treatMissingFieldsAsNull: bool=?,
    ~missingFieldHandlers: array<MissingFieldHandler.t>=?,
    ~relayFieldLogger: RelayFieldLogger.t=?,
    ~isServer: bool=?,
  ) => t

  /**
    Gets the store instance from this environment.

    Provides access to the underlying store for advanced store operations
    like publishing records or holding garbage collection.

    ## Examples

    ```rescript
    let store = environment->RescriptRelay.Environment.getStore
    store->RescriptRelay.Store.holdGC  // Prevent garbage collection
    ```
  */
  @send
  external getStore: t => Store.t = "getStore"

  /**
    Commits a GraphQL response payload to the store.

    Low-level function for manually committing operation results. Most users
    should use higher-level APIs like queries and mutations instead.

    ## Parameters
    - `operationDescriptor`: The operation that produced this payload
    - `payload`: The GraphQL response data to commit
  */
  @send
  external commitPayload: (t, operationDescriptor, 'payload) => unit = "commitPayload"

  /**
    Retains an operation to prevent garbage collection.

    Keeps the data for an operation in the store by preventing Relay's garbage
    collector from cleaning it up. Returns a disposable that releases the retain
    when disposed.

    Note: Use the generated `Query.retain` functions instead of calling this directly.

    ## Parameters
    - `operationDescriptor`: The operation to retain

    ## Returns
    Disposable that releases the retain when disposed
  */
  @send
  external retain: (t, operationDescriptor) => Disposable.t = "retain"

  /**
    Finds all connection IDs for a specific connection key on a parent record.

    Useful for operations that need to affect all instances of a connection,
    such as when using `@deleteEdge` or bulk connection updates.

    ## Parameters
    - `connectionKey`: The connection key to search for
    - `parentId`: The parent record containing the connections

    ## Returns
    Array of connection data IDs

    ## Examples

    ```rescript
    // Find all friend list connections for a user
    let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
      ~connectionKey=UserFriends_user_graphql.connectionKey,
      ~parentId=userId
    )
    ```
  */
  let findAllConnectionIds: (t, ~connectionKey: string, ~parentId: dataId) => array<dataId>

  /**
  Invalidates all connection configurations of `connectionKey` on `parentId`.

  This function invalidates all cached data for connections with the specified key on the given parent record.
  When connections are invalidated, any queries that depend on this connection data will be considered stale
  and will need to be refetched the next time they are accessed.

  ## Parameters
  - `environment`: The Relay environment
  - `connectionKey`: The connection key used in the `@connection(key: "...")` directive
  - `parentId`: The data ID of the parent record that holds the connection
  - `excludedIds`: Optional array of connection data IDs to exclude from invalidation

  ## Examples

  ### Basic Usage
  ```rescript
  // Invalidate all connections for a user's friends
  environment->RescriptRelay.Environment.invalidateAllOfConnection(
    ~connectionKey=UserProfile_friends_graphql.connectionKey,
    ~parentId=user.__id,
  )
  ```

  ### With Excluded IDs
  ```rescript
  environment->RescriptRelay.Environment.invalidateAllOfConnection(
    ~connectionKey=UserProfile_friends_graphql.connectionKey, 
    ~parentId=user.__id,
    // Invalidate all of this connection except for the currently rendered one.
    ~excludedIds=[currentConnection.__id],
  )
  ```
  */
  let invalidateAllOfConnection: (
    t,
    ~connectionKey: string,
    ~parentId: dataId,
    ~excludedIds: array<dataId>=?,
  ) => unit
}

/**fetchPolicy controls how you want Relay to resolve your data.*/
type fetchPolicy =
  /** will only reuse locally cached data, and will never send a network request to fetch the query. In this case, the responsibility of fetching the query falls to the caller, but this policy could also be used to read and operate on data that is entirely local. */
  | @as("store-only") StoreOnly
  /** (default) will reuse locally cached data, and will only send a network request if any data for the query is missing or stale. If the query is fully cached, a network request will not be made.*/
  | @as("store-or-network") StoreOrNetwork
  /** will reuse locally cached data and will always send a network request, regardless of whether any data was missing or stale in the store. */
  | @as("store-and-network") StoreAndNetwork
  /** will not reuse locally cached data, and will always send a network request to fetch the query, ignoring any data that might be locally cached and whether it's missing or stale. */
  | @as("network-only") NetworkOnly

/**The fetch policies allowed for fetching a query outside of React's render (as in `Query.fetch`).*/
type fetchQueryFetchPolicy =
  /** will not reuse locally cached data, and will always send a network request to fetch the query, ignoring any data that might be locally cached and whether it's missing or stale. */
  | @as("network-only") NetworkOnly
  /** (default) will reuse locally cached data, and will only send a network request if any data for the query is missing or stale. If the query is fully cached, a network request will not be made.*/
  | @as("store-or-network") StoreOrNetwork

/**An error from a mutation.*/
type mutationError = {message: string}

/* React Context moved to RescriptRelayReact */

/**An exception detailing that a mutation failed.*/
exception Mutation_failed(array<mutationError>)

/**
  Commits a local update to the Relay store.

  Performs imperative updates to the store without triggering network requests.
  Use this for client-side only changes like toggling UI state or updating
  local fields that don't need server synchronization.

  ## Parameters
  - `environment`: The Relay environment
  - `updater`: Function that receives the store and performs updates

  ## Examples

  ```rescript
  // Toggle a local UI state
  RescriptRelay.commitLocalUpdate(
    ~environment,
    ~updater=store => {
      let user = store->RescriptRelay.RecordSourceSelectorProxy.get(~dataId=userId)
      switch user {
      | Some(userRecord) => 
        let _ = userRecord->RescriptRelay.RecordProxy.setValueBool(
          ~value=!isExpanded,
          ~name="isExpanded"
        )
      | None => ()
      }
    }
  )
  ```
*/
@module("relay-runtime")
external commitLocalUpdate: (
  ~environment: Environment.t,
  ~updater: RecordSourceSelectorProxy.t => unit,
) => unit = "commitLocalUpdate"

/* React invalidation subscribe moved to RescriptRelayReact */

/**Options valid when fetching a query outside of React's render method (like when using `Query.fetch`).*/
type fetchQueryOptions = {
  networkCacheConfig?: cacheConfig,
  fetchPolicy?: fetchPolicy,
}

/* React loadQuery helpers moved to RescriptRelayReact */
