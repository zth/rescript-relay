let test_subscription: unit => {
  "getSink": unit => option<RescriptRelay.Observable.sink<Js.Json.t>>,
  "render": unit => React.element,
  "subscriptionFunction": ('b, 'c, 'd) => RescriptRelay.Observable.t<Js.Json.t>,
}
