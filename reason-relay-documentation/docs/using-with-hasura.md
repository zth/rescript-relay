---
id: using-with-hasura
title: Using with Hasura
sidebar_label: Using with Hasura
---

[Hasura](https://hasura.io) is a very popular backend solution for rapidly creating GraphQL backends with the use of [PostgreSQL](https://www.postgresql.org), an open-source SQL database.

As of now, Hasura _does not provide_ the primitives needed in the schema for Relay to fully work with it. However, [there's a GitHub issue outlining their strategy for adding Relay support](https://github.com/hasura/graphql-engine/issues/721) which you can have a look at.

You're also encouraged to read the section on [using ReasonRelay with schemas that don't conform to the Relay spec](using-with-schemas-that-dont-conform-to-the-relay-spec).
