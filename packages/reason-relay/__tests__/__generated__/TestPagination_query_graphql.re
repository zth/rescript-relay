/* @generated */

module Types = {
  type fragment_members_edges_node_User = {
    getFragmentRef_TestPagination_user: unit => TestPagination_user_graphql.t,
    id: string,
  };
  type fragment_members_edges_node_Group_adminsConnection_edges_node = {
    id: string,
    firstName: string,
  };
  type fragment_members_edges_node_Group_adminsConnection_edges = {
    node:
      option(fragment_members_edges_node_Group_adminsConnection_edges_node),
  };
  type fragment_members_edges_node_Group_adminsConnection = {
    edges:
      option(
        array(
          option(fragment_members_edges_node_Group_adminsConnection_edges),
        ),
      ),
  };
  type fragment_members_edges_node_Group = {
    adminsConnection: fragment_members_edges_node_Group_adminsConnection,
    name: string,
    id: string,
  };
  type fragment_members_edges_node = [
    | `User(fragment_members_edges_node_User)
    | `Group(fragment_members_edges_node_Group)
    | `UnselectedUnionMember(string)
  ];
  type fragment_members_edges = {
    node:
      option(
        [
          | `User(fragment_members_edges_node_User)
          | `Group(fragment_members_edges_node_Group)
          | `UnselectedUnionMember(string)
        ],
      ),
  };
  type fragment_members = {
    edges: option(array(option(fragment_members_edges))),
  };

  type fragment = {members: option(fragment_members)};
};

let unwrap_fragment_members_edges_node:
  {. "__typename": string} =>
  [
    | `User(Types.fragment_members_edges_node_User)
    | `Group(Types.fragment_members_edges_node_Group)
    | `UnselectedUnionMember(string)
  ] =
  u =>
    switch (u##__typename) {
    | "User" => `User(u->Obj.magic)
    | "Group" => `Group(u->Obj.magic)
    | v => `UnselectedUnionMember(v)
    };

let wrap_fragment_members_edges_node:
  [
    | `User(Types.fragment_members_edges_node_User)
    | `Group(Types.fragment_members_edges_node_Group)
    | `UnselectedUnionMember(string)
  ] =>
  {. "__typename": string} =
  fun
  | `User(v) => v->Obj.magic
  | `Group(v) => v->Obj.magic
  | `UnselectedUnionMember(v) => {"__typename": v};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"members":{"n":""},"members_edges":{"n":"","na":""},"members_edges_node":{"n":"","u":"fragment_members_edges_node"},"members_edges_node_user":{"f":"TestPagination_user"},"members_edges_node_group_adminsConnection_edges":{"n":"","na":""},"members_edges_node_group_adminsConnection_edges_node":{"n":""}}} |json}
  ];
  let fragmentConverterMap = {
    "fragment_members_edges_node": unwrap_fragment_members_edges_node,
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
type fragmentRef = t;

module Utils = {
  open Types;
  let getConnectionNodes_members:
    option(fragment_members) => array(fragment_members_edges_node) =
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

let node: operationType = [%raw
  {json| (function(){
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
})() |json}
];
