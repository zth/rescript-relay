type response = {
  .
  "siteStatistics":
    Js.Nullable.t({
      .
      "__$fragment_ref__TopCardsDisplayer_siteStatistics": TopCardsDisplayer_siteStatistics_graphql.t,
    }),
};
type variables = unit;
type operationType = ReasonRelay.queryNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "AppQuery",
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
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "AppQuery",
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
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
            "args": null,
            "storageKey": null
          }
        ]
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "AppQuery",
    "id": null,
    "text": "query AppQuery {\n  siteStatistics {\n    ...TopCardsDisplayer_siteStatistics\n    id\n  }\n}\n\nfragment TopCardsDisplayer_siteStatistics on SiteStatistics {\n  weeklySales\n  weeklyOrders\n  currentVisitorsOnline\n}\n",
    "metadata": {}
  }
} |}
];
