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

module Unions = {};

module Types = {
  type setOnlineStatusInput = {
    onlineStatus: [ | `Idle | `Offline | `Online | `FutureAddedValue(string)],
  };
  type response_setOnlineStatusComplex_user = {
    id: string,
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
  };
  type response_setOnlineStatusComplex = {
    user: option(response_setOnlineStatusComplex_user),
  };
};

open Types;

type response = {
  setOnlineStatusComplex: option(response_setOnlineStatusComplex),
};
type variables = {input: setOnlineStatusInput};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"setOnlineStatusComplex":{"n":""},"setOnlineStatusComplex_user":{"n":""},"setOnlineStatusComplex_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |}
  ];
  let wrapResponseConverterMap = {
    "enum_OnlineStatus": wrap_enum_OnlineStatus,
  };
  let convertWrapResponse = v =>
    v
    ->ReasonRelay._convertObj(
        wrapResponseConverter,
        wrapResponseConverterMap,
        Js.null,
      );

  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"setOnlineStatusComplex":{"n":""},"setOnlineStatusComplex_user":{"n":""},"setOnlineStatusComplex_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |}
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
    {| {"__root":{"input":{"r":"SetOnlineStatusInput"}},"SetOnlineStatusInput":{"onlineStatus":{"e":"enum_OnlineStatus"}}} |}
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

module Utils = {
  let make_setOnlineStatusInput = (~onlineStatus): setOnlineStatusInput => {
    onlineStatus: onlineStatus,
  };

  let makeVariables = (~input): variables => {input: input};

  let make_response_setOnlineStatusComplex_user =
      (~id, ~onlineStatus=?, ()): response_setOnlineStatusComplex_user => {
    id,
    onlineStatus,
  };

  let make_response_setOnlineStatusComplex =
      (~user=?, ()): response_setOnlineStatusComplex => {
    user: user,
  };

  let makeOptimisticResponse = (~setOnlineStatusComplex=?, ()): response => {
    setOnlineStatusComplex: setOnlineStatusComplex,
  };
};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "input",
    "type": "SetOnlineStatusInput!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "setOnlineStatusComplex",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
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
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "id": null,
    "text": "mutation TestMutationSetOnlineStatusComplexMutation(\n  $input: SetOnlineStatusInput!\n) {\n  setOnlineStatusComplex(input: $input) {\n    user {\n      id\n      onlineStatus\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
