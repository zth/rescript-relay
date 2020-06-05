module Query = [%relay.query
  {|
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
|}
];

module TestPreloaded = {
  [@react.component]
  let make = (~preloadToken) => {
    let query = Query.usePreloaded(~token=preloadToken, ());
    let users =
      switch (query) {
      | {users: Some({edges: Some(edges)})} =>
        edges->Belt.Array.keepMap(edge =>
          switch (edge) {
          | Some({node}) => node
          | _ => None
          }
        )
      | _ => [||]
      };

    <div>
      {users
       ->Belt.Array.map(user =>
           <div key={user.id}>
             {React.string(
                "Preloaded "
                ++ user.firstName
                ++ " is "
                ++ (
                  switch (user.onlineStatus) {
                  | Some(`Idle) => "idle"
                  | _ => "-"
                  }
                ),
              )}
           </div>
         )
       ->React.array}
    </div>;
  };
};

module Test = {
  [@react.component]
  let make = () => {
    let environment = ReasonRelay.useRelayEnvironment();

    let (status, setStatus) = React.useState(() => Some(`Online));
    let (preloadTokenFromModule, setPreloadTokenFromModule) =
      React.useState(() => None);
    let (hasWaitedForPreload, setHasWaitedForPreload) =
      React.useState(() => false);
    let (fetchedResult, setFetchedResult) = React.useState(() => None);

    let collectUsers = (res: Query.Types.response) =>
      switch (res) {
      | {users: Some({edges: Some(edges)})} =>
        edges->Belt.Array.keepMap(edge =>
          switch (edge) {
          | Some({node}) => node
          | _ => None
          }
        )
      | _ => [||]
      };

    let query = Query.use(~variables={status: status}, ());
    let users = collectUsers(query);

    <div>
      {users
       ->Belt.Array.map(user =>
           <div key={user.id}>
             {React.string(
                user.firstName
                ++ " is "
                ++ (
                  switch (user.onlineStatus) {
                  | Some(`Online) => "online"
                  | Some(`Offline) => "offline"
                  | Some(`Idle) => "idle"
                  | Some(`FutureAddedValue(_))
                  | None => "-"
                  }
                ),
              )}
           </div>
         )
       ->React.array}
      <button onClick={_ => setStatus(_ => Some(`Offline))}>
        {React.string("Switch to offline")}
      </button>
      <button onClick={_ => setStatus(_ => None)}>
        {React.string("Switch to all statuses")}
      </button>
      <button
        onClick={_ => {
          setPreloadTokenFromModule(_ =>
            Some(
              TestQuery_graphql.preload(
                ~environment,
                ~variables={status: Some(`Idle)},
                (),
              ),
            )
          )
        }}>
        {React.string("Test preloaded from raw module")}
      </button>
      <button
        onClick={_ => {
          let preloadToken =
            TestQuery_graphql.preload(
              ~environment,
              ~variables={status: Some(`Idle)},
              (),
            );

          preloadToken
          ->TestQuery_graphql.preloadTokenToPromise
          ->Promise.get(res =>
              switch (res) {
              | Ok () => setHasWaitedForPreload(_ => true)
              | Error () => ()
              }
            );

          setPreloadTokenFromModule(_ => Some(preloadToken));
        }}>
        {React.string("Test wait for preload")}
      </button>
      <button
        onClick={_ =>
          Query.fetch(
            ~environment,
            ~variables={status: Some(`Online)},
            ~onResult=
              fun
              | Ok(res) => setFetchedResult(_ => Some(collectUsers(res)))
              | Error(_) => (),
          )
        }>
        {React.string("Test fetch")}
      </button>
      <button
        onClick={_ =>
          Query.fetchPromised(
            ~environment,
            ~variables={status: Some(`Online)},
          )
          ->Promise.get(
              fun
              | Ok(res) => setFetchedResult(_ => Some(collectUsers(res)))
              | Error(_) => (),
            )
        }>
        {React.string("Test fetch promised")}
      </button>
      {hasWaitedForPreload
         ? <div> {React.string("Has waited for preload")} </div> : React.null}
      {switch (preloadTokenFromModule) {
       | Some(preloadToken) => <TestPreloaded preloadToken />
       | None => React.null
       }}
      {switch (fetchedResult) {
       | Some([|{firstName: "First", onlineStatus: Some(`Online)}|]) =>
         React.string("Fetched!")
       | _ => React.null
       }}
    </div>;
  };
};

let test_query = () => {
  let network =
    ReasonRelay.Network.makePromiseBased(
      ~fetchFunction=RelayEnv.fetchQuery,
      (),
    );

  let environment =
    ReasonRelay.Environment.make(
      ~network,
      ~store=
        ReasonRelay.Store.make(~source=ReasonRelay.RecordSource.make(), ()),
      (),
    );
  ();

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>;
};
