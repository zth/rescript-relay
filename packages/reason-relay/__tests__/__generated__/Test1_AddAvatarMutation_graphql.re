type response = {
  .
  "updateUserAvatar":
    Js.Nullable.t({
      .
      "user":
        Js.Nullable.t({
          .
          "id": string,
          "avatarUrl": Js.Nullable.t(string),
        }),
    }),
};
type variables = {. "avatarUrl": string};
type operationType = ReasonRelay.mutationNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "avatarUrl",
    "type": "String!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "updateUserAvatar",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "avatarUrl",
        "variableName": "avatarUrl"
      }
    ],
    "concreteType": "UpdateUserAvatarPayload",
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
            "name": "avatarUrl",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
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
    "name": "Test1_AddAvatarMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "Test1_AddAvatarMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "Test1_AddAvatarMutation",
    "id": null,
    "text": "mutation Test1_AddAvatarMutation(\n  $avatarUrl: String!\n) {\n  updateUserAvatar(avatarUrl: $avatarUrl) {\n    user {\n      avatarUrl\n      id\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
