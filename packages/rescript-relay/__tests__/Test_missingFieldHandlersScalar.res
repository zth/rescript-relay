module Query = %relay(`
    query TestMissingFieldHandlersScalarQuery {
      node(id: "123") {
        ... on User {
          surname
        }
      }
    }
`)

module MeQuery = %relay(`
    query TestMissingFieldHandlersScalarMeQuery {
      loggedInUser {
        lastName
      }
    }
`)

module RenderMe = {
  @react.component
  let make = () => {
    let query = Query.use(~variables=(), ~fetchPolicy=StoreOnly)

    switch query.node {
    | Some(User(user)) => React.string("2: " ++ user.surname)
    | _ => React.string("-")
    }
  }
}

module Test = {
  @react.component
  let make = () => {
    let query = MeQuery.use(~variables=())
    let (showNext, setShowNext) = React.useState(() => false)

    <>
      <div> {React.string("1: " ++ query.loggedInUser.lastName)} </div>
      {showNext
        ? <RenderMe />
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
      Scalar({
        handle: (field, record, _args, _store) =>
          switch (record, field.name) {
          | (Value(record), "surname") if RescriptRelay.RecordProxy.getType(record) === "User" =>
            RescriptRelay.RecordProxy.getValueString(record, ~name="lastName")->Nullable.fromOption
          | _ => undefined
          },
      }),
    ],
  )

  <TestProviders.Wrapper environment>
    <Test />
  </TestProviders.Wrapper>
}
