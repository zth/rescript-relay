type response = {
  .
  "__$fragment_ref__TodoList_query": TodoList_query_graphql.t,
  "__$fragment_ref__RecentTickets_query": RecentTickets_query_graphql.t,
  "siteStatistics": {
    .
    "__$fragment_ref__TopCardsDisplayer_siteStatistics": TopCardsDisplayer_siteStatistics_graphql.t,
  },
};
type variables = unit;
type operationType = ReasonRelay.queryNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
var v0 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v1 = {
  "kind": "Literal",
  "name": "after",
  "value": ""
},
v2 = [
  (v1/*: any*/),
  {
    "kind": "Literal",
    "name": "first",
    "value": 2
  }
],
v3 = {
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
v4 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "__typename",
  "args": null,
  "storageKey": null
},
v5 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "cursor",
  "args": null,
  "storageKey": null
},
v6 = [
  (v1/*: any*/),
  {
    "kind": "Literal",
    "name": "first",
    "value": 10
  }
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "MainQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "siteStatistics",
        "storageKey": null,
        "args": null,
        "concreteType": "SiteStatistics",
        "plural": false,
        "selections": [
          {
            "kind": "FragmentSpread",
            "name": "TopCardsDisplayer_siteStatistics",
            "args": null
          }
        ]
      },
      {
        "kind": "FragmentSpread",
        "name": "RecentTickets_query",
        "args": null
      },
      {
        "kind": "FragmentSpread",
        "name": "TodoList_query",
        "args": null
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "MainQuery",
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "siteStatistics",
        "storageKey": null,
        "args": null,
        "concreteType": "SiteStatistics",
        "plural": false,
        "selections": [
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "weeklySales",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "weeklyOrders",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "currentVisitorsOnline",
            "args": null,
            "storageKey": null
          },
          (v0/*: any*/)
        ]
      },
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "ticketsConnection",
        "storageKey": "ticketsConnection(after:\"\",first:2)",
        "args": (v2/*: any*/),
        "concreteType": "TicketConnection",
        "plural": false,
        "selections": [
          (v3/*: any*/),
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
                  (v0/*: any*/),
                  {
                    "kind": "LinkedField",
                    "alias": null,
                    "name": "assignee",
                    "storageKey": null,
                    "args": null,
                    "concreteType": null,
                    "plural": false,
                    "selections": [
                      (v4/*: any*/),
                      (v0/*: any*/),
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
                  (v4/*: any*/)
                ]
              },
              (v5/*: any*/)
            ]
          }
        ]
      },
      {
        "kind": "LinkedHandle",
        "alias": null,
        "name": "ticketsConnection",
        "args": (v2/*: any*/),
        "handle": "connection",
        "key": "RecentTickets_ticketsConnection",
        "filters": null
      },
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "todosConnection",
        "storageKey": "todosConnection(after:\"\",first:10)",
        "args": (v6/*: any*/),
        "concreteType": "TodoItemConnection",
        "plural": false,
        "selections": [
          {
            "kind": "LinkedField",
            "alias": null,
            "name": "edges",
            "storageKey": null,
            "args": null,
            "concreteType": "TodoItemEdge",
            "plural": true,
            "selections": [
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "node",
                "storageKey": null,
                "args": null,
                "concreteType": "TodoItem",
                "plural": false,
                "selections": [
                  (v0/*: any*/),
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "text",
                    "args": null,
                    "storageKey": null
                  },
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "completed",
                    "args": null,
                    "storageKey": null
                  },
                  (v4/*: any*/)
                ]
              },
              (v5/*: any*/)
            ]
          },
          (v3/*: any*/)
        ]
      },
      {
        "kind": "LinkedHandle",
        "alias": null,
        "name": "todosConnection",
        "args": (v6/*: any*/),
        "handle": "connection",
        "key": "TodoList_query_todosConnection",
        "filters": null
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "MainQuery",
    "id": null,
    "text": "query MainQuery {\n  siteStatistics {\n    ...TopCardsDisplayer_siteStatistics\n    id\n  }\n  ...RecentTickets_query\n  ...TodoList_query\n}\n\nfragment Avatar_user on User {\n  avatarUrl\n  fullName\n}\n\nfragment RecentTickets_query on Query {\n  ticketsConnection(first: 2, after: \"\") {\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n    edges {\n      node {\n        id\n        ...SingleTicket_ticket\n        __typename\n      }\n      cursor\n    }\n  }\n}\n\nfragment SingleTicketWorkingGroup_workingGroup on WorkingGroup {\n  name\n  id\n}\n\nfragment SingleTicket_ticket on Ticket {\n  assignee {\n    __typename\n    ... on User {\n      ...Avatar_user\n    }\n    ... on WorkingGroup {\n      ...SingleTicketWorkingGroup_workingGroup\n    }\n    ... on Node {\n      id\n    }\n  }\n  id\n  subject\n  lastUpdated\n  trackingId\n  ...TicketStatusBadge_ticket\n}\n\nfragment SingleTodo_todoItem on TodoItem {\n  id\n  text\n  completed\n}\n\nfragment TicketStatusBadge_ticket on Ticket {\n  status\n}\n\nfragment TodoList_query on Query {\n  todosConnection(first: 10, after: \"\") {\n    edges {\n      node {\n        id\n        ...SingleTodo_todoItem\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment TopCardsDisplayer_siteStatistics on SiteStatistics {\n  weeklySales\n  weeklyOrders\n  currentVisitorsOnline\n}\n",
    "metadata": {}
  }
};
})() |}
];
