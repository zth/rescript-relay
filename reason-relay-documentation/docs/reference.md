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


## [renderPolicy](#renderpolicy)
```reason
type renderPolicy = |
```

renderPolicy controls if Relay is allowed to render partially available data or not. 

Relay rendering partial data means it will suspend at the _fragment level_ rather than at the _query level_ if a query does not exist in the cache. This has the implication that if a fragment can be reached because the data for that fragment already exists, Relay can allow that to render while waiting for new data.

## [fetchPolicy](#fetchpolicy)
```reason
type fetchPolicy = |
```

fetchPolicy controls how you want Relay to resolve your data.

## [fetchQueryFetchPolicy](#fetchqueryfetchpolicy)
```reason
type fetchQueryFetchPolicy = |
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

## [allFieldsMasked](#allfieldsmasked)
```reason
type allFieldsMasked
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


## [any](#any)
```reason
type any
```

Abstract helper type to signify something that could not be generated in a type-safe way.

## [queryNode<'node>](#querynodelessnodegreater)
```reason
type queryNode<'node>
```

A query node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.

## [fragmentNode<'node>](#fragmentnodelessnodegreater)
```reason
type fragmentNode<'node>
```

A fragment node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.

## [mutationNode<'node>](#mutationnodelessnodegreater)
```reason
type mutationNode<'node>
```

A mutation node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.

## [subscriptionNode<'node>](#subscriptionnodelessnodegreater)
```reason
type subscriptionNode<'node>
```

A subscription node, used internally by Relay. These are runtime artifacts produced by the Relay compiler.

## [fragmentRefs<'fragments>](#fragmentrefslessfragmentsgreater)
```reason
type fragmentRefs<'fragments>
```

This type shows all of the fragments that has been spread on this particular object.

### Using fragments
Any time you spread a fragment in your GraphQL definition, a _fragment reference_ is created. To get the data for that fragment, you then pass `fragmentRefs` to that particlar component's `Fragment.use` hook. Example:

```reason
// SomeModule.res
module Fragment = %relay(
  fragment SomeModule_user on User {
    id
    ...Avatar_url # This creates a _fragment reference_ on the fragment for `Avatar_user`
  }
)

@react.component
let make = (~user) => {
  let user = Fragment.use(user) // This now has the data for the `SomeModule_user` fragment above.

  /**
   * The line below passes `fragmentRefs` on `user` (this components fragment) to the Avatar component, 
   * which then uses that to retrieve its own fragment data.
   */
  <Avatar user={user.fragmentRefs} />
}
```

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

## [featureFlags](#featureflags)
```reason
type featureFlags
```

Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.
  
### Example
```rescript
// Make sure this runs before Relay is setup.

ReasonRelay.featureFlags.enablePrecisTypeRefinement = true
```

## [recordSourceRecords](#recordsourcerecords)
```reason
type recordSourceRecords
```

An abstract type representing all records in the store serialized to JSON in a way that you can use to re-hydrate the store. 

See `RecordSource.toJSON` for how to produce it.

## [cacheConfig](#cacheconfig)
```reason
type cacheConfig
```

The cache config provided to the network layer. Relay won't do anything in particular with these, it's up to you to use them if you want inside of your `NetworkLayer`.

## [renderPolicy](#renderpolicy)
```reason
type renderPolicy
```

renderPolicy controls if Relay is allowed to render partially available data or not. 

Relay rendering partial data means it will suspend at the _fragment level_ rather than at the _query level_ if a query does not exist in the cache. This has the implication that if a fragment can be reached because the data for that fragment already exists, Relay can allow that to render while waiting for new data.

## [operationDescriptor](#operationdescriptor)
```reason
type operationDescriptor
```

Handle creating and using operation descriptors.

## [fetchPolicy](#fetchpolicy)
```reason
type fetchPolicy
```

fetchPolicy controls how you want Relay to resolve your data.

## [fetchQueryFetchPolicy](#fetchqueryfetchpolicy)
```reason
type fetchQueryFetchPolicy
```

The fetch policies allowed for fetching a query outside of React's render (as in `Query.fetch`).

## [mutationError](#mutationerror)
```reason
type mutationError
```

An error from a mutation.
    
## [generateClientID](#generateclientid)
```reason
let generateClientID: (~dataId: dataId, ~storageKey: string, ~index: int=?, unit) => dataId
```

This generates a [dataId](#dataid)  for use on the _client_ side. However, this is farily low level, and what you're probably really looking for is `generateUniqueClientID` that'll let you generate a new, unique [dataId](#dataid)  that you can use for client side only records (like when doing optimistic updates).

## [isClientID](#isclientid)
```reason
let isClientID: dataId => bool
```

Checks whether the provided [dataId](#dataid)  is guaranteed to be a client side only id.

## [relayFeatureFlags](#relayfeatureflags)
```reason
let relayFeatureFlags: featureFlags
```

Relay feature flags. Mutate this record as soon as your application boots to enable/disable features.

### Example
```rescript
// Make sure this runs before Relay is setup.

ReasonRelay.featureFlags.enablePrecisTypeRefinement = true
```

## [storeRootId](#storerootid)
```reason
let storeRootId: dataId
```

The [dataId](#dataid)  for the Relay store's root. Useful when for example referencing the `parentID` of a connection that's on the store root.

## [dataIdToString](#dataidtostring)
```reason
let dataIdToString: dataId => string
```

Turns a [dataId](#dataid)  into a `string`.

## [makeDataId](#makedataid)
```reason
let makeDataId: string => dataId
```

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

## [makeArguments](#makearguments)
```reason
let makeArguments: {..} => arguments
```

Construct an [arguments](#arguments)  object for use with certain Relay store APIs.

### Usage
Use it like this: `makeArguments({ "someArgument": someValue, "anotherArgument": anotherValue })`. Notice the "" surrounding the property names - these are important and tells ReScript that we want this to be a JS object.

## [makeUploadable](#makeuploadable)
```reason
let makeUploadable: {..} => uploadables
```

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
    
### [RecordProxy.copyFieldsFrom](#recordproxycopyfieldsfrom)
```reason
let copyFieldsFrom: (t, ~sourceRecord: t) => unit
```

Copies all fields from one RecordProxy to another.

### [RecordProxy.getType](#recordproxygettype)
```reason
let getType: t => string
```

Returns the `__typename` of this particular record.

### [RecordProxy.getValueInt](#recordproxygetvalueint)
```reason
let getValueInt: (t, ~name: string, ~arguments: arguments=?, unit) => option<int>
```

Returns a field value, expecting it to be an int.

### [RecordProxy.getValueFloat](#recordproxygetvaluefloat)
```reason
let getValueFloat: (t, ~name: string, ~arguments: arguments=?, unit) => option<float>
```

Returns a field value, expecting it to be a float.

### [RecordProxy.getValueBool](#recordproxygetvaluebool)
```reason
let getValueBool: (t, ~name: string, ~arguments: arguments=?, unit) => option<bool>
```

Returns a field value, expecting it to be a boolean.

### [RecordProxy.setLinkedRecord](#recordproxysetlinkedrecord)
```reason
let setLinkedRecord: (t, ~record: t, ~name: string, ~arguments: arguments=?, unit) => t
```

Sets a [RecordProxy.t](#recordproxyt)  as the linked record for a particular field.

### [RecordProxy.setValueString](#recordproxysetvaluestring)
```reason
let setValueString: (t, ~value: string, ~name: string, ~arguments: arguments=?, unit) => t
```

Sets a string as field value.

### [RecordProxy.setValueInt](#recordproxysetvalueint)
```reason
let setValueInt: (t, ~value: int, ~name: string, ~arguments: arguments=?, unit) => t
```

Sets an int as field value.

### [RecordProxy.setValueFloat](#recordproxysetvaluefloat)
```reason
let setValueFloat: (t, ~value: float, ~name: string, ~arguments: arguments=?, unit) => t
```

Sets a float as field value.

### [RecordProxy.setValueBool](#recordproxysetvaluebool)
```reason
let setValueBool: (t, ~value: bool, ~name: string, ~arguments: arguments=?, unit) => t
```

Sets a boolean as field value.


## RecordSourceSelectorProxy

RecordSourceSelectorProxy and RecordSourceProxy are the two modules representing the store, with various capabilities.


    
### [RecordSourceSelectorProxy.t](#recordsourceselectorproxyt)
```reason
type t
```

Type type representing a [RecordSourceSelectorProxy](#recordsourceselectorproxy) .
    
### [RecordSourceSelectorProxy.getPluralRootField](#recordsourceselectorproxygetpluralrootfield)
```reason
let getPluralRootField: (t, ~fieldName: string)
```

Plural version of `RecordSourceSelectorProxy.getRootField`.

### [RecordSourceSelectorProxy.create](#recordsourceselectorproxycreate)
```reason
let create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t
```

Creates a new [RecordProxy](#recordproxy) .

### [RecordSourceSelectorProxy.getRoot](#recordsourceselectorproxygetroot)
```reason
let getRoot: t => RecordProxy.t
```

Returns the _root_ [RecordProxy](#recordproxy) , meaning the [RecordProxy](#recordproxy)  holding your top level fields.


## ConnectionHandler

Read the Relay docs section on [ConnectionHandler](https://relay.dev/docs/en/relay-store#connectionhandler)


    

    



## Observable

A Relay observable, used throughout Relay for delivering data, in particular when dealing with multiple payloads like with subscriptions or multipart responses like `@stream` or `@defer`.


    
### [Observable.t<'response>](#observabletlessresponsegreater)
```reason
type t<'response>
```

The type representing the observable.

### [Observable.sink<'response>](#observablesinklessresponsegreater)
```reason
type sink<'response>
```

This sink can be used to give the observable new data.

### [Observable.subscription](#observablesubscription)
```reason
type subscription
```

A subscription for an observable, allowing you to unsubscribe if wanted.

### [Observable.observer<'response>](#observableobserverlessresponsegreater)
```reason
type observer<'response>
```

An observer of the observable.
    
### [Observable.subscribe](#observablesubscribe)
```reason
let subscribe: (t<'t>, observer<'t>) => subscription
```

Subscribe to the `Observable.t` using an observer.


## Network

Represents the network layer.

### [Network.subscribeFn](#networksubscribefn)
```reason
type subscribeFn = (operation, Js.Json.t, cacheConfig)
```

The shape of the function Relay expects for creating a subscription.
    
### [Network.t](#networkt)
```reason
type t
```

The type representing an instantiated `NetworkLayer`.

### [Network.operation](#networkoperation)
```reason
type operation
```

The operation fed to the `NetworkLayer` when Relay wants to make a request. Please note that if you're using persisted queries, `id` will exist but `text` won't, and vice versa when not using persisted queries.

### [Network.subscribeFn](#networksubscribefn)
```reason
type subscribeFn
```

The shape of the function Relay expects for creating a subscription.

### [Network.fetchFunctionPromise](#networkfetchfunctionpromise)
```reason
type fetchFunctionPromise
```

The shape of the function responsible for fetching data if you want to return a promise rather than an [Observable](#observable) .

### [Network.fetchFunctionObservable](#networkfetchfunctionobservable)
```reason
type fetchFunctionObservable
```

The shape of the function responsible for fetching data if you want to return an [Observable](#observable) .
    



## RecordSource

RecordSource is the source of records used by the store. Can be initiated with or without prior records; eg. hydrating the store with prior data.


    
### [RecordSource.t](#recordsourcet)
```reason
type t
```

The type representing an instantiated [RecordSource](#recordsource) .
    



## Store

The actual store module, with configuration for the store.


    
### [Store.t](#storet)
```reason
type t
```

The type representing an instantiated [Store](#store) .
    
### [Store.getSource](#storegetsource)
```reason
let getSource: t => RecordSource.t
```

Gets the [RecordSource](#recordsource)  for this [Store](#store) .


## Environment

Module representing the environment, which you'll need to use and pass to various functions. Takes a few configuration options like store and network layer.


    
### [Environment.t](#environmentt)
```reason
type t
```

The type representing an instantiated [Environment](#environment) .
    
### [Environment.getStore](#environmentgetstore)
```reason
let getStore: t => Store.t
```

Get the [Store](#store)  for this [Environment](#environment) .


## Disposable

A disposable is something you can use to dispose of something when you don't use/need it anymore.


    
### [Disposable.t](#disposablet)
```reason
type t
```

The type representing a [Disposable](#disposable) .
    



## Context

Context provider for the Relay environment.


    

    

## Provider

The context provider you wrap your app in and pass your [Environment](#environment)  for Relay to work.


    

    




