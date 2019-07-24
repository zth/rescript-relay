module Unions = {};
type input_AddBookInput = {
  .
  "clientMutationId": option(string),
  "title": string,
  "author": string,
};
type variables = {. "input": input_AddBookInput};
type response = {
  .
  "addBook": {
    .
    "book":
      Js.Nullable.t({
        .
        "title": string,
        "author": string,
        "shelf": {. "name": string},
      }),
  },
};

let node: ReasonRelay.mutationNode = [%bs.raw
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
  "name": "name",
  "args": null,
  "storageKey": null
},
v5 = {
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
    "name": "CreateBookViewMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "addBook",
        "storageKey": null,
        "args": (v1/*: any*/),
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
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "shelf",
                "storageKey": null,
                "args": null,
                "concreteType": "Shelf",
                "plural": false,
                "selections": [
                  (v4/*: any*/)
                ]
              }
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "CreateBookViewMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "addBook",
        "storageKey": null,
        "args": (v1/*: any*/),
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
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "shelf",
                "storageKey": null,
                "args": null,
                "concreteType": "Shelf",
                "plural": false,
                "selections": [
                  (v4/*: any*/),
                  (v5/*: any*/)
                ]
              },
              (v5/*: any*/)
            ]
          }
        ]
      }
    ]
  },
  "params": {
    "operationKind": "mutation",
    "name": "CreateBookViewMutation",
    "id": null,
    "text": "mutation CreateBookViewMutation(\n  $input: AddBookInput!\n) {\n  addBook(input: $input) {\n    book {\n      title\n      author\n      shelf {\n        name\n        id\n      }\n      id\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
