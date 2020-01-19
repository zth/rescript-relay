/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FUTURE_ADDED_VALUE__
];

module Unions = {};

module Types = {
  type user = {
    id: string,
    onlineStatus: option(enum_OnlineStatus),
  };
  type setOnlineStatus = {user: option(user)};
};

open Types;

type response = {setOnlineStatus: option(setOnlineStatus)};
type variables = {onlineStatus: enum_OnlineStatus};

module FragmentConverters: {} = {};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"setOnlineStatus":[[0,""]],"setOnlineStatus_user":[[0,""]],"setOnlineStatus_user_onlineStatus":[[0,""],[2,"enum_OnlineStatus"]]} |}
  ];
  let wrapResponseConverterMap = {
    "enum_OnlineStatus": SchemaAssets.Enum_OnlineStatus.wrap,
  };
  let convertWrapResponse = v =>
    v
    ->ReasonRelay._convertObj(
        wrapResponseConverter,
        wrapResponseConverterMap,
        Js.null,
      );

  type responseRaw;
  let responseConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"setOnlineStatus":[[0,""]],"setOnlineStatus_user":[[0,""]],"setOnlineStatus_user_onlineStatus":[[0,""],[2,"enum_OnlineStatus"]]} |}
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

  let variablesConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"onlineStatus":[[2,"enum_OnlineStatus"]]} |}
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

module Utils = {};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "onlineStatus",
    "type": "OnlineStatus!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "setOnlineStatus",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "onlineStatus",
        "variableName": "onlineStatus"
      }
    ],
    "concreteType": "SetOnlineStatusPayload",
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
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
            "args": null,
            "storageKey": null
          },
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
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestMutationSetOnlineStatusMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "TestMutationSetOnlineStatusMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "TestMutationSetOnlineStatusMutation",
    "id": null,
    "text": "mutation TestMutationSetOnlineStatusMutation(\n  $onlineStatus: OnlineStatus!\n) {\n  setOnlineStatus(onlineStatus: $onlineStatus) {\n    user {\n      id\n      onlineStatus\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
