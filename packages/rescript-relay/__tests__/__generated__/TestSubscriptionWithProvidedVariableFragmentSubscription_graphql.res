/* @sourceLoc Test_subscription.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live
  type rec response_userUpdated_user = {
    @live id: string,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestSubscriptionProvidedVariable_user]>,
  }
  @live
  and response_userUpdated = {
    user: option<response_userUpdated_user>,
  }
  @live
  type response = {
    userUpdated: option<response_userUpdated>,
  }
  @live
  type rawResponse = response
  @live
  type variables = unit
}

module Internal = {
  @live
  let variablesConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    None
  )
  @live
  type responseRaw
  @live
  let responseConverter: dict<dict<dict<string>>> = %raw(
    json`{"__root":{"userUpdated_user":{"f":""}}}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    None
  )
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
@live type providedVariable<'t> = { providedVariable: unit => 't, get: unit => 't }
@live type providedVariablesType = {
  __relay_internal__pv__ProvidedVariablesBool: providedVariable<bool>,
}
@live let providedVariablesDefinition: providedVariablesType = {
  __relay_internal__pv__ProvidedVariablesBool: {
    providedVariable: ProvidedVariables.Bool.get,
    get: ProvidedVariables.Bool.get,
  },
}

type relayOperationNode
type operationType = RescriptRelay.subscriptionNode<relayOperationNode>


%%private(let makeNode = (providedVariablesDefinition): operationType => {
  ignore(providedVariablesDefinition)
  %raw(json`(function(){
var v0 = [
  {
    "kind": "Literal",
    "name": "id",
    "value": "user-1"
  }
],
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "onlineStatus",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestSubscriptionWithProvidedVariableFragmentSubscription",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": "UserUpdatedPayload",
        "kind": "LinkedField",
        "name": "userUpdated",
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
              (v1/*: any*/),
              (v2/*: any*/),
              {
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestSubscriptionProvidedVariable_user"
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": "userUpdated(id:\"user-1\")"
      }
    ],
    "type": "Subscription",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "__relay_internal__pv__ProvidedVariablesBool"
      }
    ],
    "kind": "Operation",
    "name": "TestSubscriptionWithProvidedVariableFragmentSubscription",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": "UserUpdatedPayload",
        "kind": "LinkedField",
        "name": "userUpdated",
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
              (v1/*: any*/),
              (v2/*: any*/),
              {
                "alias": null,
                "args": [
                  {
                    "kind": "Variable",
                    "name": "bool",
                    "variableName": "__relay_internal__pv__ProvidedVariablesBool"
                  }
                ],
                "kind": "ScalarField",
                "name": "someRandomArgField",
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": "userUpdated(id:\"user-1\")"
      }
    ]
  },
  "params": {
    "cacheID": "07e00d76114780c061b4e56778d3b859",
    "id": null,
    "metadata": {},
    "name": "TestSubscriptionWithProvidedVariableFragmentSubscription",
    "operationKind": "subscription",
    "text": "subscription TestSubscriptionWithProvidedVariableFragmentSubscription(\n  $__relay_internal__pv__ProvidedVariablesBool: Boolean!\n) {\n  userUpdated(id: \"user-1\") {\n    user {\n      id\n      onlineStatus\n      ...TestSubscriptionProvidedVariable_user\n    }\n  }\n}\n\nfragment TestSubscriptionProvidedVariable_user on User {\n  someRandomArgField(bool: $__relay_internal__pv__ProvidedVariablesBool)\n}\n",
    "providedVariables": providedVariablesDefinition
  }
};
})()`)
})
let node: operationType = makeNode(providedVariablesDefinition)


