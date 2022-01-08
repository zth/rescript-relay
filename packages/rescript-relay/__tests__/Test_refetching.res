module Query = %relay(`
    query TestRefetchingQuery {
      loggedInUser {
        ...TestRefetching_user
      }
    }
`)

module Fragment = %relay(`
    fragment TestRefetching_user on User
      @refetchable(queryName: "TestRefetchingRefetchQuery")
      @argumentDefinitions(
        friendsOnlineStatuses: { type: "[OnlineStatus!]" }
        showOnlineStatus: { type: "Boolean", defaultValue: false }
      ) {
      firstName
      onlineStatus @include(if: $showOnlineStatus)
      friendsConnection(statuses: $friendsOnlineStatuses) {
        totalCount
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
    let query = Query.use(~variables=(), ())

    let (data, refetch) = Fragment.useRefetchable(query.loggedInUser.fragmentRefs)

    let (_, startTransition) = ReactExperimental.useTransition()

    <div>
      {React.string(
        data.firstName ++
        (" is " ++
        switch data.onlineStatus {
        | Some(#Online) => "online"
        | _ => "-"
        }),
      )}
      <div> {React.string("Friends: " ++ data.friendsConnection.totalCount->string_of_int)} </div>
      <button
        onClick={_ =>
          startTransition(() => {
            let _ = refetch(
              ~variables=Fragment.makeRefetchVariables(
                ~showOnlineStatus=true,
                ~friendsOnlineStatuses=[#Online, #Offline],
                (),
              ),
              (),
            )
          })}>
        {React.string("Fetch online status")}
      </button>
    </div>
  }
}

@live
let test_refetching = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
