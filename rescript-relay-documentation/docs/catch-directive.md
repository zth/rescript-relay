---
id: catch-directive
title: "@catch Directive"
sidebar_label: "@catch Directive"
---

#### Recommended background reading

- [Relay's @catch directive documentation](https://relay.dev/docs/next/guides/catch-directive/)
- [Error handling in GraphQL](https://spec.graphql.org/draft/#sec-Errors)

## Introduction

The `@catch` directive allows you to handle GraphQL errors explicitly in your application by surfacing them as part of your query/fragment data instead of having them result in `null` values or runtime exceptions. This enables more robust error handling and better user experiences.

## Basic Usage

The `@catch` directive can be applied to:

- Individual fields
- Fragments (at the fragment definition level)
- Operations (queries, mutations, subscriptions)
- Aliased inline fragment spreads

### The `to` Argument

The `@catch` directive accepts an optional `to` argument with two possible values:

- `RESULT` (default): Returns a `RescriptRelay.CatchResult.t<'value>` which is either `Ok({value})` or `Error({errors})`
- `NULL`: If an error occurs, the field value becomes `null` instead of causing the query to fail

## Field-Level @catch

You can catch errors on individual fields:

```rescript
module Query = %relay(`
  query UserQuery($id: ID!) {
    user(id: $id) {
      name @catch
      email @catch(to: RESULT)
      isOnline @catch(to: NULL)
    }
  }
`)

@react.component
let make = (~userId) => {
  let queryData = Query.use(~variables={id: userId})

  switch queryData.user {
  | Some(user) =>
    <div>
      // name field returns CatchResult.t<string>
      {switch user.name {
      | Ok({value: name}) => <h1>{React.string(name)}</h1>
      | Error(_) => <h1>{React.string("Error loading name")}</h1>
      }}

      // email field returns CatchResult.t<option<string>>
      {switch user.email {
      | Ok({value: Some(email)}) => <p>{React.string(email)}</p>
      | Ok({value: None}) => <p>{React.string("No email")}</p>
      | Error(_) => <p>{React.string("Error loading email")}</p>
      }}

      // isOnline field with to: NULL returns option<bool>
      {switch user.isOnline {
      | Some(true) => <span>{React.string("Online")}</span>
      | Some(false) => <span>{React.string("Offline")}</span>
      | None => <span>{React.string("Status unknown")}</span>
      }}
    </div>
  | None => React.null
  }
}
```

## Fragment-Level @catch

You can apply `@catch` to entire fragments:

```rescript
module UserFragment = %relay(`
  fragment UserProfile_user on User @catch {
    name
    email
    createdAt
  }
`)

@react.component
let make = (~userRef) => {
  let userData = UserFragment.use(userRef)

  switch userData {
  | Ok({value: user}) =>
    <div>
      <h1>{React.string(user.name)}</h1>
      <p>{React.string(user.email->Belt.Option.getWithDefault("No email"))}</p>
    </div>
  | Error(_) =>
    <div>{React.string("Error loading user profile")}</div>
  }
}
```

## Operation-Level @catch

You can catch errors at the query, mutation, or subscription level:

```rescript
module Query = %relay(`
  query UserProfileQuery($id: ID!) @catch {
    user(id: $id) {
      name
      email
      posts {
        title
        content
      }
    }
  }
`)

@react.component
let make = (~userId) => {
  let queryData = Query.use(~variables={id: userId})

  switch queryData {
  | Ok({value: data}) =>
    // Handle successful data
    switch data.user {
    | Some(user) => <UserProfile user />
    | None => <div>{React.string("User not found")}</div>
    }
  | Error(_) =>
    <div>{React.string("Error loading user data")}</div>
  }
}
```

## Working with `CatchResult.t`

RescriptRelay provides a `CatchResult` module with utilities for working with `@catch` results:

```rescript
module Utils = {
  let handleUserName = (nameResult: RescriptRelay.CatchResult.t<string>) => {
    switch nameResult {
    | Ok({value}) => Some(value)
    | Error(_) => None
    }
  }

  // Or use the built-in utility
  let handleUserNameWithUtil = (nameResult) => {
    nameResult->RescriptRelay.CatchResult.toOption
  }

  // Convert to a standard Result type
  let handleUserNameAsResult = (nameResult) => {
    nameResult->RescriptRelay.CatchResult.toResult
  }
}
```

## Error Bubbling

When `@catch` is used on a parent field or fragment, errors from child fields will bubble up to the nearest `@catch` directive:

```rescript
module Query = %relay(`
  query UserQuery($id: ID!) {
    user(id: $id) @catch {
      name
      email
      posts {
        title
      }
    }
  }
`)

// If any field within user fails (name, email, or posts.title),
// the error will be caught at the user level
```

## Nested @catch Directives

You can have multiple levels of `@catch` directives. Errors are caught by the closest `@catch` ancestor:

```rescript
module Query = %relay(`
  query UserQuery($id: ID!) @catch {
    user(id: $id) {
      name @catch
      posts @catch {
        title
        author {
          name
        }
      }
    }
  }
`)

@react.component
let make = (~userId) => {
  let queryData = Query.use(~variables={id: userId})

  switch queryData {
  | Ok({value: data}) =>
    switch data.user {
    | Some(user) =>
      <div>
        // name errors are caught at field level
        {switch user.name {
        | Ok({value: name}) => <h1>{React.string(name)}</h1>
        | Error(_) => <h1>{React.string("Name unavailable")}</h1>
        }}

        // posts errors are caught at posts field level
        {switch user.posts {
        | Ok({value: posts}) =>
          posts->Array.map(post =>
            <div key={post.title}>{React.string(post.title)}</div>
          )->React.array
        | Error(_) => <div>{React.string("Posts unavailable")}</div>
        }}
      </div>
    | None => React.null
    }
  | Error(_) => <div>{React.string("Error loading data")}</div>
  }
}
```

## Union and Interface Handling

`@catch` works seamlessly with unions and interfaces:

```rescript
module MemberFragment = %relay(`
  fragment MemberProfile_member on Member @catch {
    ... on User {
      id
      name
      email
    }
    ... on Group {
      id
      name
      memberCount
    }
  }
`)

@react.component
let make = (~memberRef) => {
  let memberData = MemberFragment.use(memberRef)

  switch memberData {
  | Ok({value: member}) =>
    switch member {
    | User(user) => <UserCard user />
    | Group(group) => <GroupCard group />
    }
  | Error(_) => <div>{React.string("Error loading member")}</div>
  }
}
```

## Mutations with @catch

Handle mutation errors gracefully:

```rescript
module UpdateUserMutation = %relay(`
  mutation UpdateUserMutation($input: UpdateUserInput!) @catch {
    updateUser(input: $input) {
      user {
        id
        name
        email
      }
      errors {
        field
        message
      }
    }
  }
`)

@react.component
let make = () => {
  let (mutate, isMutating) = UpdateUserMutation.use()

  let handleUpdate = () => {
    mutate(
      ~variables={input: {name: "New Name"}},
      ~onCompleted=(result, _errors) => {
        switch result {
        | Ok({value: data}) =>
          switch data.updateUser {
          | Some({user: Some(user), errors: []}) =>
            Console.log("User updated successfully")
          | Some({errors}) =>
            Console.log2("Validation errors:", errors)
          | _ => Console.log("Unexpected response")
          }
        | Error({errors}) =>
          Console.log2("Network/GraphQL errors:", errors)
        }
      }
    )
  }

  <button onClick={_ => handleUpdate()}>
    {React.string(isMutating ? "Updating..." : "Update User")}
  </button>
}
```

## Type Safety and Nullability

Fields with `@catch` are typed according to their semantic nullability rather than their schema nullability. This means:

- Non-null fields in the schema that are marked as semantically nullable will be typed as non-null in ReScript when caught
- The error handling is explicit through the `CatchResult` type rather than through nullable types

## Interaction with @throwOnFieldError

The `@catch` directive works in conjunction with `@throwOnFieldError`. Key points:

- **Without @throwOnFieldError**: Field errors result in `null` values by default. Using `@catch` surfaces these errors in the data object instead
- **With @throwOnFieldError**: You can use `@catch` on specific fields to handle those errors locally instead of throwing exceptions
- **@catch takes precedence**: Fields with `@catch` will not throw exceptions, even within a `@throwOnFieldError` context

For detailed information about `@throwOnFieldError`, see the [official Relay documentation](https://relay.dev/docs/next/guides/throw-on-field-error-directive/).

## Limitations

- `@catch` cannot be used with `@required` on the same field
- `@catch` cannot be used on unaliased inline fragments
- `@catch` cannot be used on fragment spreads without alias
