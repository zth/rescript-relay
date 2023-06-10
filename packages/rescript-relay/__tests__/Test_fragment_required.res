module Query = %relay(`
    query TestFragmentRequiredQuery {
      loggedInUser {
        ...TestFragmentRequired_user   
      }
      users {
        edges {
          node {
            id
            ...TestFragmentRequiredPlural_user
          }
        }
      }
    }
`)

module Fragment = %relay(`
    fragment TestFragmentRequired_user on User {
      onlineStatus @required(action: NONE)
    }
`)

module FragmentPlural = %relay(`
    fragment TestFragmentRequiredPlural_user on User @relay(plural: true) {
      onlineStatus @required(action: NONE)
    }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=(), ())
    let data = Fragment.use(query.loggedInUser.fragmentRefs)
    let users = switch query {
    | {users: Some({edges: Some(edges)})} =>
      edges->Belt.Array.keepMap(edge =>
        switch edge {
        | Some({node: Some(node)}) => Some(node.fragmentRefs)
        | _ => None
        }
      )
    | _ => []
    }

    let dataPlural = FragmentPlural.use(users)
    let pluralNonNullCount =
      dataPlural->Belt.Array.keep(item => item->Belt.Option.isSome)->Belt.Array.length
    let pluralNullCount =
      dataPlural->Belt.Array.keep(item => item->Belt.Option.isNone)->Belt.Array.length

    <div>
      <div className="plain">
        {switch data {
        | None => React.string("Plain fragment: not found")
        | Some(fragment) =>
          React.string(
            "Plain fragment: " ++
            switch fragment.onlineStatus {
            | Online => "Online"
            | Idle => "Idle"
            | Offline => "Offline"
            | FutureAddedValue(_) => "-"
            },
          )
        }}
      </div>
      <div className="plural">
        <div> {React.string("Non null count: " ++ Js.Int.toString(pluralNonNullCount))} </div>
        <div> {React.string("Null count: " ++ Js.Int.toString(pluralNullCount))} </div>
        <div>
          {React.string(
            "Users: " ++
            dataPlural
            ->Belt.Array.keepMap(item =>
              switch item {
              | None => None
              | Some(user) =>
                Some(
                  switch user.onlineStatus {
                  | Online => "Online"
                  | Idle => "Idle"
                  | Offline => "Offline"
                  | FutureAddedValue(_) => "-"
                  },
                )
              }
            )
            ->Js.Array2.joinWith(", "),
          )}
        </div>
      </div>
    </div>
  }
}

@live
let test_fragment_required = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
