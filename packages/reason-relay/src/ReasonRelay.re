let toOpt = Js.Nullable.toOption;
type jsObj('a) = Js.t({..} as 'a);

type any;

type queryNode;
type fragmentNode;
type mutationNode;
type subscriptionNode;

type wrappedFragmentRef;

type dataId;

type recordSourceRecords;

external _dataIdToString: dataId => string = "%identity";
let dataIdToString = dataId => _dataIdToString(dataId);

external _makeDataId: string => dataId = "%identity";
let makeDataId = string => _makeDataId(string);

[@bs.module "relay-runtime"]
external _generateClientID: (dataId, string, option(int)) => dataId =
  "generateClientID";

let generateClientID = (~dataId, ~storageKey, ~index=?, ()) =>
  _generateClientID(dataId, storageKey, index);

[@bs.module "relay-runtime"]
external generateUniqueClientID: unit => dataId = "generateUniqueClientID";

[@bs.module "relay-runtime"]
external isClientID: dataId => bool = "isClientID";
/**
 * Various helpers.
 */

// We occasionally have to remove undefined keys from objects, something I haven't figured out how to do with pure BuckleScript
let _cleanObjectFromUndefined = [%bs.raw
  {|
  function cleanObj(obj) {
    var newObj = {};

    Object.keys(obj).forEach(function(key) {
      if (typeof obj[key] !== 'undefined') {
        newObj[key] = obj[key];
      }
    });

    return newObj;
  }
|}
];

// Since BS compiles unit to 0, we have to convert that to an empty object when dealing with variables in order for Relay to be happy
let _cleanVariables = [%bs.raw
  {|
  function cleanVariables(variables) {
    if (typeof variables !== "object" || variables == null) {
      return {};
    }

    return variables;
  }
|}
];

[@bs.module "./utils"]
external _convertObj:
  ('a, Js.Dict.t(Js.Dict.t(Js.Dict.t(string))), 'b, 'c) => 'd =
  "traverser";

[@bs.module "relay-runtime"] external storeRootId: dataId = "ROOT_ID";
[@bs.module "relay-runtime"] external storeRootType: string = "ROOT_TYPE";

module RecordProxy = {
  type t;
  type arguments('a) = jsObj('a);

  type unsetValueType =
    | Null
    | Undefined;

  [@bs.send] external _copyFieldsFrom: (t, t) => unit = "copyFieldsFrom";
  let copyFieldsFrom = (t, ~sourceRecord: t) =>
    _copyFieldsFrom(t, sourceRecord);

  [@bs.send] external _getDataID: t => dataId = "getDataID";
  let getDataId = t => _getDataID(t);

  [@bs.send]
  external _getLinkedRecord:
    (t, string, option(arguments('a))) => Js.Nullable.t(t) =
    "getLinkedRecord";

  let getLinkedRecord = (t, ~name, ~arguments): option(t) =>
    _getLinkedRecord(t, name, arguments) |> toOpt;

  [@bs.send]
  external _getLinkedRecords:
    (t, string, option(arguments('a))) =>
    Js.Nullable.t(array(Js.Nullable.t(t))) =
    "getLinkedRecords";

  let getLinkedRecords = (t, ~name, ~arguments): option(array(option(t))) =>
    switch (_getLinkedRecords(t, name, arguments) |> toOpt) {
    | Some(records) => Some(records |> Array.map(v => v |> toOpt))
    | None => None
    };

  [@bs.send]
  external _getOrCreateLinkedRecord:
    (t, string, string, option(arguments('a))) => t =
    "getOrCreateLinkedRecord";

  let getOrCreateLinkedRecord = (t, ~name, ~typeName, ~arguments) =>
    _getOrCreateLinkedRecord(t, name, typeName, arguments);

  [@bs.send] external _getType: t => string = "getType";
  let getType = t => _getType(t);

  [@bs.send]
  external _getValue:
    (t, string, option(arguments('a))) => Js.Nullable.t('value) =
    "getValue";

  let _getValueArr = (t, ~name, ~arguments) =>
    switch (_getValue(t, name, arguments) |> toOpt) {
    | Some(arr) =>
      Some(arr |> Array.map(value => value |> Js.Nullable.toOption))
    | None => None
    };

  let getValueString = (t, ~name, ~arguments): option(string) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueStringArray =
      (t, ~name, ~arguments): option(array(option(string))) =>
    _getValueArr(~name, ~arguments, t);

  let getValueInt = (t, ~name, ~arguments): option(int) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueIntArray = (t, ~name, ~arguments): option(array(option(int))) =>
    _getValueArr(~name, ~arguments, t);

  let getValueFloat = (t, ~name, ~arguments): option(float) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueFloatArray =
      (t, ~name, ~arguments): option(array(option(float))) =>
    _getValueArr(~name, ~arguments, t);

  let getValueBool = (t, ~name, ~arguments): option(bool) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueBoolArray =
      (t, ~name, ~arguments): option(array(option(bool))) =>
    _getValueArr(~name, ~arguments, t);

  [@bs.send]
  external _setLinkedRecord: (t, t, string, option(arguments('a))) => t =
    "setLinkedRecord";
  let setLinkedRecord = (t, ~record, ~name, ~arguments) =>
    _setLinkedRecord(t, record, name, arguments);

  [@bs.send]
  external _unsetLinkedRecord:
    (t, 'nullable, string, option(arguments('a))) => t =
    "setLinkedRecord";
  let unsetLinkedRecord = (t, ~name, ~arguments, ~unsetValue) =>
    switch (unsetValue) {
    | Null => _unsetLinkedRecord(t, Js.null, name, arguments)
    | Undefined => _unsetLinkedRecord(t, Js.undefined, name, arguments)
    };

  [@bs.send]
  external _setLinkedRecords:
    (t, array(option(t)), string, option(arguments('a))) => t =
    "setLinkedRecords";
  let setLinkedRecords = (t, ~records, ~name, ~arguments) =>
    _setLinkedRecords(t, records, name, arguments);

  [@bs.send]
  external _unsetLinkedRecords:
    (t, 'nullable, string, option(arguments('a))) => t =
    "setLinkedRecords";
  let unsetLinkedRecords = (t, ~name, ~arguments, ~unsetValue) =>
    switch (unsetValue) {
    | Null => _unsetLinkedRecords(t, Js.null, name, arguments)
    | Undefined => _unsetLinkedRecords(t, Js.undefined, name, arguments)
    };

  [@bs.send]
  external _setValue: (t, 'value, string, option(arguments('a))) => t =
    "setValue";

  [@bs.send]
  external _unsetValue: (t, 'nullable, string, option(arguments('a))) => t =
    "setValue";
  let unsetValue = (t, ~name, ~arguments, ~unsetValue) =>
    switch (unsetValue) {
    | Null => _unsetValue(t, Js.null, name, arguments)
    | Undefined => _unsetValue(t, Js.undefined, name, arguments)
    };

  let setValueString = (t, ~value: string, ~name, ~arguments) =>
    _setValue(t, value, name, arguments);

  let setValueStringArray = (t, ~value: array(string), ~name, ~arguments) =>
    _setValue(t, value, name, arguments);

  let setValueInt = (t, ~value: int, ~name, ~arguments) =>
    _setValue(t, value, name, arguments);

  let setValueIntArray = (t, ~value: array(int), ~name, ~arguments) =>
    _setValue(t, value, name, arguments);

  let setValueFloat = (t, ~value: float, ~name, ~arguments) =>
    _setValue(t, value, name, arguments);

  let setValueFloatArray = (t, ~value: array(float), ~name, ~arguments) =>
    _setValue(t, value, name, arguments);

  let setValueBool = (t, ~value: bool, ~name, ~arguments) =>
    _setValue(t, value, name, arguments);

  let setValueBoolArray = (t, ~value: array(bool), ~name, ~arguments) =>
    _setValue(t, value, name, arguments);
};

module RecordSourceSelectorProxy = {
  type t;

  [@bs.send] external _create: (t, dataId, string) => RecordProxy.t = "create";
  let create = (t, ~dataId, ~typeName: string) =>
    _create(t, dataId, typeName);

  [@bs.send] external _delete: (t, dataId) => unit = "delete";
  let delete = (t, ~dataId) => _delete(t, dataId);

  [@bs.send]
  external _get: (t, dataId) => Js.Nullable.t(RecordProxy.t) = "get";
  let get = (t, ~dataId): option(RecordProxy.t) => _get(t, dataId) |> toOpt;

  [@bs.send] external getRoot: t => RecordProxy.t = "getRoot";

  [@bs.send]
  external _getRootField: (t, string) => Js.Nullable.t(RecordProxy.t) =
    "getRootField";
  let getRootField = (t, ~fieldName): option(RecordProxy.t) =>
    _getRootField(t, fieldName) |> toOpt;

  [@bs.send]
  external _getPluralRootField:
    (t, string) => Js.Nullable.t(array(Js.Nullable.t(RecordProxy.t))) =
    "getPluralRootField";

  let getPluralRootField =
      (t, ~fieldName): option(array(option(RecordProxy.t))) =>
    switch (_getPluralRootField(t, fieldName) |> toOpt) {
    | Some(arr) => Some(arr |> Array.map(v => v |> toOpt))
    | None => None
    };
};

module RecordSourceProxy = {
  type t;

  [@bs.send] external _create: (t, dataId, string) => RecordProxy.t = "create";
  let create = (t, ~dataId, ~typeName: string) =>
    _create(t, dataId, typeName);

  [@bs.send] external _delete: (t, dataId) => unit = "delete";
  let delete = (t, ~dataId) => _delete(t, dataId);

  [@bs.send]
  external _get: (t, dataId) => Js.Nullable.t(RecordProxy.t) = "get";
  let get = (t, ~dataId): option(RecordProxy.t) => _get(t, dataId) |> toOpt;

  [@bs.send] external getRoot: t => RecordProxy.t = "getRoot";
};

module ConnectionHandler = {
  type t;

  type filters('a) = jsObj('a);

  [@bs.module "relay-runtime"]
  external connectionHandler: t = "ConnectionHandler";

  [@bs.send]
  external _getConnection:
    (t, RecordProxy.t, string, option({..})) => Js.Nullable.t(RecordProxy.t) =
    "getConnection";

  let getConnection = (~record, ~key, ~filters) =>
    _getConnection(connectionHandler, record, key, filters)
    |> Js.Nullable.toOption;

  [@bs.send]
  external _createEdge:
    (t, RecordSourceSelectorProxy.t, RecordProxy.t, RecordProxy.t, string) =>
    RecordProxy.t =
    "createEdge";

  let createEdge = (~store, ~connection, ~node, ~edgeType) =>
    _createEdge(connectionHandler, store, connection, node, edgeType);

  [@bs.send]
  external _insertEdgeBefore:
    (t, RecordProxy.t, RecordProxy.t, option(string)) => unit =
    "insertEdgeBefore";

  let insertEdgeBefore = (~connection, ~newEdge, ~cursor) =>
    _insertEdgeBefore(connectionHandler, connection, newEdge, cursor);

  [@bs.send]
  external _insertEdgeAfter:
    (t, RecordProxy.t, RecordProxy.t, option(string)) => unit =
    "insertEdgeAfter";

  let insertEdgeAfter = (~connection, ~newEdge, ~cursor) =>
    _insertEdgeAfter(connectionHandler, connection, newEdge, cursor);

  [@bs.send]
  external _deleteNode: (t, RecordProxy.t, dataId) => unit = "deleteNode";

  let deleteNode = (~connection, ~nodeId) =>
    _deleteNode(connectionHandler, connection, nodeId);
};

/**
 * QUERY
 */
module Disposable = {
  type t;

  [@bs.send] external dispose: t => unit = "dispose";
};

type cacheConfig = {
  force: option(bool),
  poll: option(int),
  liveConfigId: option(string),
  transactionId: option(string),
};

/**
 * Misc
 */
module Observable = {
  type t;

  type sink('t) = {
    next: 't => unit,
    error: Js.Exn.t => unit,
    completed: unit => unit,
    closed: bool,
  };

  [@bs.module "relay-runtime"] [@bs.scope "Observable"]
  external create: (sink('t) => option('a)) => t = "create";

  let make = sinkFn =>
    create(s => {
      sinkFn({
        next: s.next,
        error: s.error,
        completed: s.completed,
        closed: s.closed,
      });
      None;
    });
};

module Network = {
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

  [@bs.module "relay-runtime"] [@bs.scope "Network"]
  external makeFromPromise: (fetchFunctionPromise, option(subscribeFn)) => t =
    "create";

  let makePromiseBased = (~fetchFunction, ~subscriptionFunction=?, ()) =>
    makeFromPromise(fetchFunction, subscriptionFunction);

  [@bs.module "relay-runtime"] [@bs.scope "Network"]
  external makeFromObservable:
    (fetchFunctionObservable, option(subscribeFn)) => t =
    "create";

  let makeObservableBased = (~observableFunction, ~subscriptionFunction=?, ()) =>
    makeFromObservable(observableFunction, subscriptionFunction);
};

module RecordSource = {
  type t;

  [@bs.module "relay-runtime"] [@bs.new]
  external _make: option(recordSourceRecords) => t = "RecordSource";

  let make = (~records=?, ()) => _make(records);

  [@bs.send] external toJSON: t => recordSourceRecords = "toJSON";
};

module Store = {
  type t;

  type storeConfig = {gcReleaseBufferSize: option(int)};

  [@bs.module "relay-runtime"] [@bs.new]
  external _make: (RecordSource.t, storeConfig) => t = "Store";

  let make = (~source, ~gcReleaseBufferSize=?, ()) =>
    _make(source, {gcReleaseBufferSize: gcReleaseBufferSize});

  [@bs.send] external getSource: t => RecordSource.t = "getSource";
};

module Environment = {
  type t;

  type environmentConfig('a) = {
    network: Network.t,
    store: Store.t,
    [@bs.as "UNSTABLE_DO_NOT_USE_getDataID"]
    getDataID: option(('a, string) => string),
  };

  [@bs.module "relay-runtime"] [@bs.new]
  external _make: environmentConfig('a) => t = "Environment";

  let make = (~network, ~store, ~getDataID=?, ()) =>
    _make({
      network,
      store,
      getDataID:
        switch (getDataID) {
        | Some(getDataID) =>
          Some((nodeObj, typeName) => getDataID(~nodeObj, ~typeName))
        | None => None
        },
    });

  [@bs.send] external getStore: t => Store.t = "getStore";
};

module Context = {
  type t;

  type contextShape = {. "environment": Environment.t};

  [@bs.module "react-relay"]
  external context: React.Context.t(option(contextShape)) =
    "ReactRelayContext";
  let provider = React.Context.provider(context);

  module Provider = {
    [@react.component]
    let make = (~environment: Environment.t, ~children) =>
      React.createElement(
        provider,
        {"value": Some({"environment": environment}), "children": children},
      );
  };
};

let useConvertedValue = (convert, v) =>
  React.useMemo1(() => convert(v), [|v|]);

exception EnvironmentNotFoundInContext;

let useEnvironmentFromContext = () => {
  let context = React.useContext(Context.context);

  switch (context) {
  | Some(ctx) => ctx##environment
  | None => raise(EnvironmentNotFoundInContext)
  };
};

type fetchPolicy =
  | StoreOnly
  | StoreOrNetwork
  | StoreAndNetwork
  | NetworkOnly;

let mapFetchPolicy = fetchPolicy =>
  switch (fetchPolicy) {
  | Some(StoreOnly) => Some("store-only")
  | Some(StoreOrNetwork) => Some("store-or-network")
  | Some(StoreAndNetwork) => Some("store-and-network")
  | Some(NetworkOnly) => Some("network-only")
  | None => None
  };

[@bs.module "relay-runtime"]
external fetchQuery:
  (Environment.t, queryNode, 'variables) => Js.Promise.t('response) =
  "fetchQuery";

type useQueryConfig = {
  fetchKey: option(string),
  fetchPolicy: option(string),
  networkCacheConfig: option(cacheConfig),
};

[@bs.module "react-relay/hooks"]
external _useQuery: (queryNode, 'variables, useQueryConfig) => 'queryResponse =
  "useLazyLoadQuery";

[@bs.module "react-relay/hooks"]
external _preloadQuery:
  (Environment.t, queryNode, 'variables, useQueryConfig) => 'queryResponse =
  "preloadQuery";

[@bs.module "react-relay/hooks"]
external _usePreloadedQuery: (queryNode, 'token) => 'queryResponse =
  "usePreloadedQuery";

module type MakeUseQueryConfig = {
  type responseRaw;
  type response;
  type variables;
  let query: queryNode;
  let convertResponse: responseRaw => response;
  let convertVariables: variables => variables;
};

module MakeUseQuery = (C: MakeUseQueryConfig) => {
  type preloadToken;

  let use =
      (~variables, ~fetchPolicy=?, ~fetchKey=?, ~networkCacheConfig=?, ())
      : C.response => {
    let data =
      _useQuery(
        C.query,
        variables
        |> _cleanVariables
        |> C.convertVariables
        |> _cleanObjectFromUndefined,
        {
          fetchKey,
          fetchPolicy: fetchPolicy |> mapFetchPolicy,
          networkCacheConfig,
        },
      );

    useConvertedValue(C.convertResponse, data);
  };

  let preload:
    (
      ~environment: Environment.t,
      ~variables: C.variables,
      ~fetchPolicy: fetchPolicy=?,
      ~fetchKey: string=?,
      ~networkCacheConfig: cacheConfig=?,
      unit
    ) =>
    preloadToken =
    (
      ~environment,
      ~variables,
      ~fetchPolicy=?,
      ~fetchKey=?,
      ~networkCacheConfig=?,
      (),
    ) =>
      _preloadQuery(
        environment,
        C.query,
        variables |> C.convertVariables |> _cleanVariables,
        {
          fetchKey,
          fetchPolicy: fetchPolicy |> mapFetchPolicy,
          networkCacheConfig,
        },
      );

  let usePreloaded = (token: preloadToken) => {
    let data = _usePreloadedQuery(C.query, token);
    data |> useConvertedValue(C.convertResponse);
  };

  let fetch =
      (~environment: Environment.t, ~variables: C.variables)
      : Js.Promise.t(C.response) =>
    fetchQuery(environment, C.query, variables |> C.convertVariables)
    |> Js.Promise.then_(res => res |> C.convertResponse |> Js.Promise.resolve);
};

/**
 * FRAGMENT
 */
[@bs.module "react-relay/hooks"]
external _useFragment: (fragmentNode, 'fragmentRef) => 'fragmentData =
  "useFragment";

module type MakeUseFragmentConfig = {
  type fragmentRaw;
  type fragment;
  type fragmentRef;
  let fragmentSpec: fragmentNode;
  let convertFragment: fragmentRaw => fragment;
};

module MakeUseFragment = (C: MakeUseFragmentConfig) => {
  let use = (fr: C.fragmentRef): C.fragment => {
    let data = _useFragment(C.fragmentSpec, fr);
    useConvertedValue(C.convertFragment, data);
  };
};

/** Refetchable */
type refetchFn('variables) =
  (
    ~variables: 'variables,
    ~fetchPolicy: fetchPolicy=?,
    ~onComplete: option(Js.Exn.t) => unit=?,
    unit
  ) =>
  unit;

type refetchFnRaw('variables) =
  (
    'variables,
    {
      .
      "fetchPolicy": option(string),
      "onComplete": option(Js.Nullable.t(Js.Exn.t) => unit),
    }
  ) =>
  unit;

let makeRefetchableFnOpts = (~fetchPolicy, ~onComplete) => {
  "fetchPolicy": fetchPolicy |> mapFetchPolicy,
  "onComplete":
    Some(
      maybeExn =>
        switch (onComplete, maybeExn |> Js.Nullable.toOption) {
        | (Some(onComplete), maybeExn) => onComplete(maybeExn)
        | _ => ()
        },
    ),
};

[@bs.module "react-relay/hooks"]
external _useRefetchableFragment:
  (fragmentNode, 'fragmentRef) => ('fragmentData, refetchFnRaw('variables)) =
  "useRefetchableFragment";

module type MakeUseRefetchableFragmentConfig = {
  type fragmentRaw;
  type fragment;
  type fragmentRef;
  type variables;
  let fragmentSpec: fragmentNode;
  let convertFragment: fragmentRaw => fragment;
  let convertVariables: variables => variables;
};

module MakeUseRefetchableFragment = (C: MakeUseRefetchableFragmentConfig) => {
  let useRefetchable = (fr: C.fragmentRef) => {
    let (fragmentData, refetchFn) =
      _useRefetchableFragment(C.fragmentSpec, fr);

    let data = useConvertedValue(C.convertFragment, fragmentData);
    (
      data,
      (~variables: C.variables, ~fetchPolicy=?, ~onComplete=?, ()) =>
        refetchFn(
          variables
          |> C.convertVariables
          |> _cleanVariables
          |> _cleanObjectFromUndefined,
          makeRefetchableFnOpts(~fetchPolicy, ~onComplete),
        ),
    );
  };
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

type paginationLoadMoreOptions = {
  onComplete: option(option(Js.Exn.t) => unit),
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

[@bs.module "react-relay/hooks"]
external _usePaginationFragment:
  (fragmentNode, 'fragmentRef) =>
  {
    .
    "data": 'fragmentData,
    "loadNext":
      [@bs.meth] ((int, option(paginationLoadMoreOptions)) => Disposable.t),
    "loadPrevious":
      [@bs.meth] ((int, option(paginationLoadMoreOptions)) => Disposable.t),
    "hasNext": bool,
    "hasPrevious": bool,
    "isLoadingNext": bool,
    "isLoadingPrevious": bool,
    "refetch":
      [@bs.meth] (
        (
          'variables,
          {
            .
            "fetchPolicy": option(string),
            "onComplete": option(Js.Nullable.t(Js.Exn.t) => unit),
          }
        ) =>
        unit
      ),
  } =
  "usePaginationFragment";

[@bs.module "react-relay/hooks"]
external _useBlockingPaginationFragment:
  (fragmentNode, 'fragmentRef) =>
  {
    .
    "data": 'fragmentData,
    "loadNext":
      [@bs.meth] ((int, option(paginationLoadMoreOptions)) => Disposable.t),
    "loadPrevious":
      [@bs.meth] ((int, option(paginationLoadMoreOptions)) => Disposable.t),
    "hasNext": bool,
    "hasPrevious": bool,
    "isLoadingNext": bool,
    "isLoadingPrevious": bool,
    "refetch":
      [@bs.meth] (
        (
          'variables,
          {
            .
            "fetchPolicy": option(string),
            "onComplete": option(Js.Nullable.t(Js.Exn.t) => unit),
          }
        ) =>
        unit
      ),
  } =
  "useBlockingPaginationFragment";

module MakeUsePaginationFragment = (C: MakeUsePaginationFragmentConfig) => {
  let useBlockingPagination =
      (fr: C.fragmentRef)
      : paginationBlockingFragmentReturn(C.fragment, C.variables) => {
    let p = _useBlockingPaginationFragment(C.fragmentSpec, fr);
    let data = useConvertedValue(C.convertFragment, p##data);

    {
      data,
      loadNext: (~count, ~onComplete=?, ()) =>
        p##loadNext(count, Some({onComplete: onComplete})),
      loadPrevious: (~count, ~onComplete=?, ()) =>
        p##loadPrevious(count, Some({onComplete: onComplete})),
      hasNext: p##hasNext,
      hasPrevious: p##hasPrevious,
      refetch: (~variables: C.variables, ~fetchPolicy=?, ~onComplete=?, ()) =>
        p##refetch(
          variables |> C.convertVariables,
          makeRefetchableFnOpts(~onComplete, ~fetchPolicy),
        ),
    };
  };

  let usePagination =
      (fr: C.fragmentRef): paginationFragmentReturn(C.fragment, C.variables) => {
    let p = _usePaginationFragment(C.fragmentSpec, fr);
    let data = useConvertedValue(C.convertFragment, p##data);

    {
      data,
      loadNext: (~count, ~onComplete=?, ()) =>
        p##loadNext(count, Some({onComplete: onComplete})),
      loadPrevious: (~count, ~onComplete=?, ()) =>
        p##loadPrevious(count, Some({onComplete: onComplete})),
      hasNext: p##hasNext,
      hasPrevious: p##hasPrevious,
      isLoadingNext: p##isLoadingNext,
      isLoadingPrevious: p##isLoadingPrevious,
      refetch: (~variables: C.variables, ~fetchPolicy=?, ~onComplete=?, ()) =>
        p##refetch(
          variables |> C.convertVariables,
          makeRefetchableFnOpts(~onComplete, ~fetchPolicy),
        ),
    };
  };
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

type _commitMutationConfig('variables, 'response) = {
  mutation: mutationNode,
  variables: 'variables,
  onCompleted:
    option(
      (Js.Nullable.t(Js.Json.t), Js.Nullable.t(array(mutationError))) =>
      unit,
    ),
  onError: option(Js.Nullable.t(mutationError) => unit),
  optimisticResponse: option('response),
  optimisticUpdater: option(optimisticUpdaterFn),
  updater: option(updaterFn('response)),
};

exception Mutation_failed(array(mutationError));

[@bs.module "relay-runtime"]
external _commitMutation:
  (Environment.t, _commitMutationConfig('variables, 'response)) => unit =
  "commitMutation";

module MakeUseMutation = (C: MutationConfig) => {};

module MakeCommitMutation = (C: MutationConfig) => {
  let commitMutation =
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~optimisticUpdater=?,
        ~optimisticResponse=?,
        ~updater=?,
        (),
      )
      : Js.Promise.t(Js.Json.t) =>
    Js.Promise.make((~resolve, ~reject) =>
      _commitMutation(
        environment,
        {
          variables: variables |> C.convertVariables |> _cleanVariables,
          mutation: C.node,
          onCompleted:
            Some(
              (res, errors) =>
                switch (res |> toOpt, errors |> toOpt) {
                | (_, Some(errors)) => reject(. Mutation_failed(errors))
                | (Some(res), None) => resolve(. res)
                | (None, None) => reject(. Mutation_failed([||]))
                },
            ),
          onError:
            Some(
              error =>
                switch (error |> toOpt) {
                | Some(error) => reject(. Mutation_failed([|error|]))
                | None => reject(. Mutation_failed([||]))
                },
            ),
          optimisticResponse:
            switch (optimisticResponse) {
            | None => None
            | Some(r) => Some(r |> C.wrapResponse)
            },
          optimisticUpdater,
          updater:
            switch (updater) {
            | None => None
            | Some(updater) =>
              Some((store, r) => updater(store, r |> C.convertResponse))
            },
        },
      )
    );
};

[@bs.module "relay-runtime"]
external _commitLocalUpdate:
  (Environment.t, RecordSourceSelectorProxy.t => unit) => unit =
  "commitLocalUpdate";

let commitLocalUpdate = (~environment, ~updater) =>
  _commitLocalUpdate(environment, updater);

module type SubscriptionConfig = {
  type variables;
  type responseRaw;
  type response;
  let node: subscriptionNode;
  let convertResponse: responseRaw => response;
  let convertVariables: variables => variables;
};

type _subscriptionConfig('response, 'variables) = {
  .
  "subscription": subscriptionNode,
  "variables": 'variables,
  "onCompleted": option(unit => unit),
  "onError": option(Js.Exn.t => unit),
  "onNext": option('response => unit),
  "updater": option(updaterFn('response)),
};

[@bs.module "relay-runtime"]
external requestSubscription:
  (Environment.t, _subscriptionConfig('response, 'variables)) => Disposable.t =
  "requestSubscription";

module MakeUseSubscription = (C: SubscriptionConfig) => {
  let subscribe =
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~onCompleted: option(unit => unit)=?,
        ~onError: option(Js.Exn.t => unit)=?,
        ~onNext: option(C.response => unit)=?,
        ~updater: option(updaterFn(C.response))=?,
        (),
      ) =>
    requestSubscription(
      environment,
      {
        "subscription": C.node,
        "variables": variables |> C.convertVariables |> _cleanVariables,
        "onCompleted": onCompleted,
        "onError": onError,
        "onNext":
          switch (onNext) {
          | None => None
          | Some(onNext) => Some(r => onNext(r |> C.convertResponse))
          },
        "updater":
          switch (updater) {
          | None => None
          | Some(updater) =>
            Some((store, r) => updater(store, C.convertResponse(r)))
          },
      },
    );
};