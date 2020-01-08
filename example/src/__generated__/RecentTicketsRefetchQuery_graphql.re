/* @generated */

module Unions = {};

module Types = {};

type response = {
  __wrappedFragment__RecentTickets_query: ReasonRelay.wrappedFragmentRef,
};
type refetchVariables = {
  first: option(int),
  after: option(string),
};
let makeRefetchVariables = (~first=?, ~after=?, ()): refetchVariables => {
  first,
  after,
};
type variables = {
  first: int,
  after: string,
};

module FragmentConverters: {
  let unwrapFragment_response:
    response =>
    {. "__$fragment_ref__RecentTickets_query": RecentTickets_query_graphql.t};
} = {
  external unwrapFragment_response:
    response =>
    {. "__$fragment_ref__RecentTickets_query": RecentTickets_query_graphql.t} =
    "%identity";
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(array((int, string))) = [%raw {| {} |}];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(array((int, string))) = [%raw {| {} |}];
  let variablesConverterMap = ();
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
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
v1 = [
  {
    "kind": "Variable",
    "name": "after",
    "variableName": "after"
  },
  {
    "kind": "Variable",
    "name": "first",
    "variableName": "first"
  }
],
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v3 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "__typename",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "RecentTicketsRefetchQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "FragmentSpread",
        "name": "RecentTickets_query",
        "args": (v1/*: any*/)
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "RecentTicketsRefetchQuery",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "ticketsConnection",
        "storageKey": null,
        "args": (v1/*: any*/),
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
                  (v2/*: any*/),
                  {
                    "kind": "LinkedField",
                    "alias": null,
                    "name": "assignee",
                    "storageKey": null,
                    "args": null,
                    "concreteType": null,
                    "plural": false,
                    "selections": [
                      (v3/*: any*/),
                      (v2/*: any*/),
                      {
                        "kind": "InlineFragment",
                        "type": "User",
                        "selections": [
                          {
                            "kind": "ScalarField",
                            "alias": null,
                            "name": "avatarUrl",
                            "args": null,
                            "storageKey": null
                          },
                          {
                            "kind": "ScalarField",
                            "alias": null,
                            "name": "fullName",
                            "args": null,
                            "storageKey": null
                          }
                        ]
                      },
                      {
                        "kind": "InlineFragment",
                        "type": "WorkingGroup",
                        "selections": [
                          {
                            "kind": "ScalarField",
                            "alias": null,
                            "name": "name",
                            "args": null,
                            "storageKey": null
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "subject",
                    "args": null,
                    "storageKey": null
                  },
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "lastUpdated",
                    "args": null,
                    "storageKey": null
                  },
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "trackingId",
                    "args": null,
                    "storageKey": null
                  },
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "status",
                    "args": null,
                    "storageKey": null
                  },
                  (v3/*: any*/)
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
      },
      {
        "kind": "LinkedHandle",
        "alias": null,
        "name": "ticketsConnection",
        "args": (v1/*: any*/),
        "handle": "connection",
        "key": "RecentTickets_ticketsConnection",
        "filters": null
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "RecentTicketsRefetchQuery",
    "id": null,
    "text": "query RecentTicketsRefetchQuery(\n  $first: Int! = 2\n  $after: String! = \"\"\n) {\n  ...RecentTickets_query_2HEEH6\n}\n\nfragment Avatar_user on User {\n  avatarUrl\n  fullName\n}\n\nfragment RecentTickets_query_2HEEH6 on Query {\n  ticketsConnection(first: $first, after: $after) {\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n    edges {\n      node {\n        id\n        ...SingleTicket_ticket\n        __typename\n      }\n      cursor\n    }\n  }\n}\n\nfragment SingleTicketWorkingGroup_workingGroup on WorkingGroup {\n  name\n  id\n}\n\nfragment SingleTicket_ticket on Ticket {\n  assignee {\n    __typename\n    ... on User {\n      ...Avatar_user\n    }\n    ... on WorkingGroup {\n      ...SingleTicketWorkingGroup_workingGroup\n    }\n    ... on Node {\n      id\n    }\n  }\n  id\n  subject\n  lastUpdated\n  trackingId\n  ...TicketStatusBadge_ticket\n}\n\nfragment TicketStatusBadge_ticket on Ticket {\n  status\n}\n",
    "metadata": {
      "derivedFrom": "RecentTickets_query",
      "isRefetchableQuery": true
    }
  }
};
})() |}
];
