---
id: fragments-by-example
title: Fragments by example
sidebar_label: Fragments by example
---

In order to make fragments a bit more comprehensible, we'll use an example UI to illustrate the power of fragments, and in all ways they can be used. Imagine we have a UI roughly like this:

```reason
<PostHeader>
  <AuthorAvatar />
  <PostTitle />
</PostHeader>
```

Each component here has different data demands on different GraphQL types. `<AuthorAvatar />` will probably need things from the `Author` type, while the `<PostTitle />` component probably needs things from the `Post` type.

We also have `<PostHeader />`, but that just renders both of `<AuthorAvatar />` and `<PostTitle />`, so it just needs to know that the data needed to render those two components will be there.

Lets start with `<AuthorAvatar />`!

```reason
// AuthorAvatar.re
module AuthorFragment = [%relay.fragment {|
    fragment AuthorAvatar_author on Author {
      avatarUrl
      firstName
      lastName
    }
  |}
];

[@react.component]
let make = (~author as authorRef) => {
  let author = AuthorFragment.use(authorRef);

  ...
};
```

So, what's going on here?

1. First we use `[%relay.fragment]` to define a fragment on the GraphQL type `Author`. This says we need `avatarUrl`, `firstName` and `lastName` from `Author` if this component is to be rendered. We'll need those props to render the avatar and a suitable `alt`-tag for the image.

2. We then define a React component. We add a prop that we call `author` but rename to `authorRef`.

   **It is not required to rename the prop if you don't want to**. I've just found it to work well to name it like that.

3. We then use the auto-generated `use` React hook that's available on the transformed `[%relay.fragment]` module. We pass the `authorRef` to that.
