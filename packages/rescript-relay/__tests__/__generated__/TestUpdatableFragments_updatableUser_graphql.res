/* @sourceLoc Test_updatableFragments.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_bestFriend = {
    mutable firstName: string,
  }
  type fragment = {
    mutable firstName: string,
    mutable isOnline: Nullable.t<bool>,
    bestFriend: Nullable.t<fragment_bestFriend>,
  }
}

module Internal = {
}


type relayOperationNode

type updatableData = {updatableData: Types.fragment}

@send external readUpdatableFragment: (RescriptRelay.RecordSourceSelectorProxy.t, ~node: RescriptRelay.fragmentNode<relayOperationNode>, ~fragmentRefs: RescriptRelay.updatableFragmentRefs<[> | #TestUpdatableFragments_updatableUser]>) => updatableData = "readUpdatableFragment"
module Utils = {
  @@warning("-33")
  open Types
}

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
  "name": "TestUpdatableFragments_updatableUser",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "isOnline",
      "storageKey": null
    },
    (v0/*: any*/),
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
  "type": "User",
  "abstractKey": null
};
})() `)


let readUpdatableFragment = (store, fragmentRefs) => store->readUpdatableFragment(~node, ~fragmentRefs)

