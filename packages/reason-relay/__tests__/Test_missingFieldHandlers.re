module Query = [%relay
  {|
    query TestMissingFieldHandlersQuery {
      node(id: "123") {
        __typename
        ... on User {
          firstName
        }
      }
    }
|}
];

module MeQuery = [%relay
  {|
    query TestMissingFieldHandlersMeQuery {
      loggedInUser {
        firstName
      }
    }
|}
];

module RenderMe = {
  [@react.component]
  let make = () => {
    let query = Query.use(~variables=(), ~fetchPolicy=StoreOnly, ());

    switch (query.node) {
    | Some(user) => React.string("2: " ++ user.firstName)
    | None => React.string("-")
    };
  };
};

module Test = {
  [@react.component]
  let make = () => {
    let query = MeQuery.use(~variables=(), ());
    let (showNext, setShowNext) = React.useState(() => false);

    <>
      <div> {React.string("1: " ++ query.loggedInUser.firstName)} </div>
      {showNext
         ? <RenderMe />
         : <button onClick={_ => setShowNext(_ => true)}>
             {React.string("Show next")}
           </button>}
    </>;
  };
};

let test_missingFieldHandlers = () => {
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
