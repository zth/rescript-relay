---
id: using-with-hasura
title: Using with Hasura
sidebar_label: Using with Hasura
---

[Hasura](https://hasura.io) is a very popular backend solution for rapidly creating GraphQL backends with the use of [PostgreSQL](https://www.postgresql.org), an open-source SQL database.

As of `v1.3.0-beta.1`, Hasura provides a relay compatible schema.

### Setting up Hasura

Follow the guide to setting up Hasura in the [Hasura docs](https://hasura.io/docs/1.0/graphql/manual/getting-started/index.html). Make sure to use a version greater than `v1.3.0-beta.1`. The rest of this guide will assume that Hasura is running on the default port of `8080` and that the hasura admin secret is `hasura-admin-secret`.

### Enabling Relay

In the Hasura console, toggle the Relay API on. Note the API endpoint generated. For more information, check out this [article](https://hasura.io/blog/adding-relay-support-to-hasura/) by Hasura. This guide will assume that the relay endpoint is `hasura-relay-endpoint`.

### Generating the schema file

Run the following command to generate the schema.graphql file.

```bash
  npx graphqurl "http://localhost:8080/hasura-relay-endpoint" -H "X-Hasura-Admin-Secret: hasura-admin-secret" --introspect > schema.graphql
```

For more information, check out the [Hasura docs](https://hasura.io/docs/1.0/graphql/manual/schema/export-graphql-schema.html).

### Configuring the Relay environment

In a [previous section](getting-started), we'd set up the Relay environment. Continuing on that, in the code below, the lines with comments indicate the changes to be made to connect to Hasura.

```reason
let fetchQuery: ReasonRelay.Network.fetchFunctionPromise = (operation, variables, _cacheConfig, _uploadables) => {
  open Fetch
  fetchWithInit(
    "http://localhost:8080/hasura-relay-endpoint", /* Update the Relay API endpoint */
    RequestInit.make(
      ~method_=Post,
      ~body=Js.Dict.fromList(list{
        ("query", Js.Json.string(operation.text)),
        ("variables", variables),
      })
      |> Js.Json.object_
      |> Js.Json.stringify
      |> BodyInit.make,
      ~headers=HeadersInit.make({
        "content-type": "application/json",
        "accept": "application/json",
        "x-hasura-admin-secret": "hasura-admin-secret", /* Add necessary headers */
      }),
      (),
    ),
  ) |> Js.Promise.then_(resp =>
    if Response.ok(resp) {
      Response.json(resp)
    } else {
      Js.Promise.reject(Graphql_error("Request failed: " ++ Response.statusText(resp)))
    }
  )
}

```

### Conclusion

That's all. Hasura is now set up. You can use the Hasura console to test your queries and [integrate them](making-queries) into your app.
