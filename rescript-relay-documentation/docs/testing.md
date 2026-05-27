---
id: testing
title: Testing
sidebar_label: Testing
---

## Testing

RescriptRelay provides a small set of helpers for rendering fragment components with typed data, and for using Relay's mock environment with typed query variables and payloads.

## Rendering fragment components with data

Every fragment module exposes `Test.fromData`. It takes the generated fragment data type and returns something that can be passed anywhere that fragment's ref type is expected.

This is useful when you want to render a fragment component directly in tests, Storybook, or local examples without wrapping it in a Relay environment and executing a query.

```rescript
module UserNameFragment = %relay(`
  fragment UserName_user on User {
    firstName
    lastName
  }
`)

@react.component
let make = (~user) => {
  let user = UserNameFragment.use(user)
  <span> {React.string(user.firstName ++ " " ++ user.lastName)} </span>
}

let testElement = () =>
  <UserName
    user={UserNameFragment.Test.fromData({
      firstName: "Ada",
      lastName: "Lovelace",
    })}
  />
```

The value passed to `fromData` is fully typed from the fragment. If the fragment changes, ReScript will tell you which test data needs to change.

Plural fragments use the same API, but take an array:

```rescript
module UsersFragment = %relay(`
  fragment UsersList_users on User @relay(plural: true) {
    id
    firstName
  }
`)

let testElement = () =>
  <UsersList
    users={UsersFragment.Test.fromData([
      {id: "user-1", firstName: "Ada"},
      {id: "user-2", firstName: "Grace"},
    ])}
  />
```

Nested fragment spreads work by building the nested fragment refs with their own `Test.fromData` helper:

```rescript
module AvatarFragment = %relay(`
  fragment UserAvatar_user on User {
    avatarUrl
  }
`)

module UserFragment = %relay(`
  fragment UserCard_user on User {
    firstName
    ...UserAvatar_user
  }
`)

let testElement = () =>
  <UserCard
    user={UserFragment.Test.fromData({
      firstName: "Ada",
      fragmentRefs: AvatarFragment.Test.fromData({
        avatarUrl: Some("https://example.com/avatar.png"),
      }),
    })}
  />
```

These synthetic fragment refs are intended for mount-time test data. Do not switch the same mounted component from a synthetic ref to a real Relay ref, or from a real Relay ref to a synthetic ref. The implementation skips Relay's `useFragment` hook when synthetic data is present, so swapping modes in the same mounted component can violate React's hook ordering rules. Rendering separate components, separate tests, or remounting with a different React `key` is fine.

## Relay mock environment helpers

For tests that should exercise Relay's store and operation machinery, use Relay's mock environment. RescriptRelay exposes a binding to `createMockEnvironment`:

```rescript
let environment = RescriptRelay_Test.createMockEnvironment()
```

Install `relay-test-utils` in packages that use this helper:

```bash
yarn add --dev relay-test-utils
```

## Typed query mock helpers

Queries annotated with both `@relay_test_operation` and `@raw_response_type` get a generated `Test` module:

```rescript
module Query = %relay(`
  query UserCardTestQuery($id: ID!) @relay_test_operation @raw_response_type {
    user(id: $id) {
      id
      firstName
    }
  }
`)
```

That module exposes typed helpers for queueing the pending operation and resolving the most recent operation:

```rescript
let environment = RescriptRelay_Test.createMockEnvironment()

Query.Test.queuePendingOperation(
  ~environment,
  ~variables={id: "user-1"},
)

Query.Test.resolveMostRecentOperation(
  ~environment,
  ~payload={
    user: Some({
      id: "user-1",
      firstName: "Ada",
    }),
  },
)
```

`queuePendingOperation` uses the query's generated variable type, and `resolveMostRecentOperation` uses the generated raw response type. This keeps query tests aligned with the operation shape Relay expects.

The query helpers are only generated when both directives are present. `@relay_test_operation` makes the operation compatible with Relay's testing utilities, and `@raw_response_type` gives RescriptRelay the typed payload shape needed for `resolveMostRecentOperation`.
