/* @sourceLoc Test_refetchingRecord.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_loggedInUser = {
    @live id: string,
  }
  type fragment = {
    loggedInUser: fragment_loggedInUser,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let fragmentConverterMap = ()
  @live
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    None
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #TestRefetchingRecordNoArgs_query]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (rescript_graphql_node_TestRefetchingRecordNoArgsRefetchQuery): operationType => {
  ignore(rescript_graphql_node_TestRefetchingRecordNoArgsRefetchQuery)
  %raw(json`{
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": {
    "refetch": {
      "connection": null,
      "fragmentPathInResult": [],
      "operation": rescript_graphql_node_TestRefetchingRecordNoArgsRefetchQuery
    }
  },
  "name": "TestRefetchingRecordNoArgs_query",
  "selections": [
    {
      "alias": null,
      "args": null,
      "concreteType": "User",
      "kind": "LinkedField",
      "name": "loggedInUser",
      "plural": false,
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "id",
          "storageKey": null
        }
      ],
      "storageKey": null
    }
  ],
  "type": "Query",
  "abstractKey": null
}`)
})
let node: operationType = makeNode(TestRefetchingRecordNoArgsRefetchQuery_graphql.node)

