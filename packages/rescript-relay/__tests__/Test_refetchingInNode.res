module Query = %relay(`
    query TestRefetchingInNodeQuery($userId: ID!, $friendsOnlineStatuses: [OnlineStatus!]) {
      node(id: $userId) {
        ... on User {
          ...TestRefetchingInNode_user @arguments(friendsOnlineStatuses: $friendsOnlineStatuses)
        }
      }
    }
`)

module Fragment = %relay(`
    fragment TestRefetchingInNode_user on User
      @refetchable(queryName: "TestRefetchingInNodeRefetchQuery")
      @argumentDefinitions(
        showOnlineStatus: { type: "Boolean", defaultValue: false }
        friendsOnlineStatuses: { type: "[OnlineStatus!]"}
      ) {
      firstName
      onlineStatus @include(if: $showOnlineStatus)
      friendsConnection(statuses: $friendsOnlineStatuses) {
        totalCount
      }
    }
`)

module UserDisplayer = {
  @react.component
  let make = (~queryRef) => {
    let (data, refetch) = Fragment.useRefetchable(queryRef)

    let (_, startTransition) = React.useTransition()

    <div>
      {React.string(
        data.firstName ++
        (" is " ++
        switch data.onlineStatus {
        | Some(Online) => "online"
        | _ => "-"
        }),
      )}
      <div> {React.string("Friends: " ++ data.friendsConnection.totalCount->Int.toString)} </div>
      <button
        onClick={_ => {
          startTransition(() => {
            refetch(
              ~variables=Fragment.makeRefetchVariables(
                ~showOnlineStatus=Some(true),
                ~friendsOnlineStatuses=None,
              ),
            )->RescriptRelay.Disposable.ignore
          })
        }}
      >
        {React.string("Fetch online status")}
      </button>
    </div>
  }
}

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables={userId: "user-1", friendsOnlineStatuses: [Online]})

    switch query.node {
    | Some(User(user)) => <UserDisplayer queryRef=user.fragmentRefs />
    | _ => React.string("-")
    }
  }
}

@live
let test_refetching = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
