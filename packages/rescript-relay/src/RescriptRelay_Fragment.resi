open RescriptRelay

let useFragment: (
  ~node: fragmentNode<'a>,
  ~convertFragment: 'fragment => 'fragment,
  ~fRef: 'b,
) => 'fragment

let useFragmentOpt: (
  ~fRef: option<'a>,
  ~node: fragmentNode<'b>,
  ~convertFragment: 'fragment => 'fragment,
) => option<'fragment>

let readInlineData: (
  ~node: fragmentNode<'a>,
  ~convertFragment: 'fragment => 'fragment,
  ~fRef: 'b,
) => 'fragment

let read: (
  ~node: fragmentNode<'a>,
  ~convertFragment: 'fragment => 'fragment,
  ~fRef: 'b,
) => 'fragment

type paginationLoadMoreOptions = {onComplete?: Js.Nullable.t<Js.Exn.t> => unit}

type paginationLoadMoreFn = (~count: int, ~onComplete: option<Js.Exn.t> => unit=?) => Disposable.t

type paginationBlockingFragmentReturn<'fragment, 'refetchVariables> = {
  data: 'fragment,
  loadNext: paginationLoadMoreFn,
  loadPrevious: paginationLoadMoreFn,
  hasNext: bool,
  hasPrevious: bool,
  refetch: (
    ~variables: 'refetchVariables,
    ~fetchPolicy: fetchPolicy=?,
    ~onComplete: option<Js.Exn.t> => unit=?,
  ) => Disposable.t,
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

let usePaginationFragment: (
  ~node: fragmentNode<'a>,
  ~fRef: 'b,
  ~convertFragment: 'fragment => 'fragment,
  ~convertRefetchVariables: 'refetchVariables => 'refetchVariables,
) => paginationFragmentReturn<'fragment, 'refetchVariables>

let useBlockingPaginationFragment: (
  ~node: fragmentNode<'a>,
  ~fRef: 'b,
  ~convertFragment: 'fragment => 'fragment,
  ~convertRefetchVariables: 'refetchVariables => 'refetchVariables,
) => paginationBlockingFragmentReturn<'fragment, 'refetchVariables>

let useRefetchableFragment: (
  ~node: fragmentNode<'a>,
  ~convertFragment: 'fragment => 'fragment,
  ~convertRefetchVariables: 'refetchVariables => 'refetchVariables,
  ~fRef: 'b,
) => (
  'fragment,
  (
    ~variables: 'refetchVariables,
    ~fetchPolicy: fetchPolicy=?,
    ~onComplete: option<Js.Exn.t> => unit=?,
  ) => Disposable.t,
)
