type response = {
  .
  "loggedInUser": {
    .
    "__$fragment_ref__Test1_User_userSimple": Test1_User_userSimple_graphql.t,
    "__$fragment_ref__Test1_User_user": Test1_User_user_graphql.t,
  },
};
type variables = unit;
type operationType = ReasonRelay.queryNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "Test1_Query",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "loggedInUser",
        "storageKey": null,
        "args": null,
        "concreteType": "User",
        "plural": false,
        "selections": [
          {
            "kind": "FragmentSpread",
            "name": "Test1_User_user",
            "args": null
          },
          {
            "kind": "FragmentSpread",
            "name": "Test1_User_userSimple",
            "args": null
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "Test1_Query",
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "loggedInUser",
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
            "name": "avatarUrl",
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
  },
  "params": {
    "operationKind": "query",
    "name": "Test1_Query",
    "id": null,
    "text": "query Test1_Query {\n  loggedInUser {\n    ...Test1_User_user\n    ...Test1_User_userSimple\n    id\n  }\n}\n\nfragment Test1_User_user on User {\n  id\n  avatarUrl\n}\n\nfragment Test1_User_userSimple on User {\n  id\n  firstName\n  lastName\n}\n",
    "metadata": {}
  }
} |}
];
