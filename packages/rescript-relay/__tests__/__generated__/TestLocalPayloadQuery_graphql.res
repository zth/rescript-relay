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
  type rec rawResponse_loggedInUser_memberOf_Group_topMember_User = {
    @live __typename: [ | #User],
    __isNode: [ | #User],
    firstName: string,
    @live id: string,
  }
  @live
  and rawResponse_loggedInUser_memberOf_Group = {
    @live __typename: [ | #Group],
    __isNode: [ | #Group],
    @live id: string,
    name: string,
    topMember: option<rawResponse_loggedInUser_memberOf_Group_topMember>,
  }
  @live
  and rawResponse_loggedInUser_memberOf_User = {
    @live __typename: [ | #User],
    __isNode: [ | #User],
    firstName: string,
    @live id: string,
  }
  @live
  and rawResponse_loggedInUser_memberOfSingular_Group = {
    @live __typename: [ | #Group],
    __isNode: [ | #Group],
    @live id: string,
    name: string,
  }
  @live
  and rawResponse_loggedInUser_memberOfSingular_User = {
    @live __typename: [ | #User],
    __isNode: [ | #User],
    firstName: string,
    @live id: string,
  }
  and rawResponse_loggedInUser_memberOf_Group_topMember = [
    | #User(rawResponse_loggedInUser_memberOf_Group_topMember_User)
    | #UnselectedUnionMember(string)
  ]

  and rawResponse_loggedInUser_memberOf = [
    | #Group(rawResponse_loggedInUser_memberOf_Group)
    | #User(rawResponse_loggedInUser_memberOf_User)
    | #UnselectedUnionMember(string)
  ]

  and rawResponse_loggedInUser_memberOfSingular = [
    | #Group(rawResponse_loggedInUser_memberOfSingular_Group)
    | #User(rawResponse_loggedInUser_memberOfSingular_User)
    | #UnselectedUnionMember(string)
  ]

  type rec response_loggedInUser = {
    @live id: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestLocalPayload_user]>,
  }
  @live
  and rawResponse_loggedInUser = {
    avatarUrl: option<string>,
    firstName: string,
    @live id: string,
    memberOf: option<array<option<rawResponse_loggedInUser_memberOf>>>,
    memberOfSingular: option<rawResponse_loggedInUser_memberOfSingular>,
    onlineStatus: option<[
      | #Idle
      | #Offline
      | #Online
    ]>,
  }
  type response = {
    loggedInUser: response_loggedInUser,
  }
  @live
  type rawResponse = {
    loggedInUser: rawResponse_loggedInUser,
  }
  @live
  type variables = unit
  @live
  type refetchVariables = unit
  @live let makeRefetchVariables = () => ()
}

@live
let unwrap_rawResponse_loggedInUser_memberOf_Group_topMember: {. "__typename": string } => [
  | #User(Types.rawResponse_loggedInUser_memberOf_Group_topMember_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_rawResponse_loggedInUser_memberOf_Group_topMember: [
  | #User(Types.rawResponse_loggedInUser_memberOf_Group_topMember_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
@live
let unwrap_rawResponse_loggedInUser_memberOf: {. "__typename": string } => [
  | #Group(Types.rawResponse_loggedInUser_memberOf_Group)
  | #User(Types.rawResponse_loggedInUser_memberOf_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "Group" => #Group(u->Obj.magic)
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_rawResponse_loggedInUser_memberOf: [
  | #Group(Types.rawResponse_loggedInUser_memberOf_Group)
  | #User(Types.rawResponse_loggedInUser_memberOf_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #Group(v) => v->Obj.magic
  | #User(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
@live
let unwrap_rawResponse_loggedInUser_memberOfSingular: {. "__typename": string } => [
  | #Group(Types.rawResponse_loggedInUser_memberOfSingular_Group)
  | #User(Types.rawResponse_loggedInUser_memberOfSingular_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "Group" => #Group(u->Obj.magic)
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_rawResponse_loggedInUser_memberOfSingular: [
  | #Group(Types.rawResponse_loggedInUser_memberOfSingular_Group)
  | #User(Types.rawResponse_loggedInUser_memberOfSingular_User)
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
    json`{"__root":{"loggedInUser":{"f":""}}}`
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
    json`{"__root":{"loggedInUser":{"f":""}}}`
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
    json`{"__root":{"loggedInUser_memberOf_Group_topMember":{"u":"rawResponse_loggedInUser_memberOf_Group_topMember"},"loggedInUser_memberOfSingular":{"u":"rawResponse_loggedInUser_memberOfSingular"},"loggedInUser_memberOf":{"u":"rawResponse_loggedInUser_memberOf"}}}`
  )
  @live
  let wrapRawResponseConverterMap = {
    "rawResponse_loggedInUser_memberOf_Group_topMember": wrap_rawResponse_loggedInUser_memberOf_Group_topMember,
    "rawResponse_loggedInUser_memberOf": wrap_rawResponse_loggedInUser_memberOf,
    "rawResponse_loggedInUser_memberOfSingular": wrap_rawResponse_loggedInUser_memberOfSingular,
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
    json`{"__root":{"loggedInUser_memberOf_Group_topMember":{"u":"rawResponse_loggedInUser_memberOf_Group_topMember"},"loggedInUser_memberOfSingular":{"u":"rawResponse_loggedInUser_memberOfSingular"},"loggedInUser_memberOf":{"u":"rawResponse_loggedInUser_memberOf"}}}`
  )
  @live
  let rawResponseConverterMap = {
    "rawResponse_loggedInUser_memberOf_Group_topMember": unwrap_rawResponse_loggedInUser_memberOf_Group_topMember,
    "rawResponse_loggedInUser_memberOf": unwrap_rawResponse_loggedInUser_memberOf,
    "rawResponse_loggedInUser_memberOfSingular": unwrap_rawResponse_loggedInUser_memberOfSingular,
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
  @live @obj external makeVariables: unit => unit = ""
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
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
  "name": "name",
  "storageKey": null
},
v4 = {
  "kind": "InlineFragment",
  "selections": [
    (v1/*: any*/)
  ],
  "type": "User",
  "abstractKey": null
},
v5 = {
  "kind": "InlineFragment",
  "selections": [
    (v0/*: any*/)
  ],
  "type": "Node",
  "abstractKey": "__isNode"
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestLocalPayloadQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          (v0/*: any*/),
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestLocalPayload_user"
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
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestLocalPayloadQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          (v0/*: any*/),
          (v1/*: any*/),
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
                  (v3/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": null,
                    "kind": "LinkedField",
                    "name": "topMember",
                    "plural": false,
                    "selections": [
                      (v2/*: any*/),
                      (v4/*: any*/),
                      (v5/*: any*/)
                    ],
                    "storageKey": null
                  }
                ],
                "type": "Group",
                "abstractKey": null
              },
              (v4/*: any*/),
              (v5/*: any*/)
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
                  (v3/*: any*/)
                ],
                "type": "Group",
                "abstractKey": null
              },
              (v4/*: any*/),
              (v5/*: any*/)
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "13836acffb145d26329fed1cbe1943e9",
    "id": null,
    "metadata": {},
    "name": "TestLocalPayloadQuery",
    "operationKind": "query",
    "text": "query TestLocalPayloadQuery {\n  loggedInUser {\n    id\n    ...TestLocalPayload_user\n  }\n}\n\nfragment TestLocalPayload_user on User {\n  firstName\n  avatarUrl\n  onlineStatus\n  memberOf {\n    __typename\n    ... on Group {\n      name\n      topMember {\n        __typename\n        ... on User {\n          firstName\n        }\n        ... on Node {\n          __typename\n          __isNode: __typename\n          id\n        }\n      }\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __typename\n      __isNode: __typename\n      id\n    }\n  }\n  memberOfSingular {\n    __typename\n    ... on Group {\n      name\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __typename\n      __isNode: __typename\n      id\n    }\n  }\n}\n"
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
