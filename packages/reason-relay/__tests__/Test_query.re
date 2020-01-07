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
    let query = Query.usePreloaded(preloadToken);
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
    let environment = ReasonRelay.useEnvironmentFromContext();

    let (status, setStatus) = React.useState(() => Some(`Online));
    let (preloadToken, setPreloadToken) = React.useState(() => None);
    let (fetchedResult, setFetchedResult) = React.useState(() => None);

    let collectUsers = (res: Query.Operation.response) =>
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
                  | Some(`FUTURE_ADDED_VALUE__)
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
          setPreloadToken(_ =>
            Some(
              Query.preload(
                ~environment,
                ~variables={status: Some(`Idle)},
                (),
              ),
            )
          )
        }}>
        {React.string("Test preloaded")}
      </button>
      <button
        onClick={_ =>
          Query.fetch(~environment, ~variables={status: Some(`Online)})
          |> Js.Promise.then_(res => {
               setFetchedResult(_ => Some(collectUsers(res)));
               Js.Promise.resolve(res);
             })
          |> ignore
        }>
        {React.string("Test fetch")}
      </button>
      {switch (preloadToken) {
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