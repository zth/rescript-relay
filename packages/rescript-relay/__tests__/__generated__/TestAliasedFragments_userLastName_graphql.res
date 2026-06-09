/* @sourceLoc Test_aliasedFragments.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment = {
    lastName: string,
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
  RescriptRelay.fragmentRefs<[> | #TestAliasedFragments_userLastName]> => fragmentRef = "%identity"

module Test = {
  let fromData = (data: Types.fragment): RescriptRelay.fragmentRefs<[> | #TestAliasedFragments_userLastName]> =>
    RescriptRelay_TestFragmentRef.make("TestAliasedFragments_userLastName", data)
}

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestAliasedFragments_userLastName",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "lastName",
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
} `)

