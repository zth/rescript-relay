module RouteFamily: {
  type t

  let matchesUrl: (t, RescriptReactRouter.url) => bool
  let preload: (t, RescriptReactRouter.url) => unit
  let render: (t, RescriptReactRouter.url) => React.element
  let make: (
    ~matchUrl: RescriptReactRouter.url => option<'routeVariables>,
    ~prepare: 'routeVariables => 'prepared,
    ~render: 'prepared => React.element,
  ) => t
}

type routerContext

module Provider: {
  let makeProps: (
    ~value: routerContext,
    ~children: React.element,
    unit,
  ) => {"value": routerContext, "children": React.element}

  let make: React.component<{"value": routerContext, "children": React.element}>
}

exception No_router_in_context

type router = {
  push: string => unit,
  pushShallow: string => unit,
  replace: string => unit,
  replaceShallow: string => unit,
  preload: string => unit,
}

let useRouter: unit => router

let make: array<RouteFamily.t> => routerContext

module RouteRenderer: {
  @react.component
  let make: (
    ~renderPending: bool => React.element=?,
    ~renderFallback: unit => React.element=?,
    ~renderNotFound: RescriptReactRouter.url => React.element=?,
    unit,
  ) => React.element
}

module Link: {
  @react.component
  let make: (
    ~to_: string,
    ~title: string=?,
    ~id: string=?,
    ~className: string=?,
    ~classNameDynamic: (RescriptReactRouter.url, RescriptReactRouter.url) => string=?,
    ~target: [#self | #blank]=?,
    ~mode: [#push | #replace]=?,
    ~render: (
      ~preload: unit => unit,
      ~changeRoute: ReactEvent.Mouse.t => unit,
      ~currentUrl: RescriptReactRouter.url,
      ~linkUrl: RescriptReactRouter.url,
    ) => React.element=?,
    ~preloadOnHover: bool=?,
    ~children: React.element,
    ~onClick: unit => unit=?,
    unit,
  ) => React.element
}

module NavigationUtils: {
  let replaceShallow: string => unit
  let pushShallow: string => unit
}
