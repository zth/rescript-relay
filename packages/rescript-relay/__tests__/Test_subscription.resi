@live
let test_subscription: unit => {
  "getLastSubscriptionVariables": unit => JSON.t,
  "pushNext": JSON.t => unit,
  "render": unit => React.element,
  "subscriptionFunction": ('b, JSON.t, 'd) => RescriptRelay.Observable.t<JSON.t>,
}
