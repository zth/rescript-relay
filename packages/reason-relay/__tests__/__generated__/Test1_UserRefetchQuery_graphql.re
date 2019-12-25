type response = {
  .
  "node":
    Js.Nullable.t({
      .
      "__$fragment_ref__Test1_User_user": Test1_User_user_graphql.t,
    }),
};
type refetchVariables = {
  .
  "id": option(string),
  "showOnlineStatus": option(bool),
  "showFriends": option(bool),
};
let makeRefetchVariables =
    (~id=?, ~showOnlineStatus=?, ~showFriends=?, ()): refetchVariables => {
  "id": id,
  "showOnlineStatus": showOnlineStatus,
  "showFriends": showFriends,
};
type variables = {
  .
  "id": string,
  "showOnlineStatus": bool,
  "showFriends": bool,
};
type operationType = ReasonRelay.queryNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
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
  },
  {
    "kind": "LocalArgument",
    "name": "id",
    "type": "ID!",
    "defaultValue": null
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "id"
  }
],
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "__typename",
  "args": null,
  "storageKey": null
},
v3 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v4 = [
  {
    "kind": "Literal",
    "name": "after",
    "value": ""
  },
  {
    "kind": "Literal",
    "name": "first",
    "value": 2
  }
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "Test1_UserRefetchQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "node",
        "storageKey": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "plural": false,
        "selections": [
          {
            "kind": "FragmentSpread",
            "name": "Test1_User_user",
            "args": [
              {
                "kind": "Variable",
                "name": "showFriends",
                "variableName": "showFriends"
              },
              {
                "kind": "Variable",
                "name": "showOnlineStatus",
                "variableName": "showOnlineStatus"
              }
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "Test1_UserRefetchQuery",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "node",
        "storageKey": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "plural": false,
        "selections": [
          (v2/*: any*/),
          (v3/*: any*/),
          {
            "kind": "InlineFragment",
            "type": "User",
            "selections": [
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
                    "kind": "LinkedField",
                    "alias": null,
                    "name": "friendsConnection",
                    "storageKey": "friendsConnection(after:\"\",first:2)",
                    "args": (v4/*: any*/),
                    "concreteType": "UserConnection",
                    "plural": false,
                    "selections": [
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "edges",
                        "storageKey": null,
                        "args": null,
                        "concreteType": "UserEdge",
                        "plural": true,
                        "selections": [
                          {
                            "kind": "LinkedField",
                            "alias": null,
                            "name": "node",
                            "storageKey": null,
                            "args": null,
                            "concreteType": "User",
                            "plural": false,
                            "selections": [
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
                              },
                              (v2/*: any*/)
                            ]
                          },
                          {
                            "kind": "ScalarField",
                            "alias": null,
                            "name": "cursor",
                            "args": null,
                            "storageKey": null
                          }
                        ]
                      },
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "pageInfo",
                        "storageKey": null,
                        "args": null,
                        "concreteType": "PageInfo",
                        "plural": false,
                        "selections": [
                          {
                            "kind": "ScalarField",
                            "alias": null,
                            "name": "endCursor",
                            "args": null,
                            "storageKey": null
                          },
                          {
                            "kind": "ScalarField",
                            "alias": null,
                            "name": "hasNextPage",
                            "args": null,
                            "storageKey": null
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "kind": "LinkedHandle",
                    "alias": null,
                    "name": "friendsConnection",
                    "args": (v4/*: any*/),
                    "handle": "connection",
                    "key": "Test1_User_userFriends_friendsConnection",
                    "filters": null
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "Test1_UserRefetchQuery",
    "id": null,
    "text": "query Test1_UserRefetchQuery(\n  $showFriends: Boolean! = false\n  $showOnlineStatus: Boolean! = false\n  $id: ID!\n) {\n  node(id: $id) {\n    __typename\n    ...Test1_User_user_W2Mm0\n    id\n  }\n}\n\nfragment Test1_User_userFriends on User {\n  id\n  friendsConnection(first: 2, after: \"\") {\n    edges {\n      node {\n        id\n        firstName\n        lastName\n        __typename\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment Test1_User_user_W2Mm0 on User {\n  id\n  avatarUrl\n  isOnline @include(if: $showOnlineStatus)\n  ...Test1_User_userFriends @include(if: $showFriends)\n}\n",
    "metadata": {
      "derivedFrom": "Test1_User_user",
      "isRefetchableQuery": true
    }
  }
};
})() |}
];
