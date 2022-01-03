/* @sourceLoc SingleTicketWorkingGroup.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type rec fragment_membersConnection_edges_node = {
    id: string,
    fullName: string,
  }
  and fragment_membersConnection_edges = {
    node: option<fragment_membersConnection_edges_node>,
  }
  and fragment_membersConnection = {
    edges: option<array<option<fragment_membersConnection_edges>>>,
  }
  type fragment = {
    name: string,
    membersConnection: option<fragment_membersConnection>,
    id: string,
  }
}

module Internal = {
  type fragmentRaw
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"membersConnection_edges_node":{"n":""},"membersConnection_edges":{"na":"","n":""},"membersConnection":{"n":""}}}`
  )
  let fragmentConverterMap = ()
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    Js.undefined
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #SingleTicketWorkingGroup_workingGroup]> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (rescript_graphql_node_SingleTicketWorkingGroupRefetchQuery): operationType => {
  ignore(rescript_graphql_node_SingleTicketWorkingGroupRefetchQuery)
  %raw(json`(function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "argumentDefinitions": [
    {
      "defaultValue": false,
      "kind": "LocalArgument",
      "name": "includeMembers"
    }
  ],
  "kind": "Fragment",
  "metadata": {
    "refetch": {
      "connection": null,
      "fragmentPathInResult": [
        "node"
      ],
      "operation": rescript_graphql_node_SingleTicketWorkingGroupRefetchQuery,
      "identifierField": "id"
    }
  },
  "name": "SingleTicketWorkingGroup_workingGroup",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "name",
      "storageKey": null
    },
    {
      "condition": "includeMembers",
      "kind": "Condition",
      "passingValue": true,
      "selections": [
        {
          "alias": null,
          "args": null,
          "concreteType": "UserConnection",
          "kind": "LinkedField",
          "name": "membersConnection",
          "plural": false,
          "selections": [
            {
              "alias": null,
              "args": null,
              "concreteType": "UserEdge",
              "kind": "LinkedField",
              "name": "edges",
              "plural": true,
              "selections": [
                {
                  "alias": null,
                  "args": null,
                  "concreteType": "User",
                  "kind": "LinkedField",
                  "name": "node",
                  "plural": false,
                  "selections": [
                    (v0/*: any*/),
                    {
                      "alias": null,
                      "args": null,
                      "kind": "ScalarField",
                      "name": "fullName",
                      "storageKey": null
                    }
                  ],
                  "storageKey": null
                }
              ],
              "storageKey": null
            }
          ],
          "storageKey": null
        }
      ]
    },
    (v0/*: any*/)
  ],
  "type": "WorkingGroup",
  "abstractKey": null
};
})()`)
})
let node: operationType = makeNode(SingleTicketWorkingGroupRefetchQuery_graphql.node)

