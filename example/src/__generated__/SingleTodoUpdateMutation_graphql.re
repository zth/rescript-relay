/* @generated */

module Unions = {};

module Types = {
  type updateTodoItemInput = {
    id: string,
    text: string,
    completed: bool,
    clientMutationId: option(string),
  };
  type updatedTodoItem = {
    id: string,
    text: string,
    completed: option(bool),
  };
  type updateTodoItem = {updatedTodoItem: option(updatedTodoItem)};
};

open Types;

type response = {updateTodoItem: option(updateTodoItem)};
type variables = {input: updateTodoItemInput};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"updateTodoItem":{"n":""},"updateTodoItem_updatedTodoItem":{"n":""},"updateTodoItem_updatedTodoItem_completed":{"n":""}}} |}
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
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"updateTodoItem":{"n":""},"updateTodoItem_updatedTodoItem":{"n":""},"updateTodoItem_updatedTodoItem_completed":{"n":""}}} |}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"input":{"r":"UpdateTodoItemInput"}},"UpdateTodoItemInput":{"clientMutationId":{"n":""}}} |}
  ];
  let variablesConverterMap = ();
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

module Utils = {};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "UpdateTodoItemInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "updateTodoItem",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "concreteType": "UpdateTodoItemPayload",
    "plural": false,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "updatedTodoItem",
        "storageKey": null,
        "args": null,
        "concreteType": "TodoItem",
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
            "name": "text",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "completed",
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
    "name": "SingleTodoUpdateMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "SingleTodoUpdateMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "SingleTodoUpdateMutation",
    "id": null,
    "text": "mutation SingleTodoUpdateMutation(\n  $input: UpdateTodoItemInput!\n) {\n  updateTodoItem(input: $input) {\n    updatedTodoItem {\n      id\n      text\n      completed\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
