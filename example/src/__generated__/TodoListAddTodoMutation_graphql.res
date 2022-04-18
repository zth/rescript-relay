/* @sourceLoc TodoList.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  @live
  type rec addTodoItemInput = {
    clientMutationId: option<string>,
    text: string,
  }
  @live
  type rec response_addTodoItem_addedTodoItem = {
    completed: option<bool>,
    @live id: string,
    text: string,
  }
  @live
  and response_addTodoItem = {
    addedTodoItem: option<response_addTodoItem_addedTodoItem>,
  }
  @live
  and rawResponse_addTodoItem_addedTodoItem = {
    completed: option<bool>,
    @live id: string,
    text: string,
  }
  @live
  and rawResponse_addTodoItem = {
    addedTodoItem: option<rawResponse_addTodoItem_addedTodoItem>,
  }
  @live
  type response = {
    addTodoItem: option<response_addTodoItem>,
  }
  @live
  type rawResponse = {
    addTodoItem: option<rawResponse_addTodoItem>,
  }
  @live
  type variables = {
    connections: array<RescriptRelay.dataId>,
    input: addTodoItemInput,
  }
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"addTodoItemInput":{},"__root":{"input":{"r":"addTodoItemInput"}}}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  @live
  type responseRaw
  @live
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  @live
  type wrapRawResponseRaw
  @live
  let wrapRawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let wrapRawResponseConverterMap = ()
  @live
  let convertWrapRawResponse = v => v->RescriptRelay.convertObj(
    wrapRawResponseConverter,
    wrapRawResponseConverterMap,
    Js.null
  )
  @live
  type rawResponseRaw
  @live
  let rawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let rawResponseConverterMap = ()
  @live
  let convertRawResponse = v => v->RescriptRelay.convertObj(
    rawResponseConverter,
    rawResponseConverterMap,
    Js.undefined
  )
}
module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live @obj external make_addTodoItemInput: (
    ~clientMutationId: string=?,
    ~text: string,
    unit
  ) => addTodoItemInput = ""


  @live @obj external makeVariables: (
    ~connections: array<RescriptRelay.dataId>,
    ~input: addTodoItemInput,
  ) => variables = ""


  @live @obj external makeOptimisticResponse: (
    ~addTodoItem: rawResponse_addTodoItem=?,
    unit
  ) => rawResponse = ""


  @live @obj external make_rawResponse_addTodoItem_addedTodoItem: (
    ~completed: bool=?,
    ~id: string,
    ~text: string,
    unit
  ) => rawResponse_addTodoItem_addedTodoItem = ""


  @live @obj external make_rawResponse_addTodoItem: (
    ~addedTodoItem: rawResponse_addTodoItem_addedTodoItem=?,
    unit
  ) => rawResponse_addTodoItem = ""


}

type relayOperationNode
type operationType = RescriptRelay.mutationNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "connections"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "input"
},
v2 = [
  {
    "kind": "Variable",
    "name": "input",
    "variableName": "input"
  }
],
v3 = {
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
};
return {
  "fragment": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "TodoListAddTodoMutation",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
        "concreteType": "AddTodoItemPayload",
        "kind": "LinkedField",
        "name": "addTodoItem",
        "plural": false,
        "selections": [
          (v3/*: any*/)
        ],
        "storageKey": null
      }
    ],
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v1/*: any*/),
      (v0/*: any*/)
    ],
    "kind": "Operation",
    "name": "TodoListAddTodoMutation",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
        "concreteType": "AddTodoItemPayload",
        "kind": "LinkedField",
        "name": "addTodoItem",
        "plural": false,
        "selections": [
          (v3/*: any*/),
          {
            "alias": null,
            "args": null,
            "filters": null,
            "handle": "appendNode",
            "key": "",
            "kind": "LinkedHandle",
            "name": "addedTodoItem",
            "handleArgs": [
              {
                "kind": "Variable",
                "name": "connections",
                "variableName": "connections"
              },
              {
                "kind": "Literal",
                "name": "edgeTypeName",
                "value": "TodoItemEdge"
              }
            ]
          }
        ],
        "storageKey": null
      }
    ]
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
})() `)


