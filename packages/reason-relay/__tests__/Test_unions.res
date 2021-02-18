module Query = %relay(
  `
  query TestUnionsQuery {
    members(groupId: "123") {
      edges {
        node {
          __typename
          ... on User {
            id
            firstName
            onlineStatus
          }

          ... on Group {
            id
            name
            avatarUrl
            members {
                __typename
                ... on User {
                    id
                    firstName
                    onlineStatus
                }
                ... on Group {
                    id
                    name
                    avatarUrl
                }
            }
          }
        }
      }
    }
  }
`
)

let mapOnlineStatus = (s: option<Query.Types.enum_OnlineStatus>) =>
  switch s {
  | Some(#Online) => "online"
  | Some(#Offline) => "offline"
  | Some(#Idle) => "idle"
  | Some(_) => "-"
  | None => "[no status]"
  }

let printUser = (firstName, onlineStatus) => firstName ++ (" is " ++ onlineStatus->mapOnlineStatus)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=(), ())

    <div>
      {switch query {
      | {members: Some({edges: Some(edges)})} => edges->Belt.Array.keepMap(edge =>
          switch edge {
          | Some({node: Some(node)}) => Some(node)
          | _ => None
          }
        )
      | _ => []
      }
      ->Belt.Array.map(x =>
        switch x {
        | #User(user) =>
          <div key=user.id>
            {React.string("First level: " ++ printUser(user.firstName, user.onlineStatus))}
          </div>
        | #Group(group) =>
          <div key=group.id>
            {React.string(
              "First level: " ++
              (group.name ++
              (" with avatarUrl " ++ group.avatarUrl->Belt.Option.getWithDefault("[no avatar]"))),
            )}
            {group.members->Belt.Option.getWithDefault([])->Belt.Array.map(x =>
              switch x {
              | Some(#User(user)) =>
                <div key=user.id>
                  {React.string("Second level: " ++ printUser(user.firstName, user.onlineStatus))}
                </div>
              | Some(#Group(g)) =>
                <div key=g.id>
                  {React.string(
                    group.name ++
                    (" - Second level: " ++
                    (g.name ++
                    (" with avatarUrl " ++
                    g.avatarUrl->Belt.Option.getWithDefault("[no avatar]")))),
                  )}
                </div>
              | Some(#UnselectedUnionMember(_)) | None => React.null
              }
            )->React.array}
          </div>
        | #UnselectedUnionMember(_) => React.null
        }
      )
      ->React.array}
    </div>
  }
}

let test_unions = () => {
  let network = ReasonRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = ReasonRelay.Environment.make(
    ~network,
    ~store=ReasonRelay.Store.make(~source=ReasonRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
