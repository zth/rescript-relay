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



  type rec response_setOnlineStatus_user = {
    id: string,
    onlineStatus: option<enum_OnlineStatus>,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestFragment_user]>,
  }
  and response_setOnlineStatus = {
    user: option<response_setOnlineStatus_user>,
  }
  and rawResponse_setOnlineStatus_user = {
    id: string,
    onlineStatus: option<enum_OnlineStatus>,
    firstName: string,
    lastName: string,
    __id: option<RescriptRelay.dataId>,
  }
  and rawResponse_setOnlineStatus = {
    user: option<rawResponse_setOnlineStatus_user>,
  }
  type response = {
    setOnlineStatus: option<response_setOnlineStatus>,
  }
  type rawResponse = {
    setOnlineStatus: option<rawResponse_setOnlineStatus>,
  }
  type variables = {
    onlineStatus: [
      | #Online
      | #Idle
      | #Offline
    ]
,
  }
}

module Internal = {
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  let variablesConverterMap = ()
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  type wrapResponseRaw
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"setOnlineStatus_user_onlineStatus":{"n":""},"setOnlineStatus_user":{"n":"","f":""},"setOnlineStatus":{"n":""}}}`
  )
  let wrapResponseConverterMap = ()
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  type responseRaw
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"setOnlineStatus_user_onlineStatus":{"n":""},"setOnlineStatus_user":{"n":"","f":""},"setOnlineStatus":{"n":""}}}`
  )
  let responseConverterMap = ()
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw
  let wrapRawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"setOnlineStatus_user_onlineStatus":{"n":""},"setOnlineStatus_user":{"n":""},"setOnlineStatus":{"n":""}}}`
  )
  let wrapRawResponseConverterMap = ()
  let convertWrapRawResponse = v => v->RescriptRelay.convertObj(
    wrapRawResponseConverter,
    wrapRawResponseConverterMap,
    Js.null
  )
  type rawResponseRaw
  let rawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"setOnlineStatus_user_onlineStatus":{"n":""},"setOnlineStatus_user":{"n":""},"setOnlineStatus":{"n":""}}}`
  )
  let rawResponseConverterMap = ()
  let convertRawResponse = v => v->RescriptRelay.convertObj(
    rawResponseConverter,
    rawResponseConverterMap,
    Js.undefined
  )
}
module Utils = {
  @@ocaml.warning("-33")
  open Types
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  let makeVariables = (
    ~onlineStatus
  ): variables => {
    onlineStatus: onlineStatus
  }
  let makeOptimisticResponse = (
    ~setOnlineStatus=?,
    ()
  ): rawResponse => {
    setOnlineStatus: setOnlineStatus
  }
  let make_rawResponse_setOnlineStatus_user = (
    ~id,
    ~onlineStatus=?,
    ~firstName,
    ~lastName,
    ~__id=?,
    ()
  ): rawResponse_setOnlineStatus_user => {
    id: id,
    onlineStatus: onlineStatus,
    firstName: firstName,
    lastName: lastName,
    __id: __id
  }
  let make_rawResponse_setOnlineStatus = (
    ~user=?,
    ()
  ): rawResponse_setOnlineStatus => {
    user: user
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
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "onlineStatus",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestMutationSetOnlineStatusMutation",
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
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestFragment_user"
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
    "name": "TestMutationSetOnlineStatusMutation",
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
              (v2/*: any*/),
              (v3/*: any*/),
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
                "kind": "ClientExtension",
                "selections": [
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "__id",
                    "storageKey": null
                  }
                ]
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
    "cacheID": "4268475f132103f907cf195a54f2934d",
    "id": null,
    "metadata": {},
    "name": "TestMutationSetOnlineStatusMutation",
    "operationKind": "mutation",
    "text": "mutation TestMutationSetOnlineStatusMutation(\n  $onlineStatus: OnlineStatus!\n) {\n  setOnlineStatus(onlineStatus: $onlineStatus) {\n    user {\n      id\n      onlineStatus\n      ...TestFragment_user\n    }\n  }\n}\n\nfragment TestFragment_sub_user on User {\n  lastName\n}\n\nfragment TestFragment_user on User {\n  firstName\n  onlineStatus\n  ...TestFragment_sub_user\n}\n"
  }
};
})() `)


