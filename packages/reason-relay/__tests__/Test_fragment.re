module Query = [%relay.query
  {|
    query TestFragmentQuery {
      loggedInUser {
        ...TestFragment_user
      }
      users {
        edges {
          node {
            id
            onlineStatus
            ...TestFragment_plural_user
          }
        }
      }
    }
|}
];

module Fragment = [%relay.fragment
  {|
    fragment TestFragment_user on User {
      firstName
      onlineStatus
    }
|}
];

module PluralFragment = [%relay.fragment
  {|
    fragment TestFragment_plural_user on User @relay(plural: true) {
      id
      firstName
      onlineStatus
    }
|}
];

module TestPlural = {
  [@react.component]
  let make = (~users) => {
    let allUsers = PluralFragment.use(users);

    <div>
      {allUsers
       ->Belt.Array.map(user =>
           <div key={user.id}>
             {React.string(
                user.firstName
                ++ " is "
                ++ (
                  switch (user.onlineStatus) {
                  | Some(`Online) => "online"
                  | Some(`Offline) => "offline"
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
    let query = Query.use(~variables=(), ());
    let data =
      Fragment.use(query.loggedInUser->Query.unwrapFragments_loggedInUser);

    let users =
      switch (query) {
      | {users: Some({edges: Some(edges)})} =>
        edges->Belt.Array.keepMap(edge =>
          switch (edge) {
          | Some({node: Some(node)}) =>
            Some(node->Query.unwrapFragments_node)
          | _ => None
          }
        )
      | _ => [||]
      };

    <div>
      {React.string(
         data.firstName
         ++ " is "
         ++ (
           switch (data.onlineStatus) {
           | Some(`Online) => "online"
           | _ => "-"
           }
         ),
       )}
      {switch (users->Belt.Array.length) {
       | 0 => React.null
       | _ => <TestPlural users />
       }}
    </div>;
  };
};

let test_fragment = () => {
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