module Fragment = %relay(`
  fragment TestConnections_user on User
    @argumentDefinitions(
      onlineStatuses: { type: "[OnlineStatus!]", defaultValue: [Idle, offline] }
      count: { type: "Int", defaultValue: 2 }
      cursor: { type: "String", defaultValue: "" }
      beforeDate: { type: "Datetime!" }
      test: { type: "Boolean", defaultValue: true }
      orderBy: {
        type: "[UserOrder!]"
        defaultValue: [{ direction: ASC, field: FIRST_NAME }]
      }
    ) {
    __id
    friendsConnection(
      statuses: $onlineStatuses
      first: $count
      after: $cursor
      beforeDate: $beforeDate
      orderBy: $orderBy
    ) @connection(key: "TestConnections_user_friendsConnection") @include(if: $test) {
      edges {
        node {
          id
        }
      }
    }
  }
`)

// This fragment is just to ensure that the PPX finds the nested connection
module Fragment2 = %relay(`
  fragment TestConnections2_user on Query 
    @argumentDefinitions(
      count: { type: "Int", defaultValue: 2 }
      cursor: { type: "String", defaultValue: "" }
      someInput: { type: "SomeInput" }
      datetime: { type: "Datetime", defaultValue: null }
      datetime2: { type: "Datetime" }
      datetime3: { type: "Datetime!" }
      flt: { type: "Float", defaultValue: null }
    ) {
    member(id: "123") {
      ... on User {
        friendsConnection(
          first: $count
          after: $cursor
          # Ensure null constants can be printed properly
          statuses: null
          # Use multiple items resulting in different types in the same array
          # Use the same variable multiple times
          objTests: [{str: "123"}, {bool: true}, $someInput, $someInput]
          # Different combinations of null default values, custom scalars, etc
          objTest: {
            datetime: $datetime,
            enum: offline,
            recursive: {
              float: $flt,
              datetime: $datetime2
              recursive: {
                datetime: $datetime3
              }
            }
          }
        ) @connection(key: "TestConnections2_user_member_friendsConnection") {
          edges {
            node {
              id
            }
          }
        }
      }
    }
  }
`)

module Fragment3 = %relay(`
  fragment TestConnections3_user on Query 
    @argumentDefinitions(
      count: { type: "Int", defaultValue: 2 }
      cursor: { type: "String", defaultValue: "" }
    ) {
    loggedInUser {
      friendsConnection(
        first: $count
        after: $cursor
      ) @connection(key: "TestConnectionsTest_user_user_friendsConnection") {
        edges {
          node {
            id
          }
        }
      }
    }
  }
`)

let _test = Fragment2.getConnectionNodes
let _test = Fragment3.getConnectionNodes

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
          addFriend(
            ~variables={
              connections: {
                open TestConnections_user_graphql
                [user.__id->makeConnectionId(~beforeDate=makeDate())]
              },
              friendId: "123",
            },
          )->RescriptRelay.Disposable.ignore
        }}>
        {React.string("Add friend")}
      </button>
    </div>
  }
}

@live
let test_connections = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
