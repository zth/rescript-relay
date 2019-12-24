module Query = [%relay.query
  {|
  query Test1_Query {
    loggedInUser {
      ...Test1_User_user
      ...Test1_User_userSimple
    }
  }
|}
];

module UserFragmentSimple = [%relay.fragment
  {|
  fragment Test1_User_userSimple on User {
    id
    firstName
    lastName
  }
|}
];

module UserFragment = [%relay.fragment
  {|
  fragment Test1_User_user on User
    @argumentDefinitions(
      showFriends: { type: "Boolean!", defaultValue: false }
      showOnlineStatus: { type: "Boolean!", defaultValue: false }
    )
    @refetchable(queryName: "Test1_UserRefetchQuery") {
    id
    avatarUrl
    isOnline @include(if: $showOnlineStatus)
    ...Test1_User_userFriends @include(if: $showFriends)
  }
|}
];

module UserFriendsFragment = [%relay.fragment
  {|
  fragment Test1_User_userFriends on User
    @argumentDefinitions(
      count: { type: "Int", defaultValue: 2 }
      cursor: { type: "String", defaultValue: "" }
    )
    @refetchable(queryName: "Test1_UserFriendsRefetchQuery") {
    id
    friendsConnection(first: $count, after: $cursor)
      @connection(key: "Test1_User_userFriends_friendsConnection") {
      edges {
        node {
          id
          firstName
          lastName
        }
      }
    }
  }
|}
];

module AddAvatarMutation = [%relay.mutation
  {|
  mutation Test1_AddAvatarMutation($avatarUrl: String!) {
    updateUserAvatar(avatarUrl: $avatarUrl) {
      user {
        avatarUrl
        id
      }
    }
  }
|}
];

module FriendList = {
  [@react.component]
  let make = (~user) => {
    let ReasonRelay.{data, hasNext, isLoadingNext, loadNext} =
      UserFriendsFragment.usePagination(user);
    let friends =
      ReasonRelayUtils.collectConnectionNodes(data##friendsConnection);

    <div>
      <h2> {React.string("Friends")} </h2>
      {friends
       |> Array.map(friend =>
            <div key=friend##id>
              {React.string(friend##firstName ++ " " ++ friend##lastName)}
            </div>
          )
       |> React.array}
      {hasNext
         ? <button
             onClick={_ =>
               loadNext(
                 ~count=2,
                 ~onComplete={
                   Some(_ => Js.log("Done!"));
                 },
               )
               |> ignore
             }>
             {React.string("Load more friends")}
           </button>
         : React.null}
      {isLoadingNext
         ? <div> {React.string("Loading more friends...")} </div> : React.null}
    </div>;
  };
};

module Test_1 = {
  [@react.component]
  let make = () => {
    let environment = ReasonRelay.useEnvironmentFromContext();
    let query = Query.use(~variables=(), ());
    let userSimple = UserFragmentSimple.use(query##loggedInUser);
    let (user, refetch) = UserFragment.useRefetchable(query##loggedInUser);
    let (startFriendsTransition, isPendingFriends) =
      ReactExperimental.useTransition(~timeoutMs=5000, ());
    let (startOnlineStatusTransition, isPendingOnlineStatus) =
      ReactExperimental.useTransition(~timeoutMs=5000, ());
    let (showingFriends, setShowingFriends) = React.useState(() => false);
    let (showingOnlineStatus, setShowingOnlineStatus) =
      React.useState(() => false);

    <div>
      <h1>
        {React.string(userSimple##firstName ++ " " ++ userSimple##lastName)}
      </h1>
      {switch (user##avatarUrl |> Js.Nullable.toOption) {
       | Some(avatarUrl) => <img src=avatarUrl alt="avatar" />
       | None => React.null
       }}
      <button
        onClick={_ =>
          AddAvatarMutation.commitMutation(
            ~environment,
            ~variables={"avatarUrl": "http://some/avatar.png"},
            (),
          )
          |> ignore
        }>
        {React.string("Add avatar")}
      </button>
      <button
        onClick={_ =>
          AddAvatarMutation.commitMutation(
            ~environment,
            ~variables={"avatarUrl": "http://some/avatar.png"},
            ~optimisticResponse={
              "updateUserAvatar":
                Some({
                  "user":
                    Some({
                      "id": user##id,
                      "avatarUrl":
                        Some("http://some/avatar.png")
                        |> Js.Nullable.fromOption,
                    })
                    |> Js.Nullable.fromOption,
                })
                |> Js.Nullable.fromOption,
            },
            (),
          )
          |> ignore
        }>
        {React.string("Add avatar optimistically")}
      </button>
      {showingOnlineStatus
         ? <div>
             {React.string(
                Belt.Option.getWithDefault(
                  Js.Nullable.toOption(user##isOnline),
                  false,
                )
                  ? "User is online" : "User is offline",
              )}
           </div>
         : <button
             onClick={_ =>
               startOnlineStatusTransition(() => {
                 refetch(
                   ~variables=
                     UserFragment.makeRefetchVariables(
                       ~showOnlineStatus=true,
                       (),
                     ),
                   ~onComplete=_ => setShowingOnlineStatus(_ => true),
                   (),
                 )
               })
             }>
             {React.string(
                isPendingOnlineStatus
                  ? "Loading online status..." : "Show online status",
              )}
           </button>}
      {showingFriends
         ? <FriendList user />
         : <button
             onClick={_ =>
               startFriendsTransition(() => {
                 refetch(
                   ~variables=
                     UserFragment.makeRefetchVariables(~showFriends=true, ()),
                   ~onComplete=_ => setShowingFriends(_ => true),
                   (),
                 )
               })
             }>
             {React.string(
                isPendingFriends ? "Loading friends..." : "Show friends",
              )}
           </button>}
    </div>;
  };
};

let test_1 = (): TestProviders.testReturn => {
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

  {
    environment,
    render: () =>
      <TestProviders.Wrapper environment> <Test_1 /> </TestProviders.Wrapper>,
  };
};