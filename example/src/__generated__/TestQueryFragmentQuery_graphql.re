type response = {
  .
  "books":
    array({
      .
      "__$fragment_ref__TestQueryFragment_book": TestQueryFragment_book_graphql.t,
      "id": string,
    }),
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
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestQueryFragmentQuery",
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
          (v0/*: any*/),
          {
            "kind": "FragmentSpread",
            "name": "TestQueryFragment_book",
            "args": null
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestQueryFragmentQuery",
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
          (v0/*: any*/),
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
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "TestQueryFragmentQuery",
    "id": null,
    "text": "query TestQueryFragmentQuery {\n  books {\n    id\n    ...TestQueryFragment_book\n  }\n}\n\nfragment TestQueryFragment_book on Book {\n  id\n  title\n  author\n}\n",
    "metadata": {}
  }
};
})() |}
];
