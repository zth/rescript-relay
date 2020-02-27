/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FutureAddedValue_(string)
];

module Unions = {
  module Union_response_members_edges_node_group_members: {
    type wrapped;
    type user = {
      onlineStatus: option(enum_OnlineStatus),
      firstName: string,
      id: string,
    };
    type group = {
      avatarUrl: option(string),
      name: string,
      id: string,
    };
    type t = [
      | `User(user)
      | `Group(group)
      | `FutureAddedValue_(Js.Json.t)
    ];
    let unwrap: wrapped => t;
  } = {
    type wrapped;
    type user = {
      onlineStatus: option(enum_OnlineStatus),
      firstName: string,
      id: string,
    };
    type group = {
      avatarUrl: option(string),
      name: string,
      id: string,
    };
    external __unwrap_union: wrapped => {. "__typename": string} =
      "%identity";
    type t = [
      | `User(user)
      | `Group(group)
      | `FutureAddedValue_(Js.Json.t)
    ];
    external __unwrap_user: wrapped => user = "%identity";
    external __unwrap_group: wrapped => group = "%identity";
    external __toJson: wrapped => Js.Json.t = "%identity";
    let unwrap = wrapped => {
      let unwrappedUnion = wrapped |> __unwrap_union;
      switch (unwrappedUnion##__typename) {
      | "User" => `User(wrapped |> __unwrap_user)
      | "Group" => `Group(wrapped |> __unwrap_group)
      | _ => `FutureAddedValue_(wrapped |> __toJson)
      };
    };
  };

  type union_response_members_edges_node_group_members = [
    | `User(Union_response_members_edges_node_group_members.user)
    | `Group(Union_response_members_edges_node_group_members.group)
    | `FutureAddedValue_(Js.Json.t)
  ];

  module Union_response_members_edges_node: {
    type wrapped;
    type user = {
      onlineStatus: option(enum_OnlineStatus),
      firstName: string,
      id: string,
    };
    type group = {
      members:
        option(
          array(option(union_response_members_edges_node_group_members)),
        ),
      avatarUrl: option(string),
      name: string,
      id: string,
    };
    type t = [
      | `User(user)
      | `Group(group)
      | `FutureAddedValue_(Js.Json.t)
    ];
    let unwrap: wrapped => t;
  } = {
    type wrapped;
    type user = {
      onlineStatus: option(enum_OnlineStatus),
      firstName: string,
      id: string,
    };
    type group = {
      members:
        option(
          array(option(union_response_members_edges_node_group_members)),
        ),
      avatarUrl: option(string),
      name: string,
      id: string,
    };
    external __unwrap_union: wrapped => {. "__typename": string} =
      "%identity";
    type t = [
      | `User(user)
      | `Group(group)
      | `FutureAddedValue_(Js.Json.t)
    ];
    external __unwrap_user: wrapped => user = "%identity";
    external __unwrap_group: wrapped => group = "%identity";
    external __toJson: wrapped => Js.Json.t = "%identity";
    let unwrap = wrapped => {
      let unwrappedUnion = wrapped |> __unwrap_union;
      switch (unwrappedUnion##__typename) {
      | "User" => `User(wrapped |> __unwrap_user)
      | "Group" => `Group(wrapped |> __unwrap_group)
      | _ => `FutureAddedValue_(wrapped |> __toJson)
      };
    };
  };

  type union_response_members_edges_node = [
    | `User(Union_response_members_edges_node.user)
    | `Group(Union_response_members_edges_node.group)
    | `FutureAddedValue_(Js.Json.t)
  ];
};

open Unions;

module Types = {
  type edges = {node: option(union_response_members_edges_node)};
  type members = {edges: option(array(option(edges)))};
};

open Types;

type response = {members: option(members)};
type variables = unit;

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"members":{"n":""},"members_edges":{"n":"","na":""},"members_edges_node":{"n":"","u":"response_members_edges_node"},"members_edges_node_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"},"members_edges_node_group_members":{"n":"","na":"","u":"response_members_edges_node_group_members"},"members_edges_node_group_members_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"},"members_edges_node_group_members_group_avatarUrl":{"n":""},"members_edges_node_group_avatarUrl":{"n":""}}} |}
  ];
  let responseConverterMap = {
    "response_members_edges_node": Union_response_members_edges_node.unwrap,
    "enum_OnlineStatus": SchemaAssets.Enum_OnlineStatus.unwrap,
    "response_members_edges_node_group_members": Union_response_members_edges_node_group_members.unwrap,
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
