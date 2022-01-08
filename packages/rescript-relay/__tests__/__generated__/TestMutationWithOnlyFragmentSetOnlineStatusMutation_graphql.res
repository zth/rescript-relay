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

  @live
  type enum_OnlineStatus_input = [
      | #Online
      | #Idle
      | #Offline
    ]



  type rec rawResponse_setOnlineStatus_user_memberOf_User = {
    @live __typename: [ | #User],
    @live __isNode: [ | #User],
    @live id: string,
    @live firstName: string,
  }
  and rawResponse_setOnlineStatus_user_memberOf_Group = {
    @live __typename: [ | #Group],
    @live __isNode: [ | #Group],
    @live id: string,
    @live name: string,
  }
  and rawResponse_setOnlineStatus_user_memberOf = [
    | #User(rawResponse_setOnlineStatus_user_memberOf_User)
    | #Group(rawResponse_setOnlineStatus_user_memberOf_Group)
    | #UnselectedUnionMember(string)
  ]

  type rec response_setOnlineStatus_user = {
    @live fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestMutation_user]>,
  }
  and response_setOnlineStatus = {
    @live user: option<response_setOnlineStatus_user>,
  }
  and rawResponse_setOnlineStatus_user = {
    @live id: string,
    @live firstName: string,
    @live lastName: string,
    @live onlineStatus: option<enum_OnlineStatus>,
    @live memberOf: option<array<option<rawResponse_setOnlineStatus_user_memberOf>>>,
  }
  and rawResponse_setOnlineStatus = {
    @live user: option<rawResponse_setOnlineStatus_user>,
  }
  type response = {
    @live setOnlineStatus: option<response_setOnlineStatus>,
  }
  type rawResponse = {
    @live setOnlineStatus: option<rawResponse_setOnlineStatus>,
  }
  type variables = {
    @live onlineStatus: [
      | #Online
      | #Idle
      | #Offline
    ]
,
  }
}

@live
let unwrap_rawResponse_setOnlineStatus_user_memberOf: {. "__typename": string } => [
  | #User(Types.rawResponse_setOnlineStatus_user_memberOf_User)
  | #Group(Types.rawResponse_setOnlineStatus_user_memberOf_Group)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | "Group" => #Group(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_rawResponse_setOnlineStatus_user_memberOf: [
  | #User(Types.rawResponse_setOnlineStatus_user_memberOf_User)
  | #Group(Types.rawResponse_setOnlineStatus_user_memberOf_Group)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #Group(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
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
    json`{"__root":{"setOnlineStatus_user":{"f":""}}}`
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
    json`{"__root":{"setOnlineStatus_user":{"f":""}}}`
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
    json`{"__root":{"setOnlineStatus_user_memberOf":{"u":"rawResponse_setOnlineStatus_user_memberOf"}}}`
  )
  @live
  let wrapRawResponseConverterMap = {
    "rawResponse_setOnlineStatus_user_memberOf": wrap_rawResponse_setOnlineStatus_user_memberOf,
  }
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
    json`{"__root":{"setOnlineStatus_user_memberOf":{"u":"rawResponse_setOnlineStatus_user_memberOf"}}}`
  )
  @live
  let rawResponseConverterMap = {
    "rawResponse_setOnlineStatus_user_memberOf": unwrap_rawResponse_setOnlineStatus_user_memberOf,
  }
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
  @live let makeVariables = (
    ~onlineStatus
  ): variables => {
    onlineStatus: onlineStatus
  }
  @live let makeOptimisticResponse = (
    ~setOnlineStatus=?,
    ()
  ): rawResponse => {
    setOnlineStatus: setOnlineStatus
  }
  @live let make_rawResponse_setOnlineStatus_user_memberOf_User = (
    ~__typename,
    ~__isNode,
    ~id,
    ~firstName
  ): rawResponse_setOnlineStatus_user_memberOf_User => {
    __typename: __typename,
    __isNode: __isNode,
    id: id,
    firstName: firstName
  }
  @live let make_rawResponse_setOnlineStatus_user_memberOf_Group = (
    ~__typename,
    ~__isNode,
    ~id,
    ~name
  ): rawResponse_setOnlineStatus_user_memberOf_Group => {
    __typename: __typename,
    __isNode: __isNode,
    id: id,
    name: name
  }
  @live let make_rawResponse_setOnlineStatus_user = (
    ~id,
    ~firstName,
    ~lastName,
    ~onlineStatus=?,
    ~memberOf=?,
    ()
  ): rawResponse_setOnlineStatus_user => {
    id: id,
    firstName: firstName,
    lastName: lastName,
    onlineStatus: onlineStatus,
    memberOf: memberOf
  }
  @live let make_rawResponse_setOnlineStatus = (
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
  "name": "firstName",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestMutationWithOnlyFragmentSetOnlineStatusMutation",
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
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestMutation_user"
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
    "name": "TestMutationWithOnlyFragmentSetOnlineStatusMutation",
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
                "name": "lastName",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "onlineStatus",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "concreteType": null,
                "kind": "LinkedField",
                "name": "memberOf",
                "plural": true,
                "selections": [
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "__typename",
                    "storageKey": null
                  },
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v3/*: any*/)
                    ],
                    "type": "User",
                    "abstractKey": null
                  },
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "name",
                        "storageKey": null
                      }
                    ],
                    "type": "Group",
                    "abstractKey": null
                  },
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v2/*: any*/)
                    ],
                    "type": "Node",
                    "abstractKey": "__isNode"
                  }
                ],
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
    "cacheID": "724fcaffced61b930d2c0273b67c23c1",
    "id": null,
    "metadata": {},
    "name": "TestMutationWithOnlyFragmentSetOnlineStatusMutation",
    "operationKind": "mutation",
    "text": "mutation TestMutationWithOnlyFragmentSetOnlineStatusMutation(\n  $onlineStatus: OnlineStatus!\n) {\n  setOnlineStatus(onlineStatus: $onlineStatus) {\n    user {\n      ...TestMutation_user\n      id\n    }\n  }\n}\n\nfragment TestMutation_user on User {\n  id\n  firstName\n  lastName\n  onlineStatus\n  memberOf {\n    __typename\n    ... on User {\n      firstName\n    }\n    ... on Group {\n      name\n    }\n    ... on Node {\n      __typename\n      __isNode: __typename\n      id\n    }\n  }\n}\n"
  }
};
})() `)


