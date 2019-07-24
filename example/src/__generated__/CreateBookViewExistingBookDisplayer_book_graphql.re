module Unions = {};
type fragment = {
  .
  "title": string,
  "author": string,
};

type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__CreateBookViewExistingBookDisplayer_book": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

let node: ReasonRelay.fragmentNode = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "CreateBookViewExistingBookDisplayer_book",
  "type": "Book",
  "metadata": null,
  "argumentDefinitions": [],
  "selections": [
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
