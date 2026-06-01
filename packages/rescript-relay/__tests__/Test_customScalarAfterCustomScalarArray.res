module Query = %relay(`
  query TestCustomScalarAfterCustomScalarArrayQuery {
    loggedInUser {
      intStrings
      createdAt
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())

    // `createdAt` is `Datetime!` (a `c` custom scalar). The conversion path
    // through `Datetime.parse` turns the wire string into a `Date.t`.
    // When the bug fires (`ca` for `intStrings` exits the loop early),
    // `Datetime.parse` is never called and `createdAt` reaches us as the
    // raw wire string. Calling `Date.getTime` on a string crashes; calling
    // it on a Date returns a number. The text we render either equals the
    // expected timestamp (parsed) or never appears (unparsed).
    <div>
      {React.string(
        "createdAt: " ++ query.loggedInUser.createdAt->Date.getTime->Float.toString,
      )}
    </div>
  }
}

@live
let test_customScalarAfterCustomScalarArray = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
