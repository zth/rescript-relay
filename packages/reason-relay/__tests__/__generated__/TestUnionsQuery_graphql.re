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
  type rawResponse = response;
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
    {json| {"__root":{"members":{"n":""},"members_edges":{"n":"","na":""},"members_edges_node":{"n":"","u":"response_members_edges_node"},"members_edges_node_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"},"members_edges_node_group_members":{"n":"","na":"","u":"response_members_edges_node_Group_members"},"members_edges_node_group_members_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"},"members_edges_node_group_members_group_avatarUrl":{"n":""},"members_edges_node_group_avatarUrl":{"n":""}}} |json}
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

  type rawResponseRaw = responseRaw;
  let convertRawResponse = convertResponse;

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {} |json}
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

type preloadToken;

module Utils = {};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%raw
  {json| (function(){
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
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "onlineStatus",
  "storageKey": null
},
v5 = {
  "kind": "InlineFragment",
  "selections": [
    (v2/*: any*/),
    (v3/*: any*/),
    (v4/*: any*/)
  ],
  "type": "User"
},
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "name",
  "storageKey": null
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "avatarUrl",
  "storageKey": null
},
v8 = {
  "kind": "InlineFragment",
  "selections": [
    (v3/*: any*/),
    (v4/*: any*/)
  ],
  "type": "User"
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
                  (v5/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v2/*: any*/),
                      (v6/*: any*/),
                      (v7/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": null,
                        "kind": "LinkedField",
                        "name": "members",
                        "plural": true,
                        "selections": [
                          (v1/*: any*/),
                          (v5/*: any*/),
                          {
                            "kind": "InlineFragment",
                            "selections": [
                              (v2/*: any*/),
                              (v6/*: any*/),
                              (v7/*: any*/)
                            ],
                            "type": "Group"
                          }
                        ],
                        "storageKey": null
                      }
                    ],
                    "type": "Group"
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
    "type": "Query"
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
                  (v2/*: any*/),
                  (v8/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v6/*: any*/),
                      (v7/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "concreteType": null,
                        "kind": "LinkedField",
                        "name": "members",
                        "plural": true,
                        "selections": [
                          (v1/*: any*/),
                          (v2/*: any*/),
                          (v8/*: any*/),
                          {
                            "kind": "InlineFragment",
                            "selections": [
                              (v6/*: any*/),
                              (v7/*: any*/)
                            ],
                            "type": "Group"
                          }
                        ],
                        "storageKey": null
                      }
                    ],
                    "type": "Group"
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
    ]
  },
  "params": {
    "id": null,
    "metadata": {},
    "name": "TestUnionsQuery",
    "operationKind": "query",
    "text": "query TestUnionsQuery {\n  members(groupId: \"123\") {\n    edges {\n      node {\n        __typename\n        ... on User {\n          id\n          firstName\n          onlineStatus\n        }\n        ... on Group {\n          id\n          name\n          avatarUrl\n          members {\n            __typename\n            ... on User {\n              id\n              firstName\n              onlineStatus\n            }\n            ... on Group {\n              id\n              name\n              avatarUrl\n            }\n            ... on Node {\n              id\n            }\n          }\n        }\n        ... on Node {\n          id\n        }\n      }\n    }\n  }\n}\n"
  }
};
})() |json}
];

include ReasonRelay.MakePreloadQuery({
  type variables = Types.variables;
  type queryPreloadToken = preloadToken;
  type response = Types.response;
  let query = node;
  let convertVariables = Internal.convertVariables;
});
