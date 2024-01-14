module Query = %relay(`
  query TestArrayIntStringCustomScalarsQuery {
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

    let intStrings = query.loggedInUser.intStrings->Belt.Option.getWithDefault([])
    let intString = query.loggedInUser.intString
    let justStrings = query.loggedInUser.justStrings->Belt.Option.getWithDefault([])
    let justString = query.loggedInUser.justString

    <>
      <div>
        {intStrings
        ->Belt.Array.map(Belt.Int.toString(_))
        ->Js.Array2.joinWith(", ")
        ->React.string}
      </div>
      <div>
        {intString
        ->Belt.Option.map(React.int(_))
        ->Belt.Option.getWithDefault(React.null)}
      </div>
      <div>
        {justStrings
        ->Js.Array2.joinWith(", ")
        ->React.string}
      </div>
      <div>
        {justString
        ->Belt.Option.map(React.string(_))
        ->Belt.Option.getWithDefault(React.null)}
      </div>
    </>
  }
}

@live
let test_arrayIntStringCustomScalars = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
