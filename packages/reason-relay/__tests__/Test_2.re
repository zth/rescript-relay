module Query = [%relay.query
  {|
  query Test2_Query {
    loggedInUser {
      ...Test2_User_user
    }
  }
|}
];

module UserFragment = [%relay.fragment
  {|
  fragment Test2_User_user on User {
    id
    firstName
    lastName
    avatarUrl
  }
|}
];

module UserUpdatedSubscription = [%relay.subscription
  {|
  subscription Test2_UserUpdatedSubscription($userId: ID!) {
    userUpdated(id: $userId) {
      user {
        id
        ...Test2_User_user
      }
    }
  }
|}
];

module Test_2 = {
  [@react.component]
  let make = () => {
    let environment = ReasonRelay.useEnvironmentFromContext();
    let query = Query.use(~variables=(), ());
    let user = UserFragment.use(query##loggedInUser);

    React.useEffect0(() => {
      let disposable =
        UserUpdatedSubscription.subscribe(
          ~environment,
          ~variables={"userId": "user-1"},
          (),
        );

      Some(() => disposable |> ReasonRelay.Disposable.dispose);
    });

    <div>
      <h1> {React.string(user##firstName ++ " " ++ user##lastName)} </h1>
      {switch (user##avatarUrl |> Js.Nullable.toOption) {
       | Some(avatarUrl) => <img src=avatarUrl alt="avatar" />
       | None => React.null
       }}
    </div>;
  };
};

type testReturn('a) = {
  render: unit => React.element,
  getSink: unit => option(ReasonRelay.Observable.sink('a)),
};

let test_2 = (): testReturn('a) => {
  let theSink: ref(option(ReasonRelay.Observable.sink('a))) = ref(None);

  let observable =
    ReasonRelay.Observable.make(sink => {theSink := Some(sink)});

  let network =
    ReasonRelay.Network.makePromiseBased(
      ~fetchFunction=RelayEnv.fetchQuery,
      ~subscriptionFunction=_ => observable,
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
    getSink: () => theSink^,
    render: () =>
      <TestProviders.Wrapper environment> <Test_2 /> </TestProviders.Wrapper>,
  };
};