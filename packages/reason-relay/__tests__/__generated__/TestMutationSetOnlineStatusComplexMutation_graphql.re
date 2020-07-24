/* @generated */

type enum_OnlineStatus = pri [> | `Idle | `Offline | `Online];

module Types = {
  type setOnlineStatusInput = {onlineStatus: enum_OnlineStatus};
  type response_setOnlineStatusComplex_user = {
    id: string,
    onlineStatus: option(enum_OnlineStatus),
  };
  type response_setOnlineStatusComplex = {
    user: option(response_setOnlineStatusComplex_user),
  };

  type response = {
    setOnlineStatusComplex: option(response_setOnlineStatusComplex),
  };
  type rawResponse = response;
  type variables = {input: setOnlineStatusInput};
};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatusComplex":{"n":""},"setOnlineStatusComplex_user":{"n":""},"setOnlineStatusComplex_user_onlineStatus":{"n":""}}} |json}
  ];
  let wrapResponseConverterMap = ();
  let convertWrapResponse = v =>
    v
    ->ReasonRelay._convertObj(
        wrapResponseConverter,
        wrapResponseConverterMap,
        Js.null,
      );

  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatusComplex":{"n":""},"setOnlineStatusComplex_user":{"n":""},"setOnlineStatusComplex_user_onlineStatus":{"n":""}}} |json}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  type wrapRawResponseRaw = wrapResponseRaw;
  let convertWrapRawResponse = convertWrapResponse;

  type rawResponseRaw = responseRaw;
  let convertRawResponse = convertResponse;

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"input":{"r":"SetOnlineStatusInput"}},"SetOnlineStatusInput":{}} |json}
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

  let makeOptimisticResponse = (~setOnlineStatusComplex=?, ()): rawResponse => {
    setOnlineStatusComplex: setOnlineStatusComplex,
  };
};

type operationType = ReasonRelay.mutationNode;

let node: operationType = [%raw
  {json| (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "input",
    "type": "SetOnlineStatusInput!"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "concreteType": "SetOnlineStatusPayload",
    "kind": "LinkedField",
    "name": "setOnlineStatusComplex",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "user",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "onlineStatus",
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation"
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "id": null,
    "metadata": {},
    "name": "TestMutationSetOnlineStatusComplexMutation",
    "operationKind": "mutation",
    "text": "mutation TestMutationSetOnlineStatusComplexMutation(\n  $input: SetOnlineStatusInput!\n) {\n  setOnlineStatusComplex(input: $input) {\n    user {\n      id\n      onlineStatus\n    }\n  }\n}\n"
  }
};
})() |json}
];
