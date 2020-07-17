module Query = [%relay.query
  {|
    query TestPaginationUnionQuery($groupId: ID!) {
      ...TestPaginationUnion_query @arguments(groupId: $groupId)
    }
|}
];

// This is just to ensure that fragments on unions work
module UserFragment = [%relay.fragment
  {|
  fragment TestPaginationUnion_user on User {
    firstName
    friendsConnection(first: 1) {
      totalCount
    }
  }
|}
];

module Fragment = [%relay.fragment
  {|
    fragment TestPaginationUnion_query on Query
      @refetchable(queryName: "TestPaginationUnionRefetchQuery")
      @argumentDefinitions(
        groupId: { type: "ID!" }
        onlineStatuses: { type: "[OnlineStatus!]" }
        count: { type: "Int", defaultValue: 2 }
        cursor: { type: "String", defaultValue: "" }
      ) {
      members(
        groupId: $groupId
        onlineStatuses: $onlineStatuses
        first: $count
        after: $cursor
      ) @connection(key: "TestPaginationUnion_query_members") {
        edges {
          node {
            __typename
            ... on User {
              id
              ...TestPaginationUnion_user
            }

            ... on Group {
              id
              name
              adminsConnection(first: 1) {
                edges {
                  node {
                    id
                    firstName
                  }
                }
              }
            }
          }
        }
      }
    }
|}
];

module UserDisplayer = {
  [@react.component]
  let make = (~user) => {
    let data = UserFragment.use(user);

    React.string(
      "User "
      ++ data.firstName
      ++ " has "
      ++ data.friendsConnection.totalCount->string_of_int
      ++ " friends",
    );
  };
};

module Test = {
  [@react.component]
  let make = () => {
    let groupId = "123";
    let query = Query.use(~variables={groupId: groupId}, ());

    let (startTransition, _) =
      React.useTransition(~config={timeoutMs: 5000}, ());

    let ReasonRelay.{data, hasNext, loadNext, isLoadingNext, refetch} =
      Fragment.usePagination(
        query.getFragmentRef_TestPaginationUnion_query(),
      );

    <div>
      {data.members
       ->Fragment.getConnectionNodes_members
       ->Belt.Array.mapWithIndex((i, member) =>
           switch (member) {
           | `User(user) =>
             <div key={user.id}>
               <UserDisplayer
                 user={user.getFragmentRef_TestPaginationUnion_user()}
               />
             </div>
           | `Group(group) =>
             <div key={group.id}>
               {React.string(
                  "Group "
                  ++ group.name
                  ++ " with "
                  ++ group.adminsConnection.edges
                     ->Belt.Option.getWithDefault([||])
                     ->Belt.Array.length
                     ->string_of_int
                  ++ " admins",
                )}
             </div>
           | `UnselectedUnionMember(_) =>
             <div key={i |> string_of_int}>
               {React.string("Unknown type")}
             </div>
           }
         )
       ->React.array}
      {hasNext
         ? <button onClick={_ => {loadNext(~count=2, ()) |> ignore}}>
             {React.string(isLoadingNext ? "Loading..." : "Load more")}
           </button>
         : React.null}
      <button
        onClick={_ =>
          startTransition(() =>
            refetch(
              ~variables=
                Fragment.makeRefetchVariables(
                  ~groupId,
                  ~onlineStatuses=[|`Online, `Idle|],
                  (),
                ),
              (),
            )
          )
        }>
        {React.string("Refetch connection")}
      </button>
    </div>;
  };
};

let test_pagination = () => {
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
