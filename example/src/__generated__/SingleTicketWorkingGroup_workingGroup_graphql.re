type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

type fragment = {
  .
  "id": Js.Nullable.t(string),
  "membersConnection":
    Js.Nullable.t({
      .
      "edges":
        Js.Nullable.t(
          array(
            Js.Nullable.t({
              .
              "node":
                Js.Nullable.t({
                  .
                  "__$fragment_ref__Avatar_user": Avatar_user_graphql.t,
                  "fullName": string,
                  "id": string,
                }),
            }),
          ),
        ),
    }),
  "name": string,
};
type operationType = ReasonRelay.fragmentNode;

module Unions = {};

let node: operationType = [%bs.raw
  {| (function(){
var v0 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
};
return {
  "kind": "Fragment",
  "name": "SingleTicketWorkingGroup_workingGroup",
  "type": "WorkingGroup",
  "metadata": {
    "refetch": {
      "connection": null,
      "operation": require('./SingleTicketWorkingGroupRefetchQuery_graphql.bs.js').node,
      "fragmentPathInResult": [
        "node"
      ]
    }
  },
  "argumentDefinitions": [
    {
      "kind": "LocalArgument",
      "name": "includeMembers",
      "type": "Boolean!",
      "defaultValue": false
    }
  ],
  "selections": [
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "name",
      "args": null,
      "storageKey": null
    },
    (v0/*: any*/),
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
                    (v0/*: any*/),
                    {
                      "kind": "ScalarField",
                      "alias": null,
                      "name": "fullName",
                      "args": null,
                      "storageKey": null
                    },
                    {
                      "kind": "FragmentSpread",
                      "name": "Avatar_user",
                      "args": null
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
};
})() |}
];
