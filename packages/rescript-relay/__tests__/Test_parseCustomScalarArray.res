module Query = %relay(`
  query TestParseCustomScalarArrayQuery {
    loggedInUser {
      intStrings
      intString
      justStrings
      justString
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let query = {
      Query.use(~variables=())
    }

    let intStrings = query.loggedInUser.intStrings->Option.getOr([])
    let intString = query.loggedInUser.intString
    let justStrings = query.loggedInUser.justStrings->Option.getOr([])
    let justString = query.loggedInUser.justString

    <>
      <div>
        {intStrings
        ->Array.map(v => v->Int.toString)
        ->Array.joinUnsafe(", ")
        ->React.string}
      </div>
      <div>
        {intString
        ->Option.map(v => v->React.int)
        ->Option.getOr(React.null)}
      </div>
      <div>
        {justStrings
        ->Array.joinUnsafe(", ")
        ->React.string}
      </div>
      <div>
        {justString
        ->Option.map(v => v->React.string)
        ->Option.getOr(React.null)}
      </div>
    </>
  }
}

@live
let test_parseCustomScalarArray = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
