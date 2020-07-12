/* @generated */

module Types = {
  type response_member_User = {createdAt: TestsUtils.Datetime.t};
  type response_member = [
    | `User(response_member_User)
    | `UnselectedUnionMember(string)
  ];
  type response_loggedInUser_friends = {createdAt: TestsUtils.Datetime.t};
  type response_loggedInUser = {
    createdAt: TestsUtils.Datetime.t,
    friends: array(response_loggedInUser_friends),
  };

  type response = {
    loggedInUser: response_loggedInUser,
    member:
      option(
        [ | `User(response_member_User) | `UnselectedUnionMember(string)],
      ),
  };
  type refetchVariables = {beforeDate: option(TestsUtils.Datetime.t)};
  let makeRefetchVariables = (~beforeDate=?, ()): refetchVariables => {
    beforeDate: beforeDate,
  };
  type variables = {beforeDate: option(TestsUtils.Datetime.t)};
};

let unwrap_response_member:
  {. "__typename": string} =>
  [ | `User(Types.response_member_User) | `UnselectedUnionMember(string)] =
  u =>
    switch (u##__typename) {
    | "User" => `User(u->Obj.magic)
    | v => `UnselectedUnionMember(v)
    };

let wrap_response_member:
  [ | `User(Types.response_member_User) | `UnselectedUnionMember(string)] =>
  {. "__typename": string} =
  fun
  | `User(v) => v->Obj.magic
  | `UnselectedUnionMember(v) => {"__typename": v};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"loggedInUser_createdAt":{"c":"TestsUtils.Datetime"},"loggedInUser_friends_createdAt":{"c":"TestsUtils.Datetime"},"member":{"n":"","u":"response_member"},"member_user_createdAt":{"c":"TestsUtils.Datetime"}}} |json}
  ];
  let responseConverterMap = {
    "TestsUtils.Datetime": TestsUtils.Datetime.parse,
    "response_member": unwrap_response_member,
  };
  let convertResponse = v =>
    v
    ->ReasonRelay._convertObj(
        responseConverter,
        responseConverterMap,
        Js.undefined,
      );

  let variablesConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"beforeDate":{"n":"","c":"TestsUtils.Datetime"}}} |json}
  ];
  let variablesConverterMap = {
    "TestsUtils.Datetime": TestsUtils.Datetime.serialize,
  };
  let convertVariables = v =>
    v
    ->ReasonRelay._convertObj(
        variablesConverter,
        variablesConverterMap,
        Js.undefined,
      );
};

type preloadToken;

module Utils = {
  open Types;
  let makeVariables = (~beforeDate=?, ()): variables => {
    beforeDate: beforeDate,
  };
};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%raw
  {json| (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "beforeDate",
    "type": "Datetime"
  }
],
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "createdAt",
  "storageKey": null
},
v2 = [
  {
    "kind": "Variable",
    "name": "beforeDate",
    "variableName": "beforeDate"
  }
],
v3 = [
  (v1/*: any*/)
],
v4 = [
  {
    "kind": "Literal",
    "name": "id",
    "value": "user-1"
  }
],
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v6 = {
  "kind": "InlineFragment",
  "selections": (v3/*: any*/),
  "type": "User"
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestCustomScalarsQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "alias": null,
            "args": (v2/*: any*/),
            "concreteType": "User",
            "kind": "LinkedField",
            "name": "friends",
            "plural": true,
            "selections": (v3/*: any*/),
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": (v4/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "member",
        "plural": false,
        "selections": [
          (v5/*: any*/),
          (v6/*: any*/)
        ],
        "storageKey": "member(id:\"user-1\")"
      }
    ],
    "type": "Query"
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestCustomScalarsQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "alias": null,
            "args": (v2/*: any*/),
            "concreteType": "User",
            "kind": "LinkedField",
            "name": "friends",
            "plural": true,
            "selections": [
              (v1/*: any*/),
              (v7/*: any*/)
            ],
            "storageKey": null
          },
          (v7/*: any*/)
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": (v4/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "member",
        "plural": false,
        "selections": [
          (v5/*: any*/),
          (v7/*: any*/),
          (v6/*: any*/)
        ],
        "storageKey": "member(id:\"user-1\")"
      }
    ]
  },
  "params": {
    "id": null,
    "metadata": {},
    "name": "TestCustomScalarsQuery",
    "operationKind": "query",
    "text": "query TestCustomScalarsQuery(\n  $beforeDate: Datetime\n) {\n  loggedInUser {\n    createdAt\n    friends(beforeDate: $beforeDate) {\n      createdAt\n      id\n    }\n    id\n  }\n  member(id: \"user-1\") {\n    __typename\n    ... on User {\n      createdAt\n    }\n    ... on Node {\n      id\n    }\n  }\n}\n"
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
