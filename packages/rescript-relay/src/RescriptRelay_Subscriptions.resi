open RescriptRelay

let subscribe: (
  ~node: subscriptionNode<'a>,
  ~convertVariables: 'variables => 'variables,
  ~convertResponse: 'response => 'response,
  ~environment: Environment.t,
  ~variables: 'variables,
  ~onCompleted: unit => unit=?,
  ~onError: Js.Exn.t => unit=?,
  ~onNext: 'response => unit=?,
  ~updater: (RecordSourceSelectorProxy.t, 'response) => unit=?,
  unit,
) => Disposable.t
