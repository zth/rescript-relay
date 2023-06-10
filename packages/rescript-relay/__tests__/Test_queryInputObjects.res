module Query = %relay(`
  query TestQueryInputObjectsQuery($input: SearchInput!) {
    search(input: $input)
  }
`)

module Test = {
  @react.component
  let make = () => {
    let data = Query.use(~variables={input: {id: 123, someOtherId: 1.5}}, ())

    <div>
      {switch data.search {
      | None => React.string("-")
      | Some(search) => React.string(search)
      }}
    </div>
  }
}

@live
let test_queryInputObjects = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
