/* @generated */

module Unions = {
  module Union_fragment_members_edges_node: {
    type wrapped;
    type fragment_members_edges_node_user = {
      id: string,
      getFragmentRefs:
        unit =>
        {
          .
          "__$fragment_ref__TestPagination_user": TestPagination_user_graphql.t,
        },
    };
    type user = fragment_members_edges_node_user;
    type fragment_members_edges_node_group_adminsConnection_edges_node = {
      id: string,
      firstName: string,
    };
    type fragment_members_edges_node_group_adminsConnection_edges = {
      node:
        option(fragment_members_edges_node_group_adminsConnection_edges_node),
    };
    type fragment_members_edges_node_group_adminsConnection = {
      edges:
        option(
          array(
            option(fragment_members_edges_node_group_adminsConnection_edges),
          ),
        ),
    };
    type fragment_members_edges_node_group = {
      adminsConnection: fragment_members_edges_node_group_adminsConnection,
      name: string,
      id: string,
    };
    type group = fragment_members_edges_node_group;
    type t = [
      | `User(user)
      | `Group(group)
      | `UnselectedUnionMember(string)
    ];
    let unwrap: wrapped => t;
  } = {
    type wrapped;
    type fragment_members_edges_node_user = {
      id: string,
      getFragmentRefs:
        unit =>
        {
          .
          "__$fragment_ref__TestPagination_user": TestPagination_user_graphql.t,
        },
    };
    type user = fragment_members_edges_node_user;
    type fragment_members_edges_node_group_adminsConnection_edges_node = {
      id: string,
      firstName: string,
    };
    type fragment_members_edges_node_group_adminsConnection_edges = {
      node:
        option(fragment_members_edges_node_group_adminsConnection_edges_node),
    };
    type fragment_members_edges_node_group_adminsConnection = {
      edges:
        option(
          array(
            option(fragment_members_edges_node_group_adminsConnection_edges),
          ),
        ),
    };
    type fragment_members_edges_node_group = {
      adminsConnection: fragment_members_edges_node_group_adminsConnection,
      name: string,
      id: string,
    };
    type group = fragment_members_edges_node_group;
    external __unwrap_union: wrapped => {. "__typename": string} =
      "%identity";
    type t = [
      | `User(user)
      | `Group(group)
      | `UnselectedUnionMember(string)
    ];
    external __unwrap_user: wrapped => user = "%identity";
    external __unwrap_group: wrapped => group = "%identity";
    external __toJson: wrapped => Js.Json.t = "%identity";
    let unwrap = wrapped => {
      let unwrappedUnion = wrapped |> __unwrap_union;
      switch (unwrappedUnion##__typename) {
      | "User" => `User(wrapped |> __unwrap_user)
      | "Group" => `Group(wrapped |> __unwrap_group)
      | typename => `UnselectedUnionMember(typename)
      };
    };
  };

  type union_fragment_members_edges_node = [
    | `User(Union_fragment_members_edges_node.user)
    | `Group(Union_fragment_members_edges_node.group)
    | `UnselectedUnionMember(string)
  ];
};

open Unions;

module Types = {
  type members_edges = {node: option(union_fragment_members_edges_node)};
  type members = {edges: option(array(option(members_edges)))};
};

open Types;

type fragment = {members: option(members)};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"members":{"n":""},"members_edges":{"n":"","na":""},"members_edges_node":{"n":"","u":"fragment_members_edges_node"},"members_edges_node_user":{"f":""},"members_edges_node_group_adminsConnection_edges":{"n":"","na":""},"members_edges_node_group_adminsConnection_edges_node":{"n":""}}} |}
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

module Utils = {
  let getConnectionNodes_members:
    option(members) => array(union_fragment_members_edges_node) =
    connection =>
      switch (connection) {
      | None => [||]
      | Some(connection) =>
        switch (connection.edges) {
        | None => [||]
        | Some(edges) =>
          edges
          ->Belt.Array.keepMap(edge =>
              switch (edge) {
              | None => None
              | Some(edge) =>
                switch (edge.node) {
                | None => None
                | Some(node) => Some(node)
                }
              }
            )
        }
      };
};

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
};
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
                    {
                      "kind": "FragmentSpread",
                      "name": "TestPagination_user",
                      "args": null
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
                      "args": [
                        {
                          "kind": "Literal",
                          "name": "first",
                          "value": 1
                        }
                      ],
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
                                {
                                  "kind": "ScalarField",
                                  "alias": null,
                                  "name": "firstName",
                                  "args": null,
                                  "storageKey": null
                                }
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
        }
      ]
    }
  ]
};
})() |}
];
