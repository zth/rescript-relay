/* @generated */

module Types = {
  type fragment_membersConnection_edges_node = {
    id: string,
    fullName: string,
    getFragmentRefs:
      unit => {. "__$fragment_ref__Avatar_user": Avatar_user_graphql.t},
  };
  type fragment_membersConnection_edges = {
    node: option(fragment_membersConnection_edges_node),
  };
  type fragment_membersConnection = {
    edges: option(array(option(fragment_membersConnection_edges))),
  };

  type fragment = {
    name: string,
    membersConnection: option(fragment_membersConnection),
    id: option(string),
  };
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"membersConnection":{"n":""},"membersConnection_edges":{"n":"","na":""},"membersConnection_edges_node":{"n":"","f":""},"id":{"n":""}}} |json}
  ];
  let fragmentConverterMap = ();
  let convertFragment = v =>
    v
    ->ReasonRelay._convertObj(
        fragmentConverter,
        fragmentConverterMap,
        Js.undefined,
      );
};

type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%raw
  {json| (function(){
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
})() |json}
];
