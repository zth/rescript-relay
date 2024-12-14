module Query = %relay(`
  query TestNonReactQuery {
    loggedInUser {
      firstName
      ...TestNonReact_user
    }
  }
`)

module Fragment = %relay(`
  fragment TestNonReact_user on User {
    firstName
    onlineStatus
  }
`)

@live
let test_nonReact = async () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  let query = await Query.fetchPromised(~environment, ~variables=())
  let fragmentData = await Fragment.waitForFragmentData(
    ~environment,
    query.loggedInUser.fragmentRefs,
  )

  {
    "waitForFragmentData": fragmentData,
  }
}
