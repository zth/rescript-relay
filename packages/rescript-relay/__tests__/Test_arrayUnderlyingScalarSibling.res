// `Number` is a custom scalar whose ReScript representation is an array
// (`type number = array<int>`). At wire-encode time `traverse`
// (utils.js) hits the `c` branch at lines 134-138 — the one introduced
// by PR #434 to close issue #407 — because the value is an array even
// though the schema-level type is a single scalar.
//
// relay-compiler sorts the generated `variables` record fields
// alphabetically, so this test prefixes the array-backed variable with
// `aa` to force it to be iterated before `beforeDate`. Without the fix
// in this PR (#631), the `aaNumber` branch returns early and
// `Datetime.serialize` is never called for `beforeDate`.
module Query = %relay(`
  query TestArrayUnderlyingScalarSiblingQuery(
    $aaNumber: Number!
    $beforeDate: Datetime
  ) {
    loggedInUser {
      friends(number: $aaNumber, beforeDate: $beforeDate) {
        id
      }
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let _ = Query.use(
      ~variables={
        aaNumber: [1, 2, 3],
        beforeDate: Date.fromTime(0.),
      },
    )

    React.string("rendered")
  }
}

@live
let test_arrayUnderlyingScalarSibling = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
