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
  type response_userUpdated_user = {
    id: string,
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
    getFragmentRefs:
      unit =>
      {
        .
        "__$fragment_ref__TestSubscription_user": TestSubscription_user_graphql.t,
      },
  };
  type response_userUpdated = {user: option(response_userUpdated_user)};

  type response = {userUpdated: option(response_userUpdated)};
  type variables = {userId: string};
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"userUpdated":{"n":""},"userUpdated_user":{"n":"","f":""},"userUpdated_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |json}
  ];
  let responseConverterMap = {"enum_OnlineStatus": unwrap_enum_OnlineStatus};
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

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

module Utils = {
  open Types;
  let makeVariables = (~userId): variables => {userId: userId};
};

type operationType = ReasonRelay.subscriptionNode;

let node: operationType = [%raw
  {json| (function(){
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
})() |json}
];
