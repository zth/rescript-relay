/* @sourceLoc Test_nullableVariables.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  @live type someInput = RelaySchemaAssets_graphql.input_SomeInput_nullable
  @live
  type rec response_updateUserAvatar_user = {
    avatarUrl: option<string>,
    someRandomArgField: option<string>,
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
  type variables = {
    avatarUrl?: Js.Nullable.t<string>,
    someInput?: Js.Nullable.t<someInput>,
  }
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"someInput":{"recursive":{"r":"someInput"},"datetime":{"c":"TestsUtils.Datetime"}},"__root":{"someInput":{"r":"someInput"}}}`
  )
  @live
  let variablesConverterMap = {
    "TestsUtils.Datetime": TestsUtils.Datetime.serialize,
  }
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.null
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
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}
module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live @obj external make_someInput: (
    ~bool: bool=?,
    ~datetime: TestsUtils.Datetime.t=?,
    ~float: float=?,
    ~int: int=?,
    ~_private: bool=?,
    ~recursive: someInput=?,
    ~str: string=?,
    unit
  ) => someInput = ""


  @live @obj external makeVariables: (
    ~avatarUrl: string=?,
    ~someInput: someInput=?,
    unit
  ) => variables = ""


}

type relayOperationNode
type operationType = RescriptRelay.mutationNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "avatarUrl"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "someInput"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "avatarUrl",
    "variableName": "avatarUrl"
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "avatarUrl",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": [
    {
      "kind": "Variable",
      "name": "someInput",
      "variableName": "someInput"
    }
  ],
  "kind": "ScalarField",
  "name": "someRandomArgField",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestNullableVariablesMutation",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
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
              (v2/*: any*/),
              (v3/*: any*/)
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
    "name": "TestNullableVariablesMutation",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
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
              (v2/*: any*/),
              (v3/*: any*/),
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
    "cacheID": "9a78edc9246d901f0f8b29ef34b53df7",
    "id": null,
    "metadata": {},
    "name": "TestNullableVariablesMutation",
    "operationKind": "mutation",
    "text": "mutation TestNullableVariablesMutation(\n  $avatarUrl: String\n  $someInput: SomeInput\n) {\n  updateUserAvatar(avatarUrl: $avatarUrl) {\n    user {\n      avatarUrl\n      someRandomArgField(someInput: $someInput)\n      id\n    }\n  }\n}\n"
  }
};
})() `)


