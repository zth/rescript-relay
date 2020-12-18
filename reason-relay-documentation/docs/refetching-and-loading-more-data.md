---
id: refetching-and-loading-more-data
title: Refetching and Loading More Data
sidebar_label: Refetching and Loading More Data
---

#### Recommended background reading

- [Queries and mutations in GraphQL](https://graphql.org/learn/queries/)
- [A Guided Tour of Relay: Re-Rendering Fragments with Different Data](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#re-rendering-fragments-with-different-data)
- [React documentation: Suspense for Data Fetching](https://reactjs.org/docs/concurrent-mode-suspense.html)

## Refetching and Loading More Data

> Some of the following features comes with some constraints if your GraphQL server schema does not follow the [Relay specification](https://relay.dev/docs/en/experimental/graphql-server-specification.html). Read more about using ReasonRelay with schemas that don't conform to the Relay specification [here](using-with-schemas-that-dont-conform-to-the-relay-spec).

Sometimes you'll want to refresh or refetch data in specific parts of your views without re-issuing the full query the data was originally rendered from. Relay makes this very simple if your schema conforms to the [Relay specification](https://relay.dev/docs/en/experimental/graphql-server-specification.html) and implements the `Node` interface, or if your fragment is on the `Query` or `Viewer` type. This page will focus on Relays feature to [refetch a fragment](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#refreshing-fragments).

## Making a fragment refetchable

You can make a fragment refetchable by adding the `@refetchable(queryName: "")` directive to it. Let's look at an example of making a fragment refetchable and refetching it with. Here's a component showing some information about a user, and then rendering a "Show bio"-button to refetch the fragment it uses, but include more information about the user:

```reason
/* UserProfileHeader.re */
module UserFragment = [%relay {|
  fragment UserProfileHeader_user on User
    @refetchable(queryName: "UserProfileHeaderRefetchQuery")
    @argumentDefinitions(includeFullBio: {type: "Boolean!", defaultValue: false}) {
    firstName
    lastName
    bio @include(if: $includeFullBio) {
      presentationText
      age
    }
  }
|}];

[@react.component]
let make = (~user as userRef) => {
  let (user, refetch) = UserFragment.useRefetchable(userRef);

  <>
    <div> {React.string(user.firstName ++ " " ++ user.lastName)} </div>
    {switch (user.bio) {
     | Some(bio) =>
       <>
         <div> {React.string(bio.presentationText)} </div>
         <div> {React.string("Age: " ++ string_of_int(bio.age))} </div>
       </>
     | None =>
       <button
         type_="button"
         onClick={_ =>
           refetch(
             ~variables=
               UserFragment.makeRefetchVariables(~includeFullBio=true, ()),
             (),
           )
         }>
         {React.string("Show bio")}
       </button>
     }}
  </>;
};
```

Whew, new stuff to break down. Let's start from the top:

- We've added two directives to our fragment, `@refetchable` and `@argumentDefinitions`. `@refetchable` tells Relay that this fragment can be refetched, and also tells the Relay compiler to _automatically generate a query to use when refetching the fragment_. Remember, fragments always have to end up in a query to be usable, so you need a query to refetch a fragment. But, Relay can autogenerate the query for your, so the only thing you need to think about is giving `@refetchable` a `queryName` prop with a name for your refetch query.
- `@argumentDefinitions`, is a way to define that a fragment can take _arguments_, much like props in React. This is a very neat feature and you're encouraged to use it as much as you can when it makes sense. Basically, we're saying that "this fragment needs a variable `$includeFullBio` that's required and a boolean. However, if the one who spreads this fragment does not pass that variable, it should default to false". `$includeFullBio` is how we'll control if we should fetch the extra data or not, and since we don't want to load the extra data before the user explicitly asks for it, we'll make sure it defaults to `false`. [You're encouraged to read more about `@argumentDefinitions` here](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#arguments-and-argumentdefinitions).
- In our selection, we use `$includeFullBio` via the built-in GraphQL directive `@include` to control whether the `bio` field should be included in the query or not. Read more about [GraphQL directives and the built in directives `@include` and `@skip` here](https://graphql.org/learn/queries/#directives).
- Whenever a fragment has a `@refetchable` directive on it with a `queryName`, _ReasonRelay will autogenerate a `useRefetchable` React hook that you can use_, in addition to the default `use` hook. `useRefetchable` works just like `use`, only that it returns a tuple containing both the data and a function to refetch the fragment instead of just the data.
- When rendering, we check for the `bio` object in the data. If it's not there, we render a button to refetch the fragment with `$includeFullBio` set to `true`. Otherwise, we render a simple UI for showing the full bio.
- Note the use of the function `UserFragment.makeRefetchVariables` to make the refetch variables. The reason we're not passing raw variables just like we'd normally do is that _when making a refetch, all variables are optional_. Relay lets you supply _only the variables you want to change from the last fetch of the fragment_, and it will re-use anything you don't pass to it from the last fetch. So, if you simply do `UserFragment.makeRefetchVariables()` without passing any changed variables, the fragment will be refetched _with the same configuration it was fetched before_. `makeRefetchVariables` is also autogenerated by ReasonRelay whenever there's a `@refetchable` directive on the fragment, and its a helper to let you easily provide only the parts of the variables that has changed.

Let's sum up:

- Defining a fragment as `@refetchable` will give you a `useRefetchable` hook, which in turn gives you a `refetch` function that you can use to refetch the fragment.
- When refetching, you provide _only the parts of `variables` that you want to change_. This means that providing an empty `Fragment.makeRefetchVariables()` will refetch the fragment with the _same configuration as it was last fetched with_.
- Control what's fetched at what point with GraphQL variables and `@argumentDefinitions`, as examplified above.

## Wrapping up

That's how you refetch a fragment. This can be used to implement a number of patterns like polling, "Read more"-functionality, deferring loading certain expensive data until needed, and so on. A tool worthy of your toolbox!

## API Reference

Adding `@refetchable` to a fragment will make ReasonRelay add a `useRefetchable` hook to your fragment. That `useRefetchable` hook takes the same parameter as the regular [`use` hook on a fragment](using-fragments#use), an object containing a fragment reference for this particular fragment.

It returns `(fragmentData, refetchFunction)`, where `fragmentData` is the data for the fragment.

##### `refetchFunction`

The refetch function that `useRefetchable` returns take [the same arguments as the `use` hook on a query](making-queries#use) with one important difference: _the properties of the `variables` object will all be optional_. This is because you only need to provide what properties in the variables you _want to change_ from the last fetch when refetching. ReasonRelay autogenerates a `makeRefetchVariables` for you function that simplifies this.

##### `makeRefetchVariables`

`makeRefetchVariables` is autogenerated and available on your fragment when you've defined your fragment as `@refetchable`. It's a helper function to make it easy to build your refetch variables by only providing what you want to change.
