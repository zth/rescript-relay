/* @sourceLoc Test_updatableFragments.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_loggedInUser_bestFriend = {
    firstName: string,
  }
  and fragment_loggedInUser = {
    updatableFragmentRefs: RescriptRelay.updatableFragmentRefs<[ | #TestUpdatableFragments_updatableUser]>,
    bestFriend: option<fragment_loggedInUser_bestFriend>,
    firstName: string,
    isOnline: option<bool>,
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
    json`{"__root":{"loggedInUser":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #TestUpdatableFragments_query]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
};
return {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestUpdatableFragments_query",
  "selections": [
    {
      "alias": null,
      "args": null,
      "concreteType": "User",
      "kind": "LinkedField",
      "name": "loggedInUser",
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
          "args": null,
          "kind": "FragmentSpread",
          "name": "TestUpdatableFragments_updatableUser"
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
};
})() `)

