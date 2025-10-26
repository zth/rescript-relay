module Query = %relay(`
  query TestUnionsQuery {
    members(groupId: "123") {
      edges {
        node {
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
`)

let mapOnlineStatus = (s: option<RelaySchemaAssets_graphql.enum_OnlineStatus>) =>
  switch s {
  | Some(Online) => "online"
  | Some(Offline) => "offline"
  | Some(Idle) => "idle"
  | Some(FutureAddedValue(_)) => "-"
  | None => "[no status]"
  }

let printUser = (firstName, onlineStatus) => firstName ++ (" is " ++ onlineStatus->mapOnlineStatus)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())

    <div>
      {switch query {
      | {members: Some({edges: Some(edges)})} =>
        edges->Array.filterMap(edge =>
          switch edge {
          | Some({node: Some(node)}) => Some(node)
          | _ => None
          }
        )
      | _ => []
      }
      ->Array.map(x =>
        switch x {
        | User(user) =>
          <div key=user.id>
            {React.string("First level: " ++ printUser(user.firstName, user.onlineStatus))}
          </div>
        | Group(group) =>
          <div key=group.id>
            {React.string(
              "First level: " ++
              (group.name ++
              (" with avatarUrl " ++ group.avatarUrl->Option.getOr("[no avatar]"))),
            )}
            {group.members
            ->Option.getOr([])
            ->Array.map(x =>
              switch x {
              | Some(User(user)) =>
                <div key=user.id>
                  {React.string("Second level: " ++ printUser(user.firstName, user.onlineStatus))}
                </div>
              | Some(Group(g)) =>
                <div key=g.id>
                  {React.string(
                    group.name ++
                    (" - Second level: " ++
                    (g.name ++ (" with avatarUrl " ++ g.avatarUrl->Option.getOr("[no avatar]")))),
                  )}
                </div>
              | Some(UnselectedUnionMember(_)) | None => React.null
              }
            )
            ->React.array}
          </div>
        | UnselectedUnionMember(_) => React.null
        }
      )
      ->React.array}
    </div>
  }
}

@live
let test_unions = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
