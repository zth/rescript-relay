/* @sourceLoc Test_updatableQuery.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_user_bestFriend = {
    mutable firstName: string,
  }
  and response_user = {
    mutable firstName: string,
    mutable isOnline: Nullable.t<bool>,
    bestFriend: Nullable.t<response_user_bestFriend>,
  }
  type response = {
    user: Nullable.t<response_user>,
  }
  @live
  type variables = {
    @live id: string,
  }
}


type queryRef

module Internal = {
  @live
  let variablesConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    None
  )
}


type relayOperationNode

type updatableData = {updatableData: Types.response}

@send external readUpdatableQuery: (RescriptRelay.RecordSourceSelectorProxy.t, ~node: RescriptRelay.queryNode<relayOperationNode>, ~variables: Types.variables) => updatableData = "readUpdatableQuery"
module Utils = {
  @@warning("-33")
  open Types
}
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "id"
      }
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestUpdatableQuery_UpdatableQuery",
    "selections": [
      {
        "alias": null,
        "args": [
          {
            "kind": "Variable",
            "name": "id",
            "variableName": "id"
          }
        ],
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "user",
        "plural": false,
        "selections": [
          (v0/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "isOnline",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "concreteType": "User",
            "kind": "LinkedField",
            "name": "bestFriend",
            "plural": false,
            "selections": [
              (v0/*: any*/)
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "UpdatableQuery"
};
})() `)


let readUpdatableQuery = (store, variables: Types.variables) => store->readUpdatableQuery(~node, ~variables=Internal.convertVariables(variables))

