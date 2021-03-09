type callback<'input, 'output> = 'input => 'output

@module("react")
external unstable_useDeferredValue: 'value => 'value = "unstable_useDeferredValue"

@module("react")
external unstable_useTransition: unit => (callback<callback<unit, unit>, unit>, bool) =
  "unstable_useTransition"

module SuspenseList = {
  @module("react") @react.component
  external make: (
    ~children: React.element,
    ~revealOrder: [#forwards | #backwards | #together]=?,
  ) => React.element = "unstable_SuspenseList"
}

@val @return(nullable)
external getElementById: string => option<Dom.element> = "document.getElementById"

let renderConcurrentRootAtElementWithId: (React.element, string) => unit = (content, id) =>
  switch getElementById(id) {
  | None =>
    raise(
      Invalid_argument(
        "ReactExperimental.renderConcurrentRootAtElementWithId : no element of id " ++
        id ++ " found in the HTML.",
      ),
    )
  | Some(element) =>
    ReactDOMExperimental.unstable_createRoot(element)->ReactDOMExperimental.render(content)
  }
