/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FUTURE_ADDED_VALUE__
];

module Unions = {};

module Types = {
  type node;
};

open Types;

type response = {node: option(node)};
type refetchVariables = {
  friendsOnlineStatuses: option(array(enum_OnlineStatus)),
  showOnlineStatus: option(bool),
  id: option(string),
};
let makeRefetchVariables =
    (~friendsOnlineStatuses=?, ~showOnlineStatus=?, ~id=?, ())
    : refetchVariables => {
  friendsOnlineStatuses,
  showOnlineStatus,
  id,
};
type variables = {
  friendsOnlineStatuses: option(array(enum_OnlineStatus)),
  showOnlineStatus: bool,
  id: string,
};

module FragmentConverters: {
  let unwrapFragment_node:
    node =>
    {. "__$fragment_ref__TestRefetching_user": TestRefetching_user_graphql.t};
} = {
  external unwrapFragment_node:
    node =>
    {. "__$fragment_ref__TestRefetching_user": TestRefetching_user_graphql.t} =
    "%identity";
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"node":[[0,""]]} |}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"friendsOnlineStatuses":[[0,""],[2,"enum_OnlineStatus"]]} |}
  ];
  let variablesConverterMap = {
    "enum_OnlineStatus": SchemaAssets.Enum_OnlineStatus.wrap,
  };
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "friendsOnlineStatuses",
    "type": "[OnlineStatus!]",
    "defaultValue": null
  },
  {
    "kind": "LocalArgument",
    "name": "showOnlineStatus",
    "type": "Boolean!",
    "defaultValue": false
  },
  {
    "kind": "LocalArgument",
    "name": "id",
    "type": "ID!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "id"
  }
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestRefetchingRefetchQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "node",
        "storageKey": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "plural": false,
        "selections": [
          {
            "kind": "FragmentSpread",
            "name": "TestRefetching_user",
            "args": [
              {
                "kind": "Variable",
                "name": "friendsOnlineStatuses",
                "variableName": "friendsOnlineStatuses"
              },
              {
                "kind": "Variable",
                "name": "showOnlineStatus",
                "variableName": "showOnlineStatus"
              }
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestRefetchingRefetchQuery",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "node",
        "storageKey": null,
        "args": (v1/*: any*/),
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
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "InlineFragment",
            "type": "User",
            "selections": [
              {
                "kind": "ScalarField",
                "alias": null,
                "name": "firstName",
                "args": null,
                "storageKey": null
              },
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "friendsConnection",
                "storageKey": null,
                "args": [
                  {
                    "kind": "Variable",
                    "name": "statuses",
                    "variableName": "friendsOnlineStatuses"
                  }
                ],
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
              },
              {
                "kind": "Condition",
                "passingValue": true,
                "condition": "showOnlineStatus",
                "selections": [
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "onlineStatus",
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
  },
  "params": {
    "operationKind": "query",
    "name": "TestRefetchingRefetchQuery",
    "id": null,
    "text": "query TestRefetchingRefetchQuery(\n  $friendsOnlineStatuses: [OnlineStatus!]\n  $showOnlineStatus: Boolean! = false\n  $id: ID!\n) {\n  node(id: $id) {\n    __typename\n    ...TestRefetching_user_lLXHd\n    id\n  }\n}\n\nfragment TestRefetching_user_lLXHd on User {\n  firstName\n  onlineStatus @include(if: $showOnlineStatus)\n  friendsConnection(statuses: $friendsOnlineStatuses) {\n    totalCount\n  }\n  id\n}\n",
    "metadata": {
      "derivedFrom": "TestRefetching_user",
      "isRefetchableQuery": true
    }
  }
};
})() |}
];
