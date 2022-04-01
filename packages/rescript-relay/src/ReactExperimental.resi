@module("react")
external useDeferredValue: 'value => 'value = "useDeferredValue"

@module("react")
external useTransitionWithOptions: unit => (
  bool,
  (. unit => unit, option<{"name": option<string>}>) => unit,
) = "useTransition"

let useTransition: unit => (bool, React.callback<unit => unit, unit>)

module SuspenseList: {
  @module("react") @react.component
  external make: (
    ~children: React.element,
    ~revealOrder: [#forwards | #backwards | #together]=?,
  ) => React.element = "SuspenseList"
}
