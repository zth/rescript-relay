/* @generated */

module Unions = {};

module Types = {
  type deleteTodoItem = {deletedTodoItemId: option(string)};
  type deleteTodoItemInput = {
    id: string,
    clientMutationId: option(string),
  };
};

open Types;

type response = {deleteTodoItem: option(deleteTodoItem)};
type variables = {input: deleteTodoItemInput};

module FragmentConverters: {} = {};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"deleteTodoItem":[[0,""]],"deleteTodoItem_deletedTodoItemId":[[0,""]]} |}
  ];
  let wrapResponseConverterMap = ();
  let convertWrapResponse = v =>
    v
    ->ReasonRelay._convertObj(
        wrapResponseConverter,
        wrapResponseConverterMap,
        Js.null,
      );

  type responseRaw;
  let responseConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"deleteTodoItem":[[0,""]],"deleteTodoItem_deletedTodoItemId":[[0,""]]} |}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(array((int, string))) = [%raw {| {} |}];
  let variablesConverterMap = ();
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "DeleteTodoItemInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "deleteTodoItem",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "concreteType": "DeleteTodoItemPayload",
    "plural": false,
    "selections": [
      {
        "kind": "ScalarField",
        "alias": null,
        "name": "deletedTodoItemId",
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
    "name": "SingleTodoDeleteMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "SingleTodoDeleteMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "SingleTodoDeleteMutation",
    "id": null,
    "text": "mutation SingleTodoDeleteMutation(\n  $input: DeleteTodoItemInput!\n) {\n  deleteTodoItem(input: $input) {\n    deletedTodoItemId\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
