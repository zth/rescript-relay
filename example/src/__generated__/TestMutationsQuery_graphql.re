type response = {
  .
  "books":
    array({
      .
      "status": Js.Nullable.t(SchemaAssets.Enum_BookStatus.wrapped),
      "author": string,
      "title": string,
      "id": string,
    }),
};
type variables = unit;
type operationType = ReasonRelay.queryNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
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
      },
      {
        "kind": "ScalarField",
        "alias": null,
        "name": "status",
        "args": null,
        "storageKey": null
      }
    ]
  }
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestMutationsQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": (v0/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "TestMutationsQuery",
    "argumentDefinitions": [],
    "selections": (v0/*: any*/)
  },
  "params": {
    "operationKind": "query",
    "name": "TestMutationsQuery",
    "id": null,
    "text": "query TestMutationsQuery {\n  books {\n    id\n    title\n    author\n    status\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
