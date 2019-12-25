type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__Test1_User_user": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

type fragment = {
  .
  "__$fragment_ref__Test1_User_userFriends": Test1_User_userFriends_graphql.t,
  "isOnline": Js.Nullable.t(bool),
  "avatarUrl": Js.Nullable.t(string),
  "id": string,
};
type operationType = ReasonRelay.fragmentNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "Test1_User_user",
  "type": "User",
  "metadata": {
    "refetch": {
      "connection": null,
      "operation": require('./Test1_UserRefetchQuery_graphql.bs.js').node,
      "fragmentPathInResult": [
        "node"
      ]
    }
  },
  "argumentDefinitions": [
    {
      "kind": "LocalArgument",
      "name": "showFriends",
      "type": "Boolean!",
      "defaultValue": false
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
      "name": "id",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "avatarUrl",
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
          "name": "isOnline",
          "args": null,
          "storageKey": null
        }
      ]
    },
    {
      "kind": "Condition",
      "passingValue": true,
      "condition": "showFriends",
      "selections": [
        {
          "kind": "FragmentSpread",
          "name": "Test1_User_userFriends",
          "args": null
        }
      ]
    }
  ]
} |}
];
