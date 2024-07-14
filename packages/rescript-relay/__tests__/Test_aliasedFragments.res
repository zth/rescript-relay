module FragmentFirstName = %relay(`
  fragment TestAliasedFragments_userFirstName on User {
    firstName
  }
`)

module FragmentLastName = %relay(`
  fragment TestAliasedFragments_userLastName on User {
    lastName
  }
`)

module Query = %relay(`
    query TestAliasedFragmentsQuery($skipThing: Boolean!) {
      loggedInUser {
        ...TestAliasedFragments_userFirstName @alias
        ...TestAliasedFragments_userLastName @alias @skip(if: $skipThing)
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables={skipThing: false})
    let firstNameData = FragmentFirstName.use(query.loggedInUser.testAliasedFragments_userFirstName)
    let lastNameData = FragmentLastName.useOpt(query.loggedInUser.testAliasedFragments_userLastName)

    <div>
      {React.string(
        firstNameData.firstName ++
        " " ++
        switch lastNameData {
        | None => "-"
        | Some({lastName}) => lastName
        },
      )}
    </div>
  }
}

@live
let test_aliasedFragments = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
