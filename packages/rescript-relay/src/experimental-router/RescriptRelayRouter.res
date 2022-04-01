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
  type t = RescriptReactRouter.url

  let getHash = url => {
    switch url->Js.String2.indexOf("#") {
    | index if index >= 0 => url->Js.String2.sliceToEnd(~from=index + 1)
    | _ => Js.String2.make("")
    }
  }

  // Start - taken from RescriptReactRouter
  let arrayToList = a => {
    let rec tolist = (i, res) =>
      if i < 0 {
        res
      } else {
        tolist(i - 1, list{Js.Array.unsafe_get(a, i), ...res})
      }
    tolist(Js.Array.length(a) - 1, list{})
  }
  let pathParse = str =>
    switch str {
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
      /* remove search portion if present in string */
      let raw = switch raw |> Js.String.splitAtMost("?", ~limit=2) {
      | [path, _] => path
      | _ => raw
      }

      raw
      |> Js.String.split("/")
      |> Js.Array.filter(item => String.length(item) != 0)
      |> arrayToList
    }

  let searchParse = str =>
    switch str {
    | ""
    | "?" => ""
    | raw =>
      switch raw |> Js.String.splitAtMost("?", ~limit=2) {
      | [_, search] => search
      | _ => ""
      }
    }
  // End - taken from RescriptReactRouter

  let parseUrl = (url: string): t => {
    path: url->pathParse,
    hash: url->getHash,
    search: url->searchParse,
  }

  let make = url => url->parseUrl
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

module NavigationUtils = {
  @send
  external replaceShallow: (Dom.history, @as(json`null`) _, @as("") _, ~href: string) => unit =
    "replaceState"

  let replaceShallow = path =>
    switch (%external(history), %external(window)) {
    | (None, _)
    | (_, None) => ()
    | (Some(history: Dom.history), Some(_window: Dom.window)) => replaceShallow(history, ~href=path)
    }

  @send
  external pushShallow: (Dom.history, @as(json`null`) _, @as("") _, ~href: string) => unit =
    "pushState"

  let pushShallow = path =>
    switch (%external(history), %external(window)) {
    | (None, _)
    | (_, None) => ()
    | (Some(history: Dom.history), Some(_window: Dom.window)) => pushShallow(history, ~href=path)
    }
}

let use = (): routerContext => React.useContext(context)

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
    if url.path != currentRoute.contents.url.path {
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
      let asRouterUrl = url->Url.make

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

type router = {
  push: string => unit,
  pushShallow: string => unit,
  replace: string => unit,
  replaceShallow: string => unit,
  preload: string => unit,
}

let useRouter = () => {
  let router = use()

  React.useMemo1(() => {
    push: RescriptReactRouter.push,
    pushShallow: NavigationUtils.pushShallow,
    replace: RescriptReactRouter.replace,
    replaceShallow: NavigationUtils.pushShallow,
    preload: router.preload,
  }, [router.preload])
}

module RouteRenderer = {
  @react.component
  let make = (~renderPending=?, ~renderFallback=?, ~renderNotFound=?, ()) => {
    let (initialized, setInitialized) = React.useState(() => false)
    let router = use()

    let (isPending, startTransition) = ReactExperimental.useTransition()

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
          startTransition(. () => setRouteEntry(_ => nextRoute), None)
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
    ~tabIndex=?,
    ~mode=?,
    ~render=?,
    ~preloadOnHover=?,
    ~children,
    ~onClick=?,
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
      let linkUrl = to_->Url.make
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
        ?tabIndex
        className={className->Belt.Option.getWithDefault("") ++
          switch classNameDynamic {
          | Some(f) => " " ++ f(url, to_->Url.make)
          | None => ""
          }}
        onClick={e => {
          changeRoute(e)
          switch onClick {
          | None => ()
          | Some(onClick) => onClick()
          }
        }}
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
