/* @generated */

module Unions = {};

module Types = {
  type node = {
    id: string,
    __wrappedFragment__SingleTicket_ticket: ReasonRelay.wrappedFragmentRef,
  };
  type edges = {node: option(node)};
  type pageInfo = {
    endCursor: option(string),
    hasNextPage: bool,
  };
  type ticketsConnection = {
    pageInfo,
    edges: option(array(option(edges))),
  };
};

open Types;

type fragment = {ticketsConnection};

module FragmentConverters: {
  let unwrapFragment_node:
    node =>
    {. "__$fragment_ref__SingleTicket_ticket": SingleTicket_ticket_graphql.t};
} = {
  external unwrapFragment_node:
    node =>
    {. "__$fragment_ref__SingleTicket_ticket": SingleTicket_ticket_graphql.t} =
    "%identity";
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"ticketsConnection_pageInfo_endCursor":[[0,""]],"ticketsConnection_edges":[[0,""],[1,""]],"ticketsConnection_edges_node":[[0,""]]} |}
  ];
  let fragmentConverterMap = ();
  let convertFragment = v =>
    v
    ->ReasonRelay._convertObj(
        fragmentConverter,
        fragmentConverterMap,
        Js.undefined,
      );
};

type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__RecentTickets_query": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  "ticketsConnection"
];
return {
  "kind": "Fragment",
  "name": "RecentTickets_query",
  "type": "Query",
  "metadata": {
    "connection": [
      {
        "count": "first",
        "cursor": "after",
        "direction": "forward",
        "path": (v0/*: any*/)
      }
    ],
    "refetch": {
      "connection": {
        "forward": {
          "count": "first",
          "cursor": "after"
        },
        "backward": null,
        "path": (v0/*: any*/)
      },
      "operation": require('./RecentTicketsRefetchQuery_graphql.bs.js').node,
      "fragmentPathInResult": []
    }
  },
  "argumentDefinitions": [
    {
      "kind": "LocalArgument",
      "name": "first",
      "type": "Int!",
      "defaultValue": 2
    },
    {
      "kind": "LocalArgument",
      "name": "after",
      "type": "String!",
      "defaultValue": ""
    }
  ],
  "selections": [
    {
      "kind": "LinkedField",
      "alias": "ticketsConnection",
      "name": "__RecentTickets_ticketsConnection_connection",
      "storageKey": null,
      "args": null,
      "concreteType": "TicketConnection",
      "plural": false,
      "selections": [
        {
          "kind": "LinkedField",
          "alias": null,
          "name": "pageInfo",
          "storageKey": null,
          "args": null,
          "concreteType": "PageInfo",
          "plural": false,
          "selections": [
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "endCursor",
              "args": null,
              "storageKey": null
            },
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "hasNextPage",
              "args": null,
              "storageKey": null
            }
          ]
        },
        {
          "kind": "LinkedField",
          "alias": null,
          "name": "edges",
          "storageKey": null,
          "args": null,
          "concreteType": "TicketEdge",
          "plural": true,
          "selections": [
            {
              "kind": "LinkedField",
              "alias": null,
              "name": "node",
              "storageKey": null,
              "args": null,
              "concreteType": "Ticket",
              "plural": false,
              "selections": [
                {
                  "kind": "ScalarField",
                  "alias": null,
                  "name": "id",
                  "args": null,
                  "storageKey": null
                },
                {
                  "kind": "ScalarField",
                  "alias": null,
                  "name": "__typename",
                  "args": null,
                  "storageKey": null
                },
                {
                  "kind": "FragmentSpread",
                  "name": "SingleTicket_ticket",
                  "args": null
                }
              ]
            },
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "cursor",
              "args": null,
              "storageKey": null
            }
          ]
        },
        {
          "kind": "ClientExtension",
          "selections": [
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "__$generated__connection__key__$$__RecentTickets_ticketsConnection$$$name__$$__ticketsConnection",
              "args": null,
              "storageKey": null
            }
          ]
        }
      ]
    }
  ]
};
})() |}
];
