open RescriptRelay

type useQueryConfig = {
  fetchKey?: string,
  fetchPolicy?: fetchPolicy,
  networkCacheConfig?: cacheConfig,
}

@module("react-relay")
external useLazyLoadQuery: (queryNode<'node>, 'variables, useQueryConfig) => 'response =
  "useLazyLoadQuery"

let useQuery = (
  ~convertVariables: 'variables => 'variables,
  ~node: 'm,
  ~convertResponse: 'response => 'response,
) => {
  /**
    React hook for using this query.\n\n\
                Prefer using `Query.useLoader()` or \
                `YourQueryName_graphql.load()` in combination with \
                `Query.usePreloaded()` to this whenever you can, as that will \
                allow you to start loading data before your code actually \
                renders.*/
  (~variables: 'variables, ~fetchPolicy=?, ~fetchKey=?, ~networkCacheConfig=?) => {
    useLazyLoadQuery(
      node,
      RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(variables->convertVariables),
      {
        ?fetchKey,
        ?fetchPolicy,
        ?networkCacheConfig,
      },
    )->RescriptRelay_Internal.internal_useConvertedValue(convertResponse, _)
  }
}

type useQueryLoaderOptions = {
  fetchPolicy?: fetchPolicy,
  networkCacheConfig?: cacheConfig,
}

@module("react-relay")
external useQueryLoader: queryNode<'node> => (
  Nullable.t<'queryRef>,
  ('variables, useQueryLoaderOptions) => unit,
  unit => unit,
) = "useQueryLoader"

let useLoader = (
  ~convertVariables: 'variables => 'variables,
  ~node: 'm,
  ~mkQueryRef: option<'queryRef> => option<'queryRef>,
) => {
  () => {
    let (nullableQueryRef, loadQueryFn, disposableFn) = useQueryLoader(node)
    let loadQuery = React.useMemo1(
      () =>
        (~variables, ~fetchPolicy=?, ~networkCacheConfig=?) =>
          loadQueryFn(variables->convertVariables, {?fetchPolicy, ?networkCacheConfig}),
      [loadQueryFn],
    )
    (nullableQueryRef->Nullable.toOption->mkQueryRef, loadQuery, disposableFn)
  }
}

@module("react-relay")
external usePreloadedQuery: (queryNode<'node>, 'queryRef) => 'response = "usePreloadedQuery"

let usePreloaded = (
  ~node,
  ~convertResponse: 'response => 'response,
  ~mkQueryRef: 'queryRef => 'queryRef,
) =>
  /** Combine this with `Query.useLoader` or \
                `YourQueryName_graphql.load()` to use a query you've started \
                preloading before rendering. */
  (~queryRef: 'queryRef) => {
    usePreloadedQuery(
      node,
      queryRef->mkQueryRef,
    )->RescriptRelay_Internal.internal_useConvertedValue(convertResponse, _)
  }

@module("react-relay")
external fetchQuery: (
  Environment.t,
  queryNode<'node>,
  'variables,
  option<fetchQueryOptions>,
) => Observable.t<'response> = "fetchQuery"

let fetch = (
  ~node,
  ~convertResponse: 'response => 'response,
  ~convertVariables: 'variables => 'variables,
) => {
  /**\n\
                This fetches the query in a one-off fashion, and returns a \
                `result` in a callback for convenience. Use \
                `Query.fetchPromised` if you need this but with promises.\n\n\
                Please *avoid* using `Query.fetch` unless you really need it, \
                since the data you fetch here isn't guaranteed to stick around \
                in the store/cache unless you explicitly use it somewhere in \
                your views.*/
  (
    ~environment: Environment.t,
    ~variables: 'variables,
    ~onResult,
    ~networkCacheConfig=?,
    ~fetchPolicy=?,
  ) => {
    open Observable

    fetchQuery(
      environment,
      node,
      variables->convertVariables,
      Some({?networkCacheConfig, ?fetchPolicy}),
    )
    ->subscribe(
      makeObserver(
        ~next=res => onResult(Ok(res->convertResponse)),
        ~error=err => onResult(Error(err)),
      ),
    )
    ->ignoreSubscription
  }
}

let fetchPromised = (
  ~node,
  ~convertResponse: 'response => 'response,
  ~convertVariables: 'variables => 'variables,
) => {
  /**Promise variant of `Query.fetch`.*/
  (~environment: Environment.t, ~variables: 'variables, ~networkCacheConfig=?, ~fetchPolicy=?) => {
    fetchQuery(
      environment,
      node,
      variables->convertVariables,
      Some({?networkCacheConfig, ?fetchPolicy}),
    )
    ->Observable.toPromise
    ->Promise.then(res => res->convertResponse->Promise.resolve)
  }
}

@module("relay-runtime")
external createOperationDescriptor: (queryNode<'node>, 'variables) => operationDescriptor =
  "createOperationDescriptor"

let retain = (~node, ~convertVariables: 'variables => 'variables) => {
  /**Calling with a set of variables will make Relay _disable \
                garbage collection_ of this query (+ variables) until you \
                explicitly dispose the `Disposable.t` you get back from this \
                call.\n\n\
                Useful for queries and data you know you want to keep in the \
                store regardless of what happens (like it not being used by \
                any view and therefore potentially garbage collected).*/
  (~environment: Environment.t, ~variables: 'variables) => {
    environment->Environment.retain(createOperationDescriptor(node, variables->convertVariables))
  }
}

let commitLocalPayload = (
  ~node,
  ~convertVariables: 'variables => 'variables,
  ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
) => {
  /** This commits a payload into the store _locally only_. Useful \
                  for driving client-only state via Relay for example, or \
                  priming the cache with data you don't necessarily want to \
                  hit the server for. */
  (~environment: Environment.t, ~variables: 'variables, ~payload: 'rawResponse) =>
    environment->Environment.commitPayload(
      createOperationDescriptor(node, variables->convertVariables),
      payload->convertWrapRawResponse,
    )
}
