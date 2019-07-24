module Unions = {};
type fragment = {
  .
  "id": string,
  "title": string,
  "author": string,
};

type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__TestQueryFragment_book": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

let node: ReasonRelay.fragmentNode = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "TestQueryFragment_book",
  "type": "Book",
  "metadata": null,
  "argumentDefinitions": [],
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
      "name": "title",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "author",
      "args": null,
      "storageKey": null
    }
  ]
} |}
];
