type response = {
  .
  "books":
    array({
      .
      "__$fragment_ref__CreateBookViewExistingBookDisplayer_book": CreateBookViewExistingBookDisplayer_book_graphql.t,
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
    "name": "CreateBookViewQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "books",
        "storageKey": null,
        "args": null,
        "concreteType": "Book",
        "plural": true,
        "selections": [
          {
            "kind": "FragmentSpread",
            "name": "CreateBookViewExistingBookDisplayer_book",
            "args": null
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "CreateBookViewQuery",
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "books",
        "storageKey": null,
        "args": null,
        "concreteType": "Book",
        "plural": true,
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
    "name": "CreateBookViewQuery",
    "id": null,
    "text": "query CreateBookViewQuery {\n  books {\n    ...CreateBookViewExistingBookDisplayer_book\n    id\n  }\n}\n\nfragment CreateBookViewExistingBookDisplayer_book on Book {\n  title\n  author\n}\n",
    "metadata": {}
  }
} |}
];
