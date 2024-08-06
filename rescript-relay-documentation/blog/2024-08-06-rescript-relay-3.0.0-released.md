---
id: rescript-relay-3.0.0-released
title: RescriptRelay 3.0.0 released
author: Gabriel Nordeborn
authorTitle: Maintainer of RescriptRelay
authorURL: https://github.com/zth
authorImageURL: https://github.com/zth.png
authorTwitter: ___zth___
tags: ["releases"]
---

It's our great pleasure to announce the release of RescriptRelay 3.0.0. Version 3 is close to a rewrite, leveraging new and shiny features from both ReScript and Relay, creating the best and most idiomatic version of RescriptRelay yet.

In this post, we're going to talk about the new version and some of its features. But, let's start with a brief history of RescriptRelay, where we're at now, and where we're going.

## A brief history of RescriptRelay

RescriptRelay started out as the marriage between my two favorite technologies - ReScript and Relay.

I've been using Relay virtually since it came out. I'm still in love with it, and it gets better every day. To me, Relay is a proven way to build scalable, maintainable and performant apps in a way that is both fast and robust.

Similarily, ReScript is an equally large passion for me, and I love it for the same reasons I love Relay - it's a robust, fast, proven way to build scalable, maintainable and performant apps.

Naturally, marrying these two should be a good idea, right? Well, that's what I set out to do, and after countless hours (5 years and counting), I can say that with version 3 it's as good as ever.

### Relay is still a great bet to take

Quite a lot of time has passed since Relay and GraphQL was released to open source. And I strongly believe using it is still a great choice to make. In fact, Relay is still unique in that it addresses a lot of issues that not even recent innovations like React Server Components can address in a good way.

Meta also still works on it very actively, with the recent expansion of capabilites around local data and using Relay as your general state manager is a testament to. So, Relay continues to be a great bet. It's a proven technology with well know pros/cons, that's here to stay.

As for RescriptRelay, it has also been around for long and it's as actively developed as ever. We track new features from Relay, and move to new Relay versions as soon as they're released.

RescriptRelay is in production in quite a lot of companies, and I dare say the general experience is great! People enjoy working with it, and continue chosing it for new enedevours. For this I'm both grateful and excited.

## A dedicated router for RescriptRelay

In tandem with RescriptRelay, we've built [RescriptRelayRouter](https://github.com/zth/rescript-relay-router/blob/main/packages/rescript-relay-router/README.md), a web router (React Native coming soon?) built specifically for use with RescriptRelay. It's performant, fully type safe (including for URL search params), and has a bunch of great features and tooling.

Check it out!

## A Relay video series

Together with the release of v3, we've started recording a comprehensive video series on how to build great apps with ReScript + Relay (and RescriptRelayRouter). [Check it out here](/docs/relay-video-series). It's intended to serve as _onboarding material_ for developers new to RescriptRelay.

This is of course extra important when introducing RescriptRelay at your company, since it ensures you'll have a set path to get new developers productive with ReScript and Relay.

More videos are continuously being recorded and the goal is to cover all aspects of ReScript and Relay, including the more advanced techniques that exist.

## A few of the new features

That's enough background, let's look at some of the new features!

The lift from 1.0/2.0 to 3.0 has allowed us to enable a number of new very nice features from Relay in RescriptRelay, plus build some more unique features of our own. Version 3 is more robust, smoother, and leverages a bunch of new powerful features from ReScript v11+ that lets you write more concise and better Relay apps as well.

Below we'll take you on a tour of some of the new features.

### Input unions (RescriptRelay exclusive)

GraphQL maps quite well to ReScript, which is a big part in why ReScript and Relay works so well together. However, there are plenty of places still where you'll miss the power of ReScript's type system in GraphQL.

One of these things is input objects. For output types in GraphQL we have unions, which map well to variants in ReScript. However, GraphQL doesn't have unions for _inputs_. This can needlessly complicate APIs, because there's no good way to communicate that a field or mutation takes _one of_ a set of inputs.

Using the [`@oneOf` input object and fields RFC](https://github.com/graphql/graphql-spec/pull/825) in GraphQL, we've been able to work around this in RescriptRelay! Any time your server schema defines an input object with the `@oneOf` directive, RescriptRelay will give you a variant to use for that input instead of a regular object.

Here's an example:

```graphql
input Address {
  streetAddress: String!
  postalCode: String!
  city: String!
}

input Coordinates {
  lat: Float!
  lng: Float!
}

input Location @oneOf {
  byAddress: Address
  byCoordinates: Coordinates
  byId: ID
}

type Query {
  allShops(location: Location!): ShopConnection
}
```

This will produce the following variant for `location`:

```rescript
type input_ByAddress = {
  city: string,
}

type input_ByLoc = {
  lat: float,
}

type input_Location =
| ByAddress(input_ByAddress)
| ByLoc(input_ByLoc)
| ById(string)
```

Which in turn will let you interact with the input like this:

```rescript
@react.component
let make = (~lat, ~lng) => {
  let data = Query.use(~variables={location: ByCoordinates({lat, lng})})
}
```

This can make a world of difference for how easy to use and understandable an API is, and we're really happy this has landed in RescriptRelay. Read more in the [docs on input unions](/docs/input-unions).

### Updatable queries and fragments

[Updatable queries and fragments](https://relay.dev/docs/guided-tour/updating-data/typesafe-updaters-faq/#what-is-an-updatable-query-or-fragment) is Relay's new way of doing type safe, local updates to the cache. You'll use these in primarily 2 cases:

- When working with local state managed by Relay (more on this below)
- When updating the local cache after mutations

Previously, this has been quite complicated, since no official (and type safe) Relay API has existed. That's however fixed now!

Here's a basic example of an updatable query that lets you update a field in a type safe way:

```rescript
// ViewerCurrentActiveUpdater.res
module Query = %relay(`
  query ViewerCurrentlyActiveUpdaterQuery @updatable {
    loggedInUser {
      currentlyActive
    }
  }
`)

let updateCurrentlyActive = (currentlyActive: bool, ~environment: RescriptRelay.Environment.t) => {
  RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
    let {updatableData} = Query.readUpdatableQuery(store)

    updatableData.loggedInUser.currentlyActive = currentlyActive
  })
}
```

[Read more in the docs on updatable queries and fragments](/docs/interacting-with-the-store#updatable-fragments).

### Using Relay as your state manager with Relay resolvers and client schema extensions

With 3.0, we can finally officially recommend using Relay as your local state manager. We now support all relevant parts from Relay (which one notable exception in `@assignable` fragments, which will be supported soon).

Turns out, Relay is really powerful as a local state manager, because:

- It's performant by default, with granular re-renders
- It lets you twine together your local data with your server data
- It even lets you link to server data _from_ local data, so you can create your own local "subgraphs" that actually fetch data from the server
- It's all type safe, and for reading data you work with it just like with server data. No need to consider that it's really local data

This is very exciting, and will let many Relay apps get rid of other state managers like Redux, Recoil, Jotai etc entirely. Read more in the [docs on interacting with the store](/docs/interacting-with-the-store).

### Better codesplitting with @preloadable

The [`@preloadable`](https://relay.dev/docs/glossary/#preloadable) directive in Relay allows you to speed up and parallelize loading of data and component code even more by ensuring that the bare minimum to initiate the query for data is available separately so that it doesn't need to be bundled together with the code for also writing that response into the local data store.

RescriptRelayRouter already helps you separate loading data and code efficiently to eliminate waterfalls and ensure your network performance is efficient by default. `@preloadable` is another tool in the network performance toolbox, especially efficient for large queries.

Read more in the [docs on `@preloadable` in RescriptRelay](/docs/making-queries#the-preloadable-directive-available-in-v3).

### Easy and efficient data-driven codesplitting with @codesplit (RescriptRelay exclusive feature)

With RescriptRelayRouter and preloadable queries, codesplitting is very easy and efficient. But this is primarily at the _route level_. Sometimes you want to codesplit driven by what _data_ is returned, not what route you're on.

Imagine a blog post where the post content itself can be either plain text or in markdown. When we render markdown, we'll need to load a potentially heavy markdown parser and renderer. But, we don't want to load that unless the blog post content is actually markdown. Enter the `@codesplit` directive!

The `@codesplit` directive let's you mark fragment spreads to have their components codesplit automatically, and the code for the codesplit component downloaded as soon as possible as the server response with the component data comes back, if that component indeed matches.

An example:

```rescript
module Query = %relay(`
  query BlogPostView($id: ID!) {
    blogPost(id: $id) {
      title
      content {
        ... on Markdown {
// color2
          ...BlogPostMarkdownRenderer_content @alias
// change-line
          ...BlogPostMarkdownRenderer_content @alias @codesplit
        }
        ... on PlainText {
          text
        }
      }
    }
  }
`)

@react.component
let make = (~blogPostId) => {
  let data = Query.use(~variables={id: blogPostId})

  switch data.blogPost {
  | Some({title, content}) =>
// change-line
    open Query.CodesplitComponents

    <div>
      <Title>{React.string(title)}</Title>
      {switch content {
      | Some(Markdown({blogPostMarkdownRenderer_content})) =>
        <BlogPostMarkdownRenderer content=blogPostMarkdownRenderer_content />
      | Some(PlainText({text})) => <div>{React.string(text)}</div>
      | None => React.null
      }}
    </div>
  | None => <FourOhFour context="blog post" />
  }
}
```

That's all it takes! `<BlogPostMarkdownRenderer />` is now codesplit, and the code for it will be downloaded if it matches as soon as the server response comes back, not when the codesplit component is first rendered, like with vanilla `React.lazy`.

Check out the [`@codesplit` documentation](/docs/codesplit-directive) for more information and how to start using it.

> Another good example is something like Facebook's news feed, where there are potentially hundreds of different components that might be needed depending on what type of news feed items are returned from the server. You want to codesplit all of these so you only load code to render the actual stories you get back, but you won't know what components to load until you get the actual server response back. `@codesplit` helps you do this easily and with great performance.

### @alias and conditional fragments

Relay uses the fragment model, which is one of the most powerful things about GraphQL. However, it has traditionally been really difficult to figure out if a fragment was actually fetched or not.

With the [`@alias`](/docs/using-fragments#conditional-fragments-and-more-with-the-alias-directive) directive, this has now become possible, and easy! An example:

```rescript
module Query = %relay(`
  query BlogPostView($id: ID!) {
    blogPost(id: $id) {
// color2
      ...BlogPostTitle_post
// change-line
      ...BlogPostTitle_post @alias
    }
  }
`)

@react.component
let make = (~blogPostId) => {
  let data = Query.use(~variables={id: blogPostId})

  switch data.blogPost {
// color2
  | Some({fragmentRefs}) => <BlogPostTitle post=fragmentRefs />
// change-line
  | Some({blogPostTitle_post}) => <BlogPostTitle post=blogPostTitle_post />
  | None => <FourOhFour context="blog post" />
  }
}
```

Relay puts the fragment ref on its own prop here. This is especially important when including that fragment is conditional:

```rescript
module Query = %relay(`
  query BlogPostView($id: ID!, $includeTitle: Boolean!) {
    blogPost(id: $id) {
      ...BlogPostTitle_post @alias @include(if: $includeTitle)
    }
  }
`)

@react.component
let make = (~blogPostId, ~includeTitle) => {
  let data = Query.use(~variables={id: blogPostId, includeTitle})

  switch data.blogPost {
  | Some({blogPostTitle_post: Some(blogPostTitle_post)}) =>
    // With the regular `fragmentRefs` approach where all fragment refs are on the same prop,
    // there's no way to figure out if `BlogPostTitle_post` was actually included in the
    // response without resorting to hacks.
    <BlogPostTitle post=blogPostTitle_post />
  | _ => <FourOhFour context="blog post" />
  }
}
```

This makes working with conditional fragments easier and safer.

## Going from V2 to V3

Since V3 has a lot of changes, you'll need to take some manual steps to migrate from prior versions to V3. Check out the [migration doc](/docs/migrating-to-v3) for more information.

## Wrapping up

Thank you for reading, and we hope you're as excited as we are for RescriptRelay v3!

Oh, and also, if you haven't already, you should check out the [tutorial on RescriptRelay](/docs/tutorial/tutorial-intro). And of course, the new [Relay video series](/docs/relay-video-series).
