/* @sourceLoc Test_mutation.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type enum_OnlineStatus = private [>
      | #Online
      | #Idle
      | #Offline
    ]

  type enum_OnlineStatus_input = [
      | #Online
      | #Idle
      | #Offline
    ]



  type rec setOnlineStatusInput = {
    onlineStatus: enum_OnlineStatus,
    recursed: option<recursiveSetOnlineStatusInput>,
  }
  and recursiveSetOnlineStatusInput = {
    someValue: TestsUtils.IntString.t,
    setOnlineStatus: option<setOnlineStatusInput>,
  }
  type rec response_setOnlineStatusComplex_user = {
    id: string,
    onlineStatus: option<enum_OnlineStatus>,
  }
  and response_setOnlineStatusComplex = {
    user: option<response_setOnlineStatusComplex_user>,
  }
  type response = {
    setOnlineStatusComplex: option<response_setOnlineStatusComplex>,
  }
  type rawResponse = response
  type variables = {
    input: setOnlineStatusInput,
  }
}

module Internal = {
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"recursiveSetOnlineStatusInput":{"someValue":{"c":"TestsUtils.IntString"},"setOnlineStatus":{"r":"setOnlineStatusInput"}},"setOnlineStatusInput":{"recursed":{"r":"recursiveSetOnlineStatusInput"}},"__root":{"someValue":{"c":"TestsUtils.IntString"},"setOnlineStatus":{"r":"setOnlineStatusInput"},"recursed":{"r":"recursiveSetOnlineStatusInput"},"input":{"r":"setOnlineStatusInput"}}}`
  )
  let variablesConverterMap = {
    "TestsUtils.IntString": TestsUtils.IntString.serialize,
  }
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  type wrapResponseRaw
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  let wrapResponseConverterMap = ()
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  type responseRaw
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  let responseConverterMap = ()
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw = wrapResponseRaw
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  let convertRawResponse = convertResponse
}
module Utils = {
  @@ocaml.warning("-33")
  open Types
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  let onlineStatus_decode = (enum: enum_OnlineStatus): option<enum_OnlineStatus_input> => {
    switch enum {
      | #...enum_OnlineStatus_input as valid => Some(valid)
      | _ => None
    }
  }
  let onlineStatus_fromString = (str: string): option<enum_OnlineStatus_input> => {
    onlineStatus_decode(Obj.magic(str))
  }
  let make_setOnlineStatusInput = (
    ~onlineStatus,
    ~recursed=?,
    ()
  ): setOnlineStatusInput => {
    onlineStatus: onlineStatus,
    recursed: recursed
  }
  let make_recursiveSetOnlineStatusInput = (
    ~someValue,
    ~setOnlineStatus=?,
    ()
  ): recursiveSetOnlineStatusInput => {
    someValue: someValue,
    setOnlineStatus: setOnlineStatus
  }
  let makeVariables = (
    ~input
  ): variables => {
    input: input
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


