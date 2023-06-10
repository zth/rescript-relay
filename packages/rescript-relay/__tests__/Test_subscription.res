module Query = %relay(`
    query TestSubscriptionQuery {
      loggedInUser {
        ...TestSubscription_user
      }
    }
`)

module Fragment = %relay(`
    fragment TestSubscription_user on User {
      id
      firstName
      avatarUrl
      onlineStatus
    }
`)

module UserUpdatedSubscription = %relay(`
  subscription TestSubscriptionUserUpdatedSubscription($userId: ID!) {
    userUpdated(id: $userId) {
      user {
        id
        onlineStatus
        ...TestSubscription_user
      }
    }
  }
`)

module Test = {
  @react.component
  let make = () => {
    let environment = RescriptRelay.useEnvironmentFromContext()
    let query = Query.use(~variables=(), ())
    let data = Fragment.use(query.loggedInUser.fragmentRefs)
    let (ready, setReady) = React.useState(() => false)

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
              | Idle => "Offline"
              | _ => "Online"
              },
              (),
            )
            ->ignore
          | _ => ()
          },
        (),
      )

      setReady(_ => true)

      Some(() => disposable->RescriptRelay.Disposable.dispose)
    })

    <div>
      <div>
        {React.string(
          switch ready {
          | true => "Ready - "
          | false => ""
          } ++
          "User " ++
          (data.firstName ++
          (" is " ++
          switch data.onlineStatus {
          | Some(Online) => "online"
          | Some(Offline) => "offline"
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

@live
let test_subscription = () => {
  let subscriptionFns = ref([])

  let subscribeToOnNext = nextFn => {
    let _ = subscriptionFns.contents->Js.Array2.push(nextFn)

    () => {
      subscriptionFns.contents = subscriptionFns.contents->Js.Array2.filter(fn => fn !== nextFn)
    }
  }

  let pushNext = next => subscriptionFns.contents->Js.Array2.forEach(fn => fn(next))

  let subscriptionFunction = (_, _, _) => {
    RescriptRelay.Observable.make(sink => {
      let unsubscribe = subscribeToOnNext(next => sink.next(next))
      Some({
        closed: false,
        unsubscribe,
      })
    })
  }

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
    "pushNext": pushNext,
    "subscriptionFunction": subscriptionFunction,
    "render": () =>
      <TestProviders.Wrapper environment>
        <Test />
      </TestProviders.Wrapper>,
  }
}
