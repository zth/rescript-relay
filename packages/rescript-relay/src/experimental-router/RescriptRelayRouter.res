module RouteFamily = {
  type t = {
    preload: RescriptReactRouter.url => unit,
    matchesUrl: RescriptReactRouter.url => bool,
    render: RescriptReactRouter.url => React.element,
  }

  let matchesUrl = (t, url) => t.matchesUrl(url)
  let preload = (t, url) => t.preload(url)
  let render = (t, url) => t.render(url)

  let make = (~matchUrl, ~prepare, ~render) => {
    preload: url =>
      switch matchUrl(url) {
      | Some(params) =>
        let _ = prepare(params)
      | None => ()
      },
    matchesUrl: url =>
      switch matchUrl(url) {
      | Some(_) => true
      | None => false
      },
    render: url =>
      switch matchUrl(url) {
      | Some(params) => params->prepare->render
      | None => React.null
      },
  }
}

module Url = {
  type t = {
    pathname: string,
    query: string,
    hash: string,
  }

  @module @new external make: string => t = "url-parse"

  // Taken from RescriptReactRouter
  module RouterCompat = {
    let path = x =>
      switch x {
      | ""
      | "/" => list{}
      | raw =>
        /* remove the preceeding /, which every pathname seems to have */
        let raw = Js.String.sliceToEnd(~from=1, raw)
        /* remove the trailing /, which some pathnames might have. Ugh */
        let raw = switch Js.String.get(raw, Js.String.length(raw) - 1) {
        | "/" => Js.String.slice(~from=0, ~to_=-1, raw)
        | _ => raw
        }

        raw->Js.String2.split("/")->Belt.List.fromArray
      }

    let hash = x =>
      switch x {
      | ""
      | "#" => ""
      | raw =>
        /* remove the preceeding #, which every hash seems to have.
         Why is this even included in location.hash?? */
        raw->Js.String.sliceToEnd(~from=1)
      }

    let search = x =>
      switch x {
      | ""
      | "?" => ""
      | raw =>
        /* remove the preceeding ?, which every search seems to have. */
        raw->Js.String.sliceToEnd(~from=1)
      }
  }
  let toRouterUrl: t => RescriptReactRouter.url = t => {
    open RouterCompat
    {
      path: t.pathname->path,
      search: t.query->search,
      hash: t.hash->hash,
    }
  }
}

type routeEntry = {
  route: option<RouteFamily.t>,
  url: RescriptReactRouter.url,
}

type subscriberCallback = routeEntry => unit
type disposeSubscriber = unit => unit

type routerContext = {
  get: unit => routeEntry,
  preload: string => unit,
  subscribe: subscriberCallback => disposeSubscriber,
}

let context = React.createContext(Obj.magic())

module Provider = {
  let make = React.Context.provider(context)

  let makeProps = (~value, ~children, ()) =>
    {
      "value": value,
      "children": children,
    }
}

exception No_router_in_context

let use = () => React.useContext(context)

let make = routes => {
  let initialUrl = RescriptReactRouter.dangerouslyGetInitialUrl()

  let matchRoutes = (routes, url): option<RouteFamily.t> =>
    routes->Belt.Array.getBy(r => r->RouteFamily.matchesUrl(url))

  let currentRoute: ref<routeEntry> = ref({url: initialUrl, route: matchRoutes(routes, initialUrl)})

  let subscribers: Js.Dict.t<option<subscriberCallback>> = Js.Dict.empty()
  let subId = ref(0)

  let getNextId = () => {
    subId := subId.contents + 1
    subId.contents->string_of_int
  }

  let _ = RescriptReactRouter.watchUrl(url =>
    if url != currentRoute.contents.url {
      let route = matchRoutes(routes, url)

      switch route {
      | Some(r) => r->RouteFamily.preload(url)
      | None => ()
      }

      let nextEntry = {route: route, url: url}

      currentRoute := nextEntry
      subscribers
      ->Js.Dict.values
      ->Belt.Array.forEach(x =>
        switch x {
        | Some(cb) => cb(nextEntry)
        | None => ()
        }
      )
    }
  )

  let router = {
    get: () => currentRoute.contents,
    preload: url => {
      let asRouterUrl = url->Url.make->Url.toRouterUrl

      switch routes->matchRoutes(asRouterUrl) {
      | Some(r) => r->RouteFamily.preload(asRouterUrl)
      | None => ()
      }
    },
    subscribe: cb => {
      let id = getNextId()
      subscribers->Js.Dict.set(id, Some(cb))
      () => subscribers->Js.Dict.set(id, None)
    },
  }

  router
}

module RouteRenderer = {
  @react.component
  let make = (~renderPending=?, ~renderFallback=?, ~renderNotFound=?, ()) => {
    let (initialized, setInitialized) = React.useState(() => false)
    let router = use()

    let (startTransition, isPending) = ReactExperimental.unstable_useTransition()

    let (routeEntry, setRouteEntry) = React.useState(() => router.get())

    switch (initialized, routeEntry.route) {
    | (false, Some(r)) =>
      r->RouteFamily.preload(routeEntry.url)
      setInitialized(_ => true)
    | _ => ()
    }

    React.useEffect2(() => {
      let currentEntry = router.get()
      if routeEntry.url != currentEntry.url {
        setRouteEntry(_ => currentEntry)
        None
      } else {
        let dispose = router.subscribe(nextRoute =>
          startTransition(() => setRouteEntry(_ => nextRoute))
        )

        Some(dispose)
      }
    }, (router, startTransition))

    let renderedContent = switch (initialized, routeEntry.route) {
    | (false, Some(_) | None) => None
    | (true, Some(r)) => Some(r->RouteFamily.render(routeEntry.url))
    | (true, None) => None
    }

    initialized
      ? <>
          {switch renderPending {
          | Some(renderPending) => renderPending(isPending)
          | None => React.null
          }}
          <React.Suspense
            fallback={switch renderFallback {
            | Some(renderFallback) => renderFallback()
            | None => React.null
            }}>
            {switch (renderedContent, renderNotFound) {
            | (Some(content), _) => content
            | (None, Some(renderNotFound)) => renderNotFound(routeEntry.url)
            | (None, None) => React.null
            }}
          </React.Suspense>
        </>
      : React.null
  }
}

let isModifiedEvent = e => {
  open ReactEvent.Mouse
  switch (e->metaKey, e->altKey, e->ctrlKey, e->shiftKey) {
  | (true, _, _, _)
  | (_, true, _, _) => true
  | (_, _, true, _) => true
  | (_, _, _, true) => true
  | _ => false
  }
}

module Link = {
  @react.component
  let make = (
    ~to_,
    ~title=?,
    ~id=?,
    ~className=?,
    ~classNameDynamic=?,
    ~target as browserTarget=?,
    ~mode=?,
    ~render=?,
    ~preloadOnHover=?,
    ~children,
    (),
  ) => {
    let router = use()
    let url = RescriptReactRouter.useUrl()

    let changeRoute = React.useCallback2(e => {
      open ReactEvent.Mouse
      switch (e->isDefaultPrevented, e->button, browserTarget, e->isModifiedEvent) {
      | (false, 0, None | Some(#self), false) =>
        e->preventDefault
        let navigate = () =>
          switch mode {
          | None
          | Some(#push) =>
            RescriptReactRouter.push(to_)
          | Some(#replace) => RescriptReactRouter.replace(to_)
          }

        navigate()
        ()
      | _ => ()
      }
    }, (to_, router))

    let preload = React.useCallback2(() => router.preload(to_), (to_, router))

    switch render {
    | Some(render) =>
      let linkUrl = to_->Url.make->Url.toRouterUrl
      render(~preload, ~changeRoute, ~currentUrl=url, ~linkUrl)
    | None =>
      <a
        href=to_
        target={switch browserTarget {
        | Some(#self) => "_self"
        | Some(#blank) => "_blank"
        | None => ""
        }}
        ?title
        ?id
        className={className->Belt.Option.getWithDefault("") ++
          switch classNameDynamic {
          | Some(f) => " " ++ f(url, to_->Url.make->Url.toRouterUrl)
          | None => ""
          }}
        onClick=changeRoute
        onMouseDown={_ => preload()}
        onTouchStart={_ => preload()}
        onMouseEnter={_ =>
          switch preloadOnHover {
          | Some(true) => preload()
          | Some(false) | None => ()
          }}>
        children
      </a>
    }
  }
}

module NavigationUtils: {
  let replaceShallow: string => unit
} = {
  @send
  external replaceShallow: (Dom.history, @as(json`null`) _, @as("") _, ~href: string) => unit =
    "replaceState"

  let replaceShallow = path =>
    switch (%external(history), %external(window)) {
    | (None, _)
    | (_, None) => ()
    | (Some(history: Dom.history), Some(_window: Dom.window)) => replaceShallow(history, ~href=path)
    }
}
