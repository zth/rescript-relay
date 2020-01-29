/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FUTURE_ADDED_VALUE__
];

module Unions = {};

module Types = {
  type friendsConnection = {totalCount: int};
};

open Types;

type fragment = {
  firstName: string,
  onlineStatus: option(enum_OnlineStatus),
  friendsConnection,
  id: option(string),
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"onlineStatus":{"n":"","e":"enum_OnlineStatus"},"id":{"n":""}}} |}
  ];
  let fragmentConverterMap = {
    "enum_OnlineStatus": SchemaAssets.Enum_OnlineStatus.unwrap,
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
  {.. "__$fragment_ref__TestRefetching_user": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "TestRefetching_user",
  "type": "User",
  "metadata": {
    "refetch": {
      "connection": null,
      "operation": require('./TestRefetchingRefetchQuery_graphql.bs.js').node,
      "fragmentPathInResult": [
        "node"
      ]
    }
  },
  "argumentDefinitions": [
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
    }
  ],
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
      "kind": "ScalarField",
      "alias": null,
      "name": "id",
      "args": null,
      "storageKey": null
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
} |}
];
