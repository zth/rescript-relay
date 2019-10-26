---
id: quirks-of-reason-relay
title: Quirks of Reason Relay
sidebar_label: Quirks of Reason Relay
---

Ahh, what would a framework be without quirks and weird stuff? ReasonRelay comes with a few _gotchas_ that are good to keep in mind.

## Nullability

Relay (and GraphQL for that matter) treats `null` and `undefined` differently, which means that all nullable fields in Relay are treated as either a value or `null`. This means that all nullable fields in ReasonRelay are modelled as `Js.Nullable.t`, which leads to lots of `someValue |> Js.Nullable.toOption` in your code.

We're actively looking for some way to make this a better experience. `graphql_ppx` and `reason-apollo` handles this much better for instance, where each nullable field is instead an `option`. However, due to the nature of Relay (`null` and `undefined` have separate meanings) we'll need to think carefully about how we do this.

## Enums and Unions

On the same theme as above, Relay models enums as a union of string literals, and unions as a union of different objects with different `__typename` keys (as string literals).

String literals as a type concept does not exist in Reason. Instead, we have variants and polymorphic variants. So, ReasonRelay models unions and enums as abstract types and autogenerates code to decode/encode those abstract types into polymorphic variants.

You're encouraged to read more about [unions](unions) and [enums](enums).

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
user##userType
```

...and this will work fine.

In a hopefully not too distant future, we'll automatically validate that you alias all reserved words and make it a compilation error if you don't.
