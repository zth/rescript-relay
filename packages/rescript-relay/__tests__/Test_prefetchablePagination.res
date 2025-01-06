module Query = %relay(`
  query TestPrefetchablePaginationQuery {
    loggedInUser {
      ...TestPrefetchablePagination_user
    }
  }
`)

module Fragment = %relay(`
    fragment TestPrefetchablePagination_user on User
      @refetchable(queryName: "TestPrefetchablePaginationRefetchQuery")
      @argumentDefinitions(
        count: { type: "Int", defaultValue: 2 }
        cursor: { type: "String" }
      ) {
      friendsConnection(
        first: $count
        after: $cursor
      ) @connection(key: "TestPrefetchablePagination_friendsConnection", prefetchable_pagination: true) {
        edges {
          node {
            id
          }
        }
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())
    let {edges, hasNext, isLoadingNext, loadNext} = Fragment.usePrefetchableForwardPagination(
      query.loggedInUser.fragmentRefs,
      ~bufferSize=2,
    )

    Js.log(edges)

    <div>
      <div>
        {edges
        ->Belt.Array.keepMap(({node}) => node)
        ->Belt.Array.map(friend => friend.id)
        ->Js.Array2.joinWith(", ")
        ->React.string}
      </div>
      {hasNext
        ? <button onClick={_ => loadNext(~count=2)->RescriptRelay.Disposable.ignore}>
            {React.string(isLoadingNext ? "Loading..." : "Load more")}
          </button>
        : React.null}
    </div>
  }
}

@live
let test_prefetchablePagination = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
