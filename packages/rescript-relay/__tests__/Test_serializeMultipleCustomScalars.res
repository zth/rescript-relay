module Mutation = %relay(`
    mutation TestSerializeMultipleCustomScalarsMutation($input: SerializeMultipleCustomScalars!) {
      serializeMultipleCustomScalars(input: $input)
    }
`)

module Test = {
  @react.component
  let make = () => {
    let (mutate, isMutating) = Mutation.use()

    <div>
      <button
        onClick={_ => {
          mutate(
            ~variables={
              input: {
                os1s: [{a: "x"}],
                os2: {a: "y"},
              },
            },
          )->ignore
        }}>
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
let test_serializeMultipleCustomScalars = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
