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

module ComplexMutation = [%relay.mutation
  {|
    mutation TestMutationSetOnlineStatusComplexMutation($input: SetOnlineStatusInput!) {
      setOnlineStatusComplex(input: $input) {
        user {
          id
          onlineStatus
        }
      }
    }
|}
];

module MutationWithOnlyFragment = [%relay.mutation
  {|
    mutation TestMutationWithOnlyFragmentSetOnlineStatusMutation($onlineStatus: OnlineStatus!) {
      setOnlineStatus(onlineStatus: $onlineStatus) {
        user {
          ...TestMutation_user
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
      Fragment.use(query.loggedInUser.getFragmentRef_TestMutation_user());
    let (mutate, isMutating) = Mutation.use();
    let (mutationResult, setMutationResult) = React.useState(() => None);

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
        onClick={_ => {
          let _ =
            Mutation.(
              commitMutation(
                ~environment,
                ~variables=makeVariables(~onlineStatus=`Idle),
                (),
              )
            );
          ();
        }}>
        {React.string("Change online status")}
      </button>
      <button
        onClick={_ => {
          let _: ReasonRelay.Disposable.t =
            MutationWithOnlyFragment.(
              commitMutation(
                ~environment,
                ~variables=makeVariables(~onlineStatus=`Idle),
                ~optimisticResponse=
                  makeOptimisticResponse(
                    ~setOnlineStatus=
                      make_response_setOnlineStatus(
                        ~user=make_response_setOnlineStatus_user(),
                        (),
                      ),
                    (),
                  ),
                (),
              )
            );
          ();
        }}>
        {React.string("Change online status with only fragment")}
      </button>
      <button
        onClick={_ =>
          Mutation.(
            commitMutationPromised(
              ~environment,
              ~variables=makeVariables(~onlineStatus=`Idle),
              (),
            )
          )
          ->Promise.get(
              fun
              | Ok((res, _)) => setMutationResult(_ => Some(res))
              | _ => Js.log("oops!"),
            )
        }>
        {React.string("Change online status promised")}
      </button>
      {switch (mutationResult) {
       | Some(_) => <div> {React.string("Has result")} </div>
       | None => <div> {React.string("No result yet")} </div>
       }}
      <button
        onClick={_ => {
          let _ =
            Mutation.(
              mutate(~variables=makeVariables(~onlineStatus=`Idle), ())
            );
          ();
        }}>
        {React.string(
           isMutating
             ? "Mutating..." : "Change online status via useMutation hook",
         )}
      </button>
      <button
        onClick={_ => {
          let _ =
            ComplexMutation.(
              commitMutation(
                ~environment,
                ~variables=
                  makeVariables(
                    ~input=make_setOnlineStatusInput(~onlineStatus=`Idle),
                  ),
                (),
              )
            );
          ();
        }}>
        {React.string("Change online status, complex")}
      </button>
      <button
        onClick={_ => {
          let _ =
            Mutation.(
              commitMutation(
                ~environment,
                ~variables=makeVariables(~onlineStatus=`Idle),
                ~optimisticResponse=
                  makeOptimisticResponse(
                    ~setOnlineStatus=
                      make_response_setOnlineStatus(
                        ~user=
                          make_response_setOnlineStatus_user(
                            ~id=data.id,
                            ~onlineStatus=`Idle,
                            (),
                          ),
                        (),
                      ),
                    (),
                  ),
                (),
              )
            );
          ();
        }}>
        {React.string("Change online status with optimistic update")}
      </button>
      <button
        onClick={_ => {
          let _ =
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
                        ~value=
                          switch (onlineStatus) {
                          | `Idle => "Offline"
                          | _ => "Online"
                          },
                        (),
                      )
                    ->ignore
                  | _ => Js.log("Error!")
                  },
              (),
            );
          ();
        }}>
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
