/* @generated */

module Types = {
  type response_node = {
    getFragmentRefs:
      unit =>
      {
        .
        "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": SingleTicketWorkingGroup_workingGroup_graphql.t,
      },
  };

  type response = {node: option(response_node)};
  type refetchVariables = {
    includeMembers: option(bool),
    id: option(string),
  };
  let makeRefetchVariables = (~includeMembers=?, ~id=?, ()): refetchVariables => {
    includeMembers,
    id,
  };
  type variables = {
    includeMembers: bool,
    id: string,
  };
};

module Internal = {
  type responseRaw;
  let responseConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"node":{"n":"","f":""}}} |json}
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

module Utils = {
  open Types;
  let makeVariables = (~includeMembers, ~id): variables => {
    includeMembers,
    id,
  };
};

type operationType = ReasonRelay.queryNode;

let node: operationType = [%raw
  {json| (function(){
var v0 = [
  {
    "kind": "LocalArgument",
    "name": "includeMembers",
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
  "name": "id",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Request",
  "fragment": {
    "kind": "Fragment",
    "name": "SingleTicketWorkingGroupRefetchQuery",
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
            "name": "SingleTicketWorkingGroup_workingGroup",
            "args": [
              {
                "kind": "Variable",
                "name": "includeMembers",
                "variableName": "includeMembers"
              }
            ]
          }
        ]
      }
    ]
  },
  "operation": {
    "kind": "Operation",
    "name": "SingleTicketWorkingGroupRefetchQuery",
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
            "kind": "ScalarField",
            "alias": null,
            "name": "__typename",
            "args": null,
            "storageKey": null
          },
          (v2/*: any*/),
          {
            "kind": "InlineFragment",
            "type": "WorkingGroup",
            "selections": [
              {
                "kind": "ScalarField",
                "alias": null,
                "name": "name",
                "args": null,
                "storageKey": null
              },
              {
                "kind": "Condition",
                "passingValue": true,
                "condition": "includeMembers",
                "selections": [
                  {
                    "kind": "LinkedField",
                    "alias": null,
                    "name": "membersConnection",
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
                              (v2/*: any*/),
                              {
                                "kind": "ScalarField",
                                "alias": null,
                                "name": "fullName",
                                "args": null,
                                "storageKey": null
                              },
                              {
                                "kind": "ScalarField",
                                "alias": null,
                                "name": "avatarUrl",
                                "args": null,
                                "storageKey": null
                              }
                            ]
                          }
                        ]
                      }
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
  "params": {
    "operationKind": "query",
    "name": "SingleTicketWorkingGroupRefetchQuery",
    "id": null,
    "text": "query SingleTicketWorkingGroupRefetchQuery(\n  $includeMembers: Boolean! = false\n  $id: ID!\n) {\n  node(id: $id) {\n    __typename\n    ...SingleTicketWorkingGroup_workingGroup_EL0Tc\n    id\n  }\n}\n\nfragment Avatar_user on User {\n  avatarUrl\n  fullName\n}\n\nfragment SingleTicketWorkingGroup_workingGroup_EL0Tc on WorkingGroup {\n  name\n  membersConnection @include(if: $includeMembers) {\n    edges {\n      node {\n        id\n        fullName\n        ...Avatar_user\n      }\n    }\n  }\n  id\n}\n",
    "metadata": {
      "derivedFrom": "SingleTicketWorkingGroup_workingGroup",
      "isRefetchableQuery": true
    }
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
