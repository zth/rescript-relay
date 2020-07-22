/* @generated */

module Types = {
  type response_member = {
    __typename: string,
    getFragmentRef_TestUnionFragment_member:
      unit => TestUnionFragment_member_graphql.t,
    getFragmentRef_TestUnionFragment_plural_member:
      unit => TestUnionFragment_plural_member_graphql.t,
  };

  type response = {member: option(response_member)};
  type rawResponse = response;
  type variables = unit;
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"member":{"n":"","f":"TestUnionFragment_member,TestUnionFragment_plural_member"}}} |json}
  ];
  let responseConverterMap = ();
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  type rawResponseRaw = responseRaw;
  let convertRawResponse = convertResponse;

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {} |json}
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

type preloadToken;

module Utils = {};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%raw
  {json| (function(){
var v0 = [
  {
    "kind": "Literal",
    "name": "id",
    "value": "123"
  }
],
v1 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "__typename",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "TestUnionFragmentQuery",
    "type": "Query",
    "metadata": null,
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "member",
        "storageKey": "member(id:\"123\")",
        "args": (v0/*: any*/),
        "concreteType": null,
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "kind": "FragmentSpread",
            "name": "TestUnionFragment_member",
            "args": null
          },
          {
            "kind": "FragmentSpread",
            "name": "TestUnionFragment_plural_member",
            "args": null
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "TestUnionFragmentQuery",
    "argumentDefinitions": [],
    "selections": [
      {
        "kind": "LinkedField",
        "alias": null,
        "name": "member",
        "storageKey": "member(id:\"123\")",
        "args": (v0/*: any*/),
        "concreteType": null,
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "kind": "ScalarField",
            "alias": null,
            "name": "id",
            "args": null,
            "storageKey": null
          },
          {
            "kind": "InlineFragment",
            "type": "User",
            "selections": [
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
              }
            ]
          }
        ]
      }
    ]
  },
  "params": {
    "operationKind": "query",
    "name": "TestUnionFragmentQuery",
    "id": null,
    "text": "query TestUnionFragmentQuery {\n  member(id: \"123\") {\n    __typename\n    ...TestUnionFragment_member\n    ...TestUnionFragment_plural_member\n    ... on Node {\n      id\n    }\n  }\n}\n\nfragment TestUnionFragment_member on Member {\n  __typename\n  ... on User {\n    firstName\n    onlineStatus\n  }\n  ... on Group {\n    name\n  }\n}\n\nfragment TestUnionFragment_plural_member on Member {\n  __typename\n  ... on User {\n    firstName\n    onlineStatus\n  }\n  ... on Group {\n    name\n  }\n}\n",
    "metadata": {}
  }
};
})() |json}
];

include ReasonRelay.MakePreloadQuery({
  type variables = Types.variables;
  type queryPreloadToken = preloadToken;
  let query = node;
  let convertVariables = Internal.convertVariables;
});
