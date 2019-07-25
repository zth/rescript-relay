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

/**
 * Store and updaters
 */
type dataId;

let dataIdToString: dataId => string;
let makeDataId: string => dataId;

/**
 * We modify most store primitives to return options instead of nullables,
 * and to take labeled arguments and for use with data-last |> pipe.
 *
 * The data-last approach is important to have in mind here, because it means
 * that we flip the [@bs.send] bindings around. This might not be a good idea/might
 * be confusing, but for various reasons I prefer data-last, so I'll keep it
 * like that for now.
 */
module RecordProxy: {
  type t;
  type arguments('a) = jsObj('a) constraint 'a = {..};

  let copyFieldsFrom: (~sourceRecord: t, t) => unit;

  let getDataId: t => dataId;

  let getLinkedRecord:
    (~name: string, ~arguments: option(arguments({..})), t) => option(t);

  let getLinkedRecords:
    (~name: string, ~arguments: option(arguments({..})), t) =>
    option(array(option(t)));

  let getOrCreateLinkedRecord:
    (
      ~name: string,
      ~typeName: string,
      ~arguments: option(arguments({..})),
      t
    ) =>
    t;

  let getType: t => string;

  let getValueString:
    (~name: string, ~arguments: option(arguments({..})), t) => option(string);

  let getValueStringArray:
    (~name: string, ~arguments: option(arguments({..})), t) =>
    option(array(option(string)));

  let getValueInt:
    (~name: string, ~arguments: option(arguments({..})), t) => option(int);

  let getValueIntArray:
    (~name: string, ~arguments: option(arguments({..})), t) =>
    option(array(option(int)));

  let getValueFloat:
    (~name: string, ~arguments: option(arguments({..})), t) => option(float);

  let getValueFloatArray:
    (~name: string, ~arguments: option(arguments({..})), t) =>
    option(array(option(float)));

  let getValueBool:
    (~name: string, ~arguments: option(arguments({..})), t) => option(bool);

  let getValueBoolArray:
    (~name: string, ~arguments: option(arguments({..})), t) =>
    option(array(option(bool)));

  let setLinkedRecord:
    (~record: t, ~name: string, ~arguments: option(arguments({..})), t) => t;

  let setLinkedRecords:
    (
      ~records: array(option(t)),
      ~name: string,
      ~arguments: option(arguments({..})),
      t
    ) =>
    t;

  let setValueString:
    (~value: string, ~name: string, ~arguments: option(arguments({..})), t) =>
    t;

  let setValueStringArray:
    (
      ~value: array(string),
      ~name: string,
      ~arguments: option(arguments({..})),
      t
    ) =>
    t;

  let setValueInt:
    (~value: int, ~name: string, ~arguments: option(arguments({..})), t) => t;

  let setValueIntArray:
    (
      ~value: array(int),
      ~name: string,
      ~arguments: option(arguments({..})),
      t
    ) =>
    t;

  let setValueFloat:
    (~value: float, ~name: string, ~arguments: option(arguments({..})), t) =>
    t;

  let setValueFloatArray:
    (
      ~value: array(float),
      ~name: string,
      ~arguments: option(arguments({..})),
      t
    ) =>
    t;

  let setValueBool:
    (~value: bool, ~name: string, ~arguments: option(arguments({..})), t) => t;

  let setValueBoolArray:
    (
      ~value: array(bool),
      ~name: string,
      ~arguments: option(arguments({..})),
      t
    ) =>
    t;
};

module RecordSourceSelectorProxy: {
  type t;

  let create: (~dataId: dataId, ~typeName: string, t) => RecordProxy.t;

  let delete: (~dataId: dataId, t) => unit;

  let get: (~dataId: dataId, t) => option(RecordProxy.t);

  let getRoot: t => RecordProxy.t;

  let getRootField: (~fieldName: string, t) => option(RecordProxy.t);

  let getPluralRootField:
    (~fieldName: string, t) => option(array(option(RecordProxy.t)));
};

module RecordSourceProxy: {
  type t;

  let create: (~dataId: dataId, ~typeName: string, t) => RecordProxy.t;

  let delete: (~dataId: dataId, t) => unit;

  let get: (~dataId: dataId, t) => option(RecordProxy.t);

  let getRoot: t => RecordProxy.t;
};

module ConnectionHandler: {
  type filters('a) = jsObj('a) constraint 'a = {..};

  let getConnection:
    (~record: RecordProxy.t, ~key: string, ~filters: option(filters({..}))) =>
    option(RecordProxy.t);

  let createEdge:
    (
      ~store: RecordSourceProxy.t,
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
 * QUERY
 */

type queryResponse('data) =
  | Loading
  | Error(Js.Exn.t)
  | Data('data);
type dataFrom =
  | NetworkOnly
  | StoreThenNetwork
  | StoreOrNetwork
  | StoreOnly;

module type MakeUseQueryConfig = {
  type response;
  type variables;
  let query: queryNode;
};

module MakeUseQuery:
  (C: MakeUseQueryConfig) =>
   {
    type response = C.response;
    type variables = C.variables;
    let use:
      (~variables: variables, ~dataFrom: dataFrom=?, unit) =>
      queryResponse(response);
  };

/**
 * FRAGMENT
 */

module type MakeUseFragmentConfig = {
  type fragment;
  type fragmentRef;
  let fragmentSpec: fragmentNode;
};

module MakeUseFragment:
  (C: MakeUseFragmentConfig) => {let use: C.fragmentRef => C.fragment;};

/**
 * MUTATION
 */

module type MutationConfig = {
  type variables;
  type response;
  let node: mutationNode;
};

type updaterFn = RecordSourceSelectorProxy.t => unit;

type mutationError = {. "message": string};

type mutationState('response) =
  | Loading
  | Error(mutationError)
  | Success(option('response));

type mutationResult('response) =
  | Success('response)
  | Error(Js.Promise.error);

type useMutationConfigType('variables) = {variables: 'variables};

module MakeUseMutation:
  (C: MutationConfig) =>
   {
    let use:
      unit =>
      (
        (
          ~variables: C.variables,
          ~optimisticResponse: C.response=?,
          ~optimisticUpdater: RecordSourceSelectorProxy.t => unit=?,
          ~updater: updaterFn=?,
          unit
        ) =>
        Js.Promise.t(mutationResult(C.response)),
        mutationState(C.response),
      );
  };

module Network: {
  type t;
  type cacheConfig = {
    .
    "force": Js.Nullable.t(bool),
    "poll": Js.Nullable.t(int),
  };
  type operation = {
    .
    "name": string,
    "operationKind": string,
    "text": string,
  };
  type fetchFunctionPromise =
    (operation, Js.Json.t, cacheConfig) => Js.Promise.t(Js.Json.t);
  let makePromiseBased: fetchFunctionPromise => t;
};

module RecordSource: {
  type t;
  let make: unit => t;
};

module Store: {
  type t;
  let make: RecordSource.t => t;
};

module Environment: {
  type t;
  type config = {
    network: Network.t,
    store: Store.t,
  };
  let make: (~network: Network.t, ~store: Store.t) => t;
};

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

let useEnvironmentFromContext: unit => Environment.t;

exception Mutation_failed(array(mutationError));

module MakeCommitMutation:
  (C: MutationConfig) =>
   {
    let commitMutation:
      (
        ~environment: Environment.t,
        ~variables: C.variables,
        ~optimisticUpdater: RecordSourceSelectorProxy.t => unit=?,
        ~optimisticResponse: C.response=?,
        ~updater: RecordSourceSelectorProxy.t => unit=?,
        unit
      ) =>
      Js.Promise.t(C.response);
  };

let commitLocalUpdate:
  (
    ~environment: Environment.t,
    ~updater: RecordSourceSelectorProxy.t => unit
  ) =>
  unit;

let fetchQuery:
  (Environment.t, queryNode, 'variables) => Js.Promise.t('response);
