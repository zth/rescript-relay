@live
let test_subscription: unit => {
  "pushNext": JSON.t => unit,
  "render": unit => React.element,
  "subscriptionFunction": ('b, 'c, 'd) => RescriptRelay.Observable.t<JSON.t>,
}
