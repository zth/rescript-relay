module Unions = {};
type input_UpdateBookInput = {
  .
  "clientMutationId": option(string),
  "id": string,
  "title": string,
  "author": string,
  "status": option(SchemaAssets.Enum_BookStatus.wrapped),
};
type variables = {. "input": input_UpdateBookInput};
type response = {
  .
  "updateBook": {
    .
    "book":
      Js.Nullable.t({
        .
        "title": string,
        "author": string,
        "status": Js.Nullable.t(SchemaAssets.Enum_BookStatus.wrapped),
      }),
  },
};

let node: ReasonRelay.mutationNode = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "UpdateBookInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "input",
    "variableName": "input"
  }
],
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "title",
  "args": null,
  "storageKey": null
},
v3 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "author",
  "args": null,
  "storageKey": null
},
v4 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "status",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "BookEditorUpdateMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "updateBook",
        "storageKey": null,
        "args": (v1/*: any*/),
        "concreteType": "UpdateBookPayload",
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
              (v2/*: any*/),
              (v3/*: any*/),
              (v4/*: any*/)
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "BookEditorUpdateMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "updateBook",
        "storageKey": null,
        "args": (v1/*: any*/),
        "concreteType": "UpdateBookPayload",
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
              (v2/*: any*/),
              (v3/*: any*/),
              (v4/*: any*/),
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
      }
    ]
  },
  "params": {
    "operationKind": "mutation",
    "name": "BookEditorUpdateMutation",
    "id": null,
    "text": "mutation BookEditorUpdateMutation(\n  $input: UpdateBookInput!\n) {\n  updateBook(input: $input) {\n    book {\n      title\n      author\n      status\n      id\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
