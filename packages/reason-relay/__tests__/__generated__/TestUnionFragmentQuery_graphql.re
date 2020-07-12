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
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestUnionFragmentQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "member",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestUnionFragment_member"
          },
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestUnionFragment_plural_member"
          }
        ],
        "storageKey": "member(id:\"123\")"
      }
    ],
    "type": "Query"
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestUnionFragmentQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "member",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          },
          {
            "kind": "InlineFragment",
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "firstName",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "onlineStatus",
                "storageKey": null
              }
            ],
            "type": "User"
          },
          {
            "kind": "InlineFragment",
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "name",
                "storageKey": null
              }
            ],
            "type": "Group"
          }
        ],
        "storageKey": "member(id:\"123\")"
      }
    ]
  },
  "params": {
    "id": null,
    "metadata": {},
    "name": "TestUnionFragmentQuery",
    "operationKind": "query",
    "text": "query TestUnionFragmentQuery {\n  member(id: \"123\") {\n    __typename\n    ...TestUnionFragment_member\n    ...TestUnionFragment_plural_member\n    ... on Node {\n      id\n    }\n  }\n}\n\nfragment TestUnionFragment_member on Member {\n  __typename\n  ... on User {\n    firstName\n    onlineStatus\n  }\n  ... on Group {\n    name\n  }\n}\n\nfragment TestUnionFragment_plural_member on Member {\n  __typename\n  ... on User {\n    firstName\n    onlineStatus\n  }\n  ... on Group {\n    name\n  }\n}\n"
  }
};
})() |json}
];

include ReasonRelay.MakePreloadQuery({
  type variables = Types.variables;
  type queryPreloadToken = preloadToken;
  type response = Types.response;
  let query = node;
  let convertVariables = Internal.convertVariables;
});
