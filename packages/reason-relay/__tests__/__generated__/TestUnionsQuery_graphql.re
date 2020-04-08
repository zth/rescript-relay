/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FutureAddedValue(string)
];

let unwrap_enum_OnlineStatus: string => enum_OnlineStatus =
  fun
  | "Idle" => `Idle
  | "Offline" => `Offline
  | "Online" => `Online
  | v => `FutureAddedValue(v);

let wrap_enum_OnlineStatus: enum_OnlineStatus => string =
  fun
  | `Idle => "Idle"
  | `Offline => "Offline"
  | `Online => "Online"
  | `FutureAddedValue(v) => v;

module Types = {
  type response_members_edges_node_Group_members_User = {
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
    firstName: string,
    id: string,
  };
  type response_members_edges_node_Group_members_Group = {
    avatarUrl: option(string),
    name: string,
    id: string,
  };
  type response_members_edges_node_Group_members = [
    | `User(response_members_edges_node_Group_members_User)
    | `Group(response_members_edges_node_Group_members_Group)
    | `UnselectedUnionMember(string)
  ];
  type response_members_edges_node_User = {
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
    firstName: string,
    id: string,
  };
  type response_members_edges_node_Group = {
    members:
      option(
        array(
          option(
            [
              | `User(response_members_edges_node_Group_members_User)
              | `Group(response_members_edges_node_Group_members_Group)
              | `UnselectedUnionMember(string)
            ],
          ),
        ),
      ),
    avatarUrl: option(string),
    name: string,
    id: string,
  };
  type response_members_edges_node = [
    | `User(response_members_edges_node_User)
    | `Group(response_members_edges_node_Group)
    | `UnselectedUnionMember(string)
  ];
  type response_members_edges = {
    node:
      option(
        [
          | `User(response_members_edges_node_User)
          | `Group(response_members_edges_node_Group)
          | `UnselectedUnionMember(string)
        ],
      ),
  };
  type response_members = {
    edges: option(array(option(response_members_edges))),
  };

  type response = {members: option(response_members)};
  type variables = unit;
};

let unwrap_response_members_edges_node_Group_members:
  {. "__typename": string} =>
  [
    | `User(Types.response_members_edges_node_Group_members_User)
    | `Group(Types.response_members_edges_node_Group_members_Group)
    | `UnselectedUnionMember(string)
  ] =
  u =>
    switch (u##__typename) {
    | "User" => `User(u->Obj.magic)
    | "Group" => `Group(u->Obj.magic)
    | v => `UnselectedUnionMember(v)
    };

let wrap_response_members_edges_node_Group_members:
  [
    | `User(Types.response_members_edges_node_Group_members_User)
    | `Group(Types.response_members_edges_node_Group_members_Group)
    | `UnselectedUnionMember(string)
  ] =>
  {. "__typename": string} =
  fun
  | `User(v) => v->Obj.magic
  | `Group(v) => v->Obj.magic
  | `UnselectedUnionMember(v) => {"__typename": v};

let unwrap_response_members_edges_node:
  {. "__typename": string} =>
  [
    | `User(Types.response_members_edges_node_User)
    | `Group(Types.response_members_edges_node_Group)
    | `UnselectedUnionMember(string)
  ] =
  u =>
    switch (u##__typename) {
    | "User" => `User(u->Obj.magic)
    | "Group" => `Group(u->Obj.magic)
    | v => `UnselectedUnionMember(v)
    };

let wrap_response_members_edges_node:
  [
    | `User(Types.response_members_edges_node_User)
    | `Group(Types.response_members_edges_node_Group)
    | `UnselectedUnionMember(string)
  ] =>
  {. "__typename": string} =
  fun
  | `User(v) => v->Obj.magic
  | `Group(v) => v->Obj.magic
  | `UnselectedUnionMember(v) => {"__typename": v};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"members":{"n":""},"members_edges":{"n":"","na":""},"members_edges_node":{"n":"","u":"response_members_edges_node"},"members_edges_node_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"},"members_edges_node_group_members":{"n":"","na":"","u":"response_members_edges_node_Group_members"},"members_edges_node_group_members_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"},"members_edges_node_group_members_group_avatarUrl":{"n":""},"members_edges_node_group_avatarUrl":{"n":""}}} |}
  ];
  let responseConverterMap = {
    "response_members_edges_node": unwrap_response_members_edges_node,
    "enum_OnlineStatus": unwrap_enum_OnlineStatus,
    "response_members_edges_node_Group_members": unwrap_response_members_edges_node_Group_members,
  };
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {} |}
  ];
  let variablesConverterMap = ();
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

module Utils = {};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "Literal",
    "name": "groupId",
    "value": "123"
  }
],
v1 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "__typename",
  "args": null,
  "storageKey": null
},
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v3 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "firstName",
  "args": null,
  "storageKey": null
},
v4 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "onlineStatus",
  "args": null,
  "storageKey": null
},
v5 = {
  "kind": "InlineFragment",
  "type": "User",
  "selections": [
    (v2/*: any*/),
    (v3/*: any*/),
    (v4/*: any*/)
  ]
},
v6 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "name",
  "args": null,
  "storageKey": null
},
v7 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "avatarUrl",
  "args": null,
  "storageKey": null
},
v8 = {
  "kind": "InlineFragment",
  "type": "User",
  "selections": [
    (v3/*: any*/),
    (v4/*: any*/)
  ]
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestUnionsQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "members",
        "storageKey": "members(groupId:\"123\")",
        "args": (v0/*: any*/),
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
                  (v1/*: any*/),
                  (v5/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "type": "Group",
                    "selections": [
                      (v2/*: any*/),
                      (v6/*: any*/),
                      (v7/*: any*/),
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "members",
                        "storageKey": null,
                        "args": null,
                        "concreteType": null,
                        "plural": true,
                        "selections": [
                          (v1/*: any*/),
                          (v5/*: any*/),
                          {
                            "kind": "InlineFragment",
                            "type": "Group",
                            "selections": [
                              (v2/*: any*/),
                              (v6/*: any*/),
                              (v7/*: any*/)
                            ]
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
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestUnionsQuery",
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "members",
        "storageKey": "members(groupId:\"123\")",
        "args": (v0/*: any*/),
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
                  (v1/*: any*/),
                  (v2/*: any*/),
                  (v8/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "type": "Group",
                    "selections": [
                      (v6/*: any*/),
                      (v7/*: any*/),
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "members",
                        "storageKey": null,
                        "args": null,
                        "concreteType": null,
                        "plural": true,
                        "selections": [
                          (v1/*: any*/),
                          (v2/*: any*/),
                          (v8/*: any*/),
                          {
                            "kind": "InlineFragment",
                            "type": "Group",
                            "selections": [
                              (v6/*: any*/),
                              (v7/*: any*/)
                            ]
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
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "TestUnionsQuery",
    "id": null,
    "text": "query TestUnionsQuery {\n  members(groupId: \"123\") {\n    edges {\n      node {\n        __typename\n        ... on User {\n          id\n          firstName\n          onlineStatus\n        }\n        ... on Group {\n          id\n          name\n          avatarUrl\n          members {\n            __typename\n            ... on User {\n              id\n              firstName\n              onlineStatus\n            }\n            ... on Group {\n              id\n              name\n              avatarUrl\n            }\n            ... on Node {\n              id\n            }\n          }\n        }\n        ... on Node {\n          id\n        }\n      }\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
