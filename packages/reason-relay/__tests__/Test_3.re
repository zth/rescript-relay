module Query = [%relay.query
  {|
  query Test3_Query {
    loggedInUser {
      ...Test3_User_user
    }
  }
|}
];

module UserFragment = [%relay.fragment
  {|
  fragment Test3_User_user on User
    @argumentDefinitions(
      count: { type: "Int", defaultValue: 2 }
      cursor: { type: "String", defaultValue: "" }
    )
    @refetchable(queryName: "Test3_UserRefetchQuery") {
    id
    firstName
    lastName
    nicknames
    friendsConnection(first: $count, after: $cursor)
      @connection(key: "Test3_User_user_friendsConnection") {
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

module AddFriendMutation = [%relay.mutation
  {|
  mutation Test3_AddFriendMutation($friendId: ID!) {
    addFriend(friendId: $friendId) {
      addedFriend {
        id
        firstName
        lastName
      }
    }
  }
|}
];

module RemoveFriendMutation = [%relay.mutation
  {|
  mutation Test3_RemoveFriendMutation($friendId: ID!) {
    removeFriend(friendId: $friendId) {
      removedFriendId
    }
  }
|}
];

module Test_3 = {
  [@react.component]
  let make = () => {
    let environment = ReasonRelay.useEnvironmentFromContext();
    let query = Query.use(~variables=(), ());
    let user = UserFragment.use(query##loggedInUser);

    <div>
      <h1> {React.string(user##firstName ++ " " ++ user##lastName)} </h1>
      <div>
        {React.string(
           "Nicknames: " ++ user##nicknames->Js.Array2.joinWith(", "),
         )}
      </div>
      <h2> {React.string("Friends")} </h2>
      {user##friendsConnection
       |> ReasonRelayUtils.collectConnectionNodes
       |> Array.map(friend =>
            <div key=friend##id>
              {React.string(friend##firstName ++ " " ++ friend##lastName)}
            </div>
          )
       |> React.array}
      <button
        onClick={_ =>
          AddFriendMutation.commitMutation(
            ~environment,
            ~variables={"friendId": "friend-3"},
            ~updater=
              (store, _) => {
                switch (
                  store->ReasonRelay.RecordSourceSelectorProxy.getRootField(
                    ~fieldName="addFriend",
                  )
                ) {
                | Some(addFriend) =>
                  switch (
                    addFriend->ReasonRelay.RecordProxy.getLinkedRecord(
                      ~name="addedFriend",
                      ~arguments=None,
                    )
                  ) {
                  | Some(addedFriend) =>
                    switch (
                      store->ReasonRelay.RecordSourceSelectorProxy.get(
                        ~dataId=ReasonRelay.makeDataId(user##id),
                      )
                    ) {
                    | Some(userRecord) =>
                      switch (
                        ReasonRelay.ConnectionHandler.getConnection(
                          ~record=userRecord,
                          ~key="Test3_User_user_friendsConnection",
                          ~filters=None,
                        )
                      ) {
                      | Some(connection) =>
                        ReasonRelay.ConnectionHandler.insertEdgeAfter(
                          ~connection,
                          ~newEdge=
                            ReasonRelay.ConnectionHandler.createEdge(
                              ~store,
                              ~connection,
                              ~node=addedFriend,
                              ~edgeType="UserEdge",
                            ),
                          ~cursor=None,
                        )
                      | None => ()
                      }
                    | None => ()
                    }
                  | None => ()
                  }
                | None => ()
                }
              },
            (),
          )
          |> ignore
        }>
        {React.string("Add friend using raw store updater")}
      </button>
      <button
        onClick={_ =>
          AddFriendMutation.commitMutation(
            ~environment,
            ~variables={"friendId": "friend-3"},
            ~updater=
              (store, _) => {
                switch (
                  ReasonRelayUtils.resolveNestedRecordFromRoot(
                    ~path=["addFriend", "addedFriend"],
                    ~store,
                  )
                ) {
                | Some(addedFriend) =>
                  ReasonRelayUtils.createAndAddEdgeToConnections(
                    ~store,
                    ~node=addedFriend,
                    ~connections=[
                      {
                        parentID: ReasonRelay.makeDataId(user##id),
                        key: "Test3_User_user_friendsConnection",
                      },
                    ],
                    ~edgeName="UserEdge",
                    ~insertAt=End,
                  )
                | None => ()
                }
              },
            (),
          )
          |> ignore
        }>
        {React.string("Add friend using utils")}
      </button>
      <button
        onClick={_ => {
          ReasonRelay.commitLocalUpdate(~environment, ~updater=store => {
            switch (
              store->ReasonRelay.RecordSourceSelectorProxy.get(
                ~dataId=ReasonRelay.makeDataId(user##id),
              )
            ) {
            | Some(userRecord) =>
              switch (
                userRecord->ReasonRelay.RecordProxy.getValueStringArray(
                  ~name="nicknames",
                  ~arguments=None,
                )
              ) {
              | Some(currentNicknames) =>
                userRecord->ReasonRelay.RecordProxy.setValueStringArray(
                  ~name="nicknames",
                  ~value=
                    Belt.Array.concat(
                      currentNicknames->Belt.Array.keepMap(s => s),
                      [|"Siggy"|],
                    ),
                  ~arguments=None,
                )
                |> ignore
              | None => ()
              }
            | None => ()
            }
          })
        }}>
        {React.string("Update nicknames locally")}
      </button>
    </div>;
  };
};

type testReturn = {render: unit => React.element};

let test_3 = (): testReturn => {
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
    render: () =>
      <TestProviders.Wrapper environment> <Test_3 /> </TestProviders.Wrapper>,
  };
};