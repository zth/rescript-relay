module Query = [%relay.query
  {|
    query TestNodeInterfaceQuery {
      node(id: "123") {
        __typename
        ... on User {
          firstName
        }
      }
    }
|}
];

module Test = {
  [@react.component]
  let make = () => {
    let query = Query.use(~variables=(), ());

    switch (query.node) {
    | Some(user) => React.string(user.firstName)
    | None => React.string("-")
    };
  };
};

let test_nodeInterface = () => {
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
