---
id: coming-from-reason-apollo
title: Coming from Reason Apollo
sidebar_label: Coming from Reason Apollo
---

Reason Apollo is awesome and has been a big inspiration when working on these bindings. You should [check it out here](https://github.com/apollographql/reason-apollo).

There's a few things to keep in mind when coming from Reason Apollo, that might help with the mental model of ReasonRelay.

### The Relay compiler replaces `graphql_ppx`

In Reason Apollo, `graphql_ppx` is responsible for both providing GraphQL validation via your `schema.graphql` for each GraphQL operation, emitting encoders/decoders from JS to ReasonML, emitting type information for each defined operation, and automatically decoding each response as it's received from the server.

In ReasonRelay, emitting types is handled by the [Relay compiler](the-compiler), and decoding is done _at the view level_ rather than once when the response is received. This is how it currently needs to be due to internals in Relay.

### No `@bsRecord`

ReasonRelay decodes _everything to records by default_. This means that there's no [`@bsRecord`](https://github.com/mhallin/graphql_ppx#record-conversion) equivalent as of now in ReasonRelay, and neither any way of decoding your response to `Js.t`.

If there's demand, we're open to implementing something that'd generate the necessary helper functions to convert a record object to a `Js.t`, if needed. Please file an issue if this is something you're interested in.
