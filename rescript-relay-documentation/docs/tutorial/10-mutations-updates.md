---
id: tutorial-mutations-updates
title: Mutations & Updates
sidebar_label: Mutations & Updates
---

# Mutations & Updates

In this chapter we’ll learn how to update data on the server and client. We’ll go through two main examples:

- Implementing a Like button for newsfeed stories
- Implementing the ability to post comments on a newsfeed story

Updating data is a complicated problem domain, and Relay handles many aspects of it automatically, while also giving you a lot of manual control so that your app can be as robust as possible in handling the cases that can arise.

First let’s distinguish two terms:

- A _mutation_ is when you ask the server to perform some action that modifies data on the server. This is a feature of GraphQL that is analogous to an HTTP POST.
- An _update_ is when you modify Relay’s local client-side data store.

The client doesn’t have the ability to directly manipulate individual pieces of data on the server side. Rather, mutations are opaque, high-level requests that express the user’s intent — for example, that the user friended somebody, joined a group, posted a comment, liked a particular newsfeed story, blocked somebody, or deleted a comment. (The GraphQL schema defines what mutations are available, as well as the input parameters that each mutation accepts.)

Mutations can have far-reaching and unpredictable effects on the state of the graph. For example, let’s say you join a group. Many things can change:

- Your name gets added to the Group Members list
- The group’s membership count gets incremented
- The group gets added to your list of groups
- Members-only posts appear in the group’s post feed
- Your recommended groups may change
- The group’s admins may get notifications
- Many other non-user-visible effects such as logging, training models, or sending emails
- Etc. etc. etc.

In general, it’s impossible to know what the full downstream effect of a mutation may be. So after asking the server to perform a mutation, the client just has to do its best to update its local data store, keeping the data as consistent as reasonably possible. It does this by asking the server for specific updated data as part of the mutation response, and by imperative code — called an _updater_ — that fixes up the store to keep it consistent.

There is no principled solution that covers every case. Even if it were possible to know the full effect of a mutation on the graph, there are even circumstances where we don’t _want_ to show updated data right away. For example, if you go to somebody’s profile page and block them, you don’t want for everything shown on that page to immediately disappear. The question of what data to update is ultimately a UI design decision.

Relay tries to make it as easy as possible to update data in response to a mutation. For example, if you want to update a certain component, you can spread its fragment into your mutation, which asks the server to send updated data for whatever was selected by that fragment. For other cases, you have to manually write an _updater_ that modifies Relay’s local data store imperatively. We’ll look at all of these cases below.

---

## Implementing a Like Button

Let’s dip our toes in the water by implementing the Like button for Newsfeed stories. Luckily we already have a Like button prepared, so open up `Story.res` and drop it in to the `Story` component, remembering to spread its fragment into Story’s fragment:

```rescript
module Fragment = %relay(`
  fragment Story_story on Story {
    title @required(action: NONE)
    summary @required(action: NONE)
    createdAt @required(action: NONE)
    poster @required(action: NONE) {
      ...PosterByline_actor
    }
    thumbnail @required(action: NONE) {
      ...Image_image @arguments(width: 400)
    }
    // change-line
    ...StoryLikeButton_story
    ...StoryCommentsSection_story
  }
`)

...

@react.component
let make = (~story) => {
  ...

  <Card>
    ...
    <StorySummary summary={summary} />
    // change-line
    <StoryLikeButton story={story.fragmentRefs} />
    <StoryCommentsSection story={story.fragmentRefs} />
  </Card>
}
```

Now let’s take a look at `StoryLikeButton.res`. Currently, it is a button that doesn’t do anything, along with a like count.

![Like button](/img/docs/tutorial/mutations-like-button.png)

You can look at its fragment to see that it fetches a field `likeCount` for the like count and `doesViewerLike` to determine whether the Like button is highlighted (it’s highlighted if the viewer likes the story, i.e. if `doesViewerLike` is true):

```rescript
module Fragment = %relay(`
  fragment StoryLikeButton_story on Story {
    id
    likeCount @required(action: NONE)
    doesViewerLike @required(action: NONE)
  }
`)
```

We want to make it so that when you press the Like button

1. The story gets “liked” on the server
2. Our local client copy of the “`likeCount`” and “`doesViewerLike`” fields get updated.

To do that, we need to write a GraphQL mutation. But first...

## Anatomy of a Mutation

The GraphQL mutation syntax is going to be confusing unless you first understand the following:

GraphQL has two different request types, Queries and Mutations — and they work in exactly the same way. This is analogous to how HTTP has GET and POST: technically the only difference is that POST requests are intended to cause effects while GET requests do not. Similarly, a Mutation is exactly like a Query, except that the Mutation is expected to cause things to happen. This means:

- A mutation is part of our client code
- A mutation declares _variables_ that let the client pass data to the server
- The server implements _individual fields._ A given mutation composes together those fields and passes its variables in as field arguments.
- Each field yields data of a particular type — either scalar or an edge to some other graph node — which is returned to the client if that field is selected. In the case of edges, further fields are selected from the node being linked to.

The only difference is that, in a mutation, selecting a field makes something happen, as well as returning data.

## The Like Mutation

With that in mind, this is what our mutation is going to look like — go ahead and add this declaration to the file:

```rescript
module StoryLikeButtonLikeMutation = %relay(`
  mutation StoryLikeButtonLikeMutation($id: ID!, $doesLike: Boolean!) {
    likeStory(id: $id, doesLike: $doesLike) {
      story {
        id
        likeCount
        doesViewerLike
      }
    }
  }
`)
```

This is a lot, let’s break it down:

- The mutation declares variables (`$id`, `$doesLike`) with type (`ID!`, `Boolean!`). These are passed from the client to the server when the mutation is dispatched. The `!` after a type indicates that it is required.
- The mutation selects a mutation field defined by the GraphQL schema. Each mutation field that the server defines corresponds to some action that the client can request of the server, such as liking a story. The mutation field accepts arguments (like any field can do). The mutation variables that we declared as the argument values are passed in. For example, the `doesLike` field argument is set to be the `$doesLike` mutation variable.
- The `likeStory` field returns an edge to a node that represents the mutation response. We can select various fields in order to receive updated data. The fields that are available in the mutation response are specified by the GraphQL schema.
- We select the `story` field, which is the Story that we just liked.
- We select specific fields from within that Story to get updated data. These are the same fields that a query could select about a Story — in fact, the same fields we selected in our fragment.

When we send the server this mutation, we’ll get a response that, just like with queries, matches the shape of the mutation that we sent. For example, the server might send this back to us:

```json
{
  "likeStory": {
    "story": {
      "id": "34a8c",
      "likeCount": 47,
      "doesViewerLike": true
    }
  }
}
```

and our job will be to update the local data store to incorporate this updated information. Relay will handle this in simple cases, while in more complex cases it will require custom code to update the store intelligently.

But we’re getting ahead of ourselves — let’s make that button trigger the mutation. Here’s what our component looks like now — we need to hook up the `onLikeButtonClicked` event to execute `StoryLikeButtonLikeMutation`.

```rescript
@react.component
let make = (~story) => {
  let data = Fragment.use(story)
  
  switch data {
  | None => React.null
  | Some({likeCount, doesViewerLike}) =>
    <div className="likeButton">
      <LikeCount count={likeCount} />
      <LikeButton doesViewerLike={doesViewerLike} onClick={onLikeButtonClicked} />
    </div>
  }
}
```

To do that, we call the mutation's `use` hook. Change the StoryLikeButton component to this:

```rescript
@react.component
let make = (~story) => {
  let data = Fragment.use(story)
  let (commitMutation, isMutationInFlight) = StoryLikeButtonLikeMutation.use()

  switch data {
  | None => React.null
  | Some({id, likeCount, doesViewerLike}) => {
      let onLikeButtonClicked = () => {
        let variables = StoryLikeButtonLikeMutation.makeVariables(~id, ~doesLike=!doesViewerLike)
        commitMutation(~variables, ())->RescriptRelay.Disposable.ignore
        ()
      }
      <div className="likeButton">
        <LikeCount count={likeCount} />
        <LikeButton doesViewerLike={doesViewerLike} onClick={onLikeButtonClicked} />
      </div>
    }
  }
}
```

The mutations `use` hook returns a function to fire the mutation (here named `commitMutation`) and a boolean which is true when the mutation is in flight (here named... `isMutationInFlight`). When calling `commitMutation` we pass in a record called `variables`, created using the `makeVariables` helper. It accepts labelled parameters for the variables defined by the mutation, namely `id` and `doesViewerLike`. This tells the server which story we’re talking about and whether the we are liking or un-liking it. The `id` of the story we’ve read from the fragment, while whether we like it or unlike it comes from toggling whatever the current value that we rendered is.

The hook also returns a boolean flag that tells us when the mutation is in flight. We can use that to make the user experience nicer by disabling the button while the mutation is happening:

```rescript
  <div className="likeButton">
    <LikeCount count={likeCount} />
    <LikeButton
      doesViewerLike={doesViewerLike}
      onClick={onLikeButtonClicked}
      // change-line
      disabled=isMutationInFlight
    />
  </div>
```

:::tip
The variables object can also be constructed manually, so the call to `commitMutation` becomes 
```rescript
    commitMutation(
      ~variables={
        id: id, 
        doesLike: doesViewerLike
      },
      (),
    )->RescriptRelay.Disposable.ignore
```
For this particular case, whether you do it one way or the other only makes a stylistic difference. However, if a mutation accepts a nullable variable
`makeVariables` is more convenient as it lets you construct the variables record without having to specify variables that you don't want to pass to the mutation.
:::

With this in place, we should now be able to like a story!

## How Relay Automatically Processes Mutation Responses

But how did Relay know to update the story we clicked on? The server sent back a response with this form:

```json
{
  "likeStory": {
    "story": {
      "id": "34a8c",
      "likeCount": 47,
      "doesViewerLike": true
    }
  }
}
```

Whenever the response includes an object with an `id` field, Relay will check if the store already contains a record with a matching ID in the `id` field of that record. If there is a match, Relay will merge the other fields from the response into the existing record. That means that, in this simple case, we don’t need to write any code to update the store.

---

## Using Fragments in the Mutation Response

Remember that mutations are just like queries. In order to make sure that the mutation response always contains the data we want to render, instead of having a separate set of fields that has to be manually kept up to date, we can simply spread fragments into our mutation response:

```rescript
module StoryLikeButtonLikeMutation = %relay(`
  mutation StoryLikeButtonLikeMutation($id: ID!, $doesLike: Boolean!) {
    likeStory(id: $id, doesLike: $doesLike) {
      story {
        // change-line
        ...StoryLikeButton_story
      }
    }
  }
`)
```

Now if we add or remove data requirements, all of the necessary data (but no more) will be included with the mutation response. This is usually the smart way of writing mutation responses. You can spread in any fragment from any component, not just the component that triggers the mutation. This helps you keep your whole UI up to date.

---

## Improving the UX with an Optimistic Response

Mutations take time to perform, yet we always want the UI to update immediately in some way to give the user feedback that they’ve taken an action. In the current example, the Like button is disabled while the mutation is happening, and then after the mutation is done, the UI is updated into the new state as Relay merges the updated data into its store and re-renders the affected components.

Oftentimes the best feedback will be to simply pretend the operation is already completed: for example, if you press the Like button, that buttons immediately goes into the same highlighted state that it will stay in whenever you see something you’ve already liked. Or take the example of posting a comment: We would like to immediately show your comment as having been posted. This is because mutations are usually fast and reliable enough that we don’t need to bother the user with a separate loading state for them. However, sometimes mutations do end in failure. In that case, we’d like to roll back the changes we made and return you to the state you were in before we tried the mutation: the comment we showed as being posted should go away, while the text of the comment should re-appear within the composer where you wrote it, so that the data isn’t lost if you want to try posting again.

Managing these so-called _optimistic updates_ is complicated to do manually, but Relay has a robust system for applying and rolling back updates. You can even have multiple mutations in flight at the same time (say if the user clicks several buttons in sequence), and Relay will keep track of what changes need to be rolled back in case of a failure.

Mutations proceed in three phases:

- First there’s an _optimistic update_, where you update the local data store into whatever state you anticipate and want to show to the user immediately.
- Then you actually perform the mutation on the server. If it’s successful, the server responds with updated information which can be used in the third step.
- When the mutation is done, you roll back the optimistic update. If the mutation failed, you’re done — back to where you started. If the mutation succeeded, Relay merges simple changes into the store and then applies a _concluding update_ that updates the local data store with the actual new information received from the server, plus whatever other changes you want to make.

![Mutation flowchart](/img/docs/tutorial/mutations-lifecycle.png)

---

With this background knowledge in hand, let’s go ahead and write an optimistic updater for our Like button so that it immediately updates to the new state when clicked.

:::tip
In Relay, there are two main ways to implement optimistic UI - updatable queries and bla bla bla...
:::

### Step 1 — Prepare the mutation for optimistic updates

Add `@raw_response_type` to the mutation definition:

```rescript
module StoryLikeButtonLikeMutation = %relay(`
  mutation StoryLikeButtonLikeMutation($id: ID!, $doesLike: Boolean!)
  // change-line
  @raw_response_type {
    likeStory(id: $id, doesLike: $doesLike) {
      story {
        ...StoryLikeButtonFragment
      }
    }
  }
`)
```

`@raw_response_type` exposes a type that matches the shape of the expected response from the server, before application of any fragments and other directives. For istance, if you have a fragment `AB` that gets fields `a, b` and `BC` that gets fields `b, c`, adding the `@raw_response_type` directive exposes response type that is exactly `{a, b, c}`.

For this mutation, the raw types are

```rescript
type rawResponse = {
  likeStory: option<rawResponse_likeStory>,
}

type rawResponse_likeStory = {
  story: option<rawResponse_likeStory_story>,
}

type rawResponse_likeStory = {
  story: option<rawResponse_likeStory_story>,
}

type rawResponse_likeStory_story = {
  id: string,
  likeCount: option<int>,
  doesViewerLike: option<bool>,
}
```

This looks pretty verbose, but we when we are going to use this type, it'll look very much like the server response (apart from some wrapping `Some`s)

### Step 2 — Add the optimitic response to `commitMutation`

We only need to call `commitMutation` with the response we're expecting. If the user has not liked the story, we expect the mutation to return the same story id, a `likeCount` incremented by 1, and that `doesViewerLike` is true. If the user has liked the story, we (again) expect the same story id, `likeCount` decremented by 1, and that `doesViewerLike` is false. That's pretty easy to code and the Rescript and Relay compilers will make sure the optimistic response that we construct has the correct shape.

```rescript
  switch data {
  | None => React.null
  | Some({id, likeCount, doesViewerLike}) => {
      let onLikeButtonClicked = () => {
        let variables = StoryLikeButtonLikeMutation.makeVariables(~id, ~doesLike=!doesViewerLike)

        commitMutation(
          ~variables,
          // begin-change
          ~optimisticResponse={
            likeStory: Some({
              story: Some({
                id,
                likeCount: doesViewerLike ? Some(likeCount - 1) : Some(likeCount + 1),
                doesViewerLike: Some(!doesViewerLike),
              }),
            }),
          },
          // end-change
          (),
        )->RescriptRelay.Disposable.ignore
      }
      <div className="likeButton">
        <LikeCount count={likeCount} />
        <LikeButton
          doesViewerLike={doesViewerLike}
          onClick={onLikeButtonClicked}
          disabled={isMutationInFlight}
        />
      </div>
    }
  }
```

That's it! When the mutation is fired the UI will update to show the result of updating the store with the optimistic response. If the mutation fails, the optimistic update will be rolled back. If the mutation succeeds, the optimistic update will be replaced with the final result. 

:::tip 
Try setting the like count to -1000 in the optimistic response to see how the mutation response from the server replaces the optimistic response.
:::

## Adding Comments — Mutations on Connections

The only thing that Relay can do completely automatically is what we’ve seen already: merge nodes in the mutation response with existing nodes that share the same ID in the store. For anything else, we have to give Relay some more information.

Let’s look at the case of Connections. We’ll implement the ability to post a new comment on a story.

The server’s mutation response only includes the newly-created comment. We have to tell Relay how to insert that story into the Connection between a story and its comments.

Head back over to `StoryCommentsSection.res` and add the `StoryCommentsComposer` for posting a new comment. As always, remember to spread its fragment:

```rescript
module Fragment = %relay(`
  fragment StoryCommentsSection_story on Story
  @refetchable(queryName: "StoryCommentsSectionPaginationQuery")
  @argumentDefinitions(
    cursor: { type: "String" }
    count: { type: "Int", defaultValue: 3 }
  ) {
    // change-line
    ...StoryCommentsComposerFragment
    comments(after: $cursor, first: $count) 
      @connection(key: "StoryCommentsSection_story_comments") {
      ...
    }
  }
`)

@react.component
let make = (~story) => {
  ...

  <div>
    // change-line
    <StoryCommentsComposer story={data.fragmentRefs} />
    {comments
    ->Array.map(comment => <Comment key=comment.id comment=comment.fragmentRefs />)
    ->React.array}
    ...
  </div>
}
```

We should now see a composer at the top of the comments section:

![Comments composer screenshot](/img/docs/tutorial/mutations-comments-composer-screenshot.png)

Now take a look inside `StoryCommentsComposer.res`:

```rescript
@react.component
let make = (~story) => {
  let _data = StoryCommentsComposerFragment.use(story)
  let (text, setText) = React.useState(() => "")
  let onPost = () => {
    // TODO post the comment here
    ()
  }
  <div className="commentsComposer">
    <TextComposer text={text} onChange={setText} onReturn={onPost} />
    <PostButton onClick={onPost} />
  </div>
}
```

### Step 1 — Define the Comment Posting Mutation

Just like before, we define a mutation. It will send the story ID and the comment text:

```rescript
module StoryCommentsComposerPostMutation = %relay(`
    mutation StoryCommentsComposerPostMutation($id: ID!, $text: String!) {
      postStoryComment(id: $id, text: $text) {
        commentEdge {
          node {
            id
            ...Comment_comment
          }
        }
      }
    }
`)
```

We select the newly-created edge to the newly-created comment in the mutation response and update the local store by inserting the edge into the connection.

### Step 2 — Call commitMutation to post the comment

Now we use the mutation's `use` hook to get access to the `commitMutation` callback, and call it in `onPost`:

```rescript
@react.component
let make = (~story) => {
  // change-line
  let {id} = StoryCommentsComposerFragment.use(story)
  let (text, setText) = React.useState(() => "")
  // change-line
  let (commitMutation, isMutationInFlight) = StoryCommentsComposerPostMutation.use()
  let onPost = () => {
    // change
    setText(_ => "")
    commitMutation(
      ~variables={
        id,
        text,
      },
      (),
    )->RescriptRelay.Disposable.ignore
    // end-change
  }
  <div className="commentsComposer">
    // change-line
    <TextComposer text={text} onChange={setText} onReturn={onPost}
    disabled={isMutationInFlight} />
    // change-line
    <PostButton onClick={onPost} disabled={isMutationInFlight} />
  </div>
}
```

Note that we are clearing the comment text regardless of whether the mutation was successful or not. If there was en error, we want to make sure to restore the text so the user can try again.

`commitMutation` accepts a callback `onCompleted`, which is called when the mutation returns. `onCompleted` receives the mutation response as the first argument and any thrown GraphQL errors as the second argument. 

We will assume that posting the comment failed, if there is no `commentEdge` in the data in `onCompleted` or if `onError` is called.

Make the following changes to `commitMutation`:
```rescript
@react.component
let make = (~story) => {
    ...
    commitMutation(
      ...
      // change
      ~onCompleted=(data, _) => {
        switch data.postStoryComment {
        | Some({commentEdge: Some(_)}) => setText(_ => "")
        | _ => ()
        }
      },
      ~onError=_ => {
        setText(_ => text)
      },
      // end-change
      ()
      },
      (),
    )->RescriptRelay.Disposable.ignore
  }
}
```

If you disable the network connection in the your browsers devtools networks tab or if you open up `resolvers.mjs` and throw an exception in `resolvePostStoryCommentMutation` you can get the mutation to error. For the former, the `onError` handler is called immediately (since only the server is artifically slowed down) and the comment text is restored. If you do the latter, you'll see the comment text dissapear and then reappear when the mutation response comes back without a new comment edge.

:::tip
A deep dive on errors are beyond the scope of this tutorial. The thing to be aware of here is that errors that happen while resolving the GraphQL response will show up the arguments to `onComplete`, since the mutation actually completed! Errors that happen outside of that (e.g. network errors), will show up in `onError`.
:::

### Step 3 — Add a Declarative Connection Handler

Now the mutation has been hooked up, you can see in the network logs that clicking Post sends a mutation request to the server. If you refresh the page, you can see that the comment has been posted. However, nothing happens in the UI. We need to tell Relay to add the newly-created `commentEdge` to the comments Connection on the story.

To do that we can use one of Relay's declarative directives to manipulate Connections. There are three edge directions, `@appendEdge`, `@prependEdge`, and `@deleteEdge` that you can use directly in the mutation definition. Then when the mutation is run, you pass in the ID(s) of the Connections that you want to modify. Relay will append, prepend, or delete the edge from those Connections as specified by you.

We want the newly-created comment to appear at the top of the list, so we’ll use `@prependEdge`. Make the following additions to the mutation definition:

```rescript
module StoryCommentsComposerPostMutation = %relay(`
    mutation StoryCommentsComposerPostMutation(
      $id: ID!
      $text: String!
      // change-line
      $connections: [ID!]!
    ) {
      postStoryComment(id: $id, text: $text) {
        // change-line
        commentEdge @prependEdge(connections: $connections) {
          node {
            id
            text
          }
        }
      }
    }
`)
```

We’ve added a variable called `connections` to the mutation which we'll use to pass the IDs of the Connections we want to update.

:::note
The `$connections` variable is only used as an argument to the `@prependEdge` directive, which is processed on the client by Relay. Because `$connections` is not passed as an argument to any _field_, it is not sent to the server.
:::

### Step 4 — Pass in the Connection ID as a Mutation Variable

We need to identify the Connection to add the new edge to. A Connection is identified with two pieces of information:

- Which node it’s off of — in this case, the Story we’re posting a comment to.
- The _key_ provided in the `@connection` directive, which lets us tell connections apart if there is more than one of the same node.

We pass this information into the mutation variables using a special API provided by RescriptRelay called `ConnectionHandler`.

First add the `__id` field on the composers fragment and remove `id`.

```rescript
module StoryCommentsComposerFragment = %relay(`
  fragment StoryCommentsComposerFragment on Story {
    // change-line
    __id
  }
`)
```

`__id` is a special type that Relay wants and not anything that you set up yourself. Where `id` is of type `string`, `__id` is of type `dataId`. Under the hood `dataId` _is_ a string, but using a separate type makes it harder to pass ids you've contructed yourself into places that want ids that Relay has created.

```rescript
@react.component
let make = (~story) => {
  // change-line
  let {__id} = StoryCommentsComposerFragment.use(story)
  let (text, setText) = React.useState(() => "")
  let (commitMutation, isMutationInFlight) = StoryCommentsComposerPostMutation.use()
  let onPost = () => {
    setText(_ => "")
    // change
    let connectionId = RescriptRelay.ConnectionHandler.getConnectionID(
      __id,
      "StoryCommentsSection_story_comments",
      (),
    )
    // end-change
    commitMutation(
      ~variables={
        // change-line
        id: __id->RescriptRelay.dataIdToString,
        text,
        // change-line
        connections: [connectionId],
        ...
      },
      (),
    )->RescriptRelay.Disposable.ignore
  }
  <div className="commentsComposer">
    <TextComposer text={text} onChange={setText} onReturn={onPost} />
    <PostButton onClick={onPost} disabled={isMutationInFlight} />
  </div>
}
```

The string `"StoryCommentsSection_story_comments"` that we pass to `getConnectionID` is the identifier that we specicy for the connection in `StoryCommentSection`.

With this change, we should see the comment appear in the list of comments once the mutation is complete.

### Step 5 - Add an optimistic response to the mutation

The final piece of the puzzle is to add an optimistic response like we did when liking and unliking a story.

First add `@raw_response_type` to the mutation defintion as before.

```rescript
module StoryCommentsComposerPostMutation = %relay(`
    mutation StoryCommentsComposerPostMutation(
      $id: ID!
      $text: String!
      $connections: [ID!]!
    // change-line
    ) @raw_response_type {
      postStoryComment(id: $id, text: $text) {
        ...
      }
    }
`)
```

Previously we knew the exact value of the response we expected from the server. However, since this mutation creates a new node and edge we can't know the id before-hand. For these situations, we use a helper function to generate a temporary node id that will let store update for the optimistic UI. When the mutation returns with the actual node id, the optimistic changes to the store will be rolled back, the teporary node is discarded, and the real node inserted.

Make the following changes to `commitMutation`:
```rescript
@react.component
let make = (~story) => {
    ...
    commitMutation(
      ...
      // change
      ~optimisticResponse={
        postStoryComment: Some({
          commentEdge: Some({
            node: Some({
              id: RescriptRelay.generateUniqueClientID()->RescriptRelay.dataIdToString,
              text: Some(text),
            }),
          }),
        }),
      },
      // end-change
      ()
      },
      (),
    )->RescriptRelay.Disposable.ignore
  }
}
```

With a relatively modest amount of code, you have implemented robust mutations that handle optimistic updates and takes care of both successes and failures. Pretty cool, huh?!

---

## Summary

Mutations let us ask the server to make changes.

- Just like Queries, Mutations are composed of fields, accept variables, and pass those variables as arguments to fields.
- The fields that are selected by a Mutation constitute the _mutation response_ which we can use to update the Store.
- Relay automatically merges nodes in the response to nodes in the Store with matching IDs.
- The `onCompleted` and `onError` callbacks lets you trigger side-effects (such as restoring or clearing component state), when the mutation finishes.
- The `@appendEdge`, `@prependEdge`, and `@deleteEdge` directives let us insert and remove items from the mutation response into Connections in the store.
- We can get optimistic UI by using the `@raw_response_type` directive on the mutation and passing what we expect the mutation response to be  to `commitMutation`.
- Updates to the store via Optimistic responses are rolled back when the mutation completes, so the actual response can be applied instead.

