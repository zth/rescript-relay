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

module SubFragment = [%relay.fragment
  {|
    fragment TestFragment_sub_user on User {
      lastName
    }
|}
];

module Fragment = [%relay.fragment
  {|
    fragment TestFragment_user on User {
      firstName
      onlineStatus
      ...TestFragment_sub_user
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
    let data = Fragment.use(query.loggedInUser.fragmentRefs);

    let (useOpt, setUseOpt) = React.useState(() => false);

    let dataOpt =
      Fragment.useOpt(useOpt ? Some(query.loggedInUser.fragmentRefs) : None);

    let users =
      switch (query) {
      | {users: Some({edges: Some(edges)})} =>
        edges->Belt.Array.keepMap(edge =>
          switch (edge) {
          | Some({node: Some(node)}) => Some(node.fragmentRefs)
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
      <button onClick={_ => setUseOpt(last => !last)}>
        {React.string(useOpt ? "Hide opt" : "Use opt")}
      </button>
      {switch (dataOpt) {
       | Some(data) =>
         <div> {React.string(data.firstName ++ " is here!")} </div>
       | None => <div> {React.string("Opt not activated")} </div>
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
