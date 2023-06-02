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

  @module("react-relay")
  external usePreloadedQuery: (queryNode<'node>, 'queryRef) => 'response = "usePreloadedQuery"

  let usePreloaded = (
    ~node,
    ~convertResponse: 'response => 'response,
    ~mkQueryRef: 'queryRef => 'queryRef,
  ) => /** Combine this with `Query.useLoader` or \
                `YourQueryName_graphql.load()` to use a query you've started \
                preloading before rendering. */
  (~queryRef: 'queryRef) => {
    usePreloadedQuery(node, queryRef->mkQueryRef)->(
      RescriptRelay_Internal.internal_useConvertedValue(convertResponse, _)
    )
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
                `Belt.Result.t` in a callback for convenience. Use \
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
      (),
    ) => {
      open Observable

      fetchQuery(
        environment,
        node,
        variables->convertVariables,
        Some({networkCacheConfig, fetchPolicy: fetchPolicy->mapFetchPolicy}),
      )
      ->subscribe(
        makeObserver(
          ~next=res => onResult(Ok(res->convertResponse)),
          ~error=err => onResult(Error(err)),
          (),
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
    (
      ~environment: Environment.t,
      ~variables: 'variables,
      ~networkCacheConfig=?,
      ~fetchPolicy=?,
      (),
    ) => {
      fetchQuery(
        environment,
        node,
        variables->convertVariables,
        Some({networkCacheConfig, fetchPolicy: fetchPolicy->mapFetchPolicy}),
      )
      ->Observable.toPromise
      ->Js.Promise2.then(res => res->convertResponse->Js.Promise2.resolve)
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
}

module Fragment = {
  @module("react-relay")
  external useFragment_: (fragmentNode<'node>, 'fragmentRef) => 'fragment = "useFragment"

  let useFragment = (~node, ~convertFragment: 'fragment => 'fragment, ~fRef) => {
    /** React hook for getting the data of this fragment. Pass \
                     the `fragmentRefs` of any object where you've spread your \
                     fragment into this and get the fragment data back.\n\n\
                     ### Fragment data outside of React's render\n\
                     If you're looking for a way to use fragments _outside_ of \
                     render (for regular function calls for instance, like for \
                     logging etc), look in to adding `@inline` to your \
                     fragment definition (like `fragment SomeFragment_user on \
                     User @inline {...}`) and then use `Fragment.readInline`. \
                     This will allow you to get the fragment data, but outside \
                     of React's render.*/
    (
      useFragment_(node, fRef)
      ->(RescriptRelay_Internal.internal_useConvertedValue(convertFragment, _))
    )
  }

  @module("react-relay")
  external useFragmentOpt_: (
    fragmentNode<'node>,
    option<'fragmentRef>,
  ) => Js.Nullable.t<'fragment> = "useFragment"

  let useFragmentOpt = (~fRef=?, ~node, ~convertFragment: 'fragment => 'fragment) => {
    /** A version of `Fragment.use` that'll allow you to pass \
                     `option<fragmentRefs>` and get `option<'fragmentData>` \
                     back. Useful for scenarios where you don't have the \
                     fragmentRefs yet.*/
    (
      useFragmentOpt_(node, fRef)
      ->Js.Nullable.toOption
      ->Belt.Option.map(data =>
        RescriptRelay_Internal.internal_useConvertedValue(convertFragment, data)
      )
    )
  }
}
