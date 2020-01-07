module Query = [%relay.query
  {|
    query TestMutationQuery {
      loggedInUser {
        ...TestMutation_user
      }
    }
|}
];

module Mutation = [%relay.mutation
  {|
    mutation TestMutationSetOnlineStatusMutation($onlineStatus: OnlineStatus!) {
      setOnlineStatus(onlineStatus: $onlineStatus) {
        user {
          id
          onlineStatus
        }
      }
    }
|}
];

module Fragment = [%relay.fragment
  {|
    fragment TestMutation_user on User {
      id
      firstName
      onlineStatus
    }
|}
];

module Test = {
  [@react.component]
  let make = () => {
    let environment = ReasonRelay.useEnvironmentFromContext();
    let query = Query.use(~variables=(), ());
    let data =
      Fragment.use(query.loggedInUser |> Query.loggedInUser_getFragments);

    <div>
      {React.string(
         data.firstName
         ++ " is "
         ++ (
           switch (data.onlineStatus) {
           | Some(`Online) => "online"
           | Some(`Idle) => "idle"
           | Some(`Offline) => "offline"
           | _ => "-"
           }
         ),
       )}
      <button
        onClick={_ =>
          Mutation.commitMutation(
            ~environment,
            ~variables={onlineStatus: `Idle},
            (),
          )
          |> ignore
        }>
        {React.string("Change online status")}
      </button>
      <button
        onClick={_ =>
          Mutation.commitMutation(
            ~environment,
            ~variables={onlineStatus: `Idle},
            ~optimisticResponse={
              setOnlineStatus:
                Some({
                  user: Some({id: data.id, onlineStatus: Some(`Idle)}),
                }),
            },
            (),
          )
          |> ignore
        }>
        {React.string("Change online status with optimistic update")}
      </button>
      <button
        onClick={_ =>
          Mutation.commitMutation(
            ~environment,
            ~variables={onlineStatus: `Idle},
            ~updater=
              (store, response) =>
                switch (
                  store->ReasonRelay.RecordSourceSelectorProxy.get(
                    ~dataId=ReasonRelay.makeDataId(data.id),
                  ),
                  response,
                ) {
                | (
                    Some(userProxy),
                    {
                      setOnlineStatus:
                        Some({
                          user: Some({onlineStatus: Some(onlineStatus)}),
                        }),
                    },
                  ) =>
                  userProxy
                  ->ReasonRelay.RecordProxy.setValueString(
                      ~name="onlineStatus",
                      ~arguments=None,
                      ~value=
                        switch (onlineStatus) {
                        | `Idle => "Offline"
                        | _ => "Online"
                        },
                    )
                  ->ignore
                | _ => Js.log("Error!")
                },
            (),
          )
          |> ignore
        }>
        {React.string("Change online status with updater")}
      </button>
    </div>;
  };
};

let test_mutation = () => {
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