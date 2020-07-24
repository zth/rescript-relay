/* @generated */

type enum_OnlineStatus = pri [> | `Idle | `Offline | `Online];

module Types = {
  type rawResponse_setOnlineStatus_user = {
    id: string,
    onlineStatus: option(enum_OnlineStatus),
    firstName: string,
    lastName: string,
  };
  type rawResponse_setOnlineStatus = {
    user: option(rawResponse_setOnlineStatus_user),
  };
  type response_setOnlineStatus_user = {
    id: string,
    onlineStatus: option(enum_OnlineStatus),
  };
  type response_setOnlineStatus = {
    user: option(response_setOnlineStatus_user),
  };

  type response = {setOnlineStatus: option(response_setOnlineStatus)};
  type rawResponse = {setOnlineStatus: option(rawResponse_setOnlineStatus)};
  type variables = {onlineStatus: enum_OnlineStatus};
};

module Internal = {
  type wrapResponseRaw;
  let wrapResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":"","f":""},"setOnlineStatus_user_onlineStatus":{"n":""}}} |json}
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
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":"","f":""},"setOnlineStatus_user_onlineStatus":{"n":""}}} |json}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  type wrapRawResponseRaw;
  let wrapRawResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":""},"setOnlineStatus_user_onlineStatus":{"n":""}}} |json}
  ];
  let wrapRawResponseConverterMap = ();
  let convertWrapRawResponse = v =>
    v
    ->ReasonRelay._convertObj(
        wrapRawResponseConverter,
        wrapRawResponseConverterMap,
        Js.null,
      );

  type rawResponseRaw;
  let rawResponseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"setOnlineStatus":{"n":""},"setOnlineStatus_user":{"n":""},"setOnlineStatus_user_onlineStatus":{"n":""}}} |json}
  ];
  let rawResponseConverterMap = ();
  let convertRawResponse = v =>
    v
    ->ReasonRelay._convertObj(
        rawResponseConverter,
        rawResponseConverterMap,
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
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "onlineStatus",
    "type": "OnlineStatus!"
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
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "onlineStatus",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestMutationSetOnlineStatusMutation",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": "SetOnlineStatusPayload",
        "kind": "LinkedField",
        "name": "setOnlineStatus",
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
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestFragment_user"
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Mutation"
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestMutationSetOnlineStatusMutation",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": "SetOnlineStatusPayload",
        "kind": "LinkedField",
        "name": "setOnlineStatus",
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
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "firstName",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "lastName",
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "id": null,
    "metadata": {},
    "name": "TestMutationSetOnlineStatusMutation",
    "operationKind": "mutation",
    "text": "mutation TestMutationSetOnlineStatusMutation(\n  $onlineStatus: OnlineStatus!\n) {\n  setOnlineStatus(onlineStatus: $onlineStatus) {\n    user {\n      id\n      onlineStatus\n      ...TestFragment_user\n    }\n  }\n}\n\nfragment TestFragment_sub_user on User {\n  lastName\n}\n\nfragment TestFragment_user on User {\n  firstName\n  onlineStatus\n  ...TestFragment_sub_user\n}\n"
  }
};
})() |json}
];
