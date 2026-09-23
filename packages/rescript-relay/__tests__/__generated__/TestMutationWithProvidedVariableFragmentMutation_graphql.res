/* @sourceLoc Test_mutation.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live
  type rec response_updateUserAvatar_user = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestMutationProvidedVariable_user]>,
  }
  @live
  and response_updateUserAvatar = {
    user: option<response_updateUserAvatar_user>,
  }
  @live
  type response = {
    updateUserAvatar: option<response_updateUserAvatar>,
  }
  @live
  type rawResponse = response
  @live
  type variables = unit
}

module Internal = {
  @live
  let convertVariables = value => RescriptRelay.convertWithoutPlan(value, None)
  @live
  type wrapResponseRaw
  %%private(
  @live
  let wrapResponseConverter: JSON.t = %raw(json`{"roots":{"__root":[{"fragments":true,"path":["updateUserAvatar","user"]}]},"version":2}`)
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
type operationType = RescriptRelay.mutationNode<relayOperationNode>


%%private(let makeNode = (providedVariablesDefinition): operationType => {
  ignore(providedVariablesDefinition)
  %raw(json`{
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestMutationWithProvidedVariableFragmentMutation",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "UpdateUserAvatarPayload",
        "kind": "LinkedField",
        "name": "updateUserAvatar",
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
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestMutationProvidedVariable_user"
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
    "argumentDefinitions": [
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "__relay_internal__pv__ProvidedVariablesBool"
      }
    ],
    "kind": "Operation",
    "name": "TestMutationWithProvidedVariableFragmentMutation",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "UpdateUserAvatarPayload",
        "kind": "LinkedField",
        "name": "updateUserAvatar",
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
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "id",
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "a3f470a6bed8cef0adf39310f761636c",
    "id": null,
    "metadata": {},
    "name": "TestMutationWithProvidedVariableFragmentMutation",
    "operationKind": "mutation",
    "text": "mutation TestMutationWithProvidedVariableFragmentMutation(\n  $__relay_internal__pv__ProvidedVariablesBool: Boolean!\n) {\n  updateUserAvatar {\n    user {\n      ...TestMutationProvidedVariable_user\n      id\n    }\n  }\n}\n\nfragment TestMutationProvidedVariable_user on User {\n  someRandomArgField(bool: $__relay_internal__pv__ProvidedVariablesBool)\n}\n",
    "providedVariables": providedVariablesDefinition
  }
}`)
})
let node: operationType = makeNode(providedVariablesDefinition)


