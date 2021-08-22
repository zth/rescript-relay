---
id: subscriptions
title: Subscriptions
sidebar_label: Subscriptions
---

#### Recommended background reading

- [Subscriptions in Relay from the Relay documentation](https://relay.dev/docs/en/subscriptions)

## Subscriptions in Relay

Subscriptions use a different network configuration than _queries_ and _mutations_. They use websocket to send and receive data from the server. We will need to configure the Relay environment by providing a `subscriptionFunction` when creating the Relay network. Relay will call this function every time we want to create a new subscription. We will also need to pick a subscription client. In this example we will be using [subscription-transport-ws](https://github.com/apollographql/subscriptions-transport-ws). Those are the minimal required bindings for our example to work, but they are tied to rescript-relay itself, and would need to be adjusted in order to be used for other purposes.

```reason
/* SubscriptionsTransportWs.res */
type operationOptions = {
  query: string,
  variables: Js.Json.t,
}

type observable<'a> = {
  @meth
  "subscribe": RescriptRelay.Observable.sink<'a> => RescriptRelay.Observable.subscription,
}

type t<'a> = {@meth "request": operationOptions => observable<'a>}

@new @module("subscriptions-transport-ws")
external createSubscriptionClient: (string, 'a) => t<'b> = "SubscriptionClient"

let createSubscriptionClient = createSubscriptionClient

```

The following code is a ReScript version of the example from the official Relay [documentation](https://relay.dev/docs/en/subscriptions#configure-network):

```reason
/* RelayEnv.res */
let subscriptionClient = SubscriptionsTransportWs.createSubscriptionClient(
  "ws://localhost:4000/graphql",
  {"reconnect": true},
)

let subscriptionFunction: RescriptRelay.Network.subscribeFn = (config, variables, _cacheConfig) => {
  let query = config.text
  let subscriptionQuery: SubscriptionsTransportWs.operationOptions = {
    query: query,
    variables: variables,
  }

  RescriptRelay.Observable.make(sink => {
    let observable = subscriptionClient["request"](subscriptionQuery)
    let subscription = observable["subscribe"](sink)
    Some(subscription)
  })
}

let network = RescriptRelay.Network.makePromiseBased(
  ~fetchFunction=fetchQuery(token),
  ~subscriptionFunction,
  (),
)

let store = {
  open RescriptRelay
  Store.make(~source=RecordSource.make(), ())
}

let environment = RescriptRelay.Environment.make(~network, ~store, ())

```

Subscriptions in RescriptRelay are defined using the `%relay()` extension node. The following example shows how to define and start a subscription with RescriptRelay.

Lets imagine we have the following schema:

```graphql
enum TicketStatus {
  TODO
  IN_PROGRESS
  DONE
}
type Ticket implements Node {
  id: ID!
  status: TicketStatus!
  title: string!
}
```

Then in your `Ticket.re` module we can subscribe to changes to the ticket status. Fragments in relay automatically subscribe to updates for the fragment data, see [Relay docs](https://relay.dev/docs/guided-tour/rendering/fragments). So when we receive an event that the ticket status updated the fragments referencing the data will receive an update and re-render the new state.

```reason
/* Ticket.res */
module TicketStatusFragment = %relay(`
  fragment TicketStatus on Ticket {
    status
  }
`)

module TicketStatusSubscription = %relay(
  `
  subscription TicketStatusSubscription($id: ID!) {
     ticket(id: $id) {
      status
      ... TicketStatus
    }
  }
 `
)

@react.component
let make = (~ticketId) => {
  let environment = RescriptRelay.useEnvironmentFromContext()
  React.useEffect2(() => {
    let subscription = TicketStatusSubscription.subscribe(
      ~environment,
      ~variables={id: ticketId},
      (),
    )
    Some(() => RescriptRelay.Disposable.dispose(subscription))
  }, (ticketId, environment))

  /* The rest of the code here... */
}

```

> A note on naming: Due to the rules of Relay, a subscription must be named `<ModuleName><optionally_anything_here>Subscription`, where module name here means _file name_, not ReScript module name. So for a file `Ticket.res`, all subscriptions in that file must start with `Ticket` regardless of whether they're defined in nested modules or not. All subscription names must also end with `Subscription`.

> Using VSCode? Our [dedicated VSCode extension](vscode-extension) lets you codegen new subscriptions easily, including boilerplate for components, via the command `> Add subscription`.

See the [examples](https://github.com/zth/rescript-relay/tree/master/example) folder for a working subscription sample.

## API Reference

`%relay()` with a subscription in it is expanded to a module containing the following functions:

## `subscribe`

| Name          | Type                                                        | Required | Notes                                                                                                                                                                                   |
| ------------- | ----------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `environment` | `Environment.t`                                             | _Yes_    | Instantiated relay environment                                                                                                                                                          |
| `variables`   | abstract type                                               | _Yes_    | Variables derived from the GraphQL operation                                                                                                                                            |
| `onCompleted` | `option(unit => unit)`                                      | No       | A callback function executed when the subscription is closed by the peer without error                                                                                                  |
| `onError`     | `option(Js.Exn.t => unit)`                                  | No       | A callback function executed when Relay or the server encounters an error processing the subscription                                                                                   |
| `onNext`      | `option(C.response => unit)`                                | No       | A callback function executed each time a response is received from the server, with the raw GraphQL response payload. `C.response` is the response data requested in the graphql query. |
| `updater`     | `option((RecordSourceSelectorProxy.t, C.response) => unit)` | No       | An optional function that can supply custom logic for updating the in-memory Relay store based on the server response                                                                   |

> `subscribe` uses Relay's `requestSubscription` under the hood, which is documented [here](https://relay.dev/docs/en/subscriptions)
