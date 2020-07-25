/* @generated */

module Types = {
  type addTodoItemInput = {
    text: string,
    clientMutationId: option(string),
  };
  type response_addTodoItem_addedTodoItem = {
    id: string,
    text: string,
    completed: option(bool),
  };
  type response_addTodoItem = {
    addedTodoItem: option(response_addTodoItem_addedTodoItem),
  };

  type response = {addTodoItem: option(response_addTodoItem)};
  type rawResponse = response;
  type variables = {input: addTodoItemInput};
};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"addTodoItem":{"n":""},"addTodoItem_addedTodoItem":{"n":""},"addTodoItem_addedTodoItem_completed":{"n":""}}} |json}
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
    {json| {"__root":{"addTodoItem":{"n":""},"addTodoItem_addedTodoItem":{"n":""},"addTodoItem_addedTodoItem_completed":{"n":""}}} |json}
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
    {json| {"__root":{"input":{"r":"AddTodoItemInput"}},"AddTodoItemInput":{"clientMutationId":{"n":""}}} |json}
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
  let make_addTodoItemInput =
      (~text, ~clientMutationId=?, ()): addTodoItemInput => {
    text,
    clientMutationId,
  };

  let makeVariables = (~input): variables => {input: input};

  let make_response_addTodoItem_addedTodoItem =
      (~id, ~text, ~completed=?, ()): response_addTodoItem_addedTodoItem => {
    id,
    text,
    completed,
  };

  let make_response_addTodoItem = (~addedTodoItem=?, ()): response_addTodoItem => {
    addedTodoItem: addedTodoItem,
  };

  let makeOptimisticResponse = (~addTodoItem=?, ()): rawResponse => {
    addTodoItem: addTodoItem,
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
    "concreteType": "AddTodoItemPayload",
    "kind": "LinkedField",
    "name": "addTodoItem",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "TodoItem",
        "kind": "LinkedField",
        "name": "addedTodoItem",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "text",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "completed",
            "storageKey": null
          }
        ],
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
    "name": "TodoListAddTodoMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TodoListAddTodoMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "c011aa6f7e05ca44cf05f93d4ec8c1aa",
    "id": null,
    "metadata": {},
    "name": "TodoListAddTodoMutation",
    "operationKind": "mutation",
    "text": "mutation TodoListAddTodoMutation(\n  $input: AddTodoItemInput!\n) {\n  addTodoItem(input: $input) {\n    addedTodoItem {\n      id\n      text\n      completed\n    }\n  }\n}\n"
  }
};
})() |json}
];
