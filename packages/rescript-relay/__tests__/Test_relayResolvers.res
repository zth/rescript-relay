RescriptRelay.relayFeatureFlags.enableRelayResolvers = true

module Query = %relay(`
    query TestRelayResolversQuery {
      loggedInUser {  
        ...TestRelayResolvers_user
      }
    }
`)

module Fragment = %relay(`
    fragment TestRelayResolvers_user on User {
      isOnline
      fullName
    }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=(), ())
    let data = Fragment.use(query.loggedInUser.fragmentRefs)

    <div>
      {switch data {
      | {isOnline: Some(isOnline), fullName: Some(fullName)} =>
        React.string(`${fullName} is ${isOnline ? "online" : "offline"}`)
      | _ => React.string("-")
      }}
    </div>
  }
}

@live
let test_relayResolvers = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
