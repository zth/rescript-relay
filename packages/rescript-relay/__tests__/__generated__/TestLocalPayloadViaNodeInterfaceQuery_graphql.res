/* @sourceLoc Test_localPayload.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type response_node = 
    | User(
      {
        @live __typename: [ | #User],
        fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestLocalPayload_user]>,
      }
    )
    | @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node_User_memberOf_Group_topMember = 
    | User(
      {
        @live __typename: [ | #User],
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node_User_memberOf = 
    | Group(
      {
        @live __typename: [ | #Group],
        __isNode: [ | #Group],
        @live id: string,
        name: string,
        topMember: option<rawResponse_node_User_memberOf_Group_topMember>,
      }
    )
    | User(
      {
        @live __typename: [ | #User],
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node_User_memberOfSingular = 
    | Group(
      {
        @live __typename: [ | #Group],
        __isNode: [ | #Group],
        @live id: string,
        name: string,
      }
    )
    | User(
      {
        @live __typename: [ | #User],
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node = 
    | User(
      {
        @live __typename: [ | #User],
        avatarUrl: option<string>,
        firstName: string,
        @live id: string,
        memberOf: option<array<option<rawResponse_node_User_memberOf>>>,
        memberOfSingular: option<rawResponse_node_User_memberOfSingular>,
        onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
      }
    )
    | @as("__unselected") UnselectedUnionMember(string)

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
  ): refetchVariables => {
    id: id
  }

}

@live
let unwrap_response_node: Types.response_node => Types.response_node = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_response_node: Types.response_node => Types.response_node = RescriptRelay_Internal.wrapUnion
@live
let unwrap_rawResponse_node_User_memberOf_Group_topMember: Types.rawResponse_node_User_memberOf_Group_topMember => Types.rawResponse_node_User_memberOf_Group_topMember = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_rawResponse_node_User_memberOf_Group_topMember: Types.rawResponse_node_User_memberOf_Group_topMember => Types.rawResponse_node_User_memberOf_Group_topMember = RescriptRelay_Internal.wrapUnion
@live
let unwrap_rawResponse_node_User_memberOf: Types.rawResponse_node_User_memberOf => Types.rawResponse_node_User_memberOf = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_rawResponse_node_User_memberOf: Types.rawResponse_node_User_memberOf => Types.rawResponse_node_User_memberOf = RescriptRelay_Internal.wrapUnion
@live
let unwrap_rawResponse_node_User_memberOfSingular: Types.rawResponse_node_User_memberOfSingular => Types.rawResponse_node_User_memberOfSingular = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_rawResponse_node_User_memberOfSingular: Types.rawResponse_node_User_memberOfSingular => Types.rawResponse_node_User_memberOfSingular = RescriptRelay_Internal.wrapUnion
@live
let unwrap_rawResponse_node: Types.rawResponse_node => Types.rawResponse_node = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_rawResponse_node: Types.rawResponse_node => Types.rawResponse_node = RescriptRelay_Internal.wrapUnion
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
    json`{"__root":{"node_User":{"f":""},"node":{"u":"response_node"}}}`
  )
  @live
  let wrapResponseConverterMap = {
    "response_node": wrap_response_node,
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
    json`{"__root":{"node_User":{"f":""},"node":{"u":"response_node"}}}`
  )
  @live
  let responseConverterMap = {
    "response_node": unwrap_response_node,
  }
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
    json`{"__root":{"node_User_memberOf_Group_topMember":{"u":"rawResponse_node_User_memberOf_Group_topMember"},"node_User_memberOfSingular":{"u":"rawResponse_node_User_memberOfSingular"},"node_User_memberOf":{"u":"rawResponse_node_User_memberOf"},"node":{"u":"rawResponse_node"}}}`
  )
  @live
  let wrapRawResponseConverterMap = {
    "rawResponse_node_User_memberOf_Group_topMember": wrap_rawResponse_node_User_memberOf_Group_topMember,
    "rawResponse_node_User_memberOf": wrap_rawResponse_node_User_memberOf,
    "rawResponse_node_User_memberOfSingular": wrap_rawResponse_node_User_memberOfSingular,
    "rawResponse_node": wrap_rawResponse_node,
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
    json`{"__root":{"node_User_memberOf_Group_topMember":{"u":"rawResponse_node_User_memberOf_Group_topMember"},"node_User_memberOfSingular":{"u":"rawResponse_node_User_memberOfSingular"},"node_User_memberOf":{"u":"rawResponse_node_User_memberOf"},"node":{"u":"rawResponse_node"}}}`
  )
  @live
  let rawResponseConverterMap = {
    "rawResponse_node_User_memberOf_Group_topMember": unwrap_rawResponse_node_User_memberOf_Group_topMember,
    "rawResponse_node_User_memberOf": unwrap_rawResponse_node_User_memberOf,
    "rawResponse_node_User_memberOfSingular": unwrap_rawResponse_node_User_memberOfSingular,
    "rawResponse_node": unwrap_rawResponse_node,
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
    "cacheID": "b9ac102e28a8770beecf8ef2afeb2211",
    "id": null,
    "metadata": {},
    "name": "TestLocalPayloadViaNodeInterfaceQuery",
    "operationKind": "query",
    "text": "query TestLocalPayloadViaNodeInterfaceQuery(\n  $id: ID!\n) {\n  node(id: $id) {\n    __typename\n    ... on User {\n      ...TestLocalPayload_user\n    }\n    id\n  }\n}\n\nfragment TestLocalPayload_user on User {\n  firstName\n  avatarUrl\n  onlineStatus\n  memberOf {\n    __typename\n    ... on Group {\n      name\n      topMember {\n        __typename\n        ... on User {\n          firstName\n        }\n        ... on Node {\n          __isNode: __typename\n          __typename\n          id\n        }\n      }\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __isNode: __typename\n      __typename\n      id\n    }\n  }\n  memberOfSingular {\n    __typename\n    ... on Group {\n      name\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __isNode: __typename\n      __typename\n      id\n    }\n  }\n}\n"
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
