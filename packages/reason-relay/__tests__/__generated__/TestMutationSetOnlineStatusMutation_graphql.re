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
  type rawResponse_setOnlineStatus_user = {
    id: string,
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
    firstName: string,
    lastName: string,
  };
  type rawResponse_setOnlineStatus = {
    user: option(rawResponse_setOnlineStatus_user),
  };
  type response_setOnlineStatus_user = {
    id: string,
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
  };
  type response_setOnlineStatus = {
    user: option(response_setOnlineStatus_user),
  };

  type response = {setOnlineStatus: option(response_setOnlineStatus)};
  type rawResponse = {setOnlineStatus: option(rawResponse_setOnlineStatus)};
  type variables = {
    onlineStatus: [ | `Idle | `Offline | `Online | `FutureAddedValue(string)],
  };
};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":"","f":"TestFragment_user"},"setOnlineStatus_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |json}
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
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":"","f":"TestFragment_user"},"setOnlineStatus_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |json}
  ];
  let responseConverterMap = {"enum_OnlineStatus": unwrap_enum_OnlineStatus};
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  type wrapRawResponseRaw;
  let wrapRawResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":""},"setOnlineStatus_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |json}
  ];
  let wrapRawResponseConverterMap = {
    "enum_OnlineStatus": wrap_enum_OnlineStatus,
  };
  let convertWrapRawResponse = v =>
    v
    ->ReasonRelay._convertObj(
        wrapRawResponseConverter,
        wrapRawResponseConverterMap,
        Js.null,
      );

  type rawResponseRaw;
  let rawResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":""},"setOnlineStatus_user_onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |json}
  ];
  let rawResponseConverterMap = {
    "enum_OnlineStatus": unwrap_enum_OnlineStatus,
  };
  let convertRawResponse = v =>
    v
    ->ReasonRelay._convertObj(
        rawResponseConverter,
        rawResponseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"onlineStatus":{"e":"enum_OnlineStatus"}}} |json}
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
  open Types;
  let makeVariables = (~onlineStatus): variables => {
    onlineStatus: onlineStatus,
  };

  let make_rawResponse_setOnlineStatus_user =
      (~id, ~onlineStatus=?, ~firstName, ~lastName, ())
      : rawResponse_setOnlineStatus_user => {
    id,
    onlineStatus,
    firstName,
    lastName,
  };

  let make_rawResponse_setOnlineStatus =
      (~user=?, ()): rawResponse_setOnlineStatus => {
    user: user,
  };

  let make_response_setOnlineStatus_user =
      (~id, ~onlineStatus=?, ()): response_setOnlineStatus_user => {
    id,
    onlineStatus,
  };

  let make_response_setOnlineStatus = (~user=?, ()): response_setOnlineStatus => {
    user: user,
  };

  let makeOptimisticResponse = (~setOnlineStatus=?, ()): rawResponse => {
    setOnlineStatus: setOnlineStatus,
  };
};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%raw
  {json| (function(){
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
    "kind": "Variable",
    "name": "onlineStatus",
    "variableName": "onlineStatus"
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
    "name": "TestMutationSetOnlineStatusMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "setOnlineStatus",
        "storageKey": null,
        "args": (v1/*: any*/),
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
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "kind": "FragmentSpread",
                "name": "TestFragment_user",
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
    "name": "TestMutationSetOnlineStatusMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "setOnlineStatus",
        "storageKey": null,
        "args": (v1/*: any*/),
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
                "name": "lastName",
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
    "operationKind": "mutation",
    "name": "TestMutationSetOnlineStatusMutation",
    "id": null,
    "text": "mutation TestMutationSetOnlineStatusMutation(\n  $onlineStatus: OnlineStatus!\n) {\n  setOnlineStatus(onlineStatus: $onlineStatus) {\n    user {\n      id\n      onlineStatus\n      ...TestFragment_user\n    }\n  }\n}\n\nfragment TestFragment_sub_user on User {\n  lastName\n}\n\nfragment TestFragment_user on User {\n  firstName\n  onlineStatus\n  ...TestFragment_sub_user\n}\n",
    "metadata": {}
  }
};
})() |json}
];
