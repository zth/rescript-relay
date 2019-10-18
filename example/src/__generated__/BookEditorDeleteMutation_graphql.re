type response = {. "deleteBook": {. "deleted": bool}};
type variables = {
  .
  "input": {
    .
    "id": string,
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
    "type": "DeleteBookInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "deleteBook",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "concreteType": "DeleteBookPayload",
    "plural": false,
    "selections": [
      {
        "kind": "ScalarField",
        "alias": null,
        "name": "deleted",
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
    "name": "BookEditorDeleteMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "BookEditorDeleteMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "BookEditorDeleteMutation",
    "id": null,
    "text": "mutation BookEditorDeleteMutation(\n  $input: DeleteBookInput!\n) {\n  deleteBook(input: $input) {\n    deleted\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
