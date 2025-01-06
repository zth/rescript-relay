open RescriptRelay

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
external useFragmentOpt_: (fragmentNode<'node>, option<'fragmentRef>) => Js.Nullable.t<'fragment> =
  "useFragment"

let useFragmentOpt = (~fRef, ~node, ~convertFragment: 'fragment => 'fragment) => {
  // TODO(v11) can convert to Nullable pattern match.

  /** A version of `Fragment.use` that'll allow you to pass \
                     `option<fragmentRefs>` and get `option<'fragmentData>` \
                     back. Useful for scenarios where you don't have the \
                     fragmentRefs yet.*/
  let data =
    useFragmentOpt_(node, fRef)->Js.Nullable.toOption
  React.useMemo1(() => {
    switch data {
    | Some(data) => Some(convertFragment(data))
    | None => None
    }
  }, [data])
}

@module("react-relay")
external readInlineData_: (fragmentNode<'node>, 'fragmentRef) => 'fragment = "readInlineData"

let readInlineData = (~node, ~convertFragment: 'fragment => 'fragment, ~fRef) => {
  /** This lets you get the data for this fragment _outside \
                       of React's render_. Useful for letting functions with \
                       with fragments too, for things like logging etc.*/
  (readInlineData_(node, fRef)->convertFragment)
}

@module("relay-runtime/lib/store/ResolverFragments")
external read_: (fragmentNode<'node>, 'fragmentRef) => 'fragment = "readFragment"

let read = (~node, ~convertFragment: 'fragment => 'fragment, ~fRef) => {
  /** This lets you get the data for this fragment _outside \
                       of React's render_. Useful for letting functions with \
                       with fragments too, for things like logging etc.*/
  (read_(node, fRef)->convertFragment)
}

type refetchableFnOpts = {
  fetchPolicy?: fetchPolicy,
  onComplete?: Js.Nullable.t<Js.Exn.t> => unit,
}

let internal_makeRefetchableFnOpts = (~fetchPolicy=?, ~onComplete=?, ()) => {
  ?fetchPolicy,
  onComplete: ?onComplete->RescriptRelay_Internal.internal_nullableToOptionalExnHandler,
}

type paginationLoadMoreOptions = {onComplete?: Js.Nullable.t<Js.Exn.t> => unit}
type paginationLoadMoreFn = (~count: int, ~onComplete: option<Js.Exn.t> => unit=?) => Disposable.t
type paginationFragmentReturnRaw<'fragment, 'refetchVariables> = {
  data: 'fragment,
  loadNext: (int, paginationLoadMoreOptions) => Disposable.t,
  loadPrevious: (int, paginationLoadMoreOptions) => Disposable.t,
  hasNext: bool,
  hasPrevious: bool,
  isLoadingNext: bool,
  isLoadingPrevious: bool,
  refetch: ('refetchVariables, refetchableFnOpts) => Disposable.t,
}
type paginationFragmentReturn<'fragment, 'refetchVariables> = {
  data: 'fragment,
  loadNext: paginationLoadMoreFn,
  loadPrevious: paginationLoadMoreFn,
  hasNext: bool,
  hasPrevious: bool,
  isLoadingNext: bool,
  isLoadingPrevious: bool,
  refetch: (
    ~variables: 'refetchVariables,
    ~fetchPolicy: fetchPolicy=?,
    ~onComplete: option<Js.Exn.t> => unit=?,
  ) => Disposable.t,
}

@module("react-relay")
external usePaginationFragment_: (
  fragmentNode<'node>,
  'fragmentRef,
) => paginationFragmentReturnRaw<'fragment, 'refetchVariables> = "usePaginationFragment"

/** React hook for paginating a fragment. Paginating with this hook will _not_ cause your component to suspend. */
let usePaginationFragment = (
  ~node,
  ~fRef,
  ~convertFragment: 'fragment => 'fragment,
  ~convertRefetchVariables: 'refetchVariables => 'refetchVariables,
) => {
  let p = usePaginationFragment_(node, fRef)
  let data = RescriptRelay_Internal.internal_useConvertedValue(convertFragment, p.data)
  {
    data,
    loadNext: React.useMemo1(() => (~count, ~onComplete=?) => {
      p.loadNext(
        count,
        {onComplete: ?onComplete->RescriptRelay_Internal.internal_nullableToOptionalExnHandler},
      )
    }, [p.loadNext]),
    loadPrevious: React.useMemo1(() => (~count, ~onComplete=?) => {
      p.loadPrevious(
        count,
        {onComplete: ?onComplete->RescriptRelay_Internal.internal_nullableToOptionalExnHandler},
      )
    }, [p.loadPrevious]),
    hasNext: p.hasNext,
    hasPrevious: p.hasPrevious,
    isLoadingNext: p.isLoadingNext,
    isLoadingPrevious: p.isLoadingPrevious,
    refetch: React.useMemo1(() => (~variables, ~fetchPolicy=?, ~onComplete=?) => {
      p.refetch(
        RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(
          variables->convertRefetchVariables,
        ),
        internal_makeRefetchableFnOpts(~onComplete?, ~fetchPolicy?, ()),
      )
    }, [p.refetch]),
  }
}

type prefetchableForwardPaginationFragmentReturnRaw<'fragment, 'edges, 'refetchVariables> = {
  data: 'fragment,
  edges: 'edges,
  loadNext: (int, paginationLoadMoreOptions) => Disposable.t,
  hasNext: bool,
  isLoadingNext: bool,
  refetch: ('refetchVariables, refetchableFnOpts) => Disposable.t,
}
type prefetchableForwardPaginationFragmentReturn<'fragment, 'edges, 'refetchVariables> = {
  data: 'fragment,
  edges: 'edges,
  loadNext: paginationLoadMoreFn,
  hasNext: bool,
  isLoadingNext: bool,
  refetch: (
    ~variables: 'refetchVariables,
    ~fetchPolicy: fetchPolicy=?,
    ~onComplete: option<Js.Exn.t> => unit=?,
  ) => Disposable.t,
}

@module("react-relay")
external usePrefetchableForwardPaginationFragment_: (
  fragmentNode<'node>,
  'fragmentRef,
  ~bufferSize: int,
  ~initialSize: int=?,
  ~prefetchingLoadMoreOptions: paginationLoadMoreOptions=?,
  ~minimumFetchSize: int=?,
) => prefetchableForwardPaginationFragmentReturnRaw<'fragment, 'edges, 'refetchVariables> =
  "usePrefetchableForwardPaginationFragment_EXPERIMENTAL"

/** React hook for paginating a fragment. Paginating with this hook will _not_ cause your component to suspend. */
let usePrefetchableForwardPagination = (
  ~node,
  ~fRef,
  ~convertEdges: 'edges => 'edges,
  ~convertFragment: 'fragment => 'fragment,
  ~convertRefetchVariables: 'refetchVariables => 'refetchVariables,
  ~bufferSize: int,
  ~initialSize: option<int>=?,
  ~prefetchingLoadMoreOptions: option<paginationLoadMoreOptions>=?,
  ~minimumFetchSize: option<int>=?,
) => {
  let p = usePrefetchableForwardPaginationFragment_(
    node,
    fRef,
    ~bufferSize,
    ~initialSize?,
    ~prefetchingLoadMoreOptions?,
    ~minimumFetchSize?,
  )
  let data = RescriptRelay_Internal.internal_useConvertedValue(convertFragment, p.data)
  let edges = RescriptRelay_Internal.internal_useConvertedValue(convertEdges, p.edges)
  {
    data,
    edges,
    loadNext: React.useMemo1(() => (~count, ~onComplete=?) => {
      p.loadNext(
        count,
        {onComplete: ?onComplete->RescriptRelay_Internal.internal_nullableToOptionalExnHandler},
      )
    }, [p.loadNext]),
    hasNext: p.hasNext,
    isLoadingNext: p.isLoadingNext,
    refetch: React.useMemo1(() => (~variables, ~fetchPolicy=?, ~onComplete=?) => {
      p.refetch(
        RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(
          variables->convertRefetchVariables,
        ),
        internal_makeRefetchableFnOpts(~onComplete?, ~fetchPolicy?, ()),
      )
    }, [p.refetch]),
  }
}

@module("react-relay")
external useRefetchableFragment_: (
  fragmentNode<'node>,
  'fragmentRef,
) => ('fragment, ('refetchVariables, refetchableFnOpts) => Disposable.t) = "useRefetchableFragment"

/**React hook for using a fragment that you want to refetch. Returns \
             a tuple of `(fragmentData, refetchFn)`.\n\n\
             ### Refetching and variables\n\
             You supply a _diff_ of your variables to Relay when refetching. \
             Diffed variables here means that any new value you supply when \
             refetching will be merged with the variables you last used when \
             fetching data for this fragment.\n\n\
             ### `Fragment.makeRefetchVariables` - helper for making the \
             refetch variables\n\
             There's a helper generated for you to create those diffed \
             variables more easily at `Fragment.makeRefetchVariables`.*/
let useRefetchableFragment = (
  ~node,
  ~convertFragment: 'fragment => 'fragment,
  ~convertRefetchVariables: 'refetchVariables => 'refetchVariables,
  ~fRef,
) => {
  let (fragmentData, refetchFn) = useRefetchableFragment_(node, fRef)
  let data = RescriptRelay_Internal.internal_useConvertedValue(convertFragment, fragmentData)
  (
    data,
    React.useMemo1(
      () => (~variables: 'refetchVariables, ~fetchPolicy=?, ~onComplete=?) =>
        refetchFn(
          RescriptRelay_Internal.internal_removeUndefinedAndConvertNullsRaw(
            variables->convertRefetchVariables,
          ),
          internal_makeRefetchableFnOpts(~fetchPolicy?, ~onComplete?, ()),
        ),
      [refetchFn],
    ),
  )
}

@module("relay-runtime/experimental")
external waitForFragmentData_: (
  Environment.t,
  fragmentNode<'node>,
  'fragmentRef,
) => promise<'fragment> = "waitForFragmentData"

let waitForFragmentData = async (
  ~environment,
  ~node,
  ~convertFragment: 'fragment => 'fragment,
  ~fRef,
) => {
  let fragmentData = await waitForFragmentData_(environment, node, fRef)
  convertFragment(fragmentData)
}
