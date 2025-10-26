/* @sourceLoc Test_localPayload.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type response_node = 
    | @live User(
      {
        fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestLocalPayload_user]>,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node_User_memberOf_Group_topMember = 
    | @live User(
      {
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node_User_memberOf = 
    | @live Group(
      {
        __isNode: [ | #Group],
        @live id: string,
        name: string,
        topMember: option<rawResponse_node_User_memberOf_Group_topMember>,
      }
    )
    | @live User(
      {
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node_User_memberOfSingular = 
    | @live Group(
      {
        __isNode: [ | #Group],
        @live id: string,
        name: string,
      }
    )
    | @live User(
      {
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_node = 
    | @live User(
      {
        avatarUrl: option<string>,
        firstName: string,
        @live id: string,
        memberOf: option<array<option<rawResponse_node_User_memberOf>>>,
        memberOfSingular: option<rawResponse_node_User_memberOfSingular>,
        onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

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

type queryRef

module Internal = {
  @live
  let variablesConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    None
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: dict<dict<dict<string>>> = %raw(
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
    null
  )
  @live
  type responseRaw
  @live
  let responseConverter: dict<dict<dict<string>>> = %raw(
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
    None
  )
  @live
  type wrapRawResponseRaw
  @live
  let wrapRawResponseConverter: dict<dict<dict<string>>> = %raw(
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
    null
  )
  @live
  type rawResponseRaw
  @live
  let rawResponseConverter: dict<dict<dict<string>>> = %raw(
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
    None
  )
  type rawPreloadToken<'response> = {source: Nullable.t<RescriptRelay.Observable.t<'response>>}
  external tokenToRaw: queryRef => rawPreloadToken<Types.response> = "%identity"
}
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

@live let load: (
  ~environment: RescriptRelay.Environment.t,
  ~variables: Types.variables,
  ~fetchPolicy: RescriptRelay.fetchPolicy=?,
  ~fetchKey: string=?,
  ~networkCacheConfig: RescriptRelay.cacheConfig=?,
) => queryRef = (
  ~environment,
  ~variables,
  ~fetchPolicy=?,
  ~fetchKey=?,
  ~networkCacheConfig=?,
) =>
  RescriptRelay.loadQuery(
    environment,
    node,
    variables->Internal.convertVariables,
    {
      fetchKey,
      fetchPolicy,
      networkCacheConfig,
    },
  )

@live
let queryRefToObservable = token => {
  let raw = token->Internal.tokenToRaw
  raw.source->Nullable.toOption
}
  
@live
let queryRefToPromise = token => {
  Promise.make((resolve, _reject) => {
    switch token->queryRefToObservable {
    | None => resolve(Error())
    | Some(o) =>
      open RescriptRelay.Observable
      let _: subscription = o->subscribe(makeObserver(~complete=() => resolve(Ok())))
    }
  })
}
