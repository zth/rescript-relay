module Query = %relay(`
  query TestPreloadedQuery($status: OnlineStatus) @preloadable {
    loggedInUser {
      ...TestPreloadedQueryProvidedVariables_user
    }
    users(status: $status) {
      edges {
        node {
          id
          firstName
          onlineStatus
        }
      }
    }
  }
`)

module Fragment = %relay(`
  fragment TestPreloadedQueryProvidedVariables_user on User
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

module TestPreloaded = {
  @react.component
  let make = (~queryRef) => {
    let query = Query.usePreloaded(~queryRef)
    let users = switch query {
    | {users: Some({edges: Some(edges)})} =>
      edges->Array.filterMap(edge =>
        switch edge {
        | Some({node}) => node
        | _ => None
        }
      )
    | _ => []
    }

    <div>
      {users
      ->Array.map(user =>
        <div key=user.id>
          {React.string(
            "Preloaded " ++
            (user.firstName ++
            (" is " ++
            switch user.onlineStatus {
            | Some(Idle) => "idle"
            | _ => "-"
            })),
          )}
        </div>
      )
      ->React.array}
    </div>
  }
}

module Test = {
  @react.component
  let make = () => {
    let (queryRef, setQueryRef) = React.useState(() => None)
    let environment = RescriptRelay.useEnvironmentFromContext()

    React.useEffect0(() => {
      setQueryRef(_ => Some(
        TestPreloadedQuery_preloadable_graphql.load(~environment, ~variables={status: Online}),
      ))
      None
    })

    <div>
      {switch queryRef {
      | None => React.null
      | Some(queryRef) =>
        <React.Suspense fallback={React.null}>
          <TestPreloaded queryRef />
        </React.Suspense>
      }}
    </div>
  }
}

@live
let test_preloadedQuery = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
