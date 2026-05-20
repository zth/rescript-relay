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

module SubscriptionWithProvidedVariableFragment = %relay(`
  subscription TestSubscriptionWithProvidedVariableFragmentSubscription {
    userUpdated(id: "user-1") {
      user {
        id
        onlineStatus
        ...TestSubscriptionProvidedVariable_user
      }
    }
  }
`)

module ProvidedVariableFragment = %relay(`
  fragment TestSubscriptionProvidedVariable_user on User
    @argumentDefinitions(
      bool: { type: "Boolean!", provider: "ProvidedVariables.Bool" }
    ) {
    someRandomArgField(bool: $bool)
  }
`)

module Test = {
  @react.component
  let make = () => {
    let environment = RescriptRelayReact.useEnvironmentFromContext()
    let query = Query.use(~variables=())
    let data = Fragment.use(query.loggedInUser.fragmentRefs)
    let (ready, setReady) = React.useState(() => false)
    let (providedVariableSubscriptionStatus, setProvidedVariableSubscriptionStatus) =
      React.useState(() => "-")

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
              | Idle => "offline"
              | _ => "Online"
              },
            )
            ->ignore
          | _ => ()
          },
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
      <div>
        {React.string(
          "Provided variable subscription status: " ++ providedVariableSubscriptionStatus,
        )}
      </div>
      <button
        onClick={_ => {
          SubscriptionWithProvidedVariableFragment.subscribe(
            ~environment,
            ~variables=(),
            ~onNext=response =>
              switch response {
              | {userUpdated: Some({user: Some(_)})} =>
                setProvidedVariableSubscriptionStatus(_ => "received")
              | _ => setProvidedVariableSubscriptionStatus(_ => "missing user")
              },
          )->RescriptRelay.Disposable.ignore
        }}
      >
        {React.string("Subscribe with provided variable fragment")}
      </button>
    </div>
  }
}

@live
let test_subscription = () => {
  let subscriptionFns = ref([])
  let subscriptionVariables = ref(([]: array<JSON.t>))

  let subscribeToOnNext = nextFn => {
    let _ = subscriptionFns.contents->Array.push(nextFn)

    () => {
      subscriptionFns.contents = subscriptionFns.contents->Array.filter(fn => fn !== nextFn)
    }
  }

  let pushNext = next => subscriptionFns.contents->Array.forEach(fn => fn(next))

  let subscriptionFunction = (_, variables, _) => {
    let _ = subscriptionVariables.contents->Array.push(variables)

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
  )

  let environment = RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
  )

  {
    "pushNext": pushNext,
    "subscriptionFunction": subscriptionFunction,
    "getLastSubscriptionVariables": () => {
      let len = subscriptionVariables.contents->Array.length

      len > 0
        ? subscriptionVariables.contents->Array.getUnsafe(len - 1)
        : JSON.Encode.object(dict{})
    },
    "render": () =>
      <TestProviders.Wrapper environment>
        <Test />
      </TestProviders.Wrapper>,
  }
}
