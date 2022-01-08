/* @sourceLoc Test_unions.res */
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



  type rec response_members_edges_node_User = {
    @live __typename: [ | #User],
    @live id: string,
    firstName: string,
    onlineStatus: option<enum_OnlineStatus>,
  }
  and response_members_edges_node_Group_members_User = {
    @live __typename: [ | #User],
    @live id: string,
    firstName: string,
    onlineStatus: option<enum_OnlineStatus>,
  }
  and response_members_edges_node_Group_members_Group = {
    @live __typename: [ | #Group],
    @live id: string,
    name: string,
    avatarUrl: option<string>,
  }
  and response_members_edges_node_Group = {
    @live __typename: [ | #Group],
    @live id: string,
    name: string,
    avatarUrl: option<string>,
    members: option<array<option<response_members_edges_node_Group_members>>>,
  }
  and response_members_edges_node_Group_members = [
    | #User(response_members_edges_node_Group_members_User)
    | #Group(response_members_edges_node_Group_members_Group)
    | #UnselectedUnionMember(string)
  ]

  and response_members_edges_node = [
    | #User(response_members_edges_node_User)
    | #Group(response_members_edges_node_Group)
    | #UnselectedUnionMember(string)
  ]

  type rec response_members_edges = {
    node: option<response_members_edges_node>,
  }
  and response_members = {
    edges: option<array<option<response_members_edges>>>,
  }
  type response = {
    members: option<response_members>,
  }
  type rawResponse = response
  type variables = unit
  type refetchVariables = unit
  @live let makeRefetchVariables = () => ()
}

@live
let unwrap_response_members_edges_node_Group_members: {. "__typename": string } => [
  | #User(Types.response_members_edges_node_Group_members_User)
  | #Group(Types.response_members_edges_node_Group_members_Group)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | "Group" => #Group(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_response_members_edges_node_Group_members: [
  | #User(Types.response_members_edges_node_Group_members_User)
  | #Group(Types.response_members_edges_node_Group_members_Group)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #Group(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
@live
let unwrap_response_members_edges_node: {. "__typename": string } => [
  | #User(Types.response_members_edges_node_User)
  | #Group(Types.response_members_edges_node_Group)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | "Group" => #Group(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_response_members_edges_node: [
  | #User(Types.response_members_edges_node_User)
  | #Group(Types.response_members_edges_node_Group)
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
    json`{"__root":{"members_edges_node_Group_members":{"u":"response_members_edges_node_Group_members"},"members_edges_node":{"u":"response_members_edges_node"}}}`
  )
  @live
  let wrapResponseConverterMap = {
    "response_members_edges_node_Group_members": wrap_response_members_edges_node_Group_members,
    "response_members_edges_node": wrap_response_members_edges_node,
  }
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
    json`{"__root":{"members_edges_node_Group_members":{"u":"response_members_edges_node_Group_members"},"members_edges_node":{"u":"response_members_edges_node"}}}`
  )
  @live
  let responseConverterMap = {
    "response_members_edges_node_Group_members": unwrap_response_members_edges_node_Group_members,
    "response_members_edges_node": unwrap_response_members_edges_node,
  }
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
  @live let makeVariables = () => ()
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "kind": "Literal",
    "name": "groupId",
    "value": "123"
  }
],
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v3 = {
  "kind": "InlineFragment",
  "selections": [
    (v2/*: any*/),
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
      "name": "onlineStatus",
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "name",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "avatarUrl",
  "storageKey": null
},
v6 = {
  "kind": "InlineFragment",
  "selections": [
    (v2/*: any*/),
    (v4/*: any*/),
    (v5/*: any*/)
  ],
  "type": "Group",
  "abstractKey": null
},
v7 = {
  "kind": "InlineFragment",
  "selections": [
    (v2/*: any*/)
  ],
  "type": "Node",
  "abstractKey": "__isNode"
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestUnionsQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": "MemberConnection",
        "kind": "LinkedField",
        "name": "members",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "MemberEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": null,
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v1/*: any*/),
                  (v3/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v2/*: any*/),
                      (v4/*: any*/),
                      (v5/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": null,
                        "kind": "LinkedField",
                        "name": "members",
                        "plural": true,
                        "selections": [
                          (v1/*: any*/),
                          (v3/*: any*/),
                          (v6/*: any*/)
                        ],
                        "storageKey": null
                      }
                    ],
                    "type": "Group",
                    "abstractKey": null
                  }
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": "members(groupId:\"123\")"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestUnionsQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": "MemberConnection",
        "kind": "LinkedField",
        "name": "members",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "MemberEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": null,
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v1/*: any*/),
                  (v3/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v2/*: any*/),
                      (v4/*: any*/),
                      (v5/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": null,
                        "kind": "LinkedField",
                        "name": "members",
                        "plural": true,
                        "selections": [
                          (v1/*: any*/),
                          (v3/*: any*/),
                          (v6/*: any*/),
                          (v7/*: any*/)
                        ],
                        "storageKey": null
                      }
                    ],
                    "type": "Group",
                    "abstractKey": null
                  },
                  (v7/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": "members(groupId:\"123\")"
      }
    ]
  },
  "params": {
    "cacheID": "ef07d7c3ba511ea77cb718a12a4094da",
    "id": null,
    "metadata": {},
    "name": "TestUnionsQuery",
    "operationKind": "query",
    "text": "query TestUnionsQuery {\n  members(groupId: \"123\") {\n    edges {\n      node {\n        __typename\n        ... on User {\n          id\n          firstName\n          onlineStatus\n        }\n        ... on Group {\n          id\n          name\n          avatarUrl\n          members {\n            __typename\n            ... on User {\n              id\n              firstName\n              onlineStatus\n            }\n            ... on Group {\n              id\n              name\n              avatarUrl\n            }\n            ... on Node {\n              __typename\n              __isNode: __typename\n              id\n            }\n          }\n        }\n        ... on Node {\n          __typename\n          __isNode: __typename\n          id\n        }\n      }\n    }\n  }\n}\n"
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
