/* @generated */

module Unions = {};

module Types = {
  type loggedInUser;
};

open Types;

type response = {loggedInUser};
type variables = unit;

module FragmentConverters: {
  let unwrapFragment_loggedInUser:
    loggedInUser =>
    {. "__$fragment_ref__TestMutation_user": TestMutation_user_graphql.t};
} = {
  external unwrapFragment_loggedInUser:
    loggedInUser =>
    {. "__$fragment_ref__TestMutation_user": TestMutation_user_graphql.t} =
    "%identity";
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(array((int, string))) = [%raw {| {} |}];
  let responseConverterMap = ();
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

module Utils = {};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%bs.raw
  {| {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestMutationQuery",
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
            "name": "TestMutation_user",
            "args": null
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestMutationQuery",
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
            "name": "firstName",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "onlineStatus",
            "args": null,
            "storageKey": null
          }
        ]
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "TestMutationQuery",
    "id": null,
    "text": "query TestMutationQuery {\n  loggedInUser {\n    ...TestMutation_user\n    id\n  }\n}\n\nfragment TestMutation_user on User {\n  id\n  firstName\n  onlineStatus\n}\n",
    "metadata": {}
  }
} |}
];
