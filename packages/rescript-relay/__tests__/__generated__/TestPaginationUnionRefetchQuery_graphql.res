/* @sourceLoc Test_paginationUnion.res */
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



  type response = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestPaginationUnion_query]>,
  }
  type rawResponse = response
  type variables = {
    count: option<int>,
    cursor: option<string>,
    groupId: string,
    onlineStatuses: option<array<[
      | #Online
      | #Idle
      | #Offline
    ]
>>,
  }
  type refetchVariables = {
    count: option<int>,
    cursor: option<string>,
    groupId: option<string>,
    onlineStatuses: option<array<[
      | #Online
      | #Idle
      | #Offline
    ]
>>,
  }
  let makeRefetchVariables = (
    ~count=?,
    ~cursor=?,
    ~groupId=?,
    ~onlineStatuses=?,
    ()
  ): refetchVariables => {
    count: count,
    cursor: cursor,
    groupId: groupId,
    onlineStatuses: onlineStatuses
  }
}

module Internal = {
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`JSON.parse(\`{}\`)`
  )
  let variablesConverterMap = ()
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  type wrapResponseRaw
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`JSON.parse(\`{"__root":{"":{"f":""}}}\`)`
  )
  let wrapResponseConverterMap = ()
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  type responseRaw
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`JSON.parse(\`{"__root":{"":{"f":""}}}\`)`
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

type queryRef

module Utils = {
  @@ocaml.warning("-33")
  open Types
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  let makeVariables = (
    ~count=?,
    ~cursor=?,
    ~groupId,
    ~onlineStatuses=?,
    ()
  ): variables => {
    count: count,
    cursor: cursor,
    groupId: groupId,
    onlineStatuses: onlineStatuses
  }
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": 2,
    "kind": "LocalArgument",
    "name": "count"
  },
  {
    "defaultValue": "",
    "kind": "LocalArgument",
    "name": "cursor"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "groupId"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "onlineStatuses"
  }
],
v1 = {
  "kind": "Variable",
  "name": "groupId",
  "variableName": "groupId"
},
v2 = {
  "kind": "Variable",
  "name": "onlineStatuses",
  "variableName": "onlineStatuses"
},
v3 = [
  {
    "kind": "Variable",
    "name": "after",
    "variableName": "cursor"
  },
  {
    "kind": "Variable",
    "name": "first",
    "variableName": "count"
  },
  (v1/*: any*/),
  (v2/*: any*/)
],
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v6 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestPaginationUnionRefetchQuery",
    "selections": [
      {
        "args": [
          {
            "kind": "Variable",
            "name": "count",
            "variableName": "count"
          },
          {
            "kind": "Variable",
            "name": "cursor",
            "variableName": "cursor"
          },
          (v1/*: any*/),
          (v2/*: any*/)
        ],
        "kind": "FragmentSpread",
        "name": "TestPaginationUnion_query"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestPaginationUnionRefetchQuery",
    "selections": [
      {
        "alias": null,
        "args": (v3/*: any*/),
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
                      (v4/*: any*/),
                      (v5/*: any*/),
                      {
                        "alias": null,
                        "args": (v6/*: any*/),
                        "concreteType": "UserConnection",
                        "kind": "LinkedField",
                        "name": "friendsConnection",
                        "plural": false,
                        "selections": [
                          {
                            "alias": null,
                            "args": null,
                            "kind": "ScalarField",
                            "name": "totalCount",
                            "storageKey": null
                          }
                        ],
                        "storageKey": "friendsConnection(first:1)"
                      }
                    ],
                    "type": "User",
                    "abstractKey": null
                  },
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v4/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "name",
                        "storageKey": null
                      },
                      {
                        "alias": null,
                        "args": (v6/*: any*/),
                        "concreteType": "UserConnection",
                        "kind": "LinkedField",
                        "name": "adminsConnection",
                        "plural": false,
                        "selections": [
                          {
                            "alias": null,
                            "args": null,
                            "concreteType": "UserEdge",
                            "kind": "LinkedField",
                            "name": "edges",
                            "plural": true,
                            "selections": [
                              {
                                "alias": null,
                                "args": null,
                                "concreteType": "User",
                                "kind": "LinkedField",
                                "name": "node",
                                "plural": false,
                                "selections": [
                                  (v4/*: any*/),
                                  (v5/*: any*/)
                                ],
                                "storageKey": null
                              }
                            ],
                            "storageKey": null
                          }
                        ],
                        "storageKey": "adminsConnection(first:1)"
                      }
                    ],
                    "type": "Group",
                    "abstractKey": null
                  },
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v4/*: any*/)
                    ],
                    "type": "Node",
                    "abstractKey": "__isNode"
                  }
                ],
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "cursor",
                "storageKey": null
              }
            ],
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "concreteType": "PageInfo",
            "kind": "LinkedField",
            "name": "pageInfo",
            "plural": false,
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "endCursor",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "hasNextPage",
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": (v3/*: any*/),
        "filters": [
          "groupId",
          "onlineStatuses"
        ],
        "handle": "connection",
        "key": "TestPaginationUnion_query_members",
        "kind": "LinkedHandle",
        "name": "members"
      }
    ]
  },
  "params": {
    "cacheID": "098b4363e057eb23bd5efbc2062d349e",
    "id": null,
    "metadata": {},
    "name": "TestPaginationUnionRefetchQuery",
    "operationKind": "query",
    "text": "query TestPaginationUnionRefetchQuery(\n  $count: Int = 2\n  $cursor: String = \"\"\n  $groupId: ID!\n  $onlineStatuses: [OnlineStatus!]\n) {\n  ...TestPaginationUnion_query_2z6KWr\n}\n\nfragment TestPaginationUnion_query_2z6KWr on Query {\n  members(groupId: $groupId, onlineStatuses: $onlineStatuses, first: $count, after: $cursor) {\n    edges {\n      node {\n        __typename\n        ... on User {\n          id\n          ...TestPaginationUnion_user\n        }\n        ... on Group {\n          id\n          name\n          adminsConnection(first: 1) {\n            edges {\n              node {\n                id\n                firstName\n              }\n            }\n          }\n        }\n        ... on Node {\n          __typename\n          __isNode: __typename\n          id\n        }\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment TestPaginationUnion_user on User {\n  firstName\n  friendsConnection(first: 1) {\n    totalCount\n  }\n}\n"
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
