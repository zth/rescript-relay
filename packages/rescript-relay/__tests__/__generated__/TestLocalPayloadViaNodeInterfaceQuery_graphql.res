/* @sourceLoc Test_localPayload.res */
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
  type rec rawResponse_node_memberOf_Group_topMember_User = {
    @live __typename: [ | #User],
    __isNode: [ | #User],
    firstName: string,
    @live id: string,
  }
  @live
  and rawResponse_node_memberOf_Group = {
    @live __typename: [ | #Group],
    __isNode: [ | #Group],
    @live id: string,
    name: string,
    topMember: option<rawResponse_node_memberOf_Group_topMember>,
  }
  @live
  and rawResponse_node_memberOf_User = {
    @live __typename: [ | #User],
    __isNode: [ | #User],
    firstName: string,
    @live id: string,
  }
  @live
  and rawResponse_node_memberOfSingular_Group = {
    @live __typename: [ | #Group],
    __isNode: [ | #Group],
    @live id: string,
    name: string,
  }
  @live
  and rawResponse_node_memberOfSingular_User = {
    @live __typename: [ | #User],
    __isNode: [ | #User],
    firstName: string,
    @live id: string,
  }
  and rawResponse_node_memberOf_Group_topMember = [
    | #User(rawResponse_node_memberOf_Group_topMember_User)
    | #UnselectedUnionMember(string)
  ]

  and rawResponse_node_memberOf = [
    | #Group(rawResponse_node_memberOf_Group)
    | #User(rawResponse_node_memberOf_User)
    | #UnselectedUnionMember(string)
  ]

  and rawResponse_node_memberOfSingular = [
    | #Group(rawResponse_node_memberOfSingular_Group)
    | #User(rawResponse_node_memberOfSingular_User)
    | #UnselectedUnionMember(string)
  ]

  type rec response_node = {
    @live __typename: [ | #User],
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestLocalPayload_user]>,
  }
  @live
  and rawResponse_node = {
    @live __typename: [ | #User],
    avatarUrl: option<string>,
    firstName: string,
    @live id: string,
    memberOf: option<array<option<rawResponse_node_memberOf>>>,
    memberOfSingular: option<rawResponse_node_memberOfSingular>,
    onlineStatus: option<[
      | #Idle
      | #Offline
      | #Online
    ]>,
  }
  type response = {
    node: option<response_node>,
  }
  @live
  type rawResponse = {
    node: option<rawResponse_node>,
  }
  @live
  type variables = {
    @live id: string,
  }
  @live
  type refetchVariables = {
    @live id: option<string>,
  }
  @live let makeRefetchVariables = (
    ~id=?,
    ()
  ): refetchVariables => {
    id: id
  }

}

@live
let unwrap_rawResponse_node_memberOf_Group_topMember: {. "__typename": string } => [
  | #User(Types.rawResponse_node_memberOf_Group_topMember_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_rawResponse_node_memberOf_Group_topMember: [
  | #User(Types.rawResponse_node_memberOf_Group_topMember_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
@live
let unwrap_rawResponse_node_memberOf: {. "__typename": string } => [
  | #Group(Types.rawResponse_node_memberOf_Group)
  | #User(Types.rawResponse_node_memberOf_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "Group" => #Group(u->Obj.magic)
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_rawResponse_node_memberOf: [
  | #Group(Types.rawResponse_node_memberOf_Group)
  | #User(Types.rawResponse_node_memberOf_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #Group(v) => v->Obj.magic
  | #User(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
@live
let unwrap_rawResponse_node_memberOfSingular: {. "__typename": string } => [
  | #Group(Types.rawResponse_node_memberOfSingular_Group)
  | #User(Types.rawResponse_node_memberOfSingular_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "Group" => #Group(u->Obj.magic)
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_rawResponse_node_memberOfSingular: [
  | #Group(Types.rawResponse_node_memberOfSingular_Group)
  | #User(Types.rawResponse_node_memberOfSingular_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #Group(v) => v->Obj.magic
  | #User(v) => v->Obj.magic
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
    json`{"__root":{"node":{"tnf":"User","f":""}}}`
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
    json`{"__root":{"node":{"tnf":"User","f":""}}}`
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
    json`{"__root":{"node_memberOf_Group_topMember":{"u":"rawResponse_node_memberOf_Group_topMember"},"node_memberOfSingular":{"u":"rawResponse_node_memberOfSingular"},"node_memberOf":{"u":"rawResponse_node_memberOf"},"node":{"tnf":"User"}}}`
  )
  @live
  let wrapRawResponseConverterMap = {
    "rawResponse_node_memberOf_Group_topMember": wrap_rawResponse_node_memberOf_Group_topMember,
    "rawResponse_node_memberOf": wrap_rawResponse_node_memberOf,
    "rawResponse_node_memberOfSingular": wrap_rawResponse_node_memberOfSingular,
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
    json`{"__root":{"node_memberOf_Group_topMember":{"u":"rawResponse_node_memberOf_Group_topMember"},"node_memberOfSingular":{"u":"rawResponse_node_memberOfSingular"},"node_memberOf":{"u":"rawResponse_node_memberOf"},"node":{"tnf":"User"}}}`
  )
  @live
  let rawResponseConverterMap = {
    "rawResponse_node_memberOf_Group_topMember": unwrap_rawResponse_node_memberOf_Group_topMember,
    "rawResponse_node_memberOf": unwrap_rawResponse_node_memberOf,
    "rawResponse_node_memberOfSingular": unwrap_rawResponse_node_memberOfSingular,
  }
  @live
  let convertRawResponse = v => v->RescriptRelay.convertObj(
    rawResponseConverter,
    rawResponseConverterMap,
    Js.undefined
  )
}

type queryRef

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
  @live @obj external makeVariables: (
    ~id: string,
  ) => variables = ""


}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "id"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "id"
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "name",
  "storageKey": null
},
v6 = {
  "kind": "InlineFragment",
  "selections": [
    (v4/*: any*/)
  ],
  "type": "User",
  "abstractKey": null
},
v7 = {
  "kind": "InlineFragment",
  "selections": [
    (v3/*: any*/)
  ],
  "type": "Node",
  "abstractKey": "__isNode"
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestLocalPayloadViaNodeInterfaceQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": [
              {
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestLocalPayload_user"
              }
            ],
            "type": "User",
            "abstractKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestLocalPayloadViaNodeInterfaceQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          (v3/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": [
              (v4/*: any*/),
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "avatarUrl",
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
                  (v2/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v5/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": null,
                        "kind": "LinkedField",
                        "name": "topMember",
                        "plural": false,
                        "selections": [
                          (v2/*: any*/),
                          (v6/*: any*/),
                          (v7/*: any*/)
                        ],
                        "storageKey": null
                      }
                    ],
                    "type": "Group",
                    "abstractKey": null
                  },
                  (v6/*: any*/),
                  (v7/*: any*/)
                ],
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "concreteType": null,
                "kind": "LinkedField",
                "name": "memberOfSingular",
                "plural": false,
                "selections": [
                  (v2/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v5/*: any*/)
                    ],
                    "type": "Group",
                    "abstractKey": null
                  },
                  (v6/*: any*/),
                  (v7/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "type": "User",
            "abstractKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "6b9239c52d5de197a37c7cb388ca9bef",
    "id": null,
    "metadata": {},
    "name": "TestLocalPayloadViaNodeInterfaceQuery",
    "operationKind": "query",
    "text": "query TestLocalPayloadViaNodeInterfaceQuery(\n  $id: ID!\n) {\n  node(id: $id) {\n    __typename\n    ... on User {\n      ...TestLocalPayload_user\n    }\n    id\n  }\n}\n\nfragment TestLocalPayload_user on User {\n  firstName\n  avatarUrl\n  onlineStatus\n  memberOf {\n    __typename\n    ... on Group {\n      name\n      topMember {\n        __typename\n        ... on User {\n          firstName\n        }\n        ... on Node {\n          __typename\n          __isNode: __typename\n          id\n        }\n      }\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __typename\n      __isNode: __typename\n      id\n    }\n  }\n  memberOfSingular {\n    __typename\n    ... on Group {\n      name\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __typename\n      __isNode: __typename\n      id\n    }\n  }\n}\n"
  }
};
})() `)

include RescriptRelay.MakeLoadQuery({
    type variables = Types.variables
    type loadedQueryRef = queryRef
    type response = Types.response
    type node = relayOperationNode
    let query = node
    let convertVariables = Internal.convertVariables
});
