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

      # Custom scalar array
      intStrArr: { type: "[IntString!]!", provider: "ProvidedVariables.IntStrArr" }
    ) {
    someRandomArgField(bool: $bool, inputC: $inputC, inputCArr: $inputCArr, intStr: $intStr, intStrArr: $intStrArr)
  }
`)

module Query = %relay(`
  query TestProvidedVariablesQuery {
      loggedInUser {
        ...TestProvidedVariables_user
      }
    }
`)

module TestPreloaded = {
  @react.component
  let make = (~queryRef) => {
    let query = Query.usePreloaded(~queryRef)
    let user = Fragment.use(query.loggedInUser.fragmentRefs)

    <div>
      {React.string(
        "Preloaded provided variable: " ++ user.someRandomArgField->Option.getOr("-"),
      )}
    </div>
  }
}

module Test = {
  @react.component
  let make = () => {
    let environment = RescriptRelayReact.useEnvironmentFromContext()
    let query = Query.use(~variables=())
    let user = Fragment.use(query.loggedInUser.fragmentRefs)
    let (queryRefFromModule, setQueryRefFromModule) = React.useState(() => None)
    let (fetchedStatus, setFetchedStatus) = React.useState(() => "-")
    let (retainedStatus, setRetainedStatus) = React.useState(() => "-")
    let (loadedQueryRef, loadQuery, _dispose) = Query.useLoader()

    <div>
      <div> {React.string(user.someRandomArgField->Option.getOr("-"))} </div>
      <div> {React.string("Provided variable fetch status: " ++ fetchedStatus)} </div>
      <div> {React.string("Provided variable retain status: " ++ retainedStatus)} </div>
      <button
        onClick={_ =>
          setQueryRefFromModule(_ => Some(
            TestProvidedVariablesQuery_graphql.load(
              ~environment,
              ~variables=(),
              ~fetchPolicy=NetworkOnly,
            ),
          ))}
      >
        {React.string("Test provided variable raw load")}
      </button>
      <button onClick={_ => loadQuery(~variables=(), ~fetchPolicy=NetworkOnly)}>
        {React.string("Test provided variable query loader")}
      </button>
      <button
        onClick={_ =>
          Query.fetch(~environment, ~variables=(), ~onResult=result =>
            switch result {
            | Ok(_) => setFetchedStatus(_ => "fetch")
            | Error(_) => setFetchedStatus(_ => "fetch error")
            }
          )}
      >
        {React.string("Test provided variable fetch")}
      </button>
      <button
        onClick={_ => {
          let _ =
            Query.fetchPromised(~environment, ~variables=())->Promise.thenResolve(_ =>
              setFetchedStatus(_ => "fetch promised")
            )
        }}
      >
        {React.string("Test provided variable fetch promised")}
      </button>
      <button
        onClick={_ => {
          Query.retain(~environment, ~variables=())->RescriptRelay.Disposable.dispose
          setRetainedStatus(_ => "retained")
        }}
      >
        {React.string("Test provided variable retain")}
      </button>
      {switch (queryRefFromModule, loadedQueryRef) {
      | (_, Some(queryRef)) | (Some(queryRef), _) => <TestPreloaded queryRef />
      | _ => React.null
      }}
    </div>
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
