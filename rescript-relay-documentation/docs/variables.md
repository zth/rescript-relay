---
id: variables
title: Variables
sidebar_label: Variables
---

## `null` in variables

ReScript doesn't really have `null`, rather it has `option` instead. So, in its default form, all features of RescriptRelay leverages `option`, even if `null` is technically used some in GraphQL.

This mostly works out well, and gives a better experience in ReScript. However, there are cases when you _need_ to be able to send the value `null` to your server in variables. For that, we have `@rescriptRelayNullableVariables`.

### `@rescriptRelayNullableVariables`

By adding this directive to your operation, you'll be able to send `null` to your server for any nullable variable (or any nullable value in any input object). It looks like this:

```rescript
module Mutation = %relay(`
    mutation TestNullableVariablesMutation($avatarUrl: String) @rescriptRelayNullableVariables {
      updateUserAvatar(avatarUrl: $avatarUrl) {
        user {
          avatarUrl
        }
      }
    }
`)

// All optional variables in this operation can now be `null`, which will be preserved and sent to your server.
Mutation.commitMutation(~environment=RelayEnvironment.environment, ~variables={avatarUrl: Js.Nullable.null}, ())

// Or if you want to send a value:
Mutation.commitMutation(~environment=RelayEnvironment.environment, ~variables={avatarUrl: Js.Nullable.return("some-avatar-url")}, ())
```

This works for:

- Variables in queries/mutations/subscriptions.
- Input objects (they'll automatically be nullable when you use this directive)

The reason for this being an explicit directive and not applied globally is that this isn't the default you want, working with options is still so much easier. So, use this only when you must.
