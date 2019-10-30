---
id: coming-from-reason-apollo
title: Coming from Reason Apollo
sidebar_label: Coming from Reason Apollo
---

Reason Apollo is awesome and has been a big inspiration when working on these bindings. You should [check it out here](https://github.com/apollographql/reason-apollo).

There's a few things to keep in mind when coming from Reason Apollo, that might help with the mental model of ReasonRelay.

### The Relay compiler replaces `graphql_ppx`

In Reason Apollo, `graphql_ppx` is responsible for both providing GraphQL validation via your `schema.graphql` for each GraphQL operation, as well as emitting encoders/decoders from JS to ReasonML, and emitting type information for each defined operation. In ReasonRelay, all of the above is handled by the [Relay compiler](the-compiler) instead. The only exception is generating decoders and encoders, as ReasonRelay does not do any encoding or decoding from JS to ReasonML by itself. You can read more about this in [quirks of ReasonRelay](quirks-of-reason-relay), but this in short means that you'll need to do more manual steps when working with ReasonRelay as compared to Reason Apollo.

### No `@bsRecord`

This also means that there's no [`@bsRecord`](https://github.com/mhallin/graphql_ppx#record-conversion) equivalent as of now in ReasonRelay. Since ReasonRelay is not doing any decoding, there's simply no place to implement `@bsRecord` automatically. Records does not work with how ReasonRelay [enforces fragment type-safety](using-fragments#fragment-references-and-how-relay-transports-fragment-data) either, sadly.

However, if there's demand, we're open to implementing something that'd generate the necessary helper functions to convert a `Js.t` object to a record, if needed. Please file an issue if this is something you're interested in.
