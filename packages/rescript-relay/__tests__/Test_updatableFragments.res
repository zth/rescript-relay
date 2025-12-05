module Query = %relay(`
    query TestUpdatableFragmentsQuery {
      ...TestUpdatableFragments_query
      loggedInUser {
        firstName
      }
    }
`)

module Fragment = %relay(`
  fragment TestUpdatableFragments_query on Query {
    loggedInUser {
      firstName
      isOnline
      ...TestUpdatableFragments_updatableUser
      bestFriend {
        firstName
      }
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())
    let environment = RescriptRelayReact.useEnvironmentFromContext()
    let {loggedInUser: {firstName, isOnline, updatableFragmentRefs, bestFriend}} = Fragment.use(
      query.fragmentRefs,
    )

    let bestFriendsName = switch bestFriend {
    | None => "-"
    | Some({firstName}) => firstName
    }

    <div>
      {React.string(
        `${firstName} is ${isOnline->Option.getOr(false)
            ? "online"
            : "offline"} and best friends with ${bestFriendsName}`,
      )}
      <button
        onClick={_ => {
          RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
            module UpdatableFragment = %relay(`
                fragment TestUpdatableFragments_updatableUser on User @updatable {
                    isOnline
                    firstName
                    bestFriend {
                        firstName
                    }
                }
            `)

            let {updatableData} = UpdatableFragment.readUpdatableFragment(
              store,
              updatableFragmentRefs,
            )

            updatableData.isOnline = Value(true)
            updatableData.firstName = "Mrmr"

            switch updatableData.bestFriend {
            | Value(bestFriend) => bestFriend.firstName = "Newton"
            | Undefined | Null => ()
            }
          })
        }}
      >
        {React.string("Change status")}
      </button>
    </div>
  }
}

@live
let test_updatableFragments = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
