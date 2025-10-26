module Query = %relay(`
    query TestNullableVariablesQuery {
      loggedInUser {
        avatarUrl
      }
    }
`)

module Mutation = %relay(`
    mutation TestNullableVariablesMutation($avatarUrl: String, $someInput: SomeInput) @rescriptRelayNullableVariables {
      updateUserAvatar(avatarUrl: $avatarUrl) {
        user {
          avatarUrl
          someRandomArgField(someInput: $someInput)
        }
      }
    }
`)

module Test = {
  @react.component
  let make = () => {
    let environment = RescriptRelay.useEnvironmentFromContext()
    let query = Query.use(~variables=())
    let data = query.loggedInUser

    <div>
      {React.string("Avatar url is " ++ data.avatarUrl->Belt.Option.getWithDefault("-"))}
      <button
        onClick={_ => {
          Mutation.commitMutation(
            ~environment,
            ~variables={
              avatarUrl: Null.null,
              someInput: Null.make({
                RelaySchemaAssets_graphql.int: Null.null,
              }),
            },
          )->RescriptRelay.Disposable.ignore
        }}
      >
        {React.string("Change avatar URL")}
      </button>
    </div>
  }
}

@live
let test_nullableVariables = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
