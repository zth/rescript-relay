---
id: interfaces
title: Interfaces
sidebar_label: Interfaces
---

#### Recommended background reading

- [Interfaces in GraphQL](https://graphql.org/learn/schema/#interfaces)

## Interfaces in RescriptRelay

In RescriptRelay, depending on how you ask for the fields, **interfaces** are either unwrapped to a polymorphic variant or a record with type specific fields being optional.

Let's clarify this with an example. Imagine this GraphQL schema:

```graphql
interface Book {
  title: String!
  author: Author!
}

type Textbook implements Book {
  title: String!
  author: Author!
  courses: [String!]!
}

type ColoringBook implements Book {
  title: String!
  author: Author!
  colors: [String!]!
}
```

Here we have an interface `Book`, which has `title` and `author` fields and `Textbook` and `ColoringBook` types which implements the `Book` interface. Both types have one specific field, `Textbook` - `courses` and `ColoringBook` - `colors`.

If all the fields we ask for are within inline fragments of the types which implement the interface, the result will be a polymorphic variant:

```rescript
/* UserBook.res */
module BookFragment = %relay(`
  fragment UserBook_book on Book {
    ... on Textbook {
      title
      courses
    }
    ... on ColoringBook {
      title
      colors
    }
  }
`)

@react.component
let make = (~book) => {
  let book = BookFragment.use(book)
  // `book` would roughly be:
  // type fragment = [
  //   | #Textbook({ title: string, courses: array<string> })
  //   | #ColoringBook({ title: string, colors: array<string> })
  //   | #UnselectedUnionMember(string)
  // ]

  switch book {
    | #Textbook({ title, courses }) => <Textbook title courses />
    | #ColoringBook({ title, colors }) => <ColoringBook title colors />
    | #UnselectedUnionMember(typename) => ("Unselected member type: " ++ typename)->React.string
  }
}
```

You could notice that in fragment definition we asked for `title` field twice, which is unnecessary since it is a common field coming from the interface. We could instead specify it only once, above inline fragment spreads, on the `Book` itself. This will produce a different result, a record type with type specific fields as optional values:

```rescript
module BookFragment = %relay(`
  fragment MyComponent_book on Book {
    title
    ... on Textbook {
      courses
    }
    ... on ColoringBook {
      colors
    }
  }
`)

@react.component
let make = (~book) => {
  let book = BookFragment.use(book)
  // `book` would be:
  // type fragment = {
  //   title: string,
  //   courses: option<array<string>>,
  //   colors: option<array<string>>
  // }

  switch (book.courses, book.colors) {
    | (Some(courses), None) => <Textbook title=book.title courses />
    | (None, Some(colors)) => <ColoringBook title=book.title colors />
    | (Some(_courses), Some(_colors)) => "Error! Somehow both courses and colors were received."->React.string
    | (None, None) => "Error! Neither courses nor colors were received."->React.string
  }
}
```

This way, we used the benefits of interfaces, but ended up having a bit harder time using its result.

> Note: Currently, this can't be improved much since these types are coming directly from the Relay compiler, so it's Relay itself that is a bit opinionated here in what types they output. It can get much more complex by adding more type specific fields, so as a workaround we recommend duplicating all field selections in inline fragment spread even if it removes most of the interface benefits. You can see more info on it [here](https://github.com/zth/rescript-relay/issues/315#issuecomment-1078739792).
