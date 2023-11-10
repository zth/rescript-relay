---
id: tutorial-interfaces-polymorphism
title: GraphQL Types, Interfaces, and Polymorphism
sidebar_label: GraphQL Types, Interfaces, and Polymorphism
---

# GraphQL Types, Interfaces, and Polymorphism

In this section, we’ll see how to treat different types of nodes differently. You might notice that some of the newsfeed stories in the example app are posted by people, while others are posted by organizations. In this example, we'll enhance our hovercard by writing a fragment that selects people-specific information about people and organization-specific information about organizations.

---

We’ve alluded to the fact that GraphQL nodes aren’t just random bags of fields — they have types. Your GraphQL schema defines what fields each type has. For instance, it might define the `Story` type like this:

```graphql
type Story {
  id: ID!
  title: String
  summary: String
  createdAt: Date
  poster: Actor
  image: Image
}
```

Here, some of the fields are scalars (like `String` and `ID`). Others are types defined elsewhere in the schema, like `Image` — these fields are edges to nodes of those specific types. The `!` on `ID!` means that field is non-nullable. In GraphQL, fields are normally nullable and non-nullability is the exception.

Fragments are always “on” a particular type. For instance, `Story_story` is defined `on Story`. This means that you can only spread it into places in a query where a `Story` node is expected. And it means that the fragment can select only those fields that exist on the `Story` type.

Of particular interest is the `Actor` type used for the `poster` field. That means that the `poster` of a story can be a Person, a Page, an Organization, or any other type of entity that is implemented to meet the specifications for being an “Actor”.

This type is an _interface_, defined in the schema in our example app as:

```graphql
interface Actor {
  id: ID!
  name: String
  profilePicture: Image
  joined: String
}
```

There are two types in the schema that _implement_ `Actor`: `Person` and `Organization`. They are declared as implementing the `Actor` interface (in addition to the `Node` interface for Relay nodes) and must therefore include all the fields in the `Actor` interface.

```
type Person implements Node & Actor {
  id: ID!
  name: String
  email: String
  profilePicture: Image
  joined: String
  location: Location
}

type Organization implements Node & Actor {
  id: ID!
  name: String
  profilePicture: Image
  joined: String
  organizationKind: OrganizationKind
}
```

Both of these types have `id`, `name` , `profilePicture`, and `joined`, so they can both declare that they implement Actor and thus can be used wherever an Actor is called for in the schema and in fragments. They also have other fields that are distinct to each particular type.

Let’s see how to work more with interfaces by extending the `PosterDetailsHovercardContentsBody` component in `PosterDetailsHovercardContents.res` to display the location of a `Person` or the organization kind of an `Organization`. These are fields that are only present on those specific types, not on the `Actor` interface.

If you’ve followed along so far, you should have a fragment defined like this:

```rescript
module Fragment = %relay(`
  fragment PosterDetailsHovercardContents_actor on Actor {
    id
    name
    joined
    profilePicture {
      ...ImageFragment
    }
  }
`)
```

If you try to add a field like `organizationKind` to this fragment, you’ll get an error from the Relay compiler:

```
✖︎ The type `Actor` has no field `organizationKind`
```

This is because when we define a fragment as being on an interface, we can only use fields from that interface. To use fields from a specific type that implements the interface, we use a _type refinement_ to tell GraphQL we’re selecting fields from that type. Change the fragment so that you select the `organizationKind` on `Organization` and `location.name` on `Person`:

```rescript
module Fragment = %relay(`
  fragment PosterDetailsHovercardContents_actor on Actor {
    id
    name
    joined
    profilePicture {
      ...Image_image
    }
    // change
    ... on Organization {
      organizationKind
    }
    ... on Person {
      location @required(action: NONE) {
        name
      }
    }
    // end-change
  }
`)
```

When you select a field that’s only present on some of the types that implement an interface, and the node you’re dealing with is of a different type, then you simply get `None` for the value of that field when you read it out. With that in mind, we can modify the `PosterDetailsHovercardContentsBody` component to show the location when the poster is a person and organization kind of when the poster is an organization:

```rescript
module PosterDetailsHovercardContentsBody = {
  @react.component
  let make = (~poster) => {
    let data = PosterDetailsHovercardContentsBodyFragment.use(poster)
  ...
  <ul className="posterHovercard__details">
    ...
    <li>
      {"Joined "->React.string}
      {switch data.joined {
      | None => React.null
      | Some(joined) => <Timestamp time={joined} />
      }}
    </li>
    // change
    {switch data.location {
    | None | Some({name: None}) => React.null
    | Some({name: Some(name)}) => <li> {name->React.string} </li>
    }}
    {switch data.organizationKind {
    | None => React.null
    | Some(organizationKind) =>
      <li>
        <OrganizationKind kind={organizationKind} />
      </li>
    }}
    // end-change
  </ul>
}
```

You should now see the location of people, and the organization kind for organizations:

![An organization hovercard](/img/docs/tutorial/interfaces-organization-screenshot.png) ![A person hovercard](/img/docs/tutorial/interfaces-person-screenshot.png)

We can now understand why we had `... on Actor` in the example earlier. The `node` field can return a node of any type because any ID could be given at runtime. So the type that it gives us is `Node`, a very generic interface that can be implemented by anything that has an `id` field. We needed a type refinement to use fields from the `Actor` interface.

Notice, that we're doing a lot of switching when rendering the card contents and you may be tempted to add some `required`s to simplify things. It's specific to a particular usecase whether that's a good idea or not. Think about whether it makes sense to bail out of rendering the contents if some of the data is missing. As an excercise, go ahead and modify `PosterDetailsHovercardContents` to make as much as possible required. Remember, that no amount of `required` will make a poster _both_ a Person and an Organization, so you can't get rid of all the `None`s.

:::note
In the GraphQL spec and other sources, type refinements are called _inline fragments_. We call them “type refinements” instead because this terminology is more descriptive and less confusing.
:::

If you need to do something totally different depending on what type it is, you can select a field called `__typename`, which returns a string with the name of the concrete type that you got (e.g., `"Person"` or `"Organization"`). This is a built-in feature of GraphQL.

If you _only_ select fields on the refined types, you can get a more convenient expression of the type. A way to achieve this is to create a fragment and component that selects the information that you switch on and then use this fragment in in the `PosterDetailsHovercardContents_actor` fragment. That fragment and component could look like this:

```rescript
module ExtraInfoFragment = %relay(`
  fragment PosterDetailsHovercardContentsExtraInfo_actor on Actor {
    ... on Organization {
      organizationKind @required(action: NONE)
    }
    ... on Person {
      location @required(action: NONE) {
        name @required(action: NONE)
      }
    }
  }
`)

module ExtraInfo = {
  @react.component
  let make = (~actor) => {
    let data = ExtraInfoFragment.use(actor)

    switch data {
    | None | Some(#UnselectedUnionMember(_)) => React.null
    | Some(#Person({location: {name}})) => <li> {name->React.string} </li>
    | Some(#Organization({organizationKind})) =>
      <li>
        <OrganizationKind kind={organizationKind} />
      </li>
    }
  }
}
```

You already know why we handle the `None` case. The other case that produces `React.null` is `#UnselectedUnionMember(_)`. This case applies when the type you get at runtime is _not_ one of the ones you've type-refined. Even if you're currently selecting all the types that are possible, you will have to handle #UnselectedUnionMember(_). This is because another type (such as a Page) implementing Actor may be added in the future as your app evolves. Forcing you to handle `#UnselectedUnionMember(_)` is a way for Relay to make sure your app resilient in the face of an evolving schema.

## Summary

The `... on Type {}` syntax allows us to select fields that are only present in a specific type that implements an interface.
