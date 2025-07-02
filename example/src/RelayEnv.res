/**
 * This file sets up the Relay environment, which is then
 * injected into the context in Index.re.
 * It's also used standalone in mutations and when using other
 * functions that does not have access to the React context.
 */
exception // This is just a custom exception to indicate that something went wrong.
Graphql_error(string)

/**
 * A standard fetch that sends our operation and variables to the
 * GraphQL server, and then decodes and returns the response.
 */
let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = async (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  let resp = await fetch(
    "http://localhost:4000/graphql",
    {
      method: #POST,
      body: {
        "query": operation.text->Js.Nullable.toOption->Belt.Option.getWithDefault(""),
        "variables": variables,
      }
      ->Js.Json.stringifyAny
      ->Belt.Option.getExn
      ->Body.string,
      headers: Headers.fromObject({
        "content-type": "application/json",
        "accept": "application/json",
      }),
    },
  )

  if Response.ok(resp) {
    await Response.json(resp)
  } else {
    raise(Graphql_error("Request failed: " ++ Response.statusText(resp)))
  }
}

/**
 * A graphql-ws client and a subscription
 * See the official Relay documentation for more details:
 * https://relay.dev/docs/guided-tour/updating-data/graphql-subscriptions/#configuring-the-network-layer
 */
let wsClient = GraphQLWs.Client.make(
  GraphQLWs.Client.makeClientOptions(
    ~url="ws://localhost:4000/graphql",
    ~shouldRetry={
      _event => {
        true
      }
    },
    (),
  ),
)

let subscriptionFunction: RescriptRelay.Network.subscribeFn = (
  operation,
  variables,
  _cacheConfig,
) => {
  let subscriptionQuery: GraphQLWs.Client.subscribeOptions = {
    operationName: operation.name,
    query: operation.text->Js.Nullable.toOption->Belt.Option.getWithDefault(""),
    variables,
  }

  RescriptRelay.Observable.make(sink => {
    let unsubscribe = GraphQLWs.Client.subscribe(wsClient, subscriptionQuery, sink)

    Some({
      unsubscribe,
      closed: false,
    })
  })
}

/**
 * This sets up the network layer. We make a promise based network network
 * layer here, but Relay also has own observables that you could set up
 * your network layer to use instead of promises.
 */
let network = RescriptRelay.Network.makePromiseBased(
  ~fetchFunction=fetchQuery,
  ~subscriptionFunction,
)

/**
 * This creates the actual environment, which consists of a network layer,
 * and a store for the cache.
 *
 * The environment can be customized somewhat in addition to what's done
 * here. For example, you can provide a `getDataID` function that would
 * override how data IDs are constructed for the store. This is necessary
 * when you have a GraphQL server where ids are not globally unique for
 * example.
 */
let environment = RescriptRelay.Environment.make(
  ~network,
  ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make()),
)
