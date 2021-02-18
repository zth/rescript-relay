module Query = %relay(
  `
    query TestNodeInterfaceQuery {
      node(id: "123") {
        __typename
        ... on User {
          firstName
        }
      }
    }
`
)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=(), ())

    switch query.node {
    | Some(user) => React.string(user.firstName)
    | None => React.string("-")
    }
  }
}

let test_nodeInterface = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
