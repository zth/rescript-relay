/* @generated */

module Unions = {};

module Types = {
  type response = {
    getFragmentRefs:
      unit =>
      {
        .
        "__$fragment_ref__TestPagination_query": TestPagination_query_graphql.t,
      },
  };
  type refetchVariables = {groupId: option(string)};
  let makeRefetchVariables = (~groupId=?, ()): refetchVariables => {
    groupId: groupId,
  };
  type variables = {groupId: string};
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"":{"f":""}}} |}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {} |}
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
  let makeVariables = (~groupId): variables => {groupId: groupId};
};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "groupId",
    "type": "ID!",
    "defaultValue": null
  }
],
v1 = {
  "kind": "Variable",
  "name": "groupId",
  "variableName": "groupId"
},
v2 = [
  {
    "kind": "Literal",
    "name": "after",
    "value": ""
  },
  {
    "kind": "Literal",
    "name": "first",
    "value": 2
  },
  (v1/*: any*/)
],
v3 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v4 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "firstName",
  "args": null,
  "storageKey": null
},
v5 = [
  {
    "kind": "Literal",
    "name": "first",
    "value": 1
  }
];
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestPaginationQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "FragmentSpread",
        "name": "TestPagination_query",
        "args": [
          (v1/*: any*/)
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestPaginationQuery",
    "argumentDefinitions": (v0/*: any*/),
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "members",
        "storageKey": null,
        "args": (v2/*: any*/),
        "concreteType": "MemberConnection",
        "plural": false,
        "selections": [
          {
            "kind": "LinkedField",
            "alias": null,
            "name": "edges",
            "storageKey": null,
            "args": null,
            "concreteType": "MemberEdge",
            "plural": true,
            "selections": [
              {
                "kind": "LinkedField",
                "alias": null,
                "name": "node",
                "storageKey": null,
                "args": null,
                "concreteType": null,
                "plural": false,
                "selections": [
                  {
                    "kind": "ScalarField",
                    "alias": null,
                    "name": "__typename",
                    "args": null,
                    "storageKey": null
                  },
                  (v3/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "type": "User",
                    "selections": [
                      (v4/*: any*/),
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "friendsConnection",
                        "storageKey": "friendsConnection(first:1)",
                        "args": (v5/*: any*/),
                        "concreteType": "UserConnection",
                        "plural": false,
                        "selections": [
                          {
                            "kind": "ScalarField",
                            "alias": null,
                            "name": "totalCount",
                            "args": null,
                            "storageKey": null
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "kind": "InlineFragment",
                    "type": "Group",
                    "selections": [
                      {
                        "kind": "ScalarField",
                        "alias": null,
                        "name": "name",
                        "args": null,
                        "storageKey": null
                      },
                      {
                        "kind": "LinkedField",
                        "alias": null,
                        "name": "adminsConnection",
                        "storageKey": "adminsConnection(first:1)",
                        "args": (v5/*: any*/),
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
                                  (v4/*: any*/)
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  }
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
        "name": "members",
        "args": (v2/*: any*/),
        "handle": "connection",
        "key": "TestPagination_query_members",
        "filters": [
          "groupId",
          "onlineStatuses"
        ]
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "TestPaginationQuery",
    "id": null,
    "text": "query TestPaginationQuery(\n  $groupId: ID!\n) {\n  ...TestPagination_query_3nceos\n}\n\nfragment TestPagination_query_3nceos on Query {\n  members(groupId: $groupId, first: 2, after: \"\") {\n    edges {\n      node {\n        __typename\n        ... on User {\n          id\n          ...TestPagination_user\n        }\n        ... on Group {\n          id\n          name\n          adminsConnection(first: 1) {\n            edges {\n              node {\n                id\n                firstName\n              }\n            }\n          }\n        }\n        ... on Node {\n          id\n        }\n      }\n      cursor\n    }\n    pageInfo {\n      endCursor\n      hasNextPage\n    }\n  }\n}\n\nfragment TestPagination_user on User {\n  firstName\n  friendsConnection(first: 1) {\n    totalCount\n  }\n}\n",
    "metadata": {}
  }
};
})() |}
];
