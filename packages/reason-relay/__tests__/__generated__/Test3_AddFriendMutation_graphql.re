type response = {
  .
  "addFriend":
    Js.Nullable.t({
      .
      "addedFriend":
        Js.Nullable.t({
          .
          "lastName": string,
          "firstName": string,
          "id": string,
        }),
    }),
};
type variables = {. "friendId": string};
type operationType = ReasonRelay.mutationNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "friendId",
    "type": "ID!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "LinkedField",
    "alias": null,
    "name": "addFriend",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "friendId",
        "variableName": "friendId"
      }
    ],
    "concreteType": "AddFriendPayload",
    "plural": false,
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "addedFriend",
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
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "Test3_AddFriendMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "Test3_AddFriendMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "Test3_AddFriendMutation",
    "id": null,
    "text": "mutation Test3_AddFriendMutation(\n  $friendId: ID!\n) {\n  addFriend(friendId: $friendId) {\n    addedFriend {\n      id\n      firstName\n      lastName\n    }\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
