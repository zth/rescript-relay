module Query = %relay(
  `
    query TestSubscriptionQuery {
      loggedInUser {
        ...TestSubscription_user
      }
    }
`
)

module Fragment = %relay(
  `
    fragment TestSubscription_user on User {
      id
      firstName
      avatarUrl
      onlineStatus
    }
`
)

module UserUpdatedSubscription = %relay(
  `
  subscription TestSubscriptionUserUpdatedSubscription($userId: ID!) {
    userUpdated(id: $userId) {
      user {
        id
        onlineStatus
        ...TestSubscription_user
      }
    }
  }
`
)

module Test = {
  @react.component
  let make = () => {
    let environment = RescriptRelay.useEnvironmentFromContext()
    let query = Query.use(~variables=(), ())
    let data = Fragment.use(query.loggedInUser.fragmentRefs)

    React.useEffect0(() => {
      let disposable = UserUpdatedSubscription.subscribe(
        ~environment,
        ~variables={userId: "user-1"},
        ~updater=(store, response) =>
          switch (
            store->RescriptRelay.RecordSourceSelectorProxy.get(
              ~dataId=RescriptRelay.makeDataId(data.id),
            ),
            response,
          ) {
          | (
              Some(userProxy),
              {userUpdated: Some({user: Some({onlineStatus: Some(onlineStatus)})})},
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
          | _ => ()
          },
        (),
      )

      Some(() => disposable->RescriptRelay.Disposable.dispose)
    })

    <div>
      <div>
        {React.string(
          "User " ++
          (data.firstName ++
          (" is " ++
          switch data.onlineStatus {
          | Some(#Online) => "online"
          | Some(#Offline) => "offline"
          | _ => "-"
          })),
        )}
      </div>
      {switch data.avatarUrl {
      | Some(avatarUrl) => <img alt="avatar" src=avatarUrl />
      | None => React.null
      }}
    </div>
  }
}

let test_subscription = () => {
  let theSink: ref<option<RescriptRelay.Observable.sink<'a>>> = ref(None)

  let observable = RescriptRelay.Observable.make(sink => {
    theSink := Some(sink)
    None
  })

  let subscriptionFunction = (_, _, _) => observable

  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=RelayEnv.fetchQuery,
    ~subscriptionFunction,
    (),
  )

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
    (),
  )

  {
    "getSink": () => theSink.contents,
    "subscriptionFunction": subscriptionFunction,
    "render": () => <TestProviders.Wrapper environment> <Test /> </TestProviders.Wrapper>,
  }
}
