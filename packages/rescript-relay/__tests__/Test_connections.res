module Fragment = %relay(`
  fragment TestConnections_user on User
    @argumentDefinitions(
      onlineStatuses: { type: "[OnlineStatus!]", defaultValue: [Idle] }
      count: { type: "Int", defaultValue: 2 }
      cursor: { type: "String", defaultValue: "" }
      beforeDate: { type: "Datetime!" }
    ) {
    __id
    friendsConnection(
      statuses: $onlineStatuses
      first: $count
      after: $cursor
      beforeDate: $beforeDate
    ) @connection(key: "TestConnections_user_friendsConnection") {
      edges {
        node {
          id
        }
      }
    }
  }
`)

module Query = %relay(`
  query TestConnectionsQuery($beforeDate: Datetime!) {
      loggedInUser {
        ...TestConnections_user @arguments(beforeDate: $beforeDate)
      }
    }
`)

module AddFriendMutation = %relay(`
    mutation TestConnections_AddFriendMutation($friendId: ID!, $connections: [ID!]!) {
      addFriend(friendId: $friendId) {
        addedFriend @appendNode(edgeTypeName: "UserEdge", connections: $connections) {
          id
        }
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let makeDate = () =>
      Js.Date.makeWithYMDHMS(
        ~date=1.,
        ~hours=1.,
        ~minutes=0.,
        ~month=0.,
        ~seconds=0.,
        ~year=2022.,
        (),
      )

    let query = Query.use(
      ~variables={
        beforeDate: makeDate(),
      },
      (),
    )
    let user = Fragment.use(query.loggedInUser.fragmentRefs)
    let friends = user.friendsConnection->Fragment.getConnectionNodes
    let (addFriend, _isAddingFriend) = AddFriendMutation.use()

    <div>
      {friends
      ->Belt.Array.map(friend => <div key=friend.id> {React.string(friend.id)} </div>)
      ->React.array}
      <button
        onClick={_ => {
          let _: RescriptRelay.Disposable.t = addFriend(
            ~variables=AddFriendMutation.makeVariables(
              ~connections={
                open TestConnections_user_graphql
                [user.__id->makeConnectionId(~beforeDate=makeDate(), ())]
              },
              ~friendId="123",
            ),
            (),
          )
        }}>
        {React.string("Add friend")}
      </button>
    </div>
  }
}

@live
let test_connections = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
