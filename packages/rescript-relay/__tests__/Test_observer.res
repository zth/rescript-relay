module Query = %relay(`
  query TestObserverQuery {
    loggedInUser {
      id
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let data = Query.use(~variables=(), ())

    <div> {React.string(data.loggedInUser.id)} </div>
  }
}

exception SomeFailure

let test_observer = () => {
  let network = RescriptRelay.Network.makeObservableBased(~observableFunction=(_, _, _, _) => {
    RescriptRelay.Observable.make(sink => {
      try {
        Js.Exn.raiseError("Some error")
      } catch {
      | Js.Exn.Error(obj) =>
        sink.error(. obj)
        sink.complete(.)
      }

      None
    })
  }, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment>
    <RescriptReactErrorBoundary fallback={_ => React.string("Failed")}>
      <Test />
    </RescriptReactErrorBoundary>
  </TestProviders.Wrapper>
}
