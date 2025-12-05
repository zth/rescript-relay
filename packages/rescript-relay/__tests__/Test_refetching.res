module Query = %relay(`
    query TestRefetchingQuery($beforeDate: Datetime, $number: Number, $showOnlineStatus: Boolean!) {
      loggedInUser {
        ...TestRefetching_user @arguments(
          beforeDate: $beforeDate
          number: $number
          showOnlineStatus: $showOnlineStatus
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
        number: { type: "Number" }
      ) {
      firstName
      onlineStatus @include(if: $showOnlineStatus)
      friendsConnection(statuses: $friendsOnlineStatuses) {
        totalCount
      }
      friends(beforeDate: $beforeDate, number: $number) {
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
        beforeDate: Date.fromString("2023-01-01T00:00:00.000Z"),
        showOnlineStatus: true,
        number: [10],
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
      <div> {React.string("Friends: " ++ data.friendsConnection.totalCount->Int.toString)} </div>
      <button
        onClick={_ => {
          startTransition(() => {
            refetch(
              ~variables=Fragment.makeRefetchVariables(
                ~friendsOnlineStatuses=Some([Online, Offline]),
                ~beforeDate=None,
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
