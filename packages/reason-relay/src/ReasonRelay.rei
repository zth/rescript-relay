type jsObj('a) = Js.t({..} as 'a);

/**
 * Abstract helper type to signify something that could not be
 * generated in a type-safe way.
 */

type any;

/**
 * The type of the actual node that Relay uses for operations.
 */
type queryNode;
type fragmentNode;
type mutationNode;
type subscriptionNode;

/**
 * Helper to signify a wrapped fragment ref.
 */
type wrappedFragmentRef;

/**
 * The type of the id's Relay uses to identify records.
 */
type dataId;

/**
 * Helpers and types for various IDs.
 */
let dataIdToString: dataId => string;
let makeDataId: string => dataId;

let generateClientID:
  (~dataId: dataId, ~storageKey: string, ~index: int=?, unit) => dataId;

let generateUniqueClientID: unit => dataId;

let isClientID: dataId => bool;

/**
 * An abstract type representing all records in the store serialized to JSON in a way
 * that you can use to re-hydrate the store.
 */
type recordSourceRecords;

/**
 * Constants
 */

/**
 * The `dataId` for the Relay store's root.
 * Useful when for example referencing the `parentID` of a connection that's on the store root.
 * */
let storeRootId: dataId;

/** The `type` for the Relay store's root `RecordProxy`. */
let storeRootType: string;

let _cleanObjectFromUndefined: jsObj('a) => jsObj('a);
let _cleanVariables: 'a => 'a;
let _convertObj: ('a, Js.Dict.t(Js.Dict.t(string)), 'b, 'c) => 'd;

/**
 * Read the following section on working with the Relay store:
 * https://relay.dev/docs/en/relay-store
 */

module RecordProxy: {
  type t;
  type arguments('a) = jsObj('a) constraint 'a = {..};

  type unsetValueType =
    | Null
    | Undefined;

  let copyFieldsFrom: (t, ~sourceRecord: t) => unit;

  let getDataId: t => dataId;

  let getLinkedRecord:
    (t, ~name: string, ~arguments: option(arguments({..}))) => option(t);

  let getLinkedRecords:
    (t, ~name: string, ~arguments: option(arguments({..}))) =>
    option(array(option(t)));

  let getOrCreateLinkedRecord:
    (
      t,
      ~name: string,
      ~typeName: string,
      ~arguments: option(arguments({..}))
    ) =>
    t;

  let getType: t => string;

  let getValueString:
    (t, ~name: string, ~arguments: option(arguments({..}))) => option(string);

  let getValueStringArray:
    (t, ~name: string, ~arguments: option(arguments({..}))) =>
    option(array(option(string)));

  let getValueInt:
    (t, ~name: string, ~arguments: option(arguments({..}))) => option(int);

  let getValueIntArray:
    (t, ~name: string, ~arguments: option(arguments({..}))) =>
    option(array(option(int)));

  let getValueFloat:
    (t, ~name: string, ~arguments: option(arguments({..}))) => option(float);

  let getValueFloatArray:
    (t, ~name: string, ~arguments: option(arguments({..}))) =>
    option(array(option(float)));

  let getValueBool:
    (t, ~name: string, ~arguments: option(arguments({..}))) => option(bool);

  let getValueBoolArray:
    (t, ~name: string, ~arguments: option(arguments({..}))) =>
    option(array(option(bool)));

  let setLinkedRecord:
    (t, ~record: t, ~name: string, ~arguments: option(arguments({..}))) => t;

  let setLinkedRecords:
    (
      t,
      ~records: array(option(t)),
      ~name: string,
      ~arguments: option(arguments({..}))
    ) =>
    t;

  let setValueString:
    (t, ~value: string, ~name: string, ~arguments: option(arguments({..}))) =>
    t;

  let setValueStringArray:
    (
      t,
      ~value: array(string),
      ~name: string,
      ~arguments: option(arguments({..}))
    ) =>
    t;

  let setValueInt:
    (t, ~value: int, ~name: string, ~arguments: option(arguments({..}))) => t;

  let setValueIntArray:
    (
      t,
      ~value: array(int),
      ~name: string,
      ~arguments: option(arguments({..}))
    ) =>
    t;

  let setValueFloat:
    (t, ~value: float, ~name: string, ~arguments: option(arguments({..}))) =>
    t;

  let setValueFloatArray:
    (
      t,
      ~value: array(float),
      ~name: string,
      ~arguments: option(arguments({..}))
    ) =>
    t;

  let setValueBool:
    (t, ~value: bool, ~name: string, ~arguments: option(arguments({..}))) => t;

  let setValueBoolArray:
    (
      t,
      ~value: array(bool),
      ~name: string,
      ~arguments: option(arguments({..}))
    ) =>
    t;

  let unsetValue:
    (
      t,
      ~name: string,
      ~arguments: option(arguments({..})),
      ~unsetValue: unsetValueType
    ) =>
    t;

  let unsetLinkedRecord:
    (
      t,
      ~name: string,
      ~arguments: option(arguments({..})),
      ~unsetValue: unsetValueType
    ) =>
    t;

  let unsetLinkedRecords:
    (
      t,
      ~name: string,
      ~arguments: option(arguments({..})),
      ~unsetValue: unsetValueType
    ) =>
    t;
};

/**
 * RecordSourceSelectorProxy and RecordSourceProxy are the two
 * modules representing the store, with various capabilities.
 */
module RecordSourceSelectorProxy: {
  type t;

  let create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t;

  let delete: (t, ~dataId: dataId) => unit;

  let get: (t, ~dataId: dataId) => option(RecordProxy.t);

  let getRoot: t => RecordProxy.t;

  let getRootField: (t, ~fieldName: string) => option(RecordProxy.t);

  let getPluralRootField:
    (t, ~fieldName: string) => option(array(option(RecordProxy.t)));
};

module RecordSourceProxy: {
  type t;

  let create: (t, ~dataId: dataId, ~typeName: string) => RecordProxy.t;

  let delete: (t, ~dataId: dataId) => unit;

  let get: (t, ~dataId: dataId) => option(RecordProxy.t);

  let getRoot: t => RecordProxy.t;
};

/**
 * https://relay.dev/docs/en/relay-store#connectionhandler
 */
module ConnectionHandler: {
  type filters('a) = jsObj('a) constraint 'a = {..};

  let getConnection:
    (~record: RecordProxy.t, ~key: string, ~filters: option({..})) =>
    option(RecordProxy.t);

  let createEdge:
    (
      ~store: RecordSourceSelectorProxy.t,
      ~connection: RecordProxy.t,
      ~node: RecordProxy.t,
      ~edgeType: string
    ) =>
    RecordProxy.t;

  let insertEdgeBefore:
    (
      ~connection: RecordProxy.t,
      ~newEdge: RecordProxy.t,
      ~cursor: option(string)
    ) =>
    unit;

  let insertEdgeAfter:
    (
      ~connection: RecordProxy.t,
      ~newEdge: RecordProxy.t,
      ~cursor: option(string)
    ) =>
    unit;

  let deleteNode: (~connection: RecordProxy.t, ~nodeId: dataId) => unit;
};

/**
 * NETWORK
 */

type cacheConfig = {
  force: option(bool),
  poll: option(int),
  liveConfigId: option(string),
  transactionId: option(string),
};

/**
 * A Relay observable, used for subscriptions and a few other things.
 */
module Observable: {
  type t;

  type sink('t) = {
    next: 't => unit,
    error: Js.Exn.t => unit,
    completed: unit => unit,
    closed: bool,
  };

  let make: (sink('t) => unit) => t;
};

/**
 * Represents the network layer.
 */
module Network: {
  type t;

  type operation = {
    text: string,
    name: string,
    operationKind: string,
  };

  type subscribeFnConfig = {
    request: operation,
    variables: Js.Json.t,
    cacheConfig,
  };

  type subscribeFn = subscribeFnConfig => Observable.t;

  type fetchFunctionPromise =
    (operation, Js.Json.t, cacheConfig) => Js.Promise.t(Js.Json.t);

  type fetchFunctionObservable =
    (operation, Js.Json.t, cacheConfig) => Observable.t;

  let makePromiseBased:
    (
      ~fetchFunction: fetchFunctionPromise,
      ~subscriptionFunction: subscribeFn=?,
      unit
    ) =>
    t;

  let makeObservableBased:
    (
      ~observableFunction: fetchFunctionObservable,
      ~subscriptionFunction: subscribeFn=?,
      unit
    ) =>
    t;
};

/**
 * RecordSource is the source of records used by the store.
 * Can be initiated with or without prior records; eg. hydrating
 * the store with prior data.
 */

module RecordSource: {
  type t;
  let make: (~records: recordSourceRecords=?, unit) => t;
  let toJSON: t => recordSourceRecords;
};

/**
 * The actual store module, with configuration for the store.
 */
module Store: {
  type t;
  let make: (~source: RecordSource.t, ~gcReleaseBufferSize: int=?, unit) => t;
  let getSource: t => RecordSource.t;
};

/**
 * Module representing the environment, which you'll need to use and
 * pass to various functions. Takes a few configuration options like store
 * and network layer.
 */
module Environment: {
  type t;

  let make:
    (
      ~network: Network.t,
      ~store: Store.t,
      ~getDataID: (
                    ~nodeObj: {
                                ..
                                "__typename": string,
                                "id": string,
                              } as 'a,
                    ~typeName: string
                  ) =>
                  string
                    =?,
      unit
    ) =>
    t;

  let getStore: t => Store.t;
};

/**
 * Disposable is a module you'll get back when issuing requests.
 * Disposable allow you to dispose of the request when/if you don't need
 * it anymore.
 */
module Disposable: {
  type t;
  let dispose: t => unit;
};

/**
 * fetchPolicy controls how you want Relay to resolve your data.
 */
type fetchPolicy =
  | StoreOnly // Resolve only from the store
  | StoreOrNetwork // Resolve from the store if all data is there, otherwise make a network request
  | StoreAndNetwork // Like StoreOrNetwork, but always make a request regardless of if the data was there initially or not
  | NetworkOnly; // Always make a request, discard what's in the store

/**
 * Internally used functors and configs.
 * You won't need to know about these.
 */
module type MakeUseQueryConfig = {
  type responseRaw;
  type response;
  type variables;
  let query: queryNode;
  let convertResponse: responseRaw => response;
  let convertVariables: variables => variables;
};

module MakeUseQuery:
  (C: MakeUseQueryConfig) =>
   {
    type preloadToken;

    let use:
      (
        ~variables: C.variables,
        ~fetchPolicy: fetchPolicy=?,
        ~fetchKey: string=?,
        ~networkCacheConfig: cacheConfig=?,
        unit
      ) =>
      C.response;

    let fetch:
      (~environment: Environment.t, ~variables: C.variables) =>
      Js.Promise.t(C.response);

    let preload:
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~fetchPolicy: fetchPolicy=?,
        ~fetchKey: string=?,
        ~networkCacheConfig: cacheConfig=?,
        unit
      ) =>
      preloadToken;

    let usePreloaded: preloadToken => C.response;
  };

/**
 * FRAGMENT
 */

module type MakeUseFragmentConfig = {
  type fragmentRaw;
  type fragment;
  type fragmentRef;
  let fragmentSpec: fragmentNode;
  let convertFragment: fragmentRaw => fragment;
};

module MakeUseFragment:
  (C: MakeUseFragmentConfig) => {let use: C.fragmentRef => C.fragment;};

/** Refetchable */
type refetchFn('variables) =
  (
    ~variables: 'variables,
    ~fetchPolicy: fetchPolicy=?,
    ~onComplete: option(Js.Exn.t) => unit=?,
    unit
  ) =>
  unit;

module type MakeUseRefetchableFragmentConfig = {
  type fragmentRaw;
  type fragment;
  type variables;
  type fragmentRef;
  let fragmentSpec: fragmentNode;
  let convertFragment: fragmentRaw => fragment;
  let convertVariables: variables => variables;
};

module MakeUseRefetchableFragment:
  (C: MakeUseRefetchableFragmentConfig) =>
   {
    let useRefetchable:
      C.fragmentRef => (C.fragment, refetchFn(C.variables));
  };

/** Pagination */
module type MakeUsePaginationFragmentConfig = {
  type fragmentRaw;
  type fragment;
  type variables;
  type fragmentRef;
  let fragmentSpec: fragmentNode;
  let convertFragment: fragmentRaw => fragment;
  let convertVariables: variables => variables;
};

type paginationLoadMoreFn =
  (~count: int, ~onComplete: option(Js.Exn.t) => unit=?, unit) => Disposable.t;

type paginationBlockingFragmentReturn('fragmentData, 'variables) = {
  data: 'fragmentData,
  loadNext: paginationLoadMoreFn,
  loadPrevious: paginationLoadMoreFn,
  hasNext: bool,
  hasPrevious: bool,
  refetch: refetchFn('variables),
};

type paginationFragmentReturn('fragmentData, 'variables) = {
  data: 'fragmentData,
  loadNext: paginationLoadMoreFn,
  loadPrevious: paginationLoadMoreFn,
  hasNext: bool,
  hasPrevious: bool,
  isLoadingNext: bool,
  isLoadingPrevious: bool,
  refetch: refetchFn('variables),
};

module MakeUsePaginationFragment:
  (C: MakeUsePaginationFragmentConfig) =>
   {
    let useBlockingPagination:
      C.fragmentRef =>
      paginationBlockingFragmentReturn(C.fragment, C.variables);

    let usePagination:
      C.fragmentRef => paginationFragmentReturn(C.fragment, C.variables);
  };

/**
 * MUTATION
 */

module type MutationConfig = {
  type variables;
  type responseRaw;
  type response;
  let node: mutationNode;
  let convertResponse: responseRaw => response;
  let wrapResponse: response => responseRaw;
  let convertVariables: variables => variables;
};

type updaterFn('response) = (RecordSourceSelectorProxy.t, 'response) => unit;
type optimisticUpdaterFn = RecordSourceSelectorProxy.t => unit;

type mutationError = {message: string};

type mutationResult('response) =
  | Success('response)
  | Error(Js.Promise.error);

type useMutationConfigType('variables) = {variables: 'variables};

module MakeUseMutation: (C: MutationConfig) => {};

/**
 * Context provider for the Relay environment.
 */
module Context: {
  type t;
  type contextShape = {. "environment": Environment.t};
  let context: React.Context.t(option(contextShape));

  module Provider: {
    let makeProps:
      (
        ~environment: Environment.t,
        ~children: 'children,
        ~key: string=?,
        unit
      ) =>
      {
        .
        "children": 'children,
        "environment": Environment.t,
      };
    let make:
      {
        .
        "children": React.element,
        "environment": Environment.t,
      } =>
      React.element;
  };
};

exception EnvironmentNotFoundInContext;

/**
 * Hook for getting the current environment from context.
 */
let useEnvironmentFromContext: unit => Environment.t;

exception Mutation_failed(array(mutationError));

module MakeCommitMutation:
  (C: MutationConfig) =>
   {
    let commitMutation:
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~optimisticUpdater: optimisticUpdaterFn=?,
        ~optimisticResponse: C.response=?,
        ~updater: (RecordSourceSelectorProxy.t, C.response) => unit=?,
        unit
      ) =>
      Js.Promise.t(Js.Json.t);
  };

/**
 * A way of committing a local update to the store.
 */
let commitLocalUpdate:
  (
    ~environment: Environment.t,
    ~updater: RecordSourceSelectorProxy.t => unit
  ) =>
  unit;

/**
 * fetchQuery is used internally only.
 */
let fetchQuery:
  (Environment.t, queryNode, 'variables) => Js.Promise.t('response);

/**
 * SUBSCRIPTIONS
 */
module type SubscriptionConfig = {
  type variables;
  type responseRaw;
  type response;
  let node: subscriptionNode;
  let convertResponse: responseRaw => response;
  let convertVariables: variables => variables;
};

module MakeUseSubscription:
  (C: SubscriptionConfig) =>
   {
    let subscribe:
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~onCompleted: unit => unit=?,
        ~onError: Js.Exn.t => unit=?,
        ~onNext: C.response => unit=?,
        ~updater: updaterFn(C.response)=?,
        unit
      ) =>
      Disposable.t;
  };