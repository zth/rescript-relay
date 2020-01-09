---
id: quirks-of-reason-relay
title: Quirks of Reason Relay
sidebar_label: Quirks of Reason Relay
---

Ahh, what would a framework be without quirks and weird stuff? ReasonRelay comes with a few _gotchas_ that are good to keep in mind.

## Field names

Since Reason has reserved words (like `type` and `val`), none of the fields you query for can end up being called a reserved word in your views. This is simply because you won't be able to access the field since you cannot use the reserved word as an accessor.

This is more a quirk of Reason than anything, but it does mean that you'll need to _alias_ any field whose name is a reserved word into something that's not a reserved word. For example:

```graphql
fragment UserProfile_user on User {
  firstName
  userType: type
}
```

`type` is a reserved word, so we alias it to `userType`. This means that in our view we access it like this:

```reason
user.userType
```

...and this will work fine.
