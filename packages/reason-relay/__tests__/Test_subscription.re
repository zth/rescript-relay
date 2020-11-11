module Query = [%relay.query
  {|
    query TestSubscriptionQuery {
      loggedInUser {
        ...TestSubscription_user
      }
    }
|}
];

module Fragment = [%relay.fragment
  {|
    fragment TestSubscription_user on User {
      id
      firstName
      avatarUrl
      onlineStatus
    }
|}
];

module UserUpdatedSubscription = [%relay.subscription
  {|
  subscription TestSubscriptionUserUpdatedSubscription($userId: ID!) {
    userUpdated(id: $userId) {
      user {
        id
        onlineStatus
        ...TestSubscription_user
      }
    }
  }
|}
];

module Test = {
  [@react.component]
  let make = () => {
    let environment = ReasonRelay.useEnvironmentFromContext();
    let query = Query.use(~variables=(), ());
    let data = Fragment.use(query.loggedInUser.fragmentRefs);

    React.useEffect0(() => {
      let disposable =
        UserUpdatedSubscription.subscribe(
          ~environment,
          ~variables=UserUpdatedSubscription.makeVariables(~userId="user-1"),
          ~updater=
            (store, response) => {
              switch (
                store->ReasonRelay.RecordSourceSelectorProxy.get(
                  ~dataId=ReasonRelay.makeDataId(data.id),
                ),
                response,
              ) {
              | (
                  Some(userProxy),
                  {
                    userUpdated:
                      Some({
                        user: Some({onlineStatus: Some(onlineStatus)}),
                      }),
                  },
                ) =>
                userProxy
                ->ReasonRelay.RecordProxy.setValueString(
                    ~name="onlineStatus",
                    ~value=
                      switch (onlineStatus) {
                      | `Idle => "Offline"
                      | _ => "Online"
                      },
                    (),
                  )
                ->ignore
              | _ => ()
              }
            },
          (),
        );

      Some(() => disposable |> ReasonRelay.Disposable.dispose);
    });

    <div>
      <div>
        {React.string(
           "User "
           ++ data.firstName
           ++ " is "
           ++ (
             switch (data.onlineStatus) {
             | Some(`Online) => "online"
             | Some(`Offline) => "offline"
             | _ => "-"
             }
           ),
         )}
      </div>
      {switch (data.avatarUrl) {
       | Some(avatarUrl) => <img alt="avatar" src=avatarUrl />
       | None => React.null
       }}
    </div>;
  };
};

let test_subscription = () => {
  let theSink: ref(option(ReasonRelay.Observable.sink('a))) = ref(None);

  let observable =
    ReasonRelay.Observable.make(sink => {
      theSink := Some(sink);
      None;
    });

  let subscriptionFunction = (_, _, _) => observable;

  let network =
    ReasonRelay.Network.makePromiseBased(
      ~fetchFunction=RelayEnv.fetchQuery,
      ~subscriptionFunction,
      (),
    );

  let environment =
    ReasonRelay.Environment.make(
      ~network,
      ~store=
        ReasonRelay.Store.make(~source=ReasonRelay.RecordSource.make(), ()),
      (),
    );

  {
    "getSink": () => theSink^,
    "subscriptionFunction": subscriptionFunction,
    "render": () =>
      <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>,
  };
};
