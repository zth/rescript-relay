module Mutation = %relay(`
    mutation TestSerializeCustomScalarArrayMutation($input: [IntString!]!) {
      serializeCustomScalarArray(input: $input) {
        works
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let (mutate, isMutating) = Mutation.use()

    <div>
      <button
        onClick={_ => {
          mutate(~variables={input: [97, 98, 99]})->ignore
        }}
      >
        {React.string("Fire mutation")}
      </button>
      {if isMutating {
        React.string("Mutating...")
      } else {
        React.null
      }}
    </div>
  }
}

@live
let test_serializeCustomScalarArray = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
