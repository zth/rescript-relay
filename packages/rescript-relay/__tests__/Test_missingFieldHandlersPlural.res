module Query = %relay(`
    query TestMissingFieldHandlersPluralQuery {
      topOnlineUserList {
          firstName 
      }
    }
`)

module BestiesQuery = %relay(`
    query TestMissingFieldHandlersPluralBestiesQuery {
      onlineBesties {
          firstName
      }
    }
`)

module RenderBesties = {
  @react.component
  let make = () => {
    let query = BestiesQuery.use(~variables=(), ~fetchPolicy=StoreOnly)

    React.string(
      "2: " ++
      query.onlineBesties
      ->Option.getOr([])
      ->Array.keepSome
      ->Array.map(({firstName}) => firstName)
      ->Array.join(" - "),
    )
  }
}

module Test = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=())
    let (showNext, setShowNext) = React.useState(() => false)

    <>
      <div>
        {React.string(
          "1: " ++
          query.topOnlineUserList
          ->Option.getOr([])
          ->Array.keepSome
          ->Array.map(({firstName}) => firstName)
          ->Array.join(" - "),
        )}
      </div>
      {showNext
        ? <RenderBesties />
        : <button onClick={_ => setShowNext(_ => true)}> {React.string("Show next")} </button>}
    </>
  }
}

@live
let test_missingFieldHandlers = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery)

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
    ~missingFieldHandlers=[
      PluralLinked({
        handle: (field, record, _args, _store) =>
          switch (record, field.name) {
          | (Value(record), "onlineBesties") =>
            module RP = RescriptRelay.RecordProxy
            RP.getLinkedRecords(record, ~name="topOnlineUserList")
            ->Option.map(array =>
              Array.map(array, record => Option.map(record, RP.getDataId)->Nullable.fromOption)
            )
            ->Nullable.fromOption
          | _ => undefined
          },
      }),
    ],
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
