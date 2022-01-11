module Query = %relay(`
    query TestPaginationInNodeQuery($userId: ID!) {
      node(id: $userId) {
        id
        ... on User {
          ...TestPaginationInNode_query
        }
      }
    }
`)

// This is just to ensure that fragments on unions work
module UserFragment = %relay(`
  fragment TestPaginationInNode_user on User {
    id
    firstName
    friendsConnection(first: 1) {
      totalCount
    }
  }
`)

module Fragment = %relay(`
    fragment TestPaginationInNode_query on User
      @refetchable(queryName: "TestPaginationInNodeRefetchQuery")
      @argumentDefinitions(
        onlineStatuses: { type: "[OnlineStatus!]" }
        count: { type: "Int", defaultValue: 2 }
        cursor: { type: "String", defaultValue: "" }
      ) {
      friendsConnection(
        statuses: $onlineStatuses
        first: $count
        after: $cursor
      ) @connection(key: "TestPaginationInNode_friendsConnection") {
        edges {
          node {
            id
            ...TestPaginationInNode_user
          }
        }
      }
    }
`)

module UserDisplayer = {
  @react.component
  let make = (~user) => {
    let data = UserFragment.use(user)

    React.string(
      "User " ++
      (data.firstName ++
      (" has " ++ (data.friendsConnection.totalCount->string_of_int ++ " friends"))),
    )
  }
}

module UserNodeDisplayer = {
  @react.component
  let make = (~queryRef) => {
    let (_, startTransition) = ReactExperimental.useTransition()

    let {data, hasNext, loadNext, isLoadingNext, refetch} = Fragment.usePagination(queryRef)

    <div>
      {data.friendsConnection
      ->Fragment.getConnectionNodes
      ->Belt.Array.map(user => <div key=user.id> <UserDisplayer user=user.fragmentRefs /> </div>)
      ->React.array}
      {hasNext
        ? <button
            onClick={_ =>
              startTransition(() =>
                loadNext(
                  ~count=2,
                  ~onComplete=x =>
                    switch x {
                    | Some(e) => Js.Console.error(e)
                    | None => ()
                    },
                  (),
                ) |> ignore
              )}>
            {React.string(isLoadingNext ? "Loading..." : "Load more")}
          </button>
        : React.null}
      <button
        onClick={_ =>
          startTransition(() => {
            let _ = refetch(
              ~variables=Fragment.makeRefetchVariables(~onlineStatuses=[#Online, #Idle], ()),
              (),
            )
          })}>
        {React.string("Refetch connection")}
      </button>
    </div>
  }
}

module Test = {
  @react.component
  let make = () => {
    let userId = "123"
    let query = Query.use(~variables={userId: userId}, ())
    switch query.node {
    | Some(node) => <UserNodeDisplayer queryRef=node.fragmentRefs />
    | None => React.string("-")
    }
  }
}

@live
let test_pagination = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
