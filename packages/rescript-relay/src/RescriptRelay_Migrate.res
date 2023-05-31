open RescriptRelay

module Mutation = {
  type updaterFn<'response> = (RecordSourceSelectorProxy.t, 'response) => unit
  type optimisticUpdaterFn = RecordSourceSelectorProxy.t => unit
  type useMutationConfig<'response, 'rawResponse, 'variables> = {
    onError?: mutationError => unit,
    onCompleted?: ('response, option<array<mutationError>>) => unit,
    onUnsubscribe?: unit => unit,
    optimisticResponse?: 'rawResponse,
    optimisticUpdater?: optimisticUpdaterFn,
    updater?: updaterFn<'response>,
    variables: 'variables,
    uploadables?: uploadables,
  }

  type commitMutationConfigRaw<'m, 'variables, 'response, 'rawResponse> = {
    mutation: mutationNode<'m>,
    variables: 'variables,
    onCompleted?: ('response, Js.Nullable.t<array<mutationError>>) => unit,
    onError?: Js.Nullable.t<mutationError> => unit,
    optimisticResponse?: 'rawResponse,
    optimisticUpdater?: optimisticUpdaterFn,
    updater?: updaterFn<'response>,
    uploadables?: uploadables,
  }

  type useMutationConfigRaw<'m, 'variables, 'response, 'rawResponse> = {
    onError?: Js.Nullable.t<mutationError> => unit,
    onCompleted?: ('response, Js.Nullable.t<array<mutationError>>) => unit,
    onUnsubscribe?: unit => unit,
    optimisticResponse?: 'rawResponse,
    optimisticUpdater?: optimisticUpdaterFn,
    updater?: updaterFn<'response>,
    variables: 'variables,
    uploadables?: uploadables,
  }

  @module("relay-runtime")
  external commitMutation_: (
    Environment.t,
    commitMutationConfigRaw<'m, 'variables, 'response, 'rawResponse>,
  ) => Disposable.t = "commitMutation"

  @module("react-relay")
  external useMutation_: 'm => (
    useMutationConfigRaw<'m, 'variables, 'response, 'rawResponse> => Disposable.t,
    bool,
  ) = "useMutation"

  let commitMutation = (
    ~convertVariables: 'variables => 'variables,
    ~node: 'm,
    ~convertResponse: 'response => 'response,
    ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
  ) => {
    /**Commits the current mutation. Use this outside of React's \
               render. If you're inside render, you should use `Mutation.use` \
               instead, which is more convenient.\n\n\
               ### Optimistic updates\n\
               Remember to annotate your mutation with `@raw_response_type` if \
               you want to do optimistic updates. That'll make Relay emit the \
               required type information for covering everything needed when \
               doing optimistic updates.*/
    (
      ~environment: Environment.t,
      ~variables: 'variables,
      ~optimisticUpdater=?,
      ~optimisticResponse: option<'rawResponse>=?,
      ~updater=?,
      ~onCompleted=?,
      ~onError=?,
      ~uploadables=?,
      (),
    ) => {
      commitMutation_(
        environment,
        {
          mutation: node,
          onCompleted: ?switch onCompleted {
          | Some(cb) => Some((res, err) => cb(res->convertResponse, err))
          | None => None
          },
          ?onError,
          optimisticResponse: ?switch optimisticResponse {
          | Some(optimisticResponse) => Some(optimisticResponse->convertWrapRawResponse)
          | None => None
          },
          ?optimisticUpdater,
          updater: ?switch updater {
          | Some(updater) => Some((store, response) => updater(store, response->convertResponse))
          | None => None
          },
          ?uploadables,
          variables: variables->convertVariables,
        },
      )
    }
  }

  let useMutation = (
    ~convertVariables: 'variables => 'variables,
    ~node: 'm,
    ~convertResponse: 'response => 'response,
    ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
  ) => {
    /**React hook for commiting this mutation.\n\n\
               ### Optimistic updates\n\
               Remember to annotate your mutation with `@raw_response_type` if \
               you want to do optimistic updates. That'll make Relay emit the \
               required type information for covering everything needed when \
               doing optimistic updates.*/
    () => {
      let (mutate, mutating) = useMutation_(node)
      (React.useMemo1(() => {
          (
            ~variables: 'variables,
            ~optimisticUpdater=?,
            ~optimisticResponse: option<'rawResponse>=?,
            ~updater=?,
            ~onCompleted=?,
            ~onError=?,
            ~uploadables=?,
            (),
          ) => {
            mutate({
              onCompleted: ?switch onCompleted {
              | Some(cb) => Some((res, err) => cb(res->convertResponse, err))
              | None => None
              },
              ?onError,
              optimisticResponse: ?switch optimisticResponse {
              | Some(optimisticResponse) => Some(optimisticResponse->convertWrapRawResponse)
              | None => None
              },
              ?optimisticUpdater,
              updater: ?switch updater {
              | Some(updater) =>
                Some((store, response) => updater(store, response->convertResponse))
              | None => None
              },
              ?uploadables,
              variables: variables->convertVariables,
            })
          }
        }, [mutate]), mutating)
    }
  }
}

module Query = {
  type useQueryConfig = {
    fetchKey?: string,
    fetchPolicy?: string,
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
    (~variables: 'variables, ~fetchPolicy=?, ~fetchKey=?, ~networkCacheConfig=?, ()) => {
      useLazyLoadQuery(
        node,
        RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(variables->convertVariables),
        {
          ?fetchKey,
          fetchPolicy: ?fetchPolicy->mapFetchPolicy,
          ?networkCacheConfig,
        },
      )->(RescriptRelay_Internal.internal_useConvertedValue(convertResponse, _))
    }
  }

  type useQueryLoaderOptions = {
    fetchPolicy?: string,
    networkCacheConfig?: cacheConfig,
  }

  @module("react-relay")
  external useQueryLoader: queryNode<'node> => (
    Js.Nullable.t<'queryRef>,
    ('variables, useQueryLoaderOptions) => unit,
    unit => unit,
  ) = "useQueryLoader"

  type loaderTuple<'queryRef, 'variables> = (
    option<'queryRef>,
    (
      ~variables: 'variables,
      ~fetchPolicy: fetchPolicy=?,
      ~networkCacheConfig: cacheConfig=?,
      unit,
    ) => unit,
    unit => unit,
  )

  let useLoader = (
    ~convertVariables: 'variables => 'variables,
    ~node: 'm,
    ~mkQueryRef: option<'queryRef> => option<'queryRef>,
  ) => {
    () => {
      let (nullableQueryRef, loadQueryFn, disposableFn) = useQueryLoader(node)
      let loadQuery = React.useMemo1(
        () => (~variables, ~fetchPolicy=?, ~networkCacheConfig=?, ()) =>
          loadQueryFn(
            variables->convertVariables,
            {fetchPolicy: ?fetchPolicy->mapFetchPolicy, ?networkCacheConfig},
          ),
        [loadQueryFn],
      )
      (nullableQueryRef->Js.Nullable.toOption->mkQueryRef, loadQuery, disposableFn)
    }
  }
}
