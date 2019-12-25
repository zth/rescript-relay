type response = {
  .
  "removeFriend":
    Js.Nullable.t({. "removedFriendId": Js.Nullable.t(string)}),
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
    "name": "removeFriend",
    "storageKey": null,
    "args": [
      {
        "kind": "Variable",
        "name": "friendId",
        "variableName": "friendId"
      }
    ],
    "concreteType": "RemoveFriendPayload",
    "plural": false,
    "selections": [
      {
        "kind": "ScalarField",
        "alias": null,
        "name": "removedFriendId",
        "args": null,
        "storageKey": null
      }
    ]
  }
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "Test3_RemoveFriendMutation",
    "type": "Mutation",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "operation": {
    "kind": "Operation",
    "name": "Test3_RemoveFriendMutation",
    "argumentDefinitions": (v0/*: any*/),
    "selections": (v1/*: any*/)
  },
  "params": {
    "operationKind": "mutation",
    "name": "Test3_RemoveFriendMutation",
    "id": null,
    "text": "mutation Test3_RemoveFriendMutation(\n  $friendId: ID!\n) {\n  removeFriend(friendId: $friendId) {\n    removedFriendId\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
