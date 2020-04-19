module Route: {
  type t;

  let getSubRoutes: t => array(t);
  let matchesUrl: (t, ReasonReactRouter.url) => bool;
  let preload: (t, ReasonReactRouter.url) => unit;
  let render: (t, ReasonReactRouter.url, React.element) => React.element;
  let make:
    (
      ~matchUrl: ReasonReactRouter.url => option('routeVariables),
      ~prepare: 'routeVariables => 'prepared,
      ~render: ('prepared, React.element) => React.element,
      ~subRoutes: array(t)=?,
      unit
    ) =>
    t;
};

type routeEntry = {
  routes: array(Route.t),
  url: ReasonReactRouter.url,
};

type subscriberCallback = routeEntry => unit;
type disposeSubscriber = unit => unit;

type routerContext = {
  get: unit => routeEntry,
  preload: string => unit,
  subscribe: subscriberCallback => disposeSubscriber,
};

let context: React.Context.t(option(routerContext));

module Provider: {
  let makeProps:
    (~value: option(routerContext), ~children: React.element, unit) =>
    {
      .
      "value": option(routerContext),
      "children": React.element,
    };

  let make:
    React.component({
      .
      "value": option(routerContext),
      "children": React.element,
    });
};

exception No_router_in_context;

let use: unit => routerContext;

let make: array(Route.t) => (routerContext, unit => unit);

module RouteRenderer: {
  [@react.component]
  let make:
    (
      ~renderPending: unit => React.element=?,
      ~renderFallback: unit => React.element=?,
      ~renderNotFound: ReasonReactRouter.url => React.element=?,
      ~suspenseTimeout: int=?,
      unit
    ) =>
    React.element;
};

module Link: {
  [@react.component]
  let make:
    (
      ~to_: string,
      ~title: string=?,
      ~id: string=?,
      ~className: string=?,
      ~classNameDynamic: (ReasonReactRouter.url, ReasonReactRouter.url) =>
                         string
                           =?,
      ~target: [ | `self | `blank]=?,
      ~mode: [ | `push | `replace]=?,
      ~render: (
                 ~preload: unit => unit,
                 ~changeRoute: ReactEvent.Mouse.t => unit,
                 ~currentUrl: ReasonReactRouter.url,
                 ~linkUrl: ReasonReactRouter.url
               ) =>
               React.element
                 =?,
      ~children: React.element,
      unit
    ) =>
    React.element;
};