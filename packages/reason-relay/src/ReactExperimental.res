type callback<'input, 'output> = 'input => 'output

@bs.module("react")
external _unstable_useDeferredValue: 'value => 'value = "unstable_useDeferredValue"

@bs.module("react")
external _unstable_useTransition: unit => (callback<callback<unit, unit>, unit>, bool) =
  "unstable_useTransition"

let unstable_useTransition = () => _unstable_useTransition()

@bs.val @bs.return(nullable)
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
