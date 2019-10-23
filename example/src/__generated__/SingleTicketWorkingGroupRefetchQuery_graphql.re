type response = {
  .
  "node":
    Js.Nullable.t({
      .
      "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": SingleTicketWorkingGroup_workingGroup_graphql.t,
    }),
};
type refetchVariables = {
  .
  "id": option(string),
  "includeMembers": option(bool),
};
let makeRefetchVariables = (~id=?, ~includeMembers=?, ()): refetchVariables => {
  "id": id,
  "includeMembers": includeMembers,
};
type variables = {
  .
  "id": string,
  "includeMembers": bool,
};
type operationType = ReasonRelay.queryNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
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
    "text": "query SingleTicketWorkingGroupRefetchQuery(\n  $includeMembers: Boolean! = false\n  $id: ID!\n) {\n  node(id: $id) {\n    __typename\n    ...SingleTicketWorkingGroup_workingGroup_EL0Tc\n    id\n  }\n}\n\nfragment SingleTicketWorkingGroup_workingGroup_EL0Tc on WorkingGroup {\n  name\n  membersConnection @include(if: $includeMembers) {\n    edges {\n      node {\n        id\n        fullName\n        ...Avatar_user\n      }\n    }\n  }\n  id\n}\n\nfragment Avatar_user on User {\n  avatarUrl\n  fullName\n}\n",
    "metadata": {
      "derivedFrom": "SingleTicketWorkingGroup_workingGroup",
      "isRefetchableQuery": true
    }
  }
};
})() |}
];
