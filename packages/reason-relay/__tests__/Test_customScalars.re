module Query = [%relay.query
  {|
    query TestCustomScalarsQuery($beforeDate: Datetime) {
      loggedInUser {
        createdAt
        friends(beforeDate: $beforeDate) {
          createdAt
        }
      }

      member(id: "user-1") {
        __typename
        ... on User {
          createdAt
        }
      }
    }
|}
];

module Test = {
  [@react.component]
  let make = () => {
    let query =
      Query.use(
        ~variables=
          Query.makeVariables(
            ~beforeDate=Js.Date.fromFloat(1514764800000.),
            (),
          ),
        (),
      );

    <>
      <div>
        {React.string(
           "loggedInUser createdAt: "
           ++ query.loggedInUser.createdAt->Js.Date.getTime->Js.Float.toString,
         )}
      </div>
      <div>
        {switch (query.member) {
         | Some(`User(user)) =>
           React.string(
             "member createdAt: "
             ++ user.createdAt->Js.Date.getTime->Js.Float.toString,
           )
         | Some(`UnselectedUnionMember(_))
         | None => React.null
         }}
      </div>
    </>;
  };
};

let test_customScalars = () => {
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
