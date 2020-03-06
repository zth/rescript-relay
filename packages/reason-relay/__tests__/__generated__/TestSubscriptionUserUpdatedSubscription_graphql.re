/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FutureAddedValue(string)
];

module Unions = {};

module Types = {
  type user = {
    id: string,
    onlineStatus: option(enum_OnlineStatus),
    getFragmentRefs:
      unit =>
      {
        .
        "__$fragment_ref__TestSubscription_user": TestSubscription_user_graphql.t,
      },
  };
  type userUpdated = {user: option(user)};
};

open Types;

type response = {userUpdated: option(userUpdated)};
type variables = {userId: string};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"userUpdated":{"n":""},"userUpdated_user":{"n":"","f":""},"userUpdated_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |}
  ];
  let responseConverterMap = {
    "enum_OnlineStatus": SchemaAssets.Enum_OnlineStatus.unwrap,
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

type operationType = ReasonRelay.subscriptionNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "userId",
    "type": "ID!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "userId"
  }
],
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
  "name": "onlineStatus",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestSubscriptionUserUpdatedSubscription",
    "type": "Subscription",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "userUpdated",
        "storageKey": null,
        "args": (v1/*: any*/),
        "concreteType": "UserUpdatedPayload",
        "plural": false,
        "selections": [
          {
            "kind": "LinkedField",
            "alias": null,
            "name": "user",
            "storageKey": null,
            "args": null,
            "concreteType": "User",
            "plural": false,
            "selections": [
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "kind": "FragmentSpread",
                "name": "TestSubscription_user",
                "args": null
              }
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestSubscriptionUserUpdatedSubscription",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "userUpdated",
        "storageKey": null,
        "args": (v1/*: any*/),
        "concreteType": "UserUpdatedPayload",
        "plural": false,
        "selections": [
          {
            "kind": "LinkedField",
            "alias": null,
            "name": "user",
            "storageKey": null,
            "args": null,
            "concreteType": "User",
            "plural": false,
            "selections": [
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "kind": "ScalarField",
                "alias": null,
                "name": "firstName",
                "args": null,
                "storageKey": null
              },
              {
                "kind": "ScalarField",
                "alias": null,
                "name": "avatarUrl",
                "args": null,
                "storageKey": null
              }
            ]
          }
        ]
      }
    ]
  },
  "params": {
    "operationKind": "subscription",
    "name": "TestSubscriptionUserUpdatedSubscription",
    "id": null,
    "text": "subscription TestSubscriptionUserUpdatedSubscription(\n  $userId: ID!\n) {\n  userUpdated(id: $userId) {\n    user {\n      id\n      onlineStatus\n      ...TestSubscription_user\n    }\n  }\n}\n\nfragment TestSubscription_user on User {\n  id\n  firstName\n  avatarUrl\n  onlineStatus\n}\n",
    "metadata": {}
  }
};
})() |}
];
