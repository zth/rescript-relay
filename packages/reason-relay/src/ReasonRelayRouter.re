module Route = {
  type t = {
    preload: ReasonReactRouter.url => unit,
    matchesUrl: ReasonReactRouter.url => bool,
    render: (ReasonReactRouter.url, React.element) => React.element,
    subRoutes: array(t),
  };

  let getSubRoutes = t => t.subRoutes;
  let matchesUrl = (t, url) => t.matchesUrl(url);
  let preload = (t, url) => t.preload(url);
  let render = (t, url, children) => t.render(url, children);

  let make = (~matchUrl, ~prepare, ~render, ~subRoutes=?, ()) => {
    preload: url =>
      switch (matchUrl(url)) {
      | Some(params) =>
        prepare(params);
        ();
      | None => ()
      },
    matchesUrl: url =>
      switch (matchUrl(url)) {
      | Some(_) => true
      | None => false
      },
    render: (url, children) =>
      switch (matchUrl(url)) {
      | Some(params) => render(prepare(params), children)
      | None => React.null
      },
    subRoutes: subRoutes->Belt.Option.getWithDefault([||]),
  };
};

module Url = {
  type t = {
    pathname: string,
    query: string,
    hash: string,
  };

  [@bs.module] [@bs.new] external make: string => t = "url-parse";

  // Taken from ReasonReactRouter
  module RouterCompat = {
    let path =
      fun
      | ""
      | "/" => []
      | raw => {
          /* remove the preceeding /, which every pathname seems to have */
          let raw = Js.String.sliceToEnd(~from=1, raw);
          /* remove the trailing /, which some pathnames might have. Ugh */
          let raw =
            switch (Js.String.get(raw, Js.String.length(raw) - 1)) {
            | "/" => Js.String.slice(~from=0, ~to_=-1, raw)
            | _ => raw
            };

          raw->Js.String2.split("/")->Belt.List.fromArray;
        };

    let hash =
      fun
      | ""
      | "#" => ""
      | raw =>
        /* remove the preceeding #, which every hash seems to have.
           Why is this even included in location.hash?? */
        raw |> Js.String.sliceToEnd(~from=1);

    let search =
      fun
      | ""
      | "?" => ""
      | raw =>
        /* remove the preceeding ?, which every search seems to have. */
        raw |> Js.String.sliceToEnd(~from=1);
  };
  let toRouterUrl: t => ReasonReactRouter.url =
    t =>
      RouterCompat.{
        path: t.pathname->path,
        search: t.query->search,
        hash: t.hash->hash,
      };
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

let context = React.createContext(None);

module Provider = {
  let make = React.Context.provider(context);

  let makeProps = (~value, ~children, ()) => {
    "value": value,
    "children": children,
  };
};

exception No_router_in_context;

let use = () =>
  switch (React.useContext(context)) {
  | Some(router) => router
  | None => raise(No_router_in_context)
  };

let make = routes => {
  let initialUrl = ReasonReactRouter.dangerouslyGetInitialUrl();

  let rec matchRoutes = (routes, url, matches) => {
    let _ =
      routes->Belt.Array.some(r =>
        if (r->Route.matchesUrl(url)) {
          let _ = matches |> Js.Array.push(r);
          let _: array(Route.t) =
            r->Route.getSubRoutes->matchRoutes(url, matches);

          true;
        } else {
          false;
        }
      );

    matches;
  };

  let currentRoute: ref(routeEntry) =
    ref({url: initialUrl, routes: matchRoutes(routes, initialUrl, [||])});

  let subscribers: Js.Dict.t(option(subscriberCallback)) = Js.Dict.empty();
  let subId = ref(0);

  let getNextId = () => {
    subId := subId^ + 1;
    (subId^)->string_of_int;
  };

  let urlSub =
    ReasonReactRouter.watchUrl(url =>
      if (url != currentRoute^.url) {
        let routes = matchRoutes(routes, url, [||]);
        routes->Belt.Array.forEach(r => r->Route.preload(url));

        let nextEntry = {routes, url};

        currentRoute := nextEntry;
        subscribers
        ->Js.Dict.values
        ->Belt.Array.forEach(
            fun
            | Some(cb) => cb(nextEntry)
            | None => (),
          );
      }
    );

  let router = {
    get: () => currentRoute^,
    preload: url => {
      let asRouterUrl = url->Url.make->Url.toRouterUrl;
      routes
      ->matchRoutes(asRouterUrl, [||])
      ->Belt.Array.forEach(r => r->Route.preload(asRouterUrl));
    },
    subscribe: cb => {
      let id = getNextId();
      subscribers->Js.Dict.set(id, Some(cb));
      () => {
        subscribers->Js.Dict.set(id, None);
      };
    },
  };

  let cleanup = () => {
    urlSub->ReasonReactRouter.unwatchUrl;
  };

  (router, cleanup);
};

module RouteRenderer = {
  [@react.component]
  let make =
      (
        ~renderPending=?,
        ~renderFallback=?,
        ~renderNotFound=?,
        ~suspenseTimeout=?,
        (),
      ) => {
    let router = use();

    let (startTransition, isPending) =
      ReactExperimental.useTransition(
        ~timeoutMs=suspenseTimeout->Belt.Option.getWithDefault(2000),
        (),
      );

    let (routeEntry, setRouteEntry) = React.useState(() => router.get());

    React.useEffect2(
      () => {
        let currentEntry = router.get();
        if (routeEntry.url != currentEntry.url) {
          setRouteEntry(_ => currentEntry);
          None;
        } else {
          let dispose =
            router.subscribe(nextRoute => {
              startTransition(() => {setRouteEntry(_ => nextRoute)})
            });

          Some(dispose);
        };
      },
      (router, startTransition),
    );

    let renderedContent = ref(React.null);
    let routesReversed = routeEntry.routes->Belt.Array.reverse;

    switch (routesReversed->Js.Array.shift) {
    | Some(r) =>
      renderedContent := r->Route.render(routeEntry.url, React.null);
      let _ =
        routesReversed->Belt.Array.map(r => {
          renderedContent := r->Route.render(routeEntry.url, renderedContent^)
        });
      ();
    | None => ()
    };

    <ReactExperimental.Suspense
      fallback={
        switch (renderFallback) {
        | Some(renderFallback) => renderFallback()
        | None => React.null
        }
      }>
      {switch (isPending, renderPending) {
       | (true, Some(renderPending)) => renderPending()
       | _ => React.null
       }}
      {switch (routesReversed->Belt.Array.length, renderNotFound) {
       | (0, Some(render)) => render(routeEntry.url)
       | _ => renderedContent^
       }}
    </ReactExperimental.Suspense>;
  };
};

/**
 * Link
 */
let isModifiedEvent = e =>
  ReactEvent.Mouse.(
    switch (e->metaKey, e->altKey, e->ctrlKey, e->shiftKey) {
    | (true, _, _, _)
    | (_, true, _, _) => true
    | (_, _, true, _) => true
    | (_, _, _, true) => true
    | _ => false
    }
  );

module Link = {
  [@react.component]
  let make =
      (
        ~to_,
        ~title=?,
        ~id=?,
        ~className=?,
        ~classNameDynamic=?,
        ~target as browserTarget=?,
        ~mode=?,
        ~render=?,
        ~children,
        (),
      ) => {
    let router = use();
    let url = ReasonReactRouter.useUrl();

    let changeRoute =
      React.useCallback2(
        e =>
          ReactEvent.Mouse.(
            switch (
              e->isDefaultPrevented,
              e->button,
              browserTarget,
              e->isModifiedEvent,
            ) {
            | (false, 0, None | Some(`self), false) =>
              e->preventDefault;
              switch (mode) {
              | None
              | Some(`push) => ReasonReactRouter.push(to_)
              | Some(`replace) => ReasonReactRouter.replace(to_)
              };

            | _ => ()
            }
          ),
        (to_, router),
      );

    let preload =
      React.useCallback2(() => {router.preload(to_)}, (to_, url.path));

    switch (render) {
    | Some(render) =>
      let linkUrl = to_->Url.make->Url.toRouterUrl;
      render(~preload, ~changeRoute, ~currentUrl=url, ~linkUrl);
    | None =>
      <a
        href=to_
        target={
          switch (browserTarget) {
          | Some(`self) => "_self"
          | Some(`blank) => "_blank"
          | None => ""
          }
        }
        ?title
        ?id
        className={
          className->Belt.Option.getWithDefault("")
          ++ (
            switch (classNameDynamic) {
            | Some(f) => " " ++ f(url, to_->Url.make->Url.toRouterUrl)
            | None => ""
            }
          )
        }
        onClick=changeRoute
        onMouseDown={_ => preload()}
        onTouchStart={_ => preload()}>
        children
      </a>
    };
  };
};