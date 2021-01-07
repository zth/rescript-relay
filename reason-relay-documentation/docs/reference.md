---
  id: reference
  title: Reference
  sidebar_label: Reference
---

# Types, values and functions
## [allFieldsMasked](#allfieldsmasked)
```reason
type allFieldsMasked = {.}
```

If you see this, it means that all fields have been masked in this selection, which is why it contains no data. Relay uses [_data masking_](https://relay.dev/docs/en/thinking-in-relay.html#data-masking) to hide data you haven't explicitly asked for, even if it exists on the object.

### Were you expecting to see something here?
In most cases when you see this but expected to see actual data, you've spread one or more fragments into a mutation and forgot to add `@raw_response_type` to your mutation, like:

```graphql
mutation SomeMutation($input: SomeMutationInput!) @raw_response_type {
  ...
}
```

`@raw_response_type` ([documented here](https://relay.dev/docs/en/a-guided-tour-of-relay#optimistic-updates)) will make sure that you get access to _all_ the data when making optimistic updates.


## [featureFlags](#featureflags)
```reason
type featureFlags = {
  mutable enableVariableConnectionKey: bool,
  mutable enablePartialRenderingDefault: bool,
  mutable enableRelayContainersSuspense: bool,
  mutable enablePrecisTypeRefinement: bool,
}
```

Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.
  
### Example
```reason
/* Make sure this runs before Relay is setup. */

ReasonRelay.featureFlags.enablePrecisTypeRefinement = true
```

## [cacheConfig](#cacheconfig)
```reason
type cacheConfig = {
  force: option<bool>,
  poll: option<int>,
  liveConfigId: option<string>,
  transactionId: option<string>,
}
```

The cache config provided to the network layer. Relay won't do anything in particular with these, it's up to you to use them if you want inside of your `NetworkLayer`.

## [renderPolicy](#renderpolicy)
```reason
type renderPolicy = 
  | Full
  /* Allow rendering any fragments that already have the data needed */
  | Partial
```

renderPolicy controls if Relay is allowed to render partially available data or not. 

Relay rendering partial data means it will suspend at the _fragment level_ rather than at the _query level_ if a query does not exist in the cache. This has the implication that if a fragment can be reached because the data for that fragment already exists, Relay can allow that to render while waiting for new data.

## [fetchPolicy](#fetchpolicy)
```reason
type fetchPolicy = 
  | StoreOnly /* Resolve only from the store */
  | StoreOrNetwork /* Resolve from the store if all data is there, otherwise make a network request */
  | StoreAndNetwork /* Like StoreOrNetwork, but always make a request regardless of if the data was there initially or not */
  | NetworkOnly
```

fetchPolicy controls how you want Relay to resolve your data.

## [fetchQueryFetchPolicy](#fetchqueryfetchpolicy)
```reason
type fetchQueryFetchPolicy = 
  | NetworkOnly
  | StoreOrNetwork
```

The fetch policies allowed for fetching a query outside of React's render (as in `Query.fetch`).

## [mutationError](#mutationerror)
```reason
type mutationError = {message: string}
```

An error from a mutation.
    
## [arguments](#arguments)
```reason
type arguments
```

Abstract type for arguments, used when selecting fields on [RecordProxy](#recordproxy)  and friends when interacting with the store imperatively.

### Using [arguments](#arguments)  to access fields on [RecordProxy](#recordproxy) 
_(note that this example is for [RecordProxy](#recordproxy) , but it applies to any primitive in the store that takes arguments for fields)_


## [uploadables](#uploadables)
```reason
type uploadables
```

Abstract type for uploadables.

### Constructing an [uploadables](#uploadables) 
Use [makeUploadable](#makeuploadable) : `makeUploadable({ "someFile": theFileYouWantToUpload })` to construct an [uploadables](#uploadables) , and then pass it to your mutation via the [uploadables](#uploadables)  prop.

Please note that you'll need to handle _sending_ the uploadables to your server yourself in the network layer. [Here's an example](https://github.com/facebook/relay/issues/1844#issuecomment-316893590) in regular JS that you can adapt to ReScript as you need/want.

## [any](#any)
```reason
type any
```

Abstract helper type to signify something that could not be generated in a type-safe way.

## [dataId](#dataid)
```reason
type dataId
```

The type of the id Relay uses to identify records in its store.

### Getting [dataId](#dataid) 's
You can get the dataId of anything by selecting `__id` in your query/fragment/mutation/subscription, like this:
```graphql
fragment Avatar_user on User {
  __id # This is the data id
  firstName
  lastName
}
```

If you have globally unique IDs in your graph, `__id` will always be the same as the regular `id`. However, as `id` is commonly modelled as a `string`, selecting `__id` will conveniently give you a [dataId](#dataid)  directly that you can use to interact with the store.

### Converting between `string` and [dataId](#dataid) 
You'll often want to convert between `string` and [dataId](#dataid) . You can do this by using [makeDataId](#makedataid)  (`ReasonRelay.makeDataId(yourStringHere`) and [dataIdToString](#dataidtostring)  (`ReasonRelay.dataIdToString(yourDataIdHere)`).

## [recordSourceRecords](#recordsourcerecords)
```reason
type recordSourceRecords
```

An abstract type representing all records in the store serialized to JSON in a way that you can use to re-hydrate the store. 

See [RecordSource.toJSON](#recordsourcetojson)  for how to produce it.
    
## [dataIdToString](#dataidtostring)
```reason
let dataIdToString: dataId => string
```
> Read more about: [dataId](#dataid)

Turns a [dataId](#dataid)  into a `string`.

## [makeArguments](#makearguments)
```reason
let makeArguments: {..} => arguments
```
> Read more about: [arguments](#arguments)

Construct an [arguments](#arguments)  object for use with certain Relay store APIs.

### Usage
Use it like this: `makeArguments({ "someArgument": someValue, "anotherArgument": anotherValue })`. Notice the "" surrounding the property names - these are important and tells ReScript that we want this to be a JS object.

## [generateClientID](#generateclientid)
```reason
let generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?, unit) => dataId
```
> Read more about: [dataId](#dataid)

Construct an [uploadables](#uploadables)  object that you can use for uploads via Relay.

### Usage
Use it like this: `makeUploadable({ "someFile": someFile, "anotherFile": anotherFile })`. Notice the "" surrounding the property names - these are important and tells ReScript that we want this to be a JS object.

## [generateUniqueClientID](#generateuniqueclientid)
```reason
let generateUniqueClientID: unit => dataId
```
> Read more about: [dataId](#dataid)

This generates a unique [dataId](#dataid)  that's safe to use on the _client_ side. Useful when doing optimistic updates and you need to create IDs that the optimistic update can use.

## [isClientID](#isclientid)
```reason
let isClientID: dataId => bool
```
> Read more about: [dataId](#dataid)

Checks whether the provided [dataId](#dataid)  is guaranteed to be a client side only id.

## [relayFeatureFlags](#relayfeatureflags)
```reason
let relayFeatureFlags: featureFlags
```
> Read more about: [featureFlags](#featureflags)

Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.
  
### Example
```reason
/* Make sure this runs before Relay is setup. */

ReasonRelay.featureFlags.enablePrecisTypeRefinement = true
```

## [storeRootId](#storerootid)
```reason
let storeRootId: dataId
```
> Read more about: [dataId](#dataid)

An abstract type representing all records in the store serialized to JSON in a way that you can use to re-hydrate the store. 

See [RecordSource.toJSON](#recordsourcetojson)  for how to produce it.

## [storeRootType](#storeroottype)
```reason
let storeRootType: string
```

The `type` for the Relay store's root [RecordProxy](#recordproxy) .

## [makeDataId](#makedataid)
```reason
let makeDataId: string => dataId
```
> Read more about: [dataId](#dataid)

Turns a `string` into a [dataId](#dataid) .

### Example
```reason
module User = %relay(`
  fragment SomeModule_user on User {
    id
  }
`)

@react.component
let make = (~user) => {
  let user = Fragment.use(user)

  /* This converts `user.id` to a [dataId](#dataid) , letting you use it to interact with the store. */
  let idAsDataId = ReasonRelay.makeDataId(user.id)
}
```

## [makeUploadable](#makeuploadable)
```reason
let makeUploadable: {..} => uploadables
```
> Read more about: [uploadables](#uploadables)

Construct an [uploadables](#uploadables)  object that you can use for uploads via Relay.

### Usage
Use it like this: `makeUploadable({ "someFile": someFile, "anotherFile": anotherFile })`. Notice the "" surrounding the property names - these are important and tells ReScript that we want this to be a JS object.
## RecordProxy

Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store


    
### [RecordProxy.t](#recordproxyt)
```reason
type t
```

Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store
    
### [RecordProxy.getLinkedRecords](#recordproxygetlinkedrecords)
```reason
let getLinkedRecords: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<t>>>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Gets an array of linked records, for when a field is a list (meaning a link to multiple records).

### [RecordProxy.copyFieldsFrom](#recordproxycopyfieldsfrom)
```reason
let copyFieldsFrom: (t, ~sourceRecord: t) => unit
```
> Read more about: [RecordProxy.t](#recordproxyt)

Read the following section on working with the Relay store: https://relay.dev/docs/en/relay-store

### [RecordProxy.getDataId](#recordproxygetdataid)
```reason
let getDataId: t => dataId
```
> Read more about: [RecordProxy.t](#recordproxyt), [dataId](#dataid)

Gets the \`dataId\` for a particular record.

### [RecordProxy.getLinkedRecord](#recordproxygetlinkedrecord)
```reason
let getLinkedRecord: (t, ~name: string, ~arguments: arguments=?, unit) => option<t>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Gets a single linked record. A linked record is another object in the store, and not a scalar field like an int or float.

### [RecordProxy.getOrCreateLinkedRecord](#recordproxygetorcreatelinkedrecord)
```reason
let getOrCreateLinkedRecord: (
    t,
    ~name: string,
    ~typeName: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Gets an array of linked records, for when a field is a list (meaning a link to multiple records).

### [RecordProxy.getType](#recordproxygettype)
```reason
let getType: t => string
```
> Read more about: [RecordProxy.t](#recordproxyt)

Returns the `__typename` of this particular record.

### [RecordProxy.getValueString](#recordproxygetvaluestring)
```reason
let getValueString: (t, ~name: string, ~arguments: arguments=?, unit) => option<string>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be a string.

### [RecordProxy.getValueStringArray](#recordproxygetvaluestringarray)
```reason
let getValueStringArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<string>>>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be an array of strings.

### [RecordProxy.getValueInt](#recordproxygetvalueint)
```reason
let getValueInt: (t, ~name: string, ~arguments: arguments=?, unit) => option<int>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be an int.

### [RecordProxy.getValueIntArray](#recordproxygetvalueintarray)
```reason
let getValueIntArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<int>>>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be an array of ints.

### [RecordProxy.getValueFloat](#recordproxygetvaluefloat)
```reason
let getValueFloat: (t, ~name: string, ~arguments: arguments=?, unit) => option<float>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be a float.

### [RecordProxy.getValueFloatArray](#recordproxygetvaluefloatarray)
```reason
let getValueFloatArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<float>>>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be an array of floats.

### [RecordProxy.getValueBool](#recordproxygetvaluebool)
```reason
let getValueBool: (t, ~name: string, ~arguments: arguments=?, unit) => option<bool>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be a boolean.

### [RecordProxy.getValueBoolArray](#recordproxygetvalueboolarray)
```reason
let getValueBoolArray: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => option<array<option<bool>>>
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Returns a field value, expecting it to be an array of booleans.

### [RecordProxy.setLinkedRecord](#recordproxysetlinkedrecord)
```reason
let setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?, unit) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets a [RecordProxy.t](#recordproxyt)  as the linked record for a particular field.

### [RecordProxy.setLinkedRecords](#recordproxysetlinkedrecords)
```reason
let setLinkedRecords: (
    t,
    ~records: array<option<t>>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets an array of [RecordProxy.t](#recordproxyt)  as the linked records for a particular field.

### [RecordProxy.setValueString](#recordproxysetvaluestring)
```reason
let setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?, unit) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets a string as field value.

### [RecordProxy.setValueStringArray](#recordproxysetvaluestringarray)
```reason
let setValueStringArray: (
    t,
    ~value: array<string>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets an array of strings as field value.

### [RecordProxy.setValueInt](#recordproxysetvalueint)
```reason
let setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?, unit) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets an int as field value.

### [RecordProxy.setValueIntArray](#recordproxysetvalueintarray)
```reason
let setValueIntArray: (
    t,
    ~value: array<int>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets an array of ints as field value.

### [RecordProxy.setValueFloat](#recordproxysetvaluefloat)
```reason
let setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?, unit) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets a float as field value.

### [RecordProxy.setValueFloatArray](#recordproxysetvaluefloatarray)
```reason
let setValueFloatArray: (
    t,
    ~value: array<float>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets an array of floats as field value.

### [RecordProxy.setValueBool](#recordproxysetvaluebool)
```reason
let setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?, unit) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets a boolean as field value.

### [RecordProxy.setValueBoolArray](#recordproxysetvalueboolarray)
```reason
let setValueBoolArray: (
    t,
    ~value: array<bool>,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets an array of booleans as field value.

### [RecordProxy.setValueToUndefined](#recordproxysetvaluetoundefined)
```reason
let setValueToUndefined: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets the field value to `undefined` (meaning Relay will treat it as missing data).

### [RecordProxy.setValueToNull](#recordproxysetvaluetonull)
```reason
let setValueToNull: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets the field value to `null`.

### [RecordProxy.setLinkedRecordToUndefined](#recordproxysetlinkedrecordtoundefined)
```reason
let setLinkedRecordToUndefined: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets this linked record to `undefined` (meaning Relay will treat it as missing data).

### [RecordProxy.setLinkedRecordToNull](#recordproxysetlinkedrecordtonull)
```reason
let setLinkedRecordToNull: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets this linked record to `null`.

### [RecordProxy.setLinkedRecordsToUndefined](#recordproxysetlinkedrecordstoundefined)
```reason
let setLinkedRecordsToUndefined: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets the field holding these linked records to `undefined` (meaning Relay will treat it as missing data).

### [RecordProxy.setLinkedRecordsToNull](#recordproxysetlinkedrecordstonull)
```reason
let setLinkedRecordsToNull: (
    t,
    ~name: string,
    ~arguments: arguments=?,
    unit,
  ) => t
```
> Read more about: [RecordProxy.t](#recordproxyt), [arguments](#arguments)

Sets the field holding these linked records to `null`.

### [RecordProxy.invalidateRecord](#recordproxyinvalidaterecord)
```reason
let invalidateRecord: t => unit
```
> Read more about: [RecordProxy.t](#recordproxyt)

Invalidates this record.

Invalidating a record means that the _next_ time Relay evaluates this record, it'll be treated as missing.

_Beware_ that this doesn't mean that queries using this record will refetch immediately. Rather, it'll happen the next time the query _renders_. Have a look at `useSubscribeToInvalidationState`, that'll allow you to subscribe to whenever records are invalidated, if you're looking for a way to refetch immediately as something invalidates.


## RecordSourceSelectorProxy

RecordSourceSelectorProxy and RecordSourceProxy are the two modules representing the store, with various capabilities.


    
### [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt)
```reason
type t
```

Type type representing a [RecordSourceSelectorProxy](#recordsourceselectorproxy) .
    
### [RecordSourceSelectorProxy.getPluralRootField](#recordsourceselectorproxygetpluralrootfield)
```reason
let getPluralRootField: (t, ~fieldName: string) => option<array<option<RecordProxy.t>>>
```
> Read more about: [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt)

Plural version of [RecordSourceSelectorProxy.getRootField](#recordsourceselectorproxygetrootfield) .

### [RecordSourceSelectorProxy.create](#recordsourceselectorproxycreate)
```reason
let create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t
```
> Read more about: [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt), [dataId](#dataid), [RecordProxy](#recordproxy), [RecordProxy.t](#recordproxyt)

Type type representing a [RecordSourceSelectorProxy](#recordsourceselectorproxy) .

### [RecordSourceSelectorProxy.delete](#recordsourceselectorproxydelete)
```reason
let delete: (t, ~dataId: dataId) => unit
```
> Read more about: [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt), [dataId](#dataid)

Deletes the [RecordProxy](#recordproxy)  with the provided [dataId](#dataid) .

### [RecordSourceSelectorProxy.get](#recordsourceselectorproxyget)
```reason
let get: (t, ~dataId: dataId) => option<RecordProxy.t>
```
> Read more about: [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt), [dataId](#dataid)

Returns the [RecordProxy](#recordproxy)  with the provided [dataId](#dataid) , if it exists.

### [RecordSourceSelectorProxy.getRoot](#recordsourceselectorproxygetroot)
```reason
let getRoot: t => RecordProxy.t
```
> Read more about: [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt), [RecordProxy](#recordproxy), [RecordProxy.t](#recordproxyt)

Returns the _root_ [RecordProxy](#recordproxy) , meaning the [RecordProxy](#recordproxy)  holding your top level fields.

### [RecordSourceSelectorProxy.getRootField](#recordsourceselectorproxygetrootfield)
```reason
let getRootField: (t, ~fieldName: string) => option<RecordProxy.t>
```
> Read more about: [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt)

Returns the [RecordProxy](#recordproxy)  for the `fieldName` at root. You should prefer using `RecordSourceSelectorProxy.getRoot()` and traverse from there if you need access to root fields rather than use this.

### [RecordSourceSelectorProxy.invalidateStore](#recordsourceselectorproxyinvalidatestore)
```reason
let invalidateStore: t => unit
```
> Read more about: [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt)

Plural version of [RecordSourceSelectorProxy.getRootField](#recordsourceselectorproxygetrootfield) .


## ConnectionHandler

Read the Relay docs section on [ConnectionHandler](https://relay.dev/docs/en/relay-store#connectionhandler)


    

    
### [ConnectionHandler.getConnection](#connectionhandlergetconnection)
```reason
let getConnection: (
    ~record: RecordProxy.t,
    ~key: string,
    ~filters: arguments=?,
    unit,
  ) => option<RecordProxy.t>
```
> Read more about: [arguments](#arguments), [RecordProxy](#recordproxy), [RecordProxy.t](#recordproxyt)

For a [RecordProxy](#recordproxy) , returns the [RecordProxy](#recordproxy)  that is at the connection config provided.

### [ConnectionHandler.createEdge](#connectionhandlercreateedge)
```reason
let createEdge: (
    ~store: RecordSourceSelectorProxy.t,
    ~connection: RecordProxy.t,
    ~node: RecordProxy.t,
    ~edgeType: string,
  ) => RecordProxy.t
```
> Read more about: [RecordProxy](#recordproxy), [RecordProxy.t](#recordproxyt), [RecordSourceSelectorProxy](#recordsourceselectorproxy), [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt), [RecordSource](#recordsource)

Creates an edge for a particular connection.

### [ConnectionHandler.insertEdgeBefore](#connectionhandlerinsertedgebefore)
```reason
let insertEdgeBefore: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit
```
> Read more about: [RecordProxy](#recordproxy), [RecordProxy.t](#recordproxyt)

Inserts an edge into a connection _before_ the provided cursor. If no cursor is provided, it inserts the edge at the start of the connection list.

### [ConnectionHandler.insertEdgeAfter](#connectionhandlerinsertedgeafter)
```reason
let insertEdgeAfter: (
    ~connection: RecordProxy.t,
    ~newEdge: RecordProxy.t,
    ~cursor: string=?,
    unit,
  ) => unit
```
> Read more about: [RecordProxy](#recordproxy), [RecordProxy.t](#recordproxyt)

Inserts an edge into a connection _after_ the provided cursor. If no cursor is provided, it inserts the edge at the end of the connection list.

### [ConnectionHandler.deleteNode](#connectionhandlerdeletenode)
```reason
let deleteNode: (~connection: RecordProxy.t, ~nodeId: dataId) => unit
```
> Read more about: [dataId](#dataid), [RecordProxy](#recordproxy), [RecordProxy.t](#recordproxyt)

Deletes any edge from the connection where the node of the edge has the provided [dataId](#dataid) . Please not that this _will not_ remove the actual node from the store. Use [RecordSourceSelectorProxy.delete](#recordsourceselectorproxydelete)  for that.


## Observable

A Relay observable, used throughout Relay for delivering data, in particular when dealing with multiple payloads like with subscriptions or multipart responses like `@stream` or `@defer`.

### [Observable.subscription](#observablesubscription)
```reason
type subscription = {
    unsubscribe: unit => unit,
    closed: bool,
  }
```

A subscription for an observable, allowing you to unsubscribe if wanted.
    

    
### [Observable.makeObserver](#observablemakeobserver)
```reason
let makeObserver: (
    ~start: subscription => unit=?,
    ~next: 'response => unit=?,
    ~error: Js.Exn.t => unit=?,
    ~complete: unit => unit=?,
    ~unsubscribe: subscription => unit=?,
    unit,
  ) => observer<'response>
```
> Read more about: [Observable.subscription](#observablesubscription)

The type representing the observable.

### [Observable.make](#observablemake)
```reason
let make: (sink<'t> => option<subscription>) => t<'t>
```

Create a new observable, getting fed an `Observable.sink` for interacting with the observable, and optionally returning a [Observable.subscription](#observablesubscription)  if you have things you want to unsubscribe from as the observable closes.

### [Observable.subscribe](#observablesubscribe)
```reason
let subscribe: (t<'t>, observer<'t>) => subscription
```
> Read more about: [Observable.subscription](#observablesubscription)

Subscribe to the `Observable.t` using an observer.

### [Observable.toPromise](#observabletopromise)
```reason
let toPromise: t<'t> => Promise.t<'t>
```

Turns an [Observable](#observable)  into a promise. _Beware_ that reading the response in the resulting promise is currently _not safe_ due to some internals of how ReScript Relay works. This will be resolved in the future.


## Network

Represents the network layer.

### [Network.operation](#networkoperation)
```reason
type operation = {
    id: string,
    text: string,
    name: string,
    operationKind: string,
  }
```

The operation fed to the `NetworkLayer` when Relay wants to make a request. Please note that if you're using persisted queries, `id` will exist but `text` won't, and vice versa when not using persisted queries.

### [Network.subscribeFn](#networksubscribefn)
```reason
type subscribeFn = (operation, Js.Json.t, cacheConfig) => Observable.t<Js.Json.t>
```
> Read more about: [Observable](#observable)

The shape of the function Relay expects for creating a subscription.

### [Network.fetchFunctionPromise](#networkfetchfunctionpromise)
```reason
type fetchFunctionPromise = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Js.Promise.t<Js.Json.t>
```

The shape of the function responsible for fetching data if you want to return a promise rather than an [Observable](#observable) .

### [Network.fetchFunctionObservable](#networkfetchfunctionobservable)
```reason
type fetchFunctionObservable = (
    operation,
    Js.Json.t,
    cacheConfig,
    Js.Nullable.t<uploadables>,
  ) => Observable.t<Js.Json.t>
```
> Read more about: [Observable](#observable)

The shape of the function responsible for fetching data if you want to return an [Observable](#observable) .
    
### [Network.t](#networkt)
```reason
type t
```

The type representing an instantiated `NetworkLayer`.
    
### [Network.makePromiseBased](#networkmakepromisebased)
```reason
let makePromiseBased: (
    ~fetchFunction: fetchFunctionPromise,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t
```
> Read more about: [Network.subscribeFn](#networksubscribefn), [Network.fetchFunctionPromise](#networkfetchfunctionpromise), [Network.t](#networkt)

The type representing an instantiated `NetworkLayer`.

### [Network.makeObservableBased](#networkmakeobservablebased)
```reason
let makeObservableBased: (
    ~observableFunction: fetchFunctionObservable,
    ~subscriptionFunction: subscribeFn=?,
    unit,
  ) => t
```
> Read more about: [Network.subscribeFn](#networksubscribefn), [Network.fetchFunctionObservable](#networkfetchfunctionobservable), [Network.t](#networkt)

Create a new `NetworkLayer` using a fetch function that returns an [Observable](#observable) .


## RecordSource

RecordSource is the source of records used by the store. Can be initiated with or without prior records; eg. hydrating the store with prior data.


    
### [RecordSource.t](#recordsourcet)
```reason
type t
```

The type representing an instantiated [RecordSource](#recordsource) .
    
### [RecordSource.make](#recordsourcemake)
```reason
let make: (~records: recordSourceRecords=?, unit) => t
```
> Read more about: [recordSourceRecords](#recordsourcerecords), [RecordSource.t](#recordsourcet)

The type representing an instantiated [RecordSource](#recordsource) .

### [RecordSource.toJSON](#recordsourcetojson)
```reason
let toJSON: t => recordSourceRecords
```
> Read more about: [RecordSource.t](#recordsourcet), [recordSourceRecords](#recordsourcerecords)

Serializes the [RecordSource](#recordsource)  into [recordSourceRecords](#recordsourcerecords)  that you can use to rehydrate another store. Typically used for SSR.


## Store

The actual store module, with configuration for the store.


    
### [Store.t](#storet)
```reason
type t
```

The type representing an instantiated [Store](#store) .
    
### [Store.make](#storemake)
```reason
let make: (
    ~source: RecordSource.t,
    ~gcReleaseBufferSize: /* `gcReleaseBufferSize` controls how many queries are allowed to be cached by default. Increase this to increase the size of the cache. */
    int=?,
    ~queryCacheExpirationTime: int /* `queryCacheExpirationTime` sets a TTL (time to live) for all queries. If that time passes, the data is considered stale and is evicted from the store. Default is no TTL. */=?,
    unit,
  ) => t
```
> Read more about: [RecordSource](#recordsource), [RecordSource.t](#recordsourcet), [Store.t](#storet)

Creates a new [Store](#store) .

### [Store.getSource](#storegetsource)
```reason
let getSource: t => RecordSource.t
```
> Read more about: [Store.t](#storet), [RecordSource](#recordsource), [RecordSource.t](#recordsourcet)

The type representing an instantiated [Store](#store) .

### [Store.publish](#storepublish)
```reason
let publish: (t, RecordSource.t) => unit
```
> Read more about: [Store.t](#storet)

Publishes _new_ records to this store. This is useful in particular with frameworks like Next.js where routes could preload data needed and then serialize that (using [RecordSource.toJSON](#recordsourcetojson) ) and send it over the wire, but you already have a store instantiated client side. This will then allow you to publish those records into your existing store.

### Pseudo-example
```reason
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
```


## Environment

Module representing the environment, which you'll need to use and pass to various functions. Takes a few configuration options like store and network layer.


    
### [Environment.t](#environmentt)
```reason
type t
```

The type representing an instantiated [Environment](#environment) .
    
### [Environment.make](#environmentmake)
```reason
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
```
> Read more about: [renderPolicy](#renderpolicy), [Network](#network), [Network.t](#networkt), [Store](#store), [Store.t](#storet), [Environment.t](#environmentt)

Create a new [Environment](#environment) .

### [Environment.getStore](#environmentgetstore)
```reason
let getStore: t => Store.t
```
> Read more about: [Environment.t](#environmentt), [Store](#store), [Store.t](#storet)

The type representing an instantiated [Environment](#environment) .

### [Environment.commitPayload](#environmentcommitpayload)
```reason
let commitPayload: (t, operationDescriptor, 'payload) => unit
```
> Read more about: [Environment.t](#environmentt)

Given an `operationDescriptor`, commits the corresponding payload.


## Disposable

A disposable is something you can use to dispose of something when you don't use/need it anymore.


    
### [Disposable.t](#disposablet)
```reason
type t
```

The type representing a [Disposable](#disposable) .
    
### [Disposable.dispose](#disposabledispose)
```reason
let dispose: t => unit
```
> Read more about: [Disposable.t](#disposablet)

The type representing a [Disposable](#disposable) .


## Context

Context provider for the Relay environment.

### [Context.contextShape](#contextcontextshape)
```reason
type contextShape = {"environment": Environment.t}
```
> Read more about: [Environment](#environment), [Environment.t](#environmentt)

The expected shape of the context.
    
### [Context.t](#contextt)
```reason
type t
```

Type representing the context.
    
### [Context.context](#contextcontext)
```reason
let context: React.Context.t<option<contextShape>>
```

Type representing the context.
## Provider

The context provider you wrap your app in and pass your [Environment](#environment)  for Relay to work.


    

    




