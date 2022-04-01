type callback<'input, 'output> = 'input => 'output

@module("react")
external useDeferredValue: 'value => 'value = "useDeferredValue"

type startTransitionOptions = {
  name: option<string>
}

@module("react")
external useTransition: unit => (bool, (. callback<unit, unit>, option<startTransitionOptions>) => unit) = "useTransition"

module SuspenseList = {
  @module("react") @react.component
  external make: (
    ~children: React.element,
    ~revealOrder: [#forwards | #backwards | #together]=?,
  ) => React.element = "SuspenseList"
}
