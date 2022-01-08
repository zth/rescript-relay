/* @sourceLoc Test_paginationUnion.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type rec fragment_members_edges_node_User = {
    @live __typename: [ | #User],
    @live id: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestPaginationUnion_user]>,
  }
  and fragment_members_edges_node_Group_adminsConnection_edges_node = {
    @live id: string,
    firstName: string,
  }
  and fragment_members_edges_node_Group_adminsConnection_edges = {
    node: option<fragment_members_edges_node_Group_adminsConnection_edges_node>,
  }
  and fragment_members_edges_node_Group_adminsConnection = {
    edges: option<array<option<fragment_members_edges_node_Group_adminsConnection_edges>>>,
  }
  and fragment_members_edges_node_Group = {
    @live __typename: [ | #Group],
    @live id: string,
    name: string,
    adminsConnection: fragment_members_edges_node_Group_adminsConnection,
  }
  and fragment_members_edges_node = [
    | #User(fragment_members_edges_node_User)
    | #Group(fragment_members_edges_node_Group)
    | #UnselectedUnionMember(string)
  ]

  type rec fragment_members_edges = {
    node: option<fragment_members_edges_node>,
  }
  and fragment_members = {
    edges: option<array<option<fragment_members_edges>>>,
  }
  type fragment = {
    members: option<fragment_members>,
  }
}

@live
let unwrap_fragment_members_edges_node: {. "__typename": string } => [
  | #User(Types.fragment_members_edges_node_User)
  | #Group(Types.fragment_members_edges_node_Group)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | "Group" => #Group(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_fragment_members_edges_node: [
  | #User(Types.fragment_members_edges_node_User)
  | #Group(Types.fragment_members_edges_node_Group)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #Group(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"members_edges_node_User":{"f":""},"members_edges_node":{"u":"fragment_members_edges_node"}}}`
  )
  @live
  let fragmentConverterMap = {
    "fragment_members_edges_node": unwrap_fragment_members_edges_node,
  }
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
  RescriptRelay.fragmentRefs<[> | #TestPaginationUnion_query]> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live
  @inline
  let connectionKey = "TestPaginationUnion_query_members"


  @live
  let getConnectionNodes: option<fragment_members> => array<fragment_members_edges_node> = connection => 
    switch connection {
      | None => []
      | Some(connection) => 
        switch connection.edges {
          | None => []
          | Some(edges) => edges
            ->Belt.Array.keepMap(edge => switch edge {
              | None => None
              | Some(edge) => edge.node
            })
        }
    }

}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (rescript_graphql_node_TestPaginationUnionRefetchQuery): operationType => {
  ignore(rescript_graphql_node_TestPaginationUnionRefetchQuery)
  %raw(json`(function(){
var v0 = [
  "members"
],
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "argumentDefinitions": [
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
      "fragmentPathInResult": [],
      "operation": rescript_graphql_node_TestPaginationUnionRefetchQuery
    }
  },
  "name": "TestPaginationUnion_query",
  "selections": [
    {
      "alias": "members",
      "args": [
        {
          "kind": "Variable",
          "name": "groupId",
          "variableName": "groupId"
        },
        {
          "kind": "Variable",
          "name": "onlineStatuses",
          "variableName": "onlineStatuses"
        }
      ],
      "concreteType": "MemberConnection",
      "kind": "LinkedField",
      "name": "__TestPaginationUnion_query_members_connection",
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
                    (v1/*: any*/),
                    {
                      "args": null,
                      "kind": "FragmentSpread",
                      "name": "TestPaginationUnion_user"
                    }
                  ],
                  "type": "User",
                  "abstractKey": null
                },
                {
                  "kind": "InlineFragment",
                  "selections": [
                    (v1/*: any*/),
                    {
                      "alias": null,
                      "args": null,
                      "kind": "ScalarField",
                      "name": "name",
                      "storageKey": null
                    },
                    {
                      "alias": null,
                      "args": [
                        {
                          "kind": "Literal",
                          "name": "first",
                          "value": 1
                        }
                      ],
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
                                (v1/*: any*/),
                                {
                                  "alias": null,
                                  "args": null,
                                  "kind": "ScalarField",
                                  "name": "firstName",
                                  "storageKey": null
                                }
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
    }
  ],
  "type": "Query",
  "abstractKey": null
};
})()`)
})
let node: operationType = makeNode(TestPaginationUnionRefetchQuery_graphql.node)

