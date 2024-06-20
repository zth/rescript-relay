module Query = %relay(`
  query TestRelayResolversAllQuery {
    localUser {
      name
      nameRepeated(times: 2)
      meta @required(action: NONE) { 
        online
      }
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let data = Query.use(~variables=(), ~fetchPolicy=StoreOnly)

    <div>
      {switch data.localUser {
      | Some({meta: {online: Some(online)}, name: Some(name), nameRepeated: Some(nameRepeated)}) =>
        React.string(name ++ " is " ++ (online ? "online" : "offline") ++ ", " ++ nameRepeated)
      | _ => React.string("No user...")
      }}
    </div>
  }
}

@live
let test_relayResolversAll = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.makeLiveStore(~source=RescriptRelay.RecordSource.make()),
  )

  RescriptRelay.relayFeatureFlags.enableRelayResolvers = true

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
