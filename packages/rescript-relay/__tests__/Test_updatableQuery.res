module Query = %relay(`
  query TestUpdatableQuery($id: ID!) {
    user(id: $id) {
      firstName
      isOnline
      bestFriend {
        firstName
      }
    }      
  }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables={id: "user-1"})
    let environment = RescriptRelay.useEnvironmentFromContext()

    switch query.user {
    | Some({firstName, isOnline, bestFriend}) =>
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
              module UpdatableQuery = %relay(`
                query TestUpdatableQuery_UpdatableQuery($id: ID!) @updatable {
                  user(id: $id) {
                    firstName
                    isOnline
                    bestFriend {
                      firstName
                    }
                  }
                }
              `)
              let {updatableData} = UpdatableQuery.readUpdatableQuery(store, {id: "user-1"})

              switch updatableData.user {
              | Value(user) =>
                user.isOnline = Value(true)
                user.firstName = "Mrmr"
                switch user.bestFriend {
                | Value(bestFriend) => bestFriend.firstName = "Newton"
                | Null | Undefined => ()
                }
              | Null | Undefined => ()
              }
            })
          }}
        >
          {React.string("Change status")}
        </button>
      </div>
    | None => React.null
    }
  }
}

@live
let test_updatableQuery = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
