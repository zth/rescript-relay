let test_subscription: unit => {
  "pushNext": Js.Json.t => unit,
  "render": unit => React.element,
  "subscriptionFunction": ('b, 'c, 'd) => RescriptRelay.Observable.t<Js.Json.t>,
}
