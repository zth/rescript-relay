---
id: tutorial-fragments-1
title: Fragments
sidebar_label: Fragments
---

# Fragments

Fragments are one of the defining features of Relay. They let each component declare its own data needs independently, while retaining the efficiency of a single query. In this section, we’ll show how to split a query up into fragments.

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

---

Let’s say we want our Story component to show the date that the story was posted. To do that, we need some more data from the server, so we’re going to have to add a field to the query.

Go to `Newsfeed.res` and find `NewsfeedQuery` so that you can add the new field:

```rescript
module NewsfeedQuery = %relay(`
  query NewsfeedQuery {
    topStory {
      title @required(action: NONE)
      summary @required(action: NONE)
      // change-line
      createdAt @required(action: NONE) // Add this line
      poster @required(action: NONE) {
        name @required(action: NONE)
        profilePicture @required(action: NONE) {
          url
        }
      }
      thumbnail @required(action: NONE) {
        url
      }
    }
  }
`)
```

Now go to `Story.res` and modify it to display the date:

```rescript
type story = {
  title: string,
  summary: string,
  // change-line
  createdAt: string, // Add this line
  thumbnail: Image.image,
  poster: PosterByline.poster,
}

  ...
    <Card>
      <PosterByline person={story.poster} />
      <Heading>{story.title}</Heading>
      // change-line
      <Timestamp time={story.createdAt} /> // Add this line
      <Image image={story.image} />
      <StorySummary summary={story.summary} />
    </Card>
  ...
```

The date should now appear. And thanks to GraphQL, we didn't have to write and deploy any new server code.

But if you think about it, why should you have had to modify `Newsfeed.res`? Shouldn’t React components be self-contained? Why should Newsfeed care about the specific data required by Story? And why should `Story.res` care about the types produced by the Newsfeed query? What if the data was required by some child component of Story way down in the hierarchy? What if it was a component that was used in many different places? Then we would have to modify many components whenever its data requirements changed.

The avoid these and many other problems, we can move the data requirements for the Story component into `Story.res`.

We do this by splitting off `Story`’s data requirements into a _fragment_ defined in `Story.res`. Fragments are separate pieces of GraphQL that the Relay compiler stitches together into complete queries. They allow each component to define its own data requirements, without paying the cost at runtime of each component running its own queries.

![The Relay compiler combines the fragment into the place it's spread](/img/docs/tutorial/fragments-newsfeed-story-compilation.png)

Let’s go ahead and split `Story`’s data requirements into a fragment now.

---

### Step 1 — Define a fragment

In `Story.res`, delete the `story` type and add this fragment:

```rescript
module Fragment = %relay(`
  fragment Story_story on Story {
    title @required(action: NONE)
    summary @required(action: NONE)
    createdAt @required(action: NONE)
    poster @required(action: NONE) {
      name @required(action: NONE)
      profilePicture @required(action: NONE) {
        url
      }
    }
    thumbnail @required(action: NONE) {
      url
    }
  }
`)
```

We’ve taken all of the selections from `topStory` in our `Newsfeed` query and copied them into this new Fragment declaration. Like queries, fragments have a name (`StoryFragment`), which we’ll use in a moment, but they also have a GraphQL type (`Story`) that they’re “on”. This means that this fragment can be used whenever we have a `Story` node in the graph, no matter how we got that `Story`.

There are also rules for what you can call a fragment. They're a bit more lax. Start the fragment with the name of the component and you're good. A common pattern is to suffix with the type that the fragment is on, here `_story`, making the final name of the component `Story_story`.

### Step 2 - Use the fragment

Now that `Story` defines its own data requirements with the fragment, we can use this directly. To access the data selected by a fragment, we use the _use_ hook on the `Fragment` module.

```rescript
@react.component
let make = (~story) => {
  let data = Fragment.use(story)

  switch data {
  | None => "Failed to load story"->React.string
  | Some(story) =>
    <Card>
      <PosterByline poster={(story.poster :> PosterByline.poster)} />
      <Heading> {story.title->React.string} </Heading>
      <Timestamp time={story.createdAt} />
      <Image image={(story.thumbnail :> Image.image)} width={400} height={400} />
      <StorySummary summary={story.summary} />
    </Card>
  }
}
```

You know `:>` from before. Since nulls are cascading to the top of the fragment, we switch on data and add a small debug message in case fetching a story fails or there is missing data.

`Fragment.use` takes one argument, the _fragment key_. The fragment key is passed down from where the fragment was spread (we'll do that very shortly). The hook returns the data selected by that fragment.

:::tip
We call `Fragment.use`, because that is the name we gave to the module returned by `%relay`. If we had done e.g. `module MyFragment = %relay( ... )`, then the hook to use would have been `MyFragment.use`. There are no rules for what you name the module, only what you name the query or fragment (or mutation or subscription) _inside_ `%relay( ... )`.
:::

### Step 3 - Spread the fragment

The type returned by `NewsfeedQuery.use` is 

```rescript
type NewsfeedQuery_graphql.Types.response = {
  topStory: option<response_topStory>,
}

type response_topStory = {
  createdAt: string,
  poster: response_topStory_poster,
  summary: string,
  thumbnail: response_topStory_thumbnail,
  title: string,
}
```

We now want to replace all the manual selection of fields in `Newsfeed.res` with the fragment we just defined. The syntax to do that is `...[FragmentName]`. Since `topStory` returns `Story`, we can spread `Story_story` inside `topStory`. Change the query in `Newsfeed.res` to look like this:

```rescript
module NewsfeedQuery = %relay(`
  query NewsfeedQuery {
    topStory {
      ...Story_story
    }
  }
`)
```

_Now_ the type is 

```rescript
type NewsfeedQuery_graphql.Types.response = {
  topStory: option<response_topStory>,
}

type response_topStory = {
  fragmentRefs: RescriptRelay.fragmentRefs<[#Story_story]>,
}
```

This means that the hook returns a record that has a `topStory` field that is an optional array of fragment keys spread on the corresponding field in the query. Here there's only the `Story_story` fragment, but if we had spread another fragment that name would appear in the list too.

Technically, `fragmentRefs` is a record that contains some hidden fields that tell Relay where to look for the data it needs. The fragment key specifies both which node to read from (here there's just one story, but soon we'll have multiple stories), and what fields can be read out (the fields selected by that specific fragment). The `Fragment.use` hook reads that specific information out of Relay's local data store.

Since `Story.res` now expects a fragment key, we change the `make` funtion of `Newsfeed.res` to pass that key using the `fragmentRefs` property.
```rescript
@react.component
let make = () => {
  let data = NewsfeedQuery.use(~variables=())

  switch data.topStory {
  | None => React.null
  | Some(topStory) =>
    <div className="newsfeed">
      // change-line
      <Story story={topStory.fragmentRefs} />
    </div>
  }
}
```

`Story`'s data requirements are now completely encapsulated in `Story`. To get the data you have to call the `use` hook on the module wherein the fragment is defined and the fragment is co-located with the component that uses the fragment. 

With Relay, unless a component specifically asks for data with a fragment, that data will not be visible. This is called _data masking_. It makes sure that component A cannot use data that component B is asking for. This in turn makes sure that you don't create accidental dependencies between components so that component A does not break if component B is changed to not ask for that data anymore. This keeps components self-contained and maintainable and means they can evolve independently without worrying about breaking something elsewhere in your app.


:::note
As we'll see in later examples, you can spread multiple fragments into the same place in a query, and also mix fragment spreads with directly-selected fields.
:::

You don't need to take any extra steps for this to be type safe. ReScript will automatically ensure that you're passing the correct object with the correct fragment keys, as well as infer that the data from `Fragment.use` is the data your fragment defines.

With that done, we have a `Newsfeed` that no longer has to care what data `Story` requires, yet can still fetch that data up-front within its own query.

---

## Exercise

The `PosterByline` component used by `Story` renders the poster’s name and profile picture. Use these same steps to fragmentize `PosterByline`. You need to:

- Declare a `PosterByline_actor` fragment on `Actor` and specify the fields it needs (`name`, `profilePicture`). The `Actor` type represents a person or organization that can post a story. Add `@required` as needed and you think makes sense.
- Call `use` on the fragment to retrieve the data and pass to the child components. Remember to use `:>` so you can pass the `profilePicture` to `Image`.
- Spread `PosterByline_actor` fragment within `poster` in the `Story_story` fragment and pass the `fragmentRef` to `PosterByLine`.

It’s worth going through these steps a second time, to get the mechanics of using fragments under your fingers. There are a lot of parts here that need to slot together in the right way.

Once you’ve done that, let’s look at a basic example of how fragments help an app to scale.

---

## Reusing a Fragment in Multiple Places

A fragment says, given _some_ graph node of a particular type, what data to read from that node. The fragment key specifies _which node_ in the graph the data is selected from. A re-usable component that specifies a fragment can retrieve the data from different parts of the graph in different contexts, by being passed a different fragment key.

Notice that the `Image` component is used in two places. The first is in `Story` for the story’s thumbnail image. The second is  `PosterByline` for the poster’s profile pic. Let’s fragmentize `Image` and see how it can select the data it needs from different places in the graph according to where it is used.

![Fragment can be used in multiple places](/img/docs/tutorial/fragments-image-two-places-compiled.png)

### Step 1 — Define and use the fragment

Open up `Image.res` and add a Fragment definition:

```rescript
module Fragment = %relay(`
  fragment Image_image on Image {
    url
  }
`)
```

and use the fragment to render the component

```rescript
@react.component
let make = (~image, ~width=?, ~height=?, ~className=?) => {
  let data = Fragment.use(image)
  <img key={data.url} src={data.url} ... />
}
```


### Step 2 — Spread the fragment and use the fragment

Spread `Image_image` into both `Story_story` and `PosterByline_actor` and pass the ref to the `Image` component

<Tabs>
  <TabItem value="1" label="Story.res" default>

```rescript
module StoryFragment = %relay(`
  fragment Story_story on Story {
    title
    summary
    postedAt
    poster {
      ...PosterByline_actor
    }
    thumbnail {
      // change-line
      ...Image_image
    }
  }
`)

...
@react.component
let make = (~story) => {
  ...

  <Card>
    <Timestamp time={story.createdAt} />
    // change-line
    <Image image={story.thumbnail.fragmentRefs} width={400} height={400} />
    <StorySummary summary={story.summary} />
  </Card>

  ...
```

  </TabItem>
  <TabItem value="2" label="PosterByline.res">

```rescript
module PosterBylineFragment = %relay(`
  fragment PosterBylineFragment on Actor {
    name
    profilePicture {
      // change-line
      ...Image_image
    }
  }
`)

...
@react.component
let make = (~poster) => {
  ...

  <div className="byline">
    // change-line
    <Image image={profilePicture.fragmentRefs} width={60} height={60} className="byline__image" />
    <div className="byline__name"> {name->React.string} </div>
  </div>

  ...
```

  </TabItem>
</Tabs>


### Step 3 — Modify once, enjoy everywhere

Now that we’ve co-located `Image`’s data dependencies and are using the fragment, we can add new dependencies to without modifying any of the components that use it!

Let’s add an `altText` label for accessibility to the `Image` component.

Edit `Image` as follows:

```rescript
module Fragment = %relay(`
  fragment Image_image on Image {
    url
    // change-line
    altText
  }
`)

@react.component
let make = (~image) => {
  ...
  <img
    // change-line
    alt=?{data.altText}
  ...
}
```

Now _both_ the story thumbnail image and the poster’s profile pic will have an alt text! Use your browser dev tools to verify it. We use `?` since `altText` is optional. We _can_ render an Image if it doesn't have an alt-text, so we don't want to make it `required` and have a missing alt-text prevent the image being displayed at all... even though you should try to make sure your images should have alt-texts!

So... with only local changes to `Image.res`, we were able to get and render alt-text for all of the images on our screen and still keep everything in _one, single top-level query!_ We changed the behaviour and data dependencies of a component by only modifying _that_ component _and_ we retain our efficient query!

It's easy to imagine how beneficial this is as your codebase grows. Each component is self-contained, no matter how many places it’s used! Even if a component is used in hundreds of places, you can add or remove fields from its data dependencies at will. This is one of the main ways that Relay helps you scale with the size of your app.

![Field added to one fragment is added in all places it's used](/img/docs/tutorial/fragment-image-add-once-compiled.png)

Fragments are the building blocks of Relay apps and a lot of Relay features are based on fragments. We’ll look at a few of them in the next sections.

---

## Fragment arguments and field arguments

Currently the `Image` component fetches images at their full size, even if they’ll be displayed at a smaller size. This is inefficient! The `Image` component takes a prop that says what size to show the image at, so it’s controlled by the component that uses `Image`. We'd like to also have the component that uses Image say what size of image to fetch within its fragment.

GraphQL fields can accept _arguments_ that give the server additional information to fulfill our request. For example, the `url` field on the `Image` type accepts `height` and `width` arguments that the server incorporates into the URL.

```graphql
type Image {
  url(height: Int, width: Int): String!
  altText: String
}
```

If we don't pass arguments to the `url` field

```graphql
fragment Example1 on Image {
  url
}
```

we might get the URL such as `/images/abcde.jpeg`

If we do something like this

```graphql
fragment Example2 on Image {
  url(height: 100, width: 100)
}
```

we'd get a url `/images/abcde.jpeg?height=100&width=100`

Now of course, we don’t want to just hard-code a specific size into `Image_image`, because we’d like the `Image` component to fetch a different size in different contexts. To this end, we can make the `Image_image` accept _fragment arguments_ so that the parent component can specify how large of an image should be fetched. These _fragment arguments_ can then be passed into specific fields (in this case `url`) as _field arguments_.

### Step 1 — Add argument definitions to the fragment

To do that, change the `Image_image` fragment to this:

```rescript
module Fragment = %relay(`
  fragment Image_image on Image
  @argumentDefinitions(
    width: { type: "Int", defaultValue: null }
    height: { type: "Int", defaultValue: null }
  ) {
    url(width: $width, height: $height)
    altText
  }
`)
```
- We’ve added an `@argumentDefinitions` directive to the fragment declaration. This says what arguments the fragment accepts. Each argument specifies:
  - Its name (here `width` and `height`)
  - Its type, which can be any <a href="https://graphql.org/learn/schema/#scalar-types">GraphQL scalar type</a> (here both are `Int`)
  - An optional default value. We have here defined a default value of `null`. If we don't supply a value for e.g. `height`, null will be passed to the `url` field. I.e. it is equivalent to `url(height: null)` which in turn is equivalent to `url`. If we didn't define a default value, we'd have to pass a value for the argument everywhere we spread the fragment.
- We finally pass the arguments to the `url` field. Here the field arguments and fragment arguments have the same names (as will often be the case) but note that `width:` is the field argument while `$width` is the variable created by the fragment argument.

### Step 2 — Pass arguments to the fragment

The different fragments using `Image_image` can now pass in the appropriate size for each image:

<Tabs>
  <TabItem value="1" label="Story.res" default>

```rescript
module StoryFragment = %relay(`
  fragment StoryFragment on Story {
    title
    summary
    postedAt
    poster {
      ...PosterBylineFragment
    }
    image {
      // change-line
      ...ImageFragment @arguments(width: 400)
    }
  }
`)
```

  </TabItem>
  <TabItem value="2" label="PosterByline.res">

```rescript
module PosterBylineFragment = %relay(`
  fragment PosterBylineFragment on Actor {
    name
    profilePicture {
      // change-line
      ...ImageFragment @arguments(width: 60, height: 60)
    }
  }
`)
```

  </TabItem>
</Tabs>

Now if you look at the images that our app downloads, you’ll see they’re of the smaller size, saving network bandwidth. Note that although we used integer literals for the value of our fragment arguments, we can also use variables supplied at runtime, as we'll see in later sections.

Field arguments (e.g. `url(height: 100)`) are a feature of GraphQL itself, while fragment arguments (as in `@argumentDefinitions` and `@arguments`) are Relay-specific features. The Relay compiler processes these fragment arguments when it combines fragments into queries.


<details>
<summary>Deep dive: More on GraphQL Directives</summary>

The syntax for arguments and argument defintions is based on _directives_. Directives are a way to extend the GraphQL language with custom features and you've already seen and used `@required`. In GraphQL any symbol starting with `@` is a directive. Their meaning isn't defined by the GraphQL spec, but is instead up to the specific client or server implementations to define.

Relay defines [several directives](https://relay.dev/docs/api-reference/graphql-and-directives/) to support its features — fragment arguments for one. These directives are not sent to the server, but give instructions to the Relay compiler at build time.

The GraphQL spec defines define the meaning of three directives:

- `@deprecated` is used in schema definitions and marks a field as deprecated.
- `@include` and `@skip` can be used to make the inclusion of a field conditional.

Besides these three, GraphQL servers can specify additional directives as part of their schemas. And Relay has its own build-time directives, which allow us to extend the language a bit without changing its grammar.

</details>

---

## Summary

Fragments are the most distinctive aspect of how Relay uses GraphQL. We recommend that every component that displays data and cares about the semantics of that data (so not just a typographic or formatting component) use a GraphQL fragment to declare its data dependences.

- Fragments help you scale: No matter how many places a component is used, you can update its data dependencies in a single place.
- Fragment data needs to be read out with the `use` hook for the fragment.
- `use` takes a _fragment key_ which says where in the graph to read from.
- Fragment keys come from places in a GraphQL response where that fragment was spread.
- Fragments can define arguments which are used at the point they’re spread. This allows them to be tailored to each situation they're used in.

We'll be revisiting many other features of fragments, such as how to refetch the contents of a single fragment without refetching the entire query. First, though, let's make this newsfeed app more newsfeed-like by learning about arrays.
