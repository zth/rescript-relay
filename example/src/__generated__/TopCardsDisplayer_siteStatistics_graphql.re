type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__TopCardsDisplayer_siteStatistics": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

type fragment = {
  .
  "currentVisitorsOnline": int,
  "weeklyOrders": int,
  "weeklySales": float,
};
type operationType = ReasonRelay.fragmentNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "TopCardsDisplayer_siteStatistics",
  "type": "SiteStatistics",
  "metadata": null,
  "argumentDefinitions": [],
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
    }
  ]
} |}
];
