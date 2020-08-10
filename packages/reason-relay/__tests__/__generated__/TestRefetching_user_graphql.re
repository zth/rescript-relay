/* @generated */

type enum_OnlineStatus = pri [> | `Idle | `Offline | `Online];

module Types = {
  [@ocaml.warning "-30"];
  type fragment_friendsConnection = {totalCount: int};

  type fragment = {
    firstName: string,
    onlineStatus: option(enum_OnlineStatus),
    friendsConnection: fragment_friendsConnection,
    id: option(string),
  };
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"onlineStatus":{"n":""},"id":{"n":""}}} |json}
  ];
  let fragmentConverterMap = ();
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
external getFragmentRef:
  ReasonRelay.fragmentRefs([> | `TestRefetching_user]) => fragmentRef =
  "%identity";

module Utils = {
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity";
};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%raw
  {json| {
  "argumentDefinitions": [
    {
      "defaultValue": null,
      "kind": "LocalArgument",
      "name": "friendsOnlineStatuses"
    },
    {
      "defaultValue": false,
      "kind": "LocalArgument",
      "name": "showOnlineStatus"
    }
  ],
  "kind": "Fragment",
  "metadata": {
    "refetch": {
      "connection": null,
      "fragmentPathInResult": [
        "node"
      ],
      "operation": require('./TestRefetchingRefetchQuery_graphql.bs.js').node,
      "identifierField": "id"
    }
  },
  "name": "TestRefetching_user",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "firstName",
      "storageKey": null
    },
    {
      "alias": null,
      "args": [
        {
          "kind": "Variable",
          "name": "statuses",
          "variableName": "friendsOnlineStatuses"
        }
      ],
      "concreteType": "UserConnection",
      "kind": "LinkedField",
      "name": "friendsConnection",
      "plural": false,
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "totalCount",
          "storageKey": null
        }
      ],
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "id",
      "storageKey": null
    },
    {
      "condition": "showOnlineStatus",
      "kind": "Condition",
      "passingValue": true,
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "onlineStatus",
          "storageKey": null
        }
      ]
    }
  ],
  "type": "User",
  "abstractKey": null
} |json}
];
