/* @generated */

module Types = {
  type node = {
    id: string,
    onlineStatus: option(SchemaAssets.Enum_OnlineStatus.t),
  };
  type edges = {node: option(node)};
  type users = {edges: option(array(option(edges)))};
  type loggedInUser;
};

open Types;

type response = {
  loggedInUser,
  users: option(users),
};
type variables = unit;

module FragmentConverters: {
  let node_getFragments:
    node =>
    {
      .
      "__$fragment_ref__TestFragment_plural_user": TestFragment_plural_user_graphql.t,
    };
  let loggedInUser_getFragments:
    loggedInUser =>
    {. "__$fragment_ref__TestFragment_user": TestFragment_user_graphql.t};
} = {
  external loggedInUser_getFragments:
    loggedInUser =>
    {. "__$fragment_ref__TestFragment_user": TestFragment_user_graphql.t} =
    "%identity";
  external node_getFragments:
    node =>
    {
      .
      "__$fragment_ref__TestFragment_plural_user": TestFragment_plural_user_graphql.t,
    } =
    "%identity";
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"users":[[0,""]],"users_edges":[[0,""],[1,""]],"users_edges_node":[[0,""]],"users_edges_node_onlineStatus":[[0,""],[2,"enum_OnlineStatus"]]} |}
  ];
  let responseConverterMap = {
    "enum_OnlineStatus": SchemaAssets.Enum_OnlineStatus.unwrap,
  };
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(array((int, string))) = [%raw {| {} |}];
  let variablesConverterMap = ();
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%bs.raw
  {| (function(){
var v0 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v1 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "onlineStatus",
  "args": null,
  "storageKey": null
},
v2 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "firstName",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestFragmentQuery",
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
            "name": "TestFragment_user",
            "args": null
          }
        ]
      },
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "users",
        "storageKey": null,
        "args": null,
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
                  (v0/*: any*/),
                  (v1/*: any*/),
                  {
                    "kind": "FragmentSpread",
                    "name": "TestFragment_plural_user",
                    "args": null
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestFragmentQuery",
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
          (v2/*: any*/),
          (v1/*: any*/),
          (v0/*: any*/)
        ]
      },
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "users",
        "storageKey": null,
        "args": null,
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
                  (v0/*: any*/),
                  (v1/*: any*/),
                  (v2/*: any*/)
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
    "name": "TestFragmentQuery",
    "id": null,
    "text": "query TestFragmentQuery {\n  loggedInUser {\n    ...TestFragment_user\n    id\n  }\n  users {\n    edges {\n      node {\n        id\n        onlineStatus\n        ...TestFragment_plural_user\n      }\n    }\n  }\n}\n\nfragment TestFragment_plural_user on User {\n  id\n  firstName\n  onlineStatus\n}\n\nfragment TestFragment_user on User {\n  firstName\n  onlineStatus\n}\n",
    "metadata": {}
  }
};
})() |}
];
