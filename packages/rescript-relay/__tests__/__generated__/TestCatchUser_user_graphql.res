/* @sourceLoc Test_catch.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment_t = {
    createdAt: TestsUtils.Datetime.t,
  }
  type fragment = RescriptRelay.CatchResult.t<fragment_t>
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"value_createdAt":{"c":"TestsUtils.Datetime"}}}`
  )
  @live
  let fragmentConverterMap = {
    "TestsUtils.Datetime": TestsUtils.Datetime.parse,
  }
  @live
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    Js.undefined
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #TestCatchUser_user]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": {
    "catchTo": "RESULT"
  },
  "name": "TestCatchUser_user",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "createdAt",
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
} `)

