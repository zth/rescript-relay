/* @sourceLoc Test_mutation.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live
  type rec response_setOnlineStatus_user = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestMutationInline_user]>,
  }
  @live
  and response_setOnlineStatus = {
    user: option<response_setOnlineStatus_user>,
  }
  @live
  and rawResponse_setOnlineStatus_user = {
    firstName: string,
    @live id: string,
    lastName: string,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus_input>,
  }
  @live
  and rawResponse_setOnlineStatus = {
    user: option<rawResponse_setOnlineStatus_user>,
  }
  @live
  type response = {
    setOnlineStatus: option<response_setOnlineStatus>,
  }
  @live
  type rawResponse = {
    setOnlineStatus: option<rawResponse_setOnlineStatus>,
  }
  @live
  type variables = {
    onlineStatus: RelaySchemaAssets_graphql.enum_OnlineStatus_input,
  }
}

module Internal = {
  @live
  let convertVariables = value => RescriptRelay.convertWithoutPlan(value, None)
  @live
  type wrapResponseRaw
  %%private(
  @live
  let wrapResponseConverter: JSON.t = %raw(json`{"roots":{"__root":[{"fragments":true,"path":["setOnlineStatus","user"]}]},"version":2}`)
  @live
  let wrapResponseCallbacks = ()
  @live
  let preparedWrapResponseConverter = RescriptRelay.prepareConversion(
    wrapResponseConverter,
    wrapResponseCallbacks,
    null
  )
  )
  @live
  let convertWrapResponse = value => RescriptRelay.runConversion(preparedWrapResponseConverter, value)
  @live
  type responseRaw
  %%private(
  @live
  let responseConverter = wrapResponseConverter
  @live
  let responseCallbacks = ()
  @live
  let preparedResponseConverter = RescriptRelay.prepareConversion(
    responseConverter,
    responseCallbacks,
    None
  )
  )
  @live
  let convertResponse = value => RescriptRelay.runConversion(preparedResponseConverter, value)
  @live
  type wrapRawResponseRaw
  @live
  let convertWrapRawResponse = value => RescriptRelay.convertWithoutPlan(value, null)
  @live
  type rawResponseRaw
  @live
  let convertRawResponse = value => RescriptRelay.convertWithoutPlan(value, None)
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
    "name": "onlineStatus"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "onlineStatus",
    "variableName": "onlineStatus"
  }
],
v2 = [
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
    "name": "firstName",
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "kind": "ScalarField",
    "name": "lastName",
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "kind": "ScalarField",
    "name": "onlineStatus",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestMutationWithInlineFragmentSetOnlineStatusMutation",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": "SetOnlineStatusPayload",
        "kind": "LinkedField",
        "name": "setOnlineStatus",
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
                "kind": "InlineDataFragmentSpread",
                "name": "TestMutationInline_user",
                "selections": (v2/*: any*/),
                "args": null,
                "argumentDefinitions": []
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestMutationWithInlineFragmentSetOnlineStatusMutation",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": "SetOnlineStatusPayload",
        "kind": "LinkedField",
        "name": "setOnlineStatus",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "User",
            "kind": "LinkedField",
            "name": "user",
            "plural": false,
            "selections": (v2/*: any*/),
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "d3e7e63af6c86488c422148cf408a848",
    "id": null,
    "metadata": {},
    "name": "TestMutationWithInlineFragmentSetOnlineStatusMutation",
    "operationKind": "mutation",
    "text": "mutation TestMutationWithInlineFragmentSetOnlineStatusMutation(\n  $onlineStatus: OnlineStatus!\n) {\n  setOnlineStatus(onlineStatus: $onlineStatus) {\n    user {\n      ...TestMutationInline_user\n      id\n    }\n  }\n}\n\nfragment TestMutationInline_user on User {\n  id\n  firstName\n  lastName\n  onlineStatus\n}\n"
  }
};
})() `)


