module Query = %relay(`
    query TestUpdatableFragmentsQuery {
      ...TestUpdatableFragments_query
      loggedInUser {
        firstName
      }
    }
`)

module Fragment = %relay(`
  fragment TestUpdatableFragments_query on Query {
    loggedInUser {
      firstName
      isOnline
      ...TestUpdatableFragments_updatableUser
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())
    let environment = RescriptRelay.useEnvironmentFromContext()
    let {loggedInUser: {firstName, isOnline, updatableFragmentRefs}} = Fragment.use(
      query.fragmentRefs,
    )

    <div>
      {React.string(
        `${firstName} is ${isOnline->Belt.Option.getWithDefault(false) ? "online" : "offline"}`,
      )}
      <button
        onClick={_ => {
          RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
            module UpdatableFragment = %relay(`
                fragment TestUpdatableFragments_updatableUser on User @updatable {
                    isOnline
                    firstName
                }
            `)

            let {updatableData} = UpdatableFragment.readUpdatableFragment(
              store,
              updatableFragmentRefs,
            )

            updatableData.isOnline = Value(true)
            updatableData.firstName = "Mrmr"
          })
        }}>
        {React.string("Change status")}
      </button>
    </div>
  }
}

@live
let test_updatableFragments = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
