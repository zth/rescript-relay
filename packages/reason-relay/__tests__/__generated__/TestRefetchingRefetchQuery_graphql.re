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
  type response_node = {
    getFragmentRefs:
      unit =>
      {
        .
        "__$fragment_ref__TestRefetching_user": TestRefetching_user_graphql.t,
      },
  };

  type response = {node: option(response_node)};
  type refetchVariables = {
    friendsOnlineStatuses:
      option(
        array([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
      ),
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
    friendsOnlineStatuses:
      option(
        array([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
      ),
    showOnlineStatus: bool,
    id: string,
  };
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"node":{"n":"","f":""}}} |json}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"friendsOnlineStatuses":{"n":"","e":"enum_OnlineStatus"}}} |json}
  ];
  let variablesConverterMap = {"enum_OnlineStatus": wrap_enum_OnlineStatus};
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

type preloadToken;

module Utils = {
  open Types;
  let makeVariables =
      (~friendsOnlineStatuses=?, ~showOnlineStatus, ~id, ()): variables => {
    friendsOnlineStatuses,
    showOnlineStatus,
    id,
  };
};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%raw
  {json| (function(){
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
})() |json}
];

module Preload =
  ReasonRelay.MakePreloadQuery({
    type variables = Types.variables;
    type queryPreloadToken = preloadToken;
    let query = node;
    let convertVariables = Internal.convertVariables;
  });

let preload = Preload.preload;
