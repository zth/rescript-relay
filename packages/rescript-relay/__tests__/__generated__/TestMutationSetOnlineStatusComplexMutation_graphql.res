/* @sourceLoc Test_mutation.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live type setOnlineStatusInput = RelaySchemaAssets_graphql.input_SetOnlineStatusInput
  @live type recursiveSetOnlineStatusInput = RelaySchemaAssets_graphql.input_RecursiveSetOnlineStatusInput
  @live
  type rec response_setOnlineStatusComplex_user = {
    @live id: string,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
  }
  @live
  and response_setOnlineStatusComplex = {
    user: option<response_setOnlineStatusComplex_user>,
  }
  @live
  type response = {
    setOnlineStatusComplex: option<response_setOnlineStatusComplex>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    input: setOnlineStatusInput,
  }
}

module Internal = {
  @live
  let variablesConverter: dict<dict<dict<string>>> = %raw(
    json`{"recursiveSetOnlineStatusInput":{"someValue":{"c":"TestsUtils.IntString"},"setOnlineStatus":{"r":"setOnlineStatusInput"}},"setOnlineStatusInput":{"someJsonValue":{"b":""},"recursed":{"r":"recursiveSetOnlineStatusInput"}},"__root":{"input":{"r":"setOnlineStatusInput"}}}`
  )
  @live
  let variablesConverterMap = {
    "TestsUtils.IntString": TestsUtils.IntString.serialize,
  }
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    None
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    null
  )
  @live
  type responseRaw
  @live
  let responseConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    None
  )
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}
module Utils = {
  @@warning("-33")
  open Types
  @live
  external onlineStatus_toString: RelaySchemaAssets_graphql.enum_OnlineStatus => string = "%identity"
  @live
  external onlineStatus_input_toString: RelaySchemaAssets_graphql.enum_OnlineStatus_input => string = "%identity"
  @live
  let onlineStatus_decode = (enum: RelaySchemaAssets_graphql.enum_OnlineStatus): option<RelaySchemaAssets_graphql.enum_OnlineStatus_input> => {
    switch enum {
      | FutureAddedValue(_) => None
      | valid => Some(Obj.magic(valid))
    }
  }
  @live
  let onlineStatus_fromString = (str: string): option<RelaySchemaAssets_graphql.enum_OnlineStatus_input> => {
    onlineStatus_decode(Obj.magic(str))
  }
}

type relayOperationNode
type operationType = RescriptRelay.mutationNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
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
    "concreteType": "SetOnlineStatusPayload",
    "kind": "LinkedField",
    "name": "setOnlineStatusComplex",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "user",
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
            "name": "onlineStatus",
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
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "20484379745a128851fbf94268a240bf",
    "id": null,
    "metadata": {},
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "operationKind": "mutation",
    "text": "mutation TestMutationSetOnlineStatusComplexMutation(\n  $input: SetOnlineStatusInput!\n) {\n  setOnlineStatusComplex(input: $input) {\n    user {\n      id\n      onlineStatus\n    }\n  }\n}\n"
  }
};
})() `)


