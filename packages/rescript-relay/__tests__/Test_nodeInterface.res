module Fragment = %relay(`
  fragment TestNodeInterface_user on User {
    firstName
  }
`)

module Query = %relay(`
    query TestNodeInterfaceQuery {
      node(id: "123") {
        ... on User {
          firstName
          ...TestNodeInterface_user
        }
      }
    }
`)

// This should deoptimize to not collapse the node interface, since the spread
// is on an abstract type.
module QueryAbstract = %relay(`
  query TestNodeInterfaceOnAbstractTypeQuery {
    node(id: "123") {
      ... on Member {
        ... on User {
          firstName
        }
        ... on Group {
          name
        }
      }
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=(), ())

    switch query.node {
    | Some(#User(user)) => React.string(user.firstName)
    | _ => React.string("-")
    }
  }
}

@live
let test_nodeInterface = () => {
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
