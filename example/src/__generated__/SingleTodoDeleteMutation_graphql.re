/* @generated */

module Types = {
  type deleteTodoItemInput = {
    id: string,
    clientMutationId: option(string),
  };
  type response_deleteTodoItem = {
    deletedTodoItemId: option(string),
    clientMutationId: option(string),
  };

  type response = {deleteTodoItem: option(response_deleteTodoItem)};
  type rawResponse = response;
  type variables = {input: deleteTodoItemInput};
};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"deleteTodoItem":{"n":""},"deleteTodoItem_deletedTodoItemId":{"n":""},"deleteTodoItem_clientMutationId":{"n":""}}} |json}
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
    {json| {"__root":{"deleteTodoItem":{"n":""},"deleteTodoItem_deletedTodoItemId":{"n":""},"deleteTodoItem_clientMutationId":{"n":""}}} |json}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  type wrapRawResponseRaw = wrapResponseRaw;
  let convertWrapRawResponse = convertWrapResponse;

  type rawResponseRaw = responseRaw;
  let convertRawResponse = convertResponse;

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"input":{"r":"DeleteTodoItemInput"}},"DeleteTodoItemInput":{"clientMutationId":{"n":""}}} |json}
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
  let make_deleteTodoItemInput =
      (~id, ~clientMutationId=?, ()): deleteTodoItemInput => {
    id,
    clientMutationId,
  };

  let makeVariables = (~input): variables => {input: input};

  let make_response_deleteTodoItem =
      (~deletedTodoItemId=?, ~clientMutationId=?, ()): response_deleteTodoItem => {
    deletedTodoItemId,
    clientMutationId,
  };

  let makeOptimisticResponse = (~deleteTodoItem=?, ()): rawResponse => {
    deleteTodoItem: deleteTodoItem,
  };
};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%raw
  {json| (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "input"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "concreteType": "DeleteTodoItemPayload",
    "kind": "LinkedField",
    "name": "deleteTodoItem",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "deletedTodoItemId",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "clientMutationId",
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "SingleTodoDeleteMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "SingleTodoDeleteMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "6c0c28a190aca7b12ad8ab91424c3d36",
    "id": null,
    "metadata": {},
    "name": "SingleTodoDeleteMutation",
    "operationKind": "mutation",
    "text": "mutation SingleTodoDeleteMutation(\n  $input: DeleteTodoItemInput!\n) {\n  deleteTodoItem(input: $input) {\n    deletedTodoItemId\n    clientMutationId\n  }\n}\n"
  }
};
})() |json}
];
