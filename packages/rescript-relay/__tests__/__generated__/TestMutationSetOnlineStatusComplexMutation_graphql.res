/* @sourceLoc Test_mutation.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type enum_OnlineStatus = private [>
      | #Idle
      | #Offline
      | #Online
    ]
  @live
  type enum_OnlineStatus_input = [
      | #Idle
      | #Offline
      | #Online
    ]


  @live
  type rec setOnlineStatusInput = {
    onlineStatus: [
      | #Idle
      | #Offline
      | #Online
    ],
    recursed: option<recursiveSetOnlineStatusInput>,
  }
  @live
  and recursiveSetOnlineStatusInput = {
    setOnlineStatus: option<setOnlineStatusInput>,
    someValue: TestsUtils.IntString.t,
  }
  @live
  type rec response_setOnlineStatusComplex_user = {
    @live id: string,
    onlineStatus: option<enum_OnlineStatus>,
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
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"recursiveSetOnlineStatusInput":{"someValue":{"c":"TestsUtils.IntString"},"setOnlineStatus":{"r":"setOnlineStatusInput"}},"setOnlineStatusInput":{"recursed":{"r":"recursiveSetOnlineStatusInput"}},"__root":{"input":{"r":"setOnlineStatusInput"}}}`
  )
  @live
  let variablesConverterMap = {
    "TestsUtils.IntString": TestsUtils.IntString.serialize,
  }
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
  @live
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  @live
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  @live
  let onlineStatus_decode = (enum: enum_OnlineStatus): option<enum_OnlineStatus_input> => {
    switch enum {
      | #...enum_OnlineStatus_input as valid => Some(valid)
      | _ => None
    }
  }
  @live
  let onlineStatus_fromString = (str: string): option<enum_OnlineStatus_input> => {
    onlineStatus_decode(Obj.magic(str))
  }
  @live @obj external make_setOnlineStatusInput: (
    ~onlineStatus: [
      | #Idle
      | #Offline
      | #Online
    ],
    ~recursed: recursiveSetOnlineStatusInput=?,
    unit
  ) => setOnlineStatusInput = ""
  @live @obj external make_recursiveSetOnlineStatusInput: (
    ~setOnlineStatus: setOnlineStatusInput=?,
    ~someValue: TestsUtils.IntString.t,
    unit
  ) => recursiveSetOnlineStatusInput = ""
  @live @obj external makeVariables: (
    ~input: setOnlineStatusInput
  ) => variables = ""
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


