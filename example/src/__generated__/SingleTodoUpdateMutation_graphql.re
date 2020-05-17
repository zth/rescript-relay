/* @generated */

module Types = {
  type updateTodoItemInput = {
    id: string,
    text: string,
    completed: bool,
    clientMutationId: option(string),
  };
  type response_updateTodoItem_updatedTodoItem = {
    id: string,
    text: string,
    completed: option(bool),
  };
  type response_updateTodoItem = {
    updatedTodoItem: option(response_updateTodoItem_updatedTodoItem),
  };

  type response = {updateTodoItem: option(response_updateTodoItem)};
  type variables = {input: updateTodoItemInput};
};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"updateTodoItem":{"n":""},"updateTodoItem_updatedTodoItem":{"n":""},"updateTodoItem_updatedTodoItem_completed":{"n":""}}} |json}
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
    {json| {"__root":{"updateTodoItem":{"n":""},"updateTodoItem_updatedTodoItem":{"n":""},"updateTodoItem_updatedTodoItem_completed":{"n":""}}} |json}
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
    {json| {"__root":{"input":{"r":"UpdateTodoItemInput"}},"UpdateTodoItemInput":{"clientMutationId":{"n":""}}} |json}
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

module Utils = {
  open Types;
  let make_updateTodoItemInput =
      (~id, ~text, ~completed, ~clientMutationId=?, ()): updateTodoItemInput => {
    id,
    text,
    completed,
    clientMutationId,
  };

  let makeVariables = (~input): variables => {input: input};

  let make_response_updateTodoItem_updatedTodoItem =
      (~id, ~text, ~completed=?, ()): response_updateTodoItem_updatedTodoItem => {
    id,
    text,
    completed,
  };

  let make_response_updateTodoItem =
      (~updatedTodoItem=?, ()): response_updateTodoItem => {
    updatedTodoItem: updatedTodoItem,
  };

  let makeOptimisticResponse = (~updateTodoItem=?, ()): response => {
    updateTodoItem: updateTodoItem,
  };
};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%raw
  {json| (function(){
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
})() |json}
];
