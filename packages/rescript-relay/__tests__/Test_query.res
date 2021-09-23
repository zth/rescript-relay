module Query = %relay(`
  query TestQuery($status: OnlineStatus) {
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

module TestPreloaded = {
  @react.component
  let make = (~queryRef) => {
    let query = Query.usePreloaded(~queryRef, ())
    let users = switch query {
    | {users: Some({edges: Some(edges)})} =>
      edges->Belt.Array.keepMap(edge =>
        switch edge {
        | Some({node}) => node
        | _ => None
        }
      )
    | _ => []
    }

    <div>
      {users
      ->Belt.Array.map(user =>
        <div key=user.id>
          {React.string(
            "Preloaded " ++
            (user.firstName ++
            (" is " ++
            switch user.onlineStatus {
            | Some(#Idle) => "idle"
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
    let environment = RescriptRelay.useEnvironmentFromContext()

    let (status, setStatus) = React.useState(() => Some(#Online))
    let (queryRefFromModule, setQueryRefFromModule) = React.useState(() => None)
    let (hasWaitedForPreload, setHasWaitedForPreload) = React.useState(() => false)
    let (fetchedResult, setFetchedResult) = React.useState(() => None)

    let (loadedQueryRef, loadQuery, _dispose) = Query.useLoader()

    let collectUsers = (res: Query.Types.response) =>
      switch res {
      | {users: Some({edges: Some(edges)})} =>
        edges->Belt.Array.keepMap(edge =>
          switch edge {
          | Some({node}) => node
          | _ => None
          }
        )
      | _ => []
      }

    let query = Query.use(~variables={status: status}, ())
    let users = collectUsers(query)

    <div>
      {users
      ->Belt.Array.map(user =>
        <div key=user.id>
          {React.string(
            user.firstName ++
            (" is " ++
            switch user.onlineStatus {
            | Some(#Online) => "online"
            | Some(#Offline) => "offline"
            | Some(#Idle) => "idle"
            | Some(_) | None => "-"
            }),
          )}
        </div>
      )
      ->React.array}
      <button onClick={_ => setStatus(_ => Some(#Offline))}>
        {React.string("Switch to offline")}
      </button>
      <button onClick={_ => setStatus(_ => None)}>
        {React.string("Switch to all statuses")}
      </button>
      <button
        onClick={_ =>
          setQueryRefFromModule(_ => Some(
            TestQuery_graphql.load(~environment, ~variables={status: Some(#Idle)}, ()),
          ))}>
        {React.string("Test preloaded from raw module")}
      </button>
      <button
        onClick={_ => {
          let queryRef = TestQuery_graphql.load(~environment, ~variables={status: Some(#Idle)}, ())

          let _ = queryRef->TestQuery_graphql.queryRefToPromise->Js.Promise.then_(res => {
              switch res {
              | Ok() => setHasWaitedForPreload(_ => true)
              | Error() => ()
              }

              Js.Promise.resolve()
            }, _)

          setQueryRefFromModule(_ => Some(queryRef))
        }}>
        {React.string("Test wait for preload")}
      </button>
      <button
        onClick={_ =>
          Query.fetch(
            ~environment,
            ~variables={status: Some(#Online)},
            ~onResult=x =>
              switch x {
              | Ok(res) => setFetchedResult(_ => Some(collectUsers(res)))
              | Error(_) => ()
              },
            (),
          )}>
        {React.string("Test fetch")}
      </button>
      <button
        onClick={_ => {
          let _ =
            Query.fetchPromised(
              ~environment,
              ~variables={status: Some(#Online)},
              (),
            )->Js.Promise.then_(res => {
              setFetchedResult(_ => Some(collectUsers(res)))
              Js.Promise.resolve()
            }, _)
        }}>
        {React.string("Test fetch promised")}
      </button>
      <button onClick={_ => loadQuery(~variables={status: Some(#Idle)}, ())}>
        {React.string("Test query loader")}
      </button>
      {hasWaitedForPreload ? <div> {React.string("Has waited for preload")} </div> : React.null}
      {switch (queryRefFromModule, loadedQueryRef) {
      | (_, Some(queryRef)) | (Some(queryRef), _) => <TestPreloaded queryRef />
      | _ => React.null
      }}
      {switch fetchedResult {
      | Some([{firstName: "First", onlineStatus: Some(#Online)}]) => React.string("Fetched!")
      | _ => React.null
      }}
    </div>
  }
}

let test_query = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
