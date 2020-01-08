/* @generated */

module Unions = {};

module Types = {
  type addedTodoItem = {
    id: string,
    text: string,
    completed: option(bool),
  };
  type addTodoItem = {addedTodoItem: option(addedTodoItem)};
  type addTodoItemInput = {
    text: string,
    clientMutationId: option(string),
  };
};

open Types;

type response = {addTodoItem: option(addTodoItem)};
type variables = {input: addTodoItemInput};

module FragmentConverters: {} = {};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"addTodoItem":[[0,""]],"addTodoItem_addedTodoItem":[[0,""]],"addTodoItem_addedTodoItem_completed":[[0,""]]} |}
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
    {| {"addTodoItem":[[0,""]],"addTodoItem_addedTodoItem":[[0,""]],"addTodoItem_addedTodoItem_completed":[[0,""]]} |}
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
    "type": "AddTodoItemInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "addTodoItem",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "concreteType": "AddTodoItemPayload",
    "plural": false,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "addedTodoItem",
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
    "name": "TodoListAddTodoMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "TodoListAddTodoMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "TodoListAddTodoMutation",
    "id": null,
    "text": "mutation TodoListAddTodoMutation(\n  $input: AddTodoItemInput!\n) {\n  addTodoItem(input: $input) {\n    addedTodoItem {\n      id\n      text\n      completed\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
