module Query = %relay(`
  query TestInputUnionQuery($location: Location!) {
    findByLocation(location: $location)
  }
`)

module Test = {
  @react.component
  let make = () => {
    let data = Query.use(
      ~variables={
        location: ByAddress({city: "City"}),
      },
    )

    let data2 = Query.use(
      ~variables={
        location: ById("<id>"),
      },
    )

    <>
      <div> {React.string(data.findByLocation->Belt.Option.getWithDefault("-"))} </div>
      <div> {React.string(data2.findByLocation->Belt.Option.getWithDefault("-"))} </div>
    </>
  }
}

@live
let test_inputUnion = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
