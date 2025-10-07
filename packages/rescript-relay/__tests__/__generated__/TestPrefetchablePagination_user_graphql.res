/* @sourceLoc Test_prefetchablePagination.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_friendsConnection_edges = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestPrefetchablePagination_user__edges]>,
  }
  and fragment_friendsConnection_pageInfo = {
    endCursor: option<string>,
    hasNextPage: bool,
  }
  and fragment_friendsConnection = {
    edges: option<array<option<fragment_friendsConnection_edges>>>,
    pageInfo: fragment_friendsConnection_pageInfo,
  }
  type fragment = {
    friendsConnection: fragment_friendsConnection,
    @live id: string,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"friendsConnection_edges":{"f":""}}}`
  )
  @live
  let fragmentConverterMap = ()
  @live
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    Js.undefined
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #TestPrefetchablePagination_user]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (rescript_graphql_node_TestPrefetchablePaginationRefetchQuery, rescript_graphql_node_TestPrefetchablePagination_user__edges): operationType => {
  ignore(rescript_graphql_node_TestPrefetchablePaginationRefetchQuery)
  ignore(rescript_graphql_node_TestPrefetchablePagination_user__edges)
  %raw(json`(function(){
var v0 = [
  "friendsConnection"
];
return {
  "argumentDefinitions": [
    {
      "defaultValue": 2,
      "kind": "LocalArgument",
      "name": "count"
    },
    {
      "defaultValue": null,
      "kind": "LocalArgument",
      "name": "cursor"
    }
  ],
  "kind": "Fragment",
  "metadata": {
    "connection": [
      {
        "count": "count",
        "cursor": "cursor",
        "direction": "forward",
        "path": (v0/*: any*/)
      }
    ],
    "refetch": {
      "connection": {
        "forward": {
          "count": "count",
          "cursor": "cursor"
        },
        "backward": null,
        "path": (v0/*: any*/)
      },
      "fragmentPathInResult": [
        "node"
      ],
      "operation": rescript_graphql_node_TestPrefetchablePaginationRefetchQuery,
      "identifierInfo": {
        "identifierField": "id",
        "identifierQueryVariableName": "id"
      },
      "edgesFragment": rescript_graphql_node_TestPrefetchablePagination_user__edges
    }
  },
  "name": "TestPrefetchablePagination_user",
  "selections": [
    {
      "alias": "friendsConnection",
      "args": null,
      "concreteType": "UserConnection",
      "kind": "LinkedField",
      "name": "__TestPrefetchablePagination_friendsConnection_connection",
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
                }
              ],
              "kind": "FragmentSpread",
              "name": "TestPrefetchablePagination_user__edges"
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
      "args": null,
      "kind": "ScalarField",
      "name": "id",
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
};
})()`)
})
let node: operationType = makeNode(TestPrefetchablePaginationRefetchQuery_graphql.node, TestPrefetchablePagination_user__edges_graphql.node)

