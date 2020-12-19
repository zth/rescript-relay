module Query = [%relay
  {|
    query TestUnionFragmentQuery {
      member(id: "123") {
        __typename
        ...TestUnionFragment_member
        ...TestUnionFragment_plural_member
      }
    }
|}
];

module Fragment = [%relay
  {|
    fragment TestUnionFragment_member on Member {
      __typename
      ... on User {
        firstName
        onlineStatus
      }
      ... on Group {
        name
      }
    }
|}
];

module PluralFragment = [%relay
  {|
    fragment TestUnionFragment_plural_member on Member @relay(plural: true) {
      __typename
      ... on User {
      firstName
        onlineStatus
      }
      ... on Group {
        name
      }
    }
|}
];

module FragmentRenderer = {
  [@react.component]
  let make = (~fragment) => {
    let regular = Fragment.use(fragment);
    let plural = PluralFragment.use([|fragment|]);

    <>
      {switch (regular) {
       | `User({onlineStatus: Some(`Online), firstName}) =>
         <div> {React.string(firstName ++ " is online")} </div>
       | _ => React.null
       }}
      {switch (plural) {
       | [|`User({onlineStatus: Some(`Online), firstName})|] =>
         <div> {React.string("plural: " ++ firstName ++ " is online")} </div>
       | _ => React.null
       }}
    </>;
  };
};

module Test = {
  [@react.component]
  let make = () => {
    let query = Query.use(~variables=(), ());

    switch (query.member) {
    | Some(member) => <FragmentRenderer fragment={member.fragmentRefs} />
    | None => React.null
    };
  };
};

let test_unionFragment = () => {
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
