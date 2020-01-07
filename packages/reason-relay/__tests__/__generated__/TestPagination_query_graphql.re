/* @generated */

module Union_fragment_members_edges_node: {
  type wrapped;
  type user_friendsConnection = {totalCount: int};
  type user = {
    friendsConnection: user_friendsConnection,
    firstName: string,
    id: string,
  };
  type group_node = {
    id: string,
    firstName: string,
  };
  type group_edges = {node: option(group_node)};
  type group_adminsConnection = {
    edges: option(array(option(group_edges))),
  };
  type group = {
    adminsConnection: group_adminsConnection,
    name: string,
    id: string,
  };
  type t = [ | `User(user) | `Group(group) | `UnmappedUnionMember];
  let unwrap: wrapped => t;
} = {
  type wrapped;
  type user_friendsConnection = {totalCount: int};
  type user = {
    friendsConnection: user_friendsConnection,
    firstName: string,
    id: string,
  };
  type group_node = {
    id: string,
    firstName: string,
  };
  type group_edges = {node: option(group_node)};
  type group_adminsConnection = {
    edges: option(array(option(group_edges))),
  };
  type group = {
    adminsConnection: group_adminsConnection,
    name: string,
    id: string,
  };
  external __unwrap_union: wrapped => {. "__typename": string} = "%identity";
  type t = [ | `User(user) | `Group(group) | `UnmappedUnionMember];
  external __unwrap_user: wrapped => user = "%identity";
  external __unwrap_group: wrapped => group = "%identity";
  let unwrap = wrapped => {
    let unwrappedUnion = wrapped |> __unwrap_union;
    switch (unwrappedUnion##__typename) {
    | "User" => `User(wrapped |> __unwrap_user)
    | "Group" => `Group(wrapped |> __unwrap_group)
    | _ => `UnmappedUnionMember
    };
  };
};
module Types = {
  type edges = {node: option(Union_fragment_members_edges_node.t)};
  type members = {edges: option(array(option(edges)))};
};

open Types;

type fragment = {members: option(members)};

module FragmentConverters: {} = {};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"members":[[0,""]],"members_edges":[[0,""],[1,""]],"members_edges_node":[[0,""],[3,"fragment_members_edges_node"]]} |}
  ];
  let fragmentConverterMap = {
    "fragment_members_edges_node": Union_fragment_members_edges_node.unwrap,
  };
  let convertFragment = v =>
    v
    ->ReasonRelay._convertObj(
        fragmentConverter,
        fragmentConverterMap,
        Js.undefined,
      );
};

type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__TestPagination_query": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  "members"
],
v1 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "firstName",
  "args": null,
  "storageKey": null
},
v3 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1
  }
];
return {
  "kind": "Fragment",
  "name": "TestPagination_query",
  "type": "Query",
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
      "operation": require('./TestPaginationRefetchQuery_graphql.bs.js').node,
      "fragmentPathInResult": []
    }
  },
  "argumentDefinitions": [
    {
      "kind": "LocalArgument",
      "name": "groupId",
      "type": "ID!",
      "defaultValue": null
    },
    {
      "kind": "LocalArgument",
      "name": "onlineStatuses",
      "type": "[OnlineStatus!]",
      "defaultValue": null
    },
    {
      "kind": "LocalArgument",
      "name": "count",
      "type": "Int",
      "defaultValue": 2
    },
    {
      "kind": "LocalArgument",
      "name": "cursor",
      "type": "String",
      "defaultValue": ""
    }
  ],
  "selections": [
    {
      "kind": "LinkedField",
      "alias": "members",
      "name": "__TestPagination_query_members_connection",
      "storageKey": null,
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
      "plural": false,
      "selections": [
        {
          "kind": "LinkedField",
          "alias": null,
          "name": "edges",
          "storageKey": null,
          "args": null,
          "concreteType": "MemberEdge",
          "plural": true,
          "selections": [
            {
              "kind": "LinkedField",
              "alias": null,
              "name": "node",
              "storageKey": null,
              "args": null,
              "concreteType": null,
              "plural": false,
              "selections": [
                {
                  "kind": "ScalarField",
                  "alias": null,
                  "name": "__typename",
                  "args": null,
                  "storageKey": null
                },
                {
                  "kind": "InlineFragment",
                  "type": "User",
                  "selections": [
                    (v1/*: any*/),
                    (v2/*: any*/),
                    {
                      "kind": "LinkedField",
                      "alias": null,
                      "name": "friendsConnection",
                      "storageKey": "friendsConnection(first:1)",
                      "args": (v3/*: any*/),
                      "concreteType": "UserConnection",
                      "plural": false,
                      "selections": [
                        {
                          "kind": "ScalarField",
                          "alias": null,
                          "name": "totalCount",
                          "args": null,
                          "storageKey": null
                        }
                      ]
                    }
                  ]
                },
                {
                  "kind": "InlineFragment",
                  "type": "Group",
                  "selections": [
                    (v1/*: any*/),
                    {
                      "kind": "ScalarField",
                      "alias": null,
                      "name": "name",
                      "args": null,
                      "storageKey": null
                    },
                    {
                      "kind": "LinkedField",
                      "alias": null,
                      "name": "adminsConnection",
                      "storageKey": "adminsConnection(first:1)",
                      "args": (v3/*: any*/),
                      "concreteType": "UserConnection",
                      "plural": false,
                      "selections": [
                        {
                          "kind": "LinkedField",
                          "alias": null,
                          "name": "edges",
                          "storageKey": null,
                          "args": null,
                          "concreteType": "UserEdge",
                          "plural": true,
                          "selections": [
                            {
                              "kind": "LinkedField",
                              "alias": null,
                              "name": "node",
                              "storageKey": null,
                              "args": null,
                              "concreteType": "User",
                              "plural": false,
                              "selections": [
                                (v1/*: any*/),
                                (v2/*: any*/)
                              ]
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "cursor",
              "args": null,
              "storageKey": null
            }
          ]
        },
        {
          "kind": "LinkedField",
          "alias": null,
          "name": "pageInfo",
          "storageKey": null,
          "args": null,
          "concreteType": "PageInfo",
          "plural": false,
          "selections": [
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "endCursor",
              "args": null,
              "storageKey": null
            },
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "hasNextPage",
              "args": null,
              "storageKey": null
            }
          ]
        },
        {
          "kind": "ClientExtension",
          "selections": [
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "__$generated__connection__key__$$__TestPagination_query_members$$$name__$$__members",
              "args": null,
              "storageKey": null
            }
          ]
        }
      ]
    }
  ]
};
})() |}
];
