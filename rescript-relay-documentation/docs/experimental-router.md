---
id: experimental-router
title: Experimental Router
sidebar_label: Experimental Router
---

We're actively iterating on an experimental concurrent mode and suspense ready router designed for RescriptRelay, that enables you to do render-as-you-fetch. This lets you start loading both code and data for route in parallell, and as soon as possible, removing request waterfalls and ensuring routing is as fast and efficient as ever.

If you're interested, you're welcome to start testing this router and provide your feedback. The router is:

- Used actively in a fairly large production application, so it does indeed work
- Currently focused on a plain, client side app setup (think more ReactRouter than Next.js), although extending it to work well for SSR should be fairly trivial (get in touch if you're interested in this)
- Based on `RescriptReactRouter` and tries to be as bare bones as possible
- Somewhat opinionated, while trying to stay fairly flexible

Other than that, we try to leverage pattern matching and other language features as much as possible. Most things are "just ReScript".

To summarize - the router will work perfectly fine with the most setups, including:

- webpack
- Vite
- Rollup

However, because of the assumptions around control over routing built into some stacks, you cannot use this specific feature with for example Next.js.

### Getting started

The router will be included in the main RescriptRelay package once it's stable, but for now you'll need to copy it into your own project [from this gist](https://gist.github.com/zth/a48827c83aa6ebf8d1eb2c172e320726).

> You're encouraged to tweak it according to your needs as you copy it into your own project.

#### Setting it up in your project

First, copy the files into your project as described above. You'll also need to install `url-parse` to your project:

```
yarn add url-parse
```

Next, add a file where you'll construct your router. We'll call it `Routes.res`:

```reason
/* Routes.res */
let routerContext = RescriptRelayRouter.make([
  /* We'll put our route families here in a sec */
])
```

Wire the router up by wrapping your app with `RescriptRelayRouter.Provider` just like you'd wrap your app with any other top level React context provider, feeding it the `Routes.routerContext` you just constructed:

```reason
/* Main.res */
...
<RescriptRelayRouter.Provider value={Routes.routerContext}>
  ...
</RescriptRelayRouter.Provider>
```

Now, the final step! Render `RescriptRelayRouter.RouteRenderer` where you want the router to render in your app (usually at the top level):

```reason
/* App.res */
<RescriptRelayRouter.RouteRenderer
  renderFallback={() => <Skeletons.Page />}
  renderNotFound={_ => <FourOhFour.Standard />}
  renderPending={pending => <PendingIndicatorBar pending />}
/>
```

A few things to distill with `RescriptRelayRouter.RouteRenderer`:

- `renderFallback` lets you control what's rendered when the router _itself_ suspends, like when loading a route the first time.
- `renderNotFound` controls what is rendered if no route family matches at all. Ideally, _this should not happen_, as the better solution is to provide a catch-all route family that handles if no other route family matches. But hey, you know, safety first..
- `renderPending` renders whenever a new route is pending render, and is controlled by a concurrent mode `useTransition`. It's suitable to render some form of progress indicator here.

There, we've wired it all up! Let's look at how defining our first route family (and navigating to it) looks.

#### Defining your first route family

The router uses a concept called _route families_. This really isn't that complicated, so instead of risking unecessarily complicating this by trying to explain it in some "smart" way, we'll just look at how defining a simple one looks.

First, let's look at the type signature for `RescriptRelayRouter.RouteFamily.make`:

```reason
let make: (
  ~matchUrl: RescriptReactRouter.url => option<'routeParams>,
  ~prepare: 'routeParams => 'prepared,
  ~render: 'prepared => React.element,
) => RescriptRelayRouter.RouteFamily.t
```

`matchUrl` gets a `url`, which it then potentially matches on and maybe extracts parameters from. These parameters are then fed into `prepare`, which prepares the route for render. Finally, `render` renders the route usign what `prepare` gives it.

Now, with that knowledge fresh in mind, defining a route family looks like this in its simplest form:

> You're strongly encouraged to read [this section about `RescriptReactRouter`](https://rescript-lang.org/docs/react/latest/router) prior to reading this part.

```reason
/* Routes.res */
let userRoutes = RescriptRelayRouter.RouteFamily.make(
  ~matchUrl=url =>
    switch url.path {
    | list{} => Some(#Dashboard)
    | list{"profile", userId} => Some(#UserProfile(userId))
    | _ => None
    },
  ~prepare=route => route,
  ~render=route =>
    switch route {
    | #Dashboard => <Dashboard />
    | #UserProfile(userId) => <UserProfile userId />
    },
)
```

- `matchUrl` gets a `url: RescriptReactRouter.url` and is expected to return an option where `Some` indicates this route family matches for the url, and `None` indicates that it doesn't.
- `matchUrl` is free to return an option of _anything_ (more about this later). Here we've opted to match on the url to extract the params we need to render our different pages. We use [polymorphic variants](https://rescript-lang.org/docs/manual/latest/polymorphic-variant#sidebar) as an ergonomic way of getting strong type safety, leveraging inference to avoid having to declare our types in advance. But again, you're free to do whatever you want.
- `prepare` just passes whatever `matchUrl` provides it directly to `render` here. Our upcoming examples will show how we can use `prepare` to leverage Relay's ability to preload data.
- `render` takes whatever `prepare` gives to it and puts actual pixels on the screen.

Now, wire this up in `Routes.res` and we're good to go rendering our first routes!

```reason
/* Routes.res */
let routerContext = RescriptRelayRouter.make([
  userRoutes
])
```

We just pass a single route family to `RescriptRelayRouter.make` here, but you can of course pass any number of route families you want to it.

### Preloading data with the router

Let's look at how we can leverage Relay's excellent support for preloading data in order to start loading data for our routes as soon as we possibly can.

We'll re-use our `userRoutes` example, but the `Dashboard` component will now have its own query we'd like to start loading as soon as we can.

First, let's look at what the `Dashboard` component could look like:

```reason
/* Dashboard.res */
module Query = %relay(`
  query DashboardQuery {
    me {
      ...DashboardUserInfo_user
    }
  }
`)

@react.component
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef, ())

  <DashboardUserInfo user=data.me.fragmentRefs />
}
```

So, we have a `<Dashboard />` component that defines a query called `DashboardQuery`. The component expects that someone has already kicked off the loading of `DashboardQuery` when it renders, as we use `Query.usePreloaded`, which is expecting a `queryRef` (which you get when you start loading a query ahead of time).

Don't worry if all of this doesn't make sense now, it'll hopefully be clearer in a sec.

Now, two things need to change in `userRoutes` for us to be able to render `<Dashboard />` - we'll need to start loading `DashboardQuery`, and we'll need to pass the `queryRef` that gives us to `<Dashboard />`:

```reason
/* Routes.res */
let userRoutes = RescriptRelayRouter.RouteFamily.make(
  ~matchUrl=url =>
    switch url.path {
    | list{} => Some(#Dashboard)
    | list{"profile", userId} => Some(#UserProfile(userId))
    | _ => None
    },
  ~prepare=route =>
    switch route {
    /* Start loading the query for the Dashboard route here, and pass the queryRef along */
    | #Dashboard =>
      #Dashboard(
        DashboardQuery_graphql.load(
          ~environment=RelayEnv.environment,
          ~variables=(),
          ~fetchPolicy=StoreOrNetwork,
          (),
        ),
      )
    /* Just pass along anything else as-is */
    | route => route
    },
  ~render=route =>
    switch route {
    /* Pass the queryRef to the Dashboard component so it can render */
    | #Dashboard(queryRef) => <Dashboard queryRef />
    | #UserProfile(userId) => <UserProfile userId />
    },
)
```

Ahh look at that, `prepare` finally does something! Let's break down what's going on here.

- `prepare` now kicks off `DashboardQuery` by calling its `load` method.
- Notice the name of the module that has the `load` method - `DashboardQuery_graphql`. All queries (and all other operations/fragments for that matter) will have a file like this generated, and for queries that file will contain a `load` method. That load method can be used to start loading that query at any time, and will return a `queryRef` whenever it's called. That `queryRef` can then be fed into `Query.usePreloaded`, like shown above.

And viola, we've added data preloading of data to our router!

There are a few more tricks we'll cover, but before doing that, let's have a brief look at how it looks to link to one of these routes.

### Linking to a route

The router ships with a `<RescriptRelayRouter.Link>` component. This component lets you render a link that'll use the router to preload data.

> You're encouraged to copy the `Link` component into project and customize it as you need.

Linking to any route is as simple as passing the desired url to the `Link` component:

```reason
<RescriptRelayRouter.Link to_="/" preloadOnHover=true>
  {React.string("Go to the dashboard")}
</RescriptRelayRouter.Link>
```

The snippet above links to the `Dashboard`, and whenever that link is hovered, it'll automatically start loading the data for `Dashboard`. Nice!

### Preloading code (experimental experimental)

Now, preloading data is only half the story. For things to be really efficient, we'll also want to preload the _code_ for our route, so that we can safely code split it.

ReScript currently doesn't have the primitives needed for using dynamic imports without quite a lot of hassle. So, as a workaround, we've opted to add a solution to RescriptRelay, just to enable easy code splitting and preloading of code for the routes in your app. This is _highly experimental_ and will hopefully be replaced by something more official in the future.

#### Creating a code split React component

Anyway, disclaimers aside, with RescriptRelay you can very easily create a fully lazy, code split component leveraging `React.lazy` by doing the following:

```reason
/* DashboardLazy.res */
include %relay.lazyComponent(Dashboard.make)
```

There! Now you can use `<DashboardLazy />` like you'd use `<Dashboard />`, but it'll be dynamically imported. _Note_ though that this relies on the following conventions:

- You must place your lazy file _right next to_ the file it refers to. So `DashboardLazy.res` needs to live in the same folder as `Dashboard.res`.
- It currently only works if you have `.bs.js` as the configured extension in ReScript.

We hope these conventions can be lifted once ReScript has the proper primitives for dynamic imports.

#### Preloading the code for the component

But, like with our data, we want to start loading the code for this component as soon as we can, rather than waiting for a render to trigger loading the code. For this very reason, `%relay.lazyComponent` generates a `preload` function that we can use to start loading the code for the component whenever we want.

Let's look at how we'd integrate this into our previous example:

```reason
/* Routes.res */
let userRoutes = RescriptRelayRouter.RouteFamily.make(
  ~matchUrl=url =>
    switch url.path {
    | list{} => Some(#Dashboard)
    | list{"profile", userId} => Some(#UserProfile(userId))
    | _ => None
    },
  ~prepare=route =>
    switch route {
    | #Dashboard =>
      /* Start loading the code for the route component */
      DashboardLazy.preload()

      #Dashboard(
        DashboardQuery_graphql.load(
          ~environment=RelayEnv.environment,
          ~variables=(),
          ~fetchPolicy=StoreOrNetwork,
          (),
        ),
      )
    /* Just pass along anything else as-is */
    | route => route
    },
  ~render=route =>
    switch route {
    /* Pass the queryRef to the Dashboard component so it can render */
    | #Dashboard(queryRef) => <DashboardLazy queryRef />
    | #UserProfile(userId) => <UserProfile userId />
    },
)
```

Notice the following:

- `render` now renders `DashboardLazy` and not `Dashboard`
- `prepare` calls `DashboardLazy.preload()` to start loading the code for `Dashboard` as soon as it can

Viola, we now have _both_ preloading of data and code - render-as-you-fetch! A really powerful method for making routing both efficient and fast.

> In the future, we hope to replace this somewhat manual process with "entry points", a concept in Relay that combines loading both code and data together. But for now, this will have to do.

### Tips and tricks

Here follows a number of tips and tricks that'll make life easier using this router.

#### Organizing routes

It's up to you how you want to organize your routes. Some people prefer one huge route family detailing all routes, while others like to break the routing up in different route families. It's all up to you, the router will be fine with either.

#### Navigating programatically

Navigating programatically is just like with `RescriptReactRouter`, but ideally you should call `router.preload(urlOfNewRoute)` to leverage all of the goodies of preloading the route as soon as possible. Check out the included `Link` component for an example of how `router.preload` can be used.

#### Query params

Query params is fully up to you how you want to handle. The `url` of `matchUrl` will give you a `url.search`, which is a `string` with the search string for the current route. Use your favorite method of decoding that string into parameters, and just pass those along to `prepare`. Here's a simplified example:

```reason
/**
 * Imagine `DashboardRouteUtils.decodeQueryParams` takes a url like
 * `/?showFriends=true&tab=Profile`and returns a record like:
 * type params = {showFriends: bool, tab: [#Profile | #Settings]}
 */
let userRoutes = RescriptRelayRouter.RouteFamily.make(
  ~matchUrl=url =>
    switch url.path {
    | list{} => Some(#Dashboard(DashboardRouteUtils.decodeQueryParams(url.search)))
    | _ => None
    },
  ~prepare=route =>
    switch route {
    | #Dashboard(params) =>
      DashboardLazy.preload()

      #Dashboard(
        DashboardQuery_graphql.load(
          ~environment=RelayEnv.environment,
          ~variables={showFriends: params.showFriends},
          ~fetchPolicy=StoreOrNetwork,
          (),
        ),
        /* Pass along the decoded query params too */
        params
      )
    },
  ~render=route =>
    switch route {
    | #Dashboard(queryRef, params) =>
      <DashboardLazy
        queryRef
        showFriends=params.showFriends
        tabOpen=params.tab
      />
    },
)
```

Again, it's all just regular ReScript. So, use whatever approach you want and feel comfortable with for decoding and using the query params.

#### Navigating shallowly

Sometimes you want to persist state (like what tab is open in the example above) to the URL, but not necessarily trigger a full rerender and route change when all you do is update the query params. The typical example is when refetching something using a refetch query and new variables, but also persisting these variables to the URL.

`RescriptRelayRouter` provides a helper for this - `RescriptRelayRouter.NavigationUtils.replaceShallow(newUrl)`. This will replace the current url, but without triggering any router update.

So, using this helper will let you persist state to the URL without unecessarily retriggering any query already covered by the refetch you're making.

#### Handling child routes

_To be updated_. In short - no child routes baked in to the router, do it yourself. In the future the router will probably provide some helpers to simplify things, like setting up outlets that can help control rendering sub-parts of the page in a more maintainable way. But for now, do it yourself.

#### Shared layouts between routes

Since there are no child routes with this router, we'll need to make sure that we always return the same top level layout component when rendering our routes, if we want to avoid full re-mounts of the app.

Here's an example of something that'd work:

```reason
let userRoutes = RescriptRelayRouter.RouteFamily.make(
  ~matchUrl=url =>
    switch url.path {
    | list{} => Some(#Dashboard)
    | list{"profile"} => Some(#Profile)
    | list{"settings"} => Some(#Settings)
    | _ => None
    },
  ~prepare=route => route,
  ~render=route =>
    /* Notice we render SharedLayout around all actual route components */
    <SharedLayout>
      {switch route {
      | #Dashboard => <Dashboard />
      | #Profile => <Profile />
      | #Settings => <Settings />
      }}
    </SharedLayout>,
)
```

This will work since `<SharedLayout />` is _always_ the component that's returned. It would _not work_ if `<SharedLayout />` was returned by any of the route components - it'd still count as a new component to React even if it's the same component that's returned, and React would force a full remount of the router. Not good.

### Relay, concurrent mode and suspense gives you super powers

_WIP_.

- Fine grained control
- Partial rendering, leveraging fragments the right way
- Placing suspense boundaries

### The future

_WIP_.

- A better and more feature complete Link component
- Relay entry points
- Outlets
