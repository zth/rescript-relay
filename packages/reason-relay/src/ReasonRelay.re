let toOpt = Js.Nullable.toOption;
type arguments;
type allFieldsMasked = {.};

type any;

type queryNode;
type fragmentNode;
type mutationNode;
type subscriptionNode;

type wrappedFragmentRef;

type dataId;

type recordSourceRecords;

external dataIdToString: dataId => string = "%identity";
external makeDataId: string => dataId = "%identity";

external makeArguments: Js.t({..}) => arguments = "%identity";

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
    (t, string, option(arguments)) => Js.Nullable.t(t) =
    "getLinkedRecord";

  let getLinkedRecord = (t, ~name, ~arguments=?, ()): option(t) =>
    _getLinkedRecord(t, name, arguments) |> toOpt;

  [@bs.send]
  external _getLinkedRecords:
    (t, string, option(arguments)) =>
    Js.Nullable.t(array(Js.Nullable.t(t))) =
    "getLinkedRecords";

  let getLinkedRecords =
      (t, ~name, ~arguments=?, ()): option(array(option(t))) =>
    switch (_getLinkedRecords(t, name, arguments) |> toOpt) {
    | Some(records) => Some(records |> Array.map(v => v |> toOpt))
    | None => None
    };

  [@bs.send]
  external _getOrCreateLinkedRecord:
    (t, string, string, option(arguments)) => t =
    "getOrCreateLinkedRecord";

  let getOrCreateLinkedRecord = (t, ~name, ~typeName, ~arguments=?, ()) =>
    _getOrCreateLinkedRecord(t, name, typeName, arguments);

  [@bs.send] external _getType: t => string = "getType";
  let getType = t => _getType(t);

  [@bs.send]
  external _getValue: (t, string, option(arguments)) => Js.Nullable.t('value) =
    "getValue";

  let _getValueArr = (t, ~name, ~arguments) =>
    switch (_getValue(t, name, arguments) |> toOpt) {
    | Some(arr) =>
      Some(arr |> Array.map(value => value |> Js.Nullable.toOption))
    | None => None
    };

  let getValueString = (t, ~name, ~arguments=?, ()): option(string) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueStringArray =
      (t, ~name, ~arguments=?, ()): option(array(option(string))) =>
    _getValueArr(~name, ~arguments, t);

  let getValueInt = (t, ~name, ~arguments=?, ()): option(int) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueIntArray =
      (t, ~name, ~arguments=?, ()): option(array(option(int))) =>
    _getValueArr(~name, ~arguments, t);

  let getValueFloat = (t, ~name, ~arguments=?, ()): option(float) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueFloatArray =
      (t, ~name, ~arguments=?, ()): option(array(option(float))) =>
    _getValueArr(~name, ~arguments, t);

  let getValueBool = (t, ~name, ~arguments=?, ()): option(bool) =>
    _getValue(t, name, arguments) |> toOpt;

  let getValueBoolArray =
      (t, ~name, ~arguments=?, ()): option(array(option(bool))) =>
    _getValueArr(~name, ~arguments, t);

  [@bs.send]
  external _setLinkedRecord: (t, t, string, option(arguments)) => t =
    "setLinkedRecord";
  let setLinkedRecord = (t, ~record, ~name, ~arguments=?, ()) =>
    _setLinkedRecord(t, record, name, arguments);

  [@bs.send]
  external _unsetLinkedRecord: (t, 'nullable, string, option(arguments)) => t =
    "setLinkedRecord";
  let unsetLinkedRecord = (t, ~name, ~unsetValue, ~arguments=?, ()) =>
    switch (unsetValue) {
    | Null => _unsetLinkedRecord(t, Js.null, name, arguments)
    | Undefined => _unsetLinkedRecord(t, Js.undefined, name, arguments)
    };

  [@bs.send]
  external _setLinkedRecords:
    (t, array(option(t)), string, option(arguments)) => t =
    "setLinkedRecords";
  let setLinkedRecords = (t, ~records, ~name, ~arguments=?, ()) =>
    _setLinkedRecords(t, records, name, arguments);

  [@bs.send]
  external _unsetLinkedRecords: (t, 'nullable, string, option(arguments)) => t =
    "setLinkedRecords";
  let unsetLinkedRecords = (t, ~name, ~unsetValue, ~arguments=?, ()) =>
    switch (unsetValue) {
    | Null => _unsetLinkedRecords(t, Js.null, name, arguments)
    | Undefined => _unsetLinkedRecords(t, Js.undefined, name, arguments)
    };

  [@bs.send]
  external _setValue: (t, 'value, string, option(arguments)) => t =
    "setValue";

  [@bs.send]
  external _unsetValue: (t, 'nullable, string, option(arguments)) => t =
    "setValue";
  let unsetValue = (t, ~name, ~unsetValue, ~arguments=?, ()) =>
    switch (unsetValue) {
    | Null => _unsetValue(t, Js.null, name, arguments)
    | Undefined => _unsetValue(t, Js.undefined, name, arguments)
    };

  let setValueString = (t, ~value: string, ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  let setValueStringArray =
      (t, ~value: array(string), ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  let setValueInt = (t, ~value: int, ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  let setValueIntArray = (t, ~value: array(int), ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  let setValueFloat = (t, ~value: float, ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  let setValueFloatArray = (t, ~value: array(float), ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  let setValueBool = (t, ~value: bool, ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  let setValueBoolArray = (t, ~value: array(bool), ~name, ~arguments=?, ()) =>
    _setValue(t, value, name, arguments);

  [@bs.send] external invalidateRecord: t => unit = "invalidateRecord";
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

  [@bs.send] external invalidateStore: t => unit = "invalidateStore";
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

  [@bs.send] external invalidateStore: t => unit = "invalidateStore";
};

module ConnectionHandler = {
  type t;

  [@bs.module "relay-runtime"]
  external connectionHandler: t = "ConnectionHandler";

  [@bs.send]
  external _getConnection:
    (t, RecordProxy.t, string, option(arguments)) =>
    Js.Nullable.t(RecordProxy.t) =
    "getConnection";

  let getConnection = (~record, ~key, ~filters=?, ()) =>
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

  let insertEdgeBefore = (~connection, ~newEdge, ~cursor=?, ()) =>
    _insertEdgeBefore(connectionHandler, connection, newEdge, cursor);

  [@bs.send]
  external _insertEdgeAfter:
    (t, RecordProxy.t, RecordProxy.t, option(string)) => unit =
    "insertEdgeAfter";

  let insertEdgeAfter = (~connection, ~newEdge, ~cursor=?, ()) =>
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

  type subscription = {
    unsubscribe: unit => unit,
    closed: bool,
  };

  type sink('t) = {
    next: 't => unit,
    error: Js.Exn.t => unit,
    completed: unit => unit,
    closed: bool,
  };

  type observer('t) = {
    start: option(subscription => unit),
    next: option('t => unit),
    error: option(Js.Exn.t => unit),
    complete: option(unit => unit),
    unsubscribe: option(subscription => unit),
  };

  let makeObserver =
      (~start=?, ~next=?, ~error=?, ~complete=?, ~unsubscribe=?, ()) => {
    start,
    next,
    error,
    complete,
    unsubscribe,
  };

  [@bs.module "relay-runtime"] [@bs.scope "Observable"]
  external create: (sink('t) => option('a)) => t = "create";

  [@bs.send]
  external subscribe: (t, observer('t)) => subscription = "subscribe";

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

  type subscribeFn = (operation, Js.Json.t, cacheConfig) => Observable.t;

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

type renderPolicy =
  | Full
  | Partial;

let mapRenderPolicy =
  fun
  | Some(Full) => Some("full")
  | Some(Partial) => Some("partial")
  | None => None;

module Environment = {
  type t;

  type environmentConfig('a) = {
    network: Network.t,
    store: Store.t,
    [@bs.as "UNSTABLE_DO_NOT_USE_getDataID"]
    getDataID: option(('a, string) => string),
    [@bs.as "UNSTABLE_defaultRenderPolicy"]
    defaultRenderPolicy: option(string),
  };

  [@bs.module "relay-runtime"] [@bs.new]
  external _make: environmentConfig('a) => t = "Environment";

  let make = (~network, ~store, ~getDataID=?, ~defaultRenderPolicy=?, ()) =>
    _make({
      network,
      store,
      getDataID:
        switch (getDataID) {
        | Some(getDataID) =>
          Some((nodeObj, typeName) => getDataID(~nodeObj, ~typeName))
        | None => None
        },
      defaultRenderPolicy: defaultRenderPolicy->mapRenderPolicy,
    });

  [@bs.send] external getStore: t => Store.t = "getStore";
};

module EnvironmentProvider = {
  [@bs.module "relay-experimental"] [@react.component]
  external make:
    (~environment: Environment.t, ~children: React.element) => React.element =
    "RelayEnvironmentProvider";

  let make = make;
};

let useConvertedValue = (convert, v) =>
  React.useMemo1(() => convert(v), [|v|]);

exception EnvironmentNotFoundInContext;

[@bs.module "relay-experimental"]
external useRelayEnvironment: unit => Environment.t = "useRelayEnvironment";

type fetchPolicy =
  | StoreOnly
  | StoreOrNetwork
  | StoreAndNetwork
  | NetworkOnly;

let mapFetchPolicy =
  fun
  | Some(StoreOnly) => Some("store-only")
  | Some(StoreOrNetwork) => Some("store-or-network")
  | Some(StoreAndNetwork) => Some("store-and-network")
  | Some(NetworkOnly) => Some("network-only")
  | None => None;

[@bs.module "relay-runtime"]
external fetchQuery:
  (Environment.t, queryNode, 'variables) => Js.Promise.t('response) =
  "fetchQuery";

type useQueryConfig = {
  fetchKey: option(string),
  fetchPolicy: option(string),
  [@bs.as "UNSTABLE_renderPolicy"]
  renderPolicy: option(string),
  networkCacheConfig: option(cacheConfig),
};

type preloadQueryConfig = {
  fetchKey: option(string),
  fetchPolicy: option(string),
  networkCacheConfig: option(cacheConfig),
};

[@bs.module "relay-experimental"]
external _useQuery: (queryNode, 'variables, useQueryConfig) => 'queryResponse =
  "useLazyLoadQuery";

[@bs.module "relay-experimental"]
external _preloadQuery:
  (Environment.t, queryNode, 'variables, preloadQueryConfig) => 'queryResponse =
  "preloadQuery";

[@bs.module "relay-experimental"]
external _usePreloadedQuery:
  (queryNode, 'token, option({. "UNSTABLE_renderPolicy": option(string)})) =>
  'queryResponse =
  "usePreloadedQuery";

module type MakeUseQueryConfig = {
  type responseRaw;
  type response;
  type variables;
  type preloadToken;
  let query: queryNode;
  let convertResponse: responseRaw => response;
  let convertVariables: variables => variables;
};

module MakeUseQuery = (C: MakeUseQueryConfig) => {
  let use =
      (
        ~variables,
        ~fetchPolicy=?,
        ~renderPolicy=?,
        ~fetchKey=?,
        ~networkCacheConfig=?,
        (),
      )
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
          renderPolicy: renderPolicy |> mapRenderPolicy,
          networkCacheConfig,
        },
      );

    useConvertedValue(C.convertResponse, data);
  };

  let usePreloaded = (~token: C.preloadToken, ~renderPolicy=?, ()) => {
    let data =
      _usePreloadedQuery(
        C.query,
        token,
        switch (renderPolicy) {
        | Some(_) =>
          Some({"UNSTABLE_renderPolicy": renderPolicy |> mapRenderPolicy})
        | None => None
        },
      );
    data |> useConvertedValue(C.convertResponse);
  };

  let fetch =
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~onResult: Belt.Result.t(C.response, Js.Promise.error) => unit,
      )
      : unit => {
    let _ =
      fetchQuery(environment, C.query, variables |> C.convertVariables)
      |> Js.Promise.then_(res => {
           onResult(Ok(res |> C.convertResponse));
           Js.Promise.resolve();
         })
      |> Js.Promise.catch(err => {
           onResult(Error(err));
           Js.Promise.resolve();
         });
    ();
  };

  let fetchPromised =
      (~environment: Environment.t, ~variables: C.variables)
      : Promise.t(Belt.Result.t(C.response, Js.Promise.error)) => {
    let (promise, resolve) = Promise.pending();

    let _ =
      fetchQuery(environment, C.query, variables |> C.convertVariables)
      |> Js.Promise.then_(res => {
           resolve(Ok(res |> C.convertResponse));
           Js.Promise.resolve();
         })
      |> Js.Promise.catch(err => {
           resolve(Error(err));
           Js.Promise.resolve();
         });

    promise;
  };
};

module type MakePreloadQueryConfig = {
  type variables;
  type queryPreloadToken;
  let query: queryNode;
  let convertVariables: variables => variables;
};

module MakePreloadQuery = (C: MakePreloadQueryConfig) => {
  let preload:
    (
      ~environment: Environment.t,
      ~variables: C.variables,
      ~fetchPolicy: fetchPolicy=?,
      ~fetchKey: string=?,
      ~networkCacheConfig: cacheConfig=?,
      unit
    ) =>
    C.queryPreloadToken =
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

  type rawPreloadToken = {source: Js.Nullable.t(Observable.t)};
  external tokenToRaw: C.queryPreloadToken => rawPreloadToken = "%identity";

  let preloadTokenToObservable = token => {
    let raw = token->tokenToRaw;
    raw.source->Js.Nullable.toOption;
  };

  let preloadTokenToPromise = token => {
    let (promise, resolve) = Promise.pending();

    switch (token->preloadTokenToObservable) {
    | None => resolve(Error())
    | Some(o) =>
      let _: Observable.subscription =
        o->Observable.(
             subscribe(makeObserver(~complete=() => resolve(Ok()), ()))
           );
      ();
    };

    promise;
  };
};

/**
 * FRAGMENT
 */
[@bs.module "relay-experimental"]
external _useFragment: (fragmentNode, 'fragmentRef) => 'fragmentData =
  "useFragment";

[@bs.module "relay-experimental"]
external _useFragmentOpt:
  (fragmentNode, Js.Nullable.t('fragmentRef)) => Js.Nullable.t('fragmentData) =
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

  let useOpt = (fr: option(C.fragmentRef)): option(C.fragment) => {
    let nullableFragmentData: Js.Nullable.t(C.fragmentRaw) =
      _useFragmentOpt(
        C.fragmentSpec,
        switch (fr) {
        | Some(fr) => Some(fr)->Js.Nullable.fromOption
        | None => Js.Nullable.null
        },
      );

    let data: option(C.fragmentRaw) =
      nullableFragmentData->Js.Nullable.toOption;

    useConvertedValue(
      rawFragment =>
        switch (rawFragment) {
        | Some(rawFragment) => Some(rawFragment->C.convertFragment)
        | None => None
        },
      data,
    );
  };
};

/** Refetchable */
type refetchFn('variables) =
  (
    ~variables: 'variables,
    ~fetchPolicy: fetchPolicy=?,
    ~renderPolicy: renderPolicy=?,
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
      "UNSTABLE_renderPolicy": option(string),
      "onComplete": option(Js.Nullable.t(Js.Exn.t) => unit),
    }
  ) =>
  unit;

let makeRefetchableFnOpts = (~fetchPolicy, ~renderPolicy, ~onComplete) => {
  "fetchPolicy": fetchPolicy |> mapFetchPolicy,
  "UNSTABLE_renderPolicy": renderPolicy |> mapRenderPolicy,
  "onComplete":
    Some(
      maybeExn =>
        switch (onComplete, maybeExn |> Js.Nullable.toOption) {
        | (Some(onComplete), maybeExn) => onComplete(maybeExn)
        | _ => ()
        },
    ),
};

[@bs.module "relay-experimental"]
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
      (
        ~variables: C.variables,
        ~fetchPolicy=?,
        ~renderPolicy=?,
        ~onComplete=?,
        (),
      ) =>
        refetchFn(
          variables
          |> C.convertVariables
          |> _cleanVariables
          |> _cleanObjectFromUndefined,
          makeRefetchableFnOpts(~fetchPolicy, ~renderPolicy, ~onComplete),
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

[@bs.module "relay-experimental"]
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
            "UNSTABLE_renderPolicy": option(string),
            "onComplete": option(Js.Nullable.t(Js.Exn.t) => unit),
          }
        ) =>
        unit
      ),
  } =
  "usePaginationFragment";

[@bs.module "relay-experimental"]
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
            "UNSTABLE_renderPolicy": option(string),
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
      refetch:
        (
          ~variables: C.variables,
          ~fetchPolicy=?,
          ~renderPolicy=?,
          ~onComplete=?,
          (),
        ) =>
        p##refetch(
          variables |> C.convertVariables |> _cleanVariables,
          makeRefetchableFnOpts(~onComplete, ~fetchPolicy, ~renderPolicy),
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
      refetch:
        (
          ~variables: C.variables,
          ~fetchPolicy=?,
          ~renderPolicy=?,
          ~onComplete=?,
          (),
        ) =>
        p##refetch(
          variables |> C.convertVariables |> _cleanVariables,
          makeRefetchableFnOpts(~onComplete, ~fetchPolicy, ~renderPolicy),
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

type useMutationConfig('response, 'variables) = {
  onError: option(mutationError => unit),
  onCompleted: option(('response, option(array(mutationError))) => unit),
  onUnsubscribe: option(unit => unit),
  optimisticResponse: option('response),
  optimisticUpdater: option(optimisticUpdaterFn),
  updater: option(updaterFn('response)),
  variables: 'variables,
};

type _useMutationConfig('response, 'variables) = {
  onError: option(mutationError => unit),
  onCompleted:
    option(('response, Js.Nullable.t(array(mutationError))) => unit),
  onUnsubscribe: option(unit => unit),
  optimisticResponse: option('response),
  optimisticUpdater: option(optimisticUpdaterFn),
  updater: option(updaterFn('response)),
  variables: 'variables,
};

type _commitMutationConfig('variables, 'response) = {
  mutation: mutationNode,
  variables: 'variables,
  onCompleted:
    option(('response, Js.Nullable.t(array(mutationError))) => unit),
  onError: option(Js.Nullable.t(mutationError) => unit),
  optimisticResponse: option('response),
  optimisticUpdater: option(optimisticUpdaterFn),
  updater: option(updaterFn('response)),
};

exception Mutation_failed(array(mutationError));

[@bs.module "relay-runtime"]
external _commitMutation:
  (Environment.t, _commitMutationConfig('variables, 'response)) =>
  Disposable.t =
  "commitMutation";

[@bs.module "relay-experimental"]
external _useMutation:
  mutationNode =>
  (_useMutationConfig('response, 'variables) => Disposable.t, bool) =
  "useMutation";

module MakeUseMutation = (C: MutationConfig) => {
  let use = () => {
    let (mutate, mutating) = _useMutation(C.node);
    (
      (
        ~onError=?,
        ~onCompleted=?,
        ~onUnsubscribe=?,
        ~optimisticResponse=?,
        ~optimisticUpdater=?,
        ~updater=?,
        ~variables,
        (),
      ) =>
        mutate({
          onError,
          onCompleted:
            switch (onCompleted) {
            | Some(fn) =>
              Some(
                (r, errors) =>
                  fn(r |> C.convertResponse, Js.Nullable.toOption(errors)),
              )

            | None => None
            },
          optimisticResponse:
            switch (optimisticResponse) {
            | None => None
            | Some(r) => Some(r |> C.wrapResponse)
            },
          onUnsubscribe,
          variables: variables |> C.convertVariables |> _cleanVariables,
          optimisticUpdater,
          updater:
            switch (updater) {
            | None => None
            | Some(updater) =>
              Some((store, r) => updater(store, r |> C.convertResponse))
            },
        }),
      mutating,
    );
  };
};

module MakeCommitMutation = (C: MutationConfig) => {
  let commitMutation =
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~optimisticUpdater=?,
        ~optimisticResponse=?,
        ~updater=?,
        ~onCompleted=?,
        ~onError=?,
        (),
      )
      : Disposable.t =>
    _commitMutation(
      environment,
      {
        variables: variables |> C.convertVariables |> _cleanVariables,
        mutation: C.node,
        onCompleted:
          Some(
            (res, err) =>
              switch (onCompleted) {
              | Some(cb) =>
                cb(res->C.convertResponse, Js.Nullable.toOption(err))
              | None => ()
              },
          ),
        onError:
          Some(
            err =>
              switch (onError) {
              | Some(cb) => cb(Js.Nullable.toOption(err))
              | None => ()
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
    );

  let commitMutationPromised =
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~optimisticUpdater=?,
        ~optimisticResponse=?,
        ~updater=?,
        (),
      )
      : Promise.t(
          Belt.Result.t(
            (C.response, option(array(mutationError))),
            option(mutationError),
          ),
        ) => {
    let (promise, resolve) = Promise.pending();

    let _: Disposable.t =
      _commitMutation(
        environment,
        {
          variables: variables |> C.convertVariables |> _cleanVariables,
          mutation: C.node,
          onCompleted:
            Some(
              (res, err) =>
                resolve(
                  Ok((res->C.convertResponse, Js.Nullable.toOption(err))),
                ),
            ),
          onError: Some(err => resolve(Error(Js.Nullable.toOption(err)))),
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
      );

    promise;
  };
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
