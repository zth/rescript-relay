module Query = %relay(`
    query TestMutationQuery {
      loggedInUser {
        ...TestMutation_user
      }
    }
`)

module Mutation = %relay(`
    mutation TestMutationSetOnlineStatusMutation($onlineStatus: OnlineStatus!) @raw_response_type {
      setOnlineStatus(onlineStatus: $onlineStatus) {
        user {
          id
          onlineStatus
          ...TestFragment_user
        }
      }
    }
`)

module ComplexMutation = %relay(`
    mutation TestMutationSetOnlineStatusComplexMutation($input: SetOnlineStatusInput!) {
      setOnlineStatusComplex(input: $input) {
        user {
          id
          onlineStatus
        }
      }
    }
`)

module MutationWithOnlyFragment = %relay(`
    mutation TestMutationWithOnlyFragmentSetOnlineStatusMutation($onlineStatus: OnlineStatus!) @raw_response_type {
      setOnlineStatus(onlineStatus: $onlineStatus) {
        user {
          ...TestMutation_user
        }
      }
    }
`)

module Fragment = %relay(`
    fragment TestMutation_user on User {
      id
      firstName
      lastName
      onlineStatus
      memberOf {
        __typename
        ... on User {
          firstName
        }
        ... on Group {
          name
        }
      }
    }
`)

module MutationWithInlineFragment = %relay(`
    mutation TestMutationWithInlineFragmentSetOnlineStatusMutation($onlineStatus: OnlineStatus!) @raw_response_type {
      setOnlineStatus(onlineStatus: $onlineStatus) {
        user {
          ...TestMutationInline_user
        }
      }
    }
`)

module InlineFragment = %relay(`
    fragment TestMutationInline_user on User @inline {
      id
      firstName
      lastName
      onlineStatus
    }
`)

module Test = {
  @react.component
  let make = () => {
    let environment = RescriptRelay.useEnvironmentFromContext()
    let query = Query.use(~variables=(), ())
    let data = Fragment.use(query.loggedInUser.fragmentRefs)
    let (mutate, isMutating) = Mutation.use()
    let (inlineStatus, setInlineStatus) = React.useState(_ => "-")

    <div>
      {React.string(
        data.firstName ++
        (" is " ++
        switch data.onlineStatus {
        | Some(#Online) => "online"
        | Some(#Idle) => "idle"
        | Some(#Offline) => "offline"
        | _ => "-"
        }),
      )}
      <div> {React.string("Inline status: " ++ inlineStatus)} </div>
      <button
        onClick={_ => {
          let _ = {
            open Mutation
            commitMutation(~environment, ~variables=makeVariables(~onlineStatus=#Idle), ())
          }
        }}>
        {React.string("Change online status")}
      </button>
      <button
        onClick={_ => {
          let _: RescriptRelay.Disposable.t = {
            open MutationWithOnlyFragment
            commitMutation(
              ~environment,
              ~variables=makeVariables(~onlineStatus=#Idle),
              ~optimisticResponse=makeOptimisticResponse(
                ~setOnlineStatus=make_rawResponse_setOnlineStatus(
                  ~user=make_rawResponse_setOnlineStatus_user(
                    ~id=data.id,
                    ~firstName=data.firstName,
                    ~lastName=data.lastName,
                    ~memberOf=[
                      Some(
                        #User({
                          __typename: #User,
                          firstName: "test",
                          id: "123",
                          __isNode: #User,
                        }),
                      ),
                    ],
                    ~onlineStatus=#Idle,
                    (),
                  ),
                  (),
                ),
                (),
              ),
              (),
            )
          }
        }}>
        {React.string("Change online status with only fragment")}
      </button>
      <button
        onClick={_ => {
          let _: RescriptRelay.Disposable.t = {
            open MutationWithInlineFragment
            commitMutation(
              ~environment,
              ~variables=makeVariables(~onlineStatus=#Idle),
              ~onCompleted=(response, _) => {
                setInlineStatus(_ => "completed")
                switch response {
                | {setOnlineStatus: Some({user: Some(user)})} =>
                  let inlineData = InlineFragment.readInline(user.fragmentRefs)
                  setInlineStatus(_ =>
                    switch inlineData.onlineStatus {
                    | Some(#Online) => "online"
                    | Some(#Idle) => "idle"
                    | Some(#Offline) => "offline"
                    | _ => "unknown"
                    }
                  )
                | _ => ignore()
                }
              },
              (),
            )
          }
        }}>
        {React.string("Change online status with inline fragment")}
      </button>
      <button
        onClick={_ => {
          let _ = {
            open Mutation
            mutate(~variables=makeVariables(~onlineStatus=#Idle), ())
          }
        }}>
        {React.string(isMutating ? "Mutating..." : "Change online status via useMutation hook")}
      </button>
      <button
        onClick={_ => {
          let _ = {
            open ComplexMutation
            commitMutation(
              ~environment,
              ~variables=makeVariables(
                // The "mess" below is to try and provoke a test failure if
                // recursive conversion would be broken.
                ~input=make_setOnlineStatusInput(
                  ~onlineStatus=#Idle,
                  ~recursed=make_recursiveSetOnlineStatusInput(
                    ~someValue=100,
                    ~setOnlineStatus=make_setOnlineStatusInput(
                      ~onlineStatus=#Online,
                      ~recursed=make_recursiveSetOnlineStatusInput(~someValue=100, ()),
                      (),
                    ),
                    (),
                  ),
                  (),
                ),
              ),
              (),
            )
          }
        }}>
        {React.string("Change online status, complex")}
      </button>
      <button
        onClick={_ => {
          let _ = {
            open Mutation
            commitMutation(
              ~environment,
              ~variables=makeVariables(~onlineStatus=#Idle),
              ~optimisticResponse=makeOptimisticResponse(
                ~setOnlineStatus=make_rawResponse_setOnlineStatus(
                  ~user=make_rawResponse_setOnlineStatus_user(
                    ~id=data.id,
                    ~__id=data.id->RescriptRelay.makeDataId,
                    ~onlineStatus=#Idle,
                    ~firstName=data.firstName,
                    ~lastName=data.lastName,
                    (),
                  ),
                  (),
                ),
                (),
              ),
              (),
            )
          }
        }}>
        {React.string("Change online status with optimistic update")}
      </button>
      <button
        onClick={_ => {
          let _ = Mutation.commitMutation(
            ~environment,
            ~variables={onlineStatus: #Idle},
            ~updater=(store, response) =>
              switch (
                store->RescriptRelay.RecordSourceSelectorProxy.get(
                  ~dataId=RescriptRelay.makeDataId(data.id),
                ),
                response,
              ) {
              | (
                  Some(userProxy),
                  {setOnlineStatus: Some({user: Some({onlineStatus: Some(onlineStatus)})})},
                ) =>
                userProxy
                ->RescriptRelay.RecordProxy.setValueString(
                  ~name="onlineStatus",
                  ~value=switch onlineStatus {
                  | #Idle => "Offline"
                  | _ => "Online"
                  },
                  (),
                )
                ->ignore
              | _ => Js.log("Error!")
              },
            (),
          )
        }}>
        {React.string("Change online status with updater")}
      </button>
    </div>
  }
}

let test_mutation = () => {
  let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=RelayEnv.fetchQuery, ())

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )
  ()

  <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>
}
