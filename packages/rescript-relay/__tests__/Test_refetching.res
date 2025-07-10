module Query = %relay(`
    query TestRefetchingQuery($beforeDate: Datetime) {
      loggedInUser {
        ...TestRefetching_user @arguments(
          beforeDate: $beforeDate
        )
      }
    }
`)

module Fragment = %relay(`
    fragment TestRefetching_user on User
      @refetchable(queryName: "TestRefetchingRefetchQuery")
      @argumentDefinitions(
        friendsOnlineStatuses: { type: "[OnlineStatus!]" }
        showOnlineStatus: { type: "Boolean", defaultValue: false }
        beforeDate: { type: "Datetime" }
      ) {
      firstName
      onlineStatus @include(if: $showOnlineStatus)
      friendsConnection(statuses: $friendsOnlineStatuses) {
        totalCount
      }
      friends(beforeDate: $beforeDate) {
        id
      }
    }
`)

module FragmentWithNoArgs = %relay(`
    fragment TestRefetchingNoArgs_query on Query
      @refetchable(queryName: "TestRefetchingNoArgsRefetchQuery")
      {
      loggedInUser {
        id
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(
      ~variables={
        beforeDate: Js.Date.fromString("2023-01-01T00:00:00.000Z"),
      },
    )

    let (data, refetch) = Fragment.useRefetchable(query.loggedInUser.fragmentRefs)

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
      <div> {React.string("Friends: " ++ data.friendsConnection.totalCount->string_of_int)} </div>
      <button
        onClick={_ => {
          startTransition(() => {
            refetch(
              ~variables=Fragment.makeRefetchVariables(
                ~showOnlineStatus=Some(true),
                ~friendsOnlineStatuses=Some([Online, Offline]),
                ~beforeDate=None,
              ),
            )->RescriptRelay.Disposable.ignore
          })
        }}>
        {React.string("Fetch online status")}
      </button>
    </div>
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
