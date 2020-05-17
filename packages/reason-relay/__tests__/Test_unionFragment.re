module Query = [%relay.query
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

module Fragment = [%relay.fragment
  {|
    fragment TestUnionFragment_member on Member {
    __typename
      ... on User {
          id
          firstName
          onlineStatus
        }
        ... on Group {
          id
          name
          members {
          __typename
            ... on User {
              id
            }
            ... on Group {
              id
            }
          }
        }
    }
|}
];

module PluralFragment = [%relay.fragment
  {|
    fragment TestUnionFragment_plural_member on Member @relay(plural: true) {
      __typename
      ... on User {
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
       | `User(u) =>
         <div>
           <div> u.firstName->React.string </div>
           <div>
             {React.string(
                switch (u.onlineStatus) {
                | Some(`Online) => "Online"
                | _ => "-"
                },
              )}
           </div>
         </div>
       | `Group(g) =>
         <div>
           <div> g.name->React.string </div>
           <div>
             {switch (g.members) {
              | None => React.null
              | Some(members) =>
                members
                ->Belt.Array.keepMap(m =>
                    switch (m) {
                    | Some(`User(u)) => Some(u.id->React.string)
                    | Some(`Group(g)) => Some(g.id->React.string)
                    | _ => None
                    }
                  )
                ->React.array
              }}
           </div>
         </div>
       | `UnselectedUnionMember(_) => React.null
       }}
    </>;
  };
};

module Test = {
  [@react.component]
  let make = () => {
    let query = Query.use(~variables=(), ());

    switch (query.member) {
    | Some(member) => <FragmentRenderer fragment={member.getFragmentRefs()} />
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