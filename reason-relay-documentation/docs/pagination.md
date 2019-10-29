---
id: pagination
title: Pagination
sidebar_label: Pagination
---

_This section is a WIP_

#### Recommended background reading

- [Queries and mutations in GraphQL](https://graphql.org/learn/queries/)
- [A Guided Tour of Relay: Rendering List Data and Pagination](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#rendering-list-data-and-pagination)
- [The Relay server specification: Connections](https://relay.dev/docs/en/graphql-server-specification.html#connections)
- [React documentation: Suspense for Data Fetching](https://reactjs.org/docs/concurrent-mode-suspense.html)

## Pagination in Relay

> The features outlined on this page requires that your schema follow the [Relay specification](https://relay.dev/docs/en/experimental/graphql-server-specification.html). Read more about using ReasonRelay with schemas that don't conform to the Relay specification [here](using-with-schemas-that-dont-conform-to-the-relay-spec).

Relay has some great built-in tools to make pagination very simple if you use [connection-based pagination](https://relay.dev/docs/en/graphql-server-specification.html#connections) and your schema conforms to the [the Relay server specification](https://relay.dev/docs/en/graphql-server-specification.html). Let's look at some examples.

### Setting up for pagination

Pagination is always done using a [fragment](using-fragments). Here's a definition of a Relay [fragment](using-fragments) that'll allow you to paginate over the connection `ticketsConnection`:

```reason
module Fragment = [%relay.fragment
  {|
  fragment RecentTickets_query on Query
    @refetchable(queryName: "RecentTicketsRefetchQuery")
    @argumentDefinitions(
      count: {type: "Int!", defaultValue: 10},
      cursor: {type: "String!", defaultValue: ""}
    ) {
    ticketsConnection(first: $count, after: $cursor)
      @connection(key: "RecentTickets_ticketsConnection")
    {
      edges {
        node {
          id
          ...SingleTicket_ticket
        }
      }
    }
  }
|}
];
```

Quite a few directives and annotations used here. Let's break down what's going on:

1. First off, this particular fragment is defined on the `Query` root type (the root query type is really just like any other GraphQL type). This is just because the `ticketsConnection` field happen to be on `Query`, pagination can be done on fields on any GraphQL type.
2. We make our fragment _refetchable_ by adding the `@refetchable` directive to it. You're encouraged to read [refetching and loading more data](refetching-and-loading-more-data) for more information on making fragments refetchable.
3. We add another directive, `@argumentDefinitions`, where we define two arguments that we need for pagination, `count` and `cursor`. This component is responsible for paginating itself, so we want anyone to be able to use this fragment without providing those arguments for the initial render. To solve that we add default values to our arguments. [You're encouraged to read more about `@argumentDefinitions` here](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#arguments-and-argumentdefinitions).
4. We select the `ticketsConnection` field on `Query` and pass it our pagination arguments. We also add a `@connection` directive to the field. This is important, because it tells Relay that we want it to help us paginate this particular field. By annotating with `@connection` and passing a `keyName`, Relay will understand how to find and use the field for pagination. This in turn means we'll get access to a bunch of hooks and functions for paginating and dealing with the pagination in the store. You can read more about `@connection` [here](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#adding-and-removing-items-from-a-connection).
5. Finally, we spread another component fragment `SingleTicket_ticket` on the connection's `node`, since that's the component we'll use to display each ticket.

We've now added everything we need to enable pagination for this fragment.

## Pagination in a component

Let's look at a component that uses the fragment above for pagination:

```reason
[@react.component]
let make = (~query as queryRef) => {
  let ReasonRelay.{data, hasNext, isLoadingNext, loadNext} =
    Fragment.usePagination(queryRef);

  <div className="card">
    <div className="card-body">
      <h4 className="card-title"> {React.string("Recent Tickets")} </h4>
      <div>
        {data##ticketsConnection
         |> ReasonRelayUtils.collectConnectionNodes
         |> Array.map(ticket => <SingleTicket key=ticket##id ticket />)
         |> React.array}
        {hasNext
           ? <button
               onClick={_ => loadNext(~count=2, ~onComplete=None) |> ignore}
               disabled=isLoadingNext>
               {React.string(isLoadingNext ? "Loading..." : "More")}
             </button>
           : React.null}
      </div>
    </div>
  </div>;
};
```

Whew, plenty more to break down:

1. Just like with anything [using fragments](using-fragments), we'll need a fragment reference to pass to our fragment.
2. We pass our fragment reference into `Fragment.usePagination`. Here's a few extra things to break down:
   1. There are 2 types of pagination in Relay - _blocking using suspense_ or _non-blocking without suspense_. We'll address this further down, but for now keep in mind that we're using the _non-blocking_ one in this example. The hook exposed for non-blocking pagination is called `usePagination`, as seen in the example above.
   2. We get a record back from `usePagination` that we can destruct and just bring out the things we need.

_WIP_
