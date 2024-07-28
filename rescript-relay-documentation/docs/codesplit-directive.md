---
id: codesplit-directive
title: The codesplit directive
sidebar_label: The @codesplit directive
---

#### Recommended background reading

- ["3D", data-driven dependencies](https://relay.dev/docs/glossary/#3d), in Relay

## The `@codesplit` directive

RescriptRelay ships with a unique feature called the `@codesplit` directive. This directive will, in a nut shell, let you automatically codesplit fragment components in a way that'll ensure that app starts downloading the code for the components as soon as a response from the server comes back that indicates that the component is going to be used.

This has 2 major benefits:

### Benefit 1: No waterfalls ever

Using the `@codesplit` directive, code for your codesplit component will always start downloading as soon as it possibly can.

The standard approach to codesplitting components in React is to use `React.lazy`. This is great, but the one downside is that loading the code to render the codesplit component will not start until the `React.lazy` component actually renders, unless you explicitly start preloading yourself earlier.

With `@codesplit` this splitting and preloading happens automatically.

### Benefit 2: Codesplitting is low-effort to do

The best optimizations are the one that are so easy and effortless to do that they get done. This is a big part of what makes Relay so good - it makes you fall into the pit of success.

The `@codesplit` directive has been designed with the intention to make it as easy and effortless as possible to do, with virtually no boilerplate.

### Bonus benefit: Fully client side

Relay has ["3D", data-driven dependencies](https://relay.dev/docs/glossary/#3d), which covers the same ground as the RescriptRelay `@codesplit` directive does. However, outside of being poorly documented and understood outside of Meta, it also requires server support for each GraphQL type you want to be able to use data-driven dependencies with, in the form of adding a special `js` field to each type.

`@codesplit` is fully client side and usable without server support. This means that you can start using it right away, and don't have to worry about maintaining server support for it.

### Moving on

We're now going to look at how to use the `@codesplit` directive in practice. However, if you want to read more about the rationale for this feature, and see examples of when it's particularly useful, scroll down to the [rationale section](#rationale).

## Using the `@codesplit` directive

The `@codesplit` directive goes on _fragment spreads_. This is important because this means that the user of a fragment component decides whether it makes sense to codesplit that component or not for this particular usage.

It works anywhere fragment spreads work - object types, unions, interfaces. Let's look at what you need to do to use it.

### 1. Setup the network layer

In your network layer, where you receive the response from the server, call `RescriptRelay.Network.preloadResources` with the operation, variables, and the response JSON you got back from your server:

```rescript
let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = async (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  let resp = await fetch(
    "https://your.server/graphql",
    {
      method: #POST,
      body: {"query": operation.text, "id": operation.id, "variables": variables}
      ->Js.Json.stringifyAny
      ->Belt.Option.getExn
      ->Body.string,
      headers: Headers.fromObject({
        "content-type": "application/json",
        "accept": "application/json",
      }),
    },
  )

  if Response.ok(resp) {
    let response = await Response.json(resp)
    // change-line
    RescriptRelay.Network.preloadResources(~operation, ~variables, ~response)
    response
  } else {
    panic("Request failed: " ++ Response.statusText(resp))
  }
}
```

`preloadResources` is what'll make sure that any codesplit components are preloaded appropriately depending on whether that component's data matches or not.

> Support for chunked responses, like when using `@defer`, is coming soon.

### 2. Use the directive and render the codesplit component

Now that we have the network layer setup, we can do some actual codesplitting.

Let's look at what a real world example of when using `@codesplit` might make sense looks like.

#### Lazy loading a blog post markdown renderer only when we're actually going to be rendering markdown

We have a simple blog post view that renders a blog post. The blog post content can be in 2 different forms - either plain text, or markdown. First, let's look at what this could look like **without** codesplitting (we'll add that in the next section):

```rescript
module Query = %relay(`
  query BlogPostView($id: ID!) {
    blogPost(id: $id) {
      title
      content {
        ... on Markdown {
          ...BlogPostMarkdownRenderer_content @alias
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

> Read more about the [`@alias` directive here](docs/alias). Using it is not required when not using `@codesplit`, but it's used here to make the next diff easier to understand.

There, we're rendering a blog post! However, we have a problem here. The `<BlogPostMarkdownRenderer />` is heavy code-wise, since it ships an entire markdown parser and renderer. We don't want to load that code unless the content for that blog post is actually markdown.

Let's use the `@codesplit` directive to achieve that:

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

There! With just 2 lines of code changed we've now created and use a codesplit component that'll be automatically preloaded as soon as possible for you whenever it matches, avoiding any potential waterfalls. Fully connected to your graph.

Here's what happens in the code above:

- The `@codesplit` directive is used on the spread of `BlogPostMarkdownRenderer_content`. This fragment is defined by the `BlogPostMarkdownRenderer.res` component.
- Notice the [`@alias` directive](using-fragments.md#conditional-fragments-and-more-with-the-alias-directive). It's required when using `@codesplit`.
- A `React.lazy` codesplit version of `<BlogPostMarkdownRenderer />` is automatically generated and exposed under `Query.CodesplitComponents.BlogPostMarkdownRenderer`.
- We switch on the data like usual. But, before we actually render `<BlogPostMarkdownRenderer />`, we make sure to open `Query.CodesplitComponents`. This ensures that the codesplit component is the one we're actually using.
- That `open` is particularly useful when you make several codesplit components - just open and you can be sure you're using the correct codesplit version.

Now, what we don't see here is that as soon as the response comes back for the `BlogPostQuery`, the network layer will check whether `response.blogPost.content` is of type `Markdown`, and if so, start loading the code for `<BlogPostMarkdownRenderer />`. This happens in parallel to React rendering your view.

So, when React finally reaches and tries to render the codesplit `<BlogPostMarkdownRenderer />` component, code for that has already been loading for a while.

A few things to remember:

- You must use the `@alias` directive together with `@codesplit`, it's a requirement. The compiler will error if you don't.
- Remember to actually use the codesplit component as you render too. This is most easily done by adding that `open` listed above so that all codesplit components are exposed in scope automatically as you render.
- Any fragment ref props on the component you codesplit must be annotated properly. More on that in the next section.

### Annotate any fragment ref props on components you use `@codesplit` on

Note that you'll need to make a simple adjustment to any component you want to use `@codesplit` on - annotate any fragment ref props on the component.

Let's examplify by imagining the `<BlogPostMarkdownRenderer />` component. Normally, you'd leverage inference to not have to annotate the fragment refs property:

```rescript
// BlogPostMarkdownRenderer.res
module Fragment = %relay(`
  fragment BlogPostMarkdownRenderer_content on MarkdownContent {
    markdownText
  }
`)

@react.component
let make = (~content) => {
  let content = Fragment.use(content)

  MarkdownRenderer.render(content.markdownText)
}
```

This is neat because it infers the type of `content` for you, a type which is a bit complicated. However, because of how the types coming from Relay are currently designed, this won't be possible to infer when you codesplit the component. Therefore, you need to annotate the `content` prop:

```rescript
module Fragment = %relay(`
  fragment BlogPostMarkdownRenderer_content on MarkdownContent {
    markdownText
  }
`)

@react.component
// color2
let make = (~content) => {
// change-line
let make = (~content: RescriptRelay.fragmentRefs<[#BlogPostMarkdownRenderer_content]>) => {
  let content = Fragment.use(content)

  MarkdownRenderer.render(content.markdownText)
}
```

And with that, codesplitting will work.

> Note that this inference limitation comes from Relay bundling together all fragment refs on a single prop. With the `@alias` directive, this is about to change. So, this limitation might be lifted eventually.

### Wrapping up

There, that's it! You can now codesplit efficiently and with little effort. That's all you need to get `@codesplit` working.
