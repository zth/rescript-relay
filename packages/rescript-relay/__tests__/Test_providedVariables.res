module Fragment = %relay(`
  fragment TestProvidedVariables_user on User
    @argumentDefinitions(
      # Regular unconverted value
      bool: { type: "Boolean!", provider: "ProvidedVariables.Bool" }

      # Recursive input with custom scalar
      inputC: { type: "InputC!", provider: "ProvidedVariables.InputC" }

      # Array of recursive input with custom scalar
      inputCArr: { type: "[InputC!]", provider: "ProvidedVariables.InputCArr" }

      # Custom scalar
      intStr: { type: "IntString!", provider: "ProvidedVariables.IntStr" }
    ) {
    someRandomArgField(bool: $bool, inputC: $inputC, inputCArr: $inputCArr, intStr: $intStr)
  }
`)

module Query = %relay(`
  query TestProvidedVariablesQuery {
      loggedInUser {
        ...TestProvidedVariables_user
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())
    let user = Fragment.use(query.loggedInUser.fragmentRefs)

    <div> {React.string(user.someRandomArgField->Belt.Option.getWithDefault("-"))} </div>
  }
}

@live
let test_providedVariables = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
