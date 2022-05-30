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
let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  fetchWithInit(
    "http://localhost:4000/graphql",
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

/**
 * A graphql-ws client and a subscription
 * See the official Relay documentation for more details:
 * https://relay.dev/docs/guided-tour/updating-data/graphql-subscriptions/#configuring-the-network-layer
 */
let wsClient = GraphQLWs.Client.make(
  GraphQLWs.Client.makeClientOptions(
    ~url="ws://localhost:4000/graphql",
    ~shouldRetry={
      event => {
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
    query: operation.text,
    variables: variables,
  }

  RescriptRelay.Observable.make(sink => {
    let unsubscribe = GraphQLWs.Client.subscribe(wsClient, subscriptionQuery, sink)

    Some({
      unsubscribe: unsubscribe,
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
  (),
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
  ~store=RescriptRelay.Store.make(~source=RescriptRelay.RecordSource.make(), ()),
  (),
)
