module Query = [%relay.query
  {|
    query TestRefetchingInNodeQuery($userId: ID!) {
      node(id: $userId) {
        __typename
        ... on User {
          ...TestRefetchingInNode_user
        }
      }
    }
|}
];

module Fragment = [%relay.fragment
  {|
    fragment TestRefetchingInNode_user on User
      @refetchable(queryName: "TestRefetchingInNodeRefetchQuery")
      @argumentDefinitions(
        showOnlineStatus: { type: "Boolean!", defaultValue: false }
        friendsOnlineStatuses: { type: "[OnlineStatus!]!", defaultValue: [Online, Offline]}
      ) {
      firstName
      onlineStatus @include(if: $showOnlineStatus)
      friendsConnection(statuses: $friendsOnlineStatuses) {
        totalCount
      }
    }
|}
];

module UserDisplayer = {
  [@react.component]
  let make = (~queryRef) => {
    let (data, refetch) = Fragment.useRefetchable(queryRef);

    let (startTransition, _) =
      React.useTransition(~config={timeoutMs: 5000}, ());

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
      <div>
        {React.string(
           "Friends: " ++ data.friendsConnection.totalCount->string_of_int,
         )}
      </div>
      <button
        onClick={_ =>
          startTransition(() => {
            let _ =
              refetch(
                ~variables=
                  Fragment.makeRefetchVariables(~showOnlineStatus=true, ()),
                (),
              );
            ();
          })
        }>
        {React.string("Fetch online status")}
      </button>
    </div>;
  };
};

module Test = {
  [@react.component]
  let make = () => {
    let query = Query.use(~variables={userId: "user-1"}, ());

    switch (query.node) {
    | Some(user) => <UserDisplayer queryRef={user.fragmentRefs} />
    | None => React.string("-")
    };
  };
};

let test_refetching = () => {
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
