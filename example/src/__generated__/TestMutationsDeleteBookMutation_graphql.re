type response = {
  .
  "addBook": {
    .
    "book":
      Js.Nullable.t({
        .
        "status": Js.Nullable.t(SchemaAssets.Enum_BookStatus.wrapped),
        "author": string,
        "title": string,
        "id": string,
      }),
  },
};
type variables = {
  .
  "input": {
    .
    "author": string,
    "title": string,
    "clientMutationId": option(string),
  },
};
type operationType = ReasonRelay.mutationNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "AddBookInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "addBook",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "concreteType": "AddBookPayload",
    "plural": false,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "book",
        "storageKey": null,
        "args": null,
        "concreteType": "Book",
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
    ]
  }
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestMutationsDeleteBookMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "TestMutationsDeleteBookMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "TestMutationsDeleteBookMutation",
    "id": null,
    "text": "mutation TestMutationsDeleteBookMutation(\n  $input: AddBookInput!\n) {\n  addBook(input: $input) {\n    book {\n      id\n      title\n      author\n      status\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
