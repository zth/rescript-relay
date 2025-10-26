open RescriptRelay

type updaterFn<'response> = (RecordSourceSelectorProxy.t, 'response) => unit
type subscriptionConfig<'node, 'variables, 'response> = {
  subscription: subscriptionNode<'node>,
  variables: 'variables,
  onCompleted?: unit => unit,
  onError?: JsExn.t => unit,
  onNext?: 'response => unit,
  updater?: updaterFn<'response>,
}

@module("relay-runtime")
external requestSubscription_: (
  Environment.t,
  subscriptionConfig<'node, 'variables, 'response>,
) => Disposable.t = "requestSubscription"

let subscribe = (
  ~node,
  ~convertVariables: 'variables => 'variables,
  ~convertResponse: 'response => 'response,
) => {
  (
    ~environment: Environment.t,
    ~variables: 'variables,
    ~onCompleted=?,
    ~onError=?,
    ~onNext=?,
    ~updater=?,
  ) => {
    requestSubscription_(
      environment,
      {
        ?onCompleted,
        subscription: node,
        variables: variables->convertVariables,
        ?onError,
        onNext: ?switch onNext {
        | Some(onNext) => Some(response => onNext(response->convertResponse))
        | None => None
        },
        updater: ?switch updater {
        | Some(updater) => Some((store, response) => updater(store, response->convertResponse))
        | None => None
        },
      },
    )
  }
}
