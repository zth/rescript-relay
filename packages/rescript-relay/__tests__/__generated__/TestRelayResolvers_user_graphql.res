/* @sourceLoc Test_relayResolvers.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type fragment = {
    fullName: option<TestRelayUserResolver.t>,
    isOnline: option<bool>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let fragmentConverterMap = ()
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
  RescriptRelay.fragmentRefs<[> | #TestRelayResolvers_user]> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (rescript_module_TestRelayUserResolver): operationType => {
  ignore(rescript_module_TestRelayUserResolver)
  %raw(json`{
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestRelayResolvers_user",
  "selections": [
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
      "fragment": {
        "args": null,
        "kind": "FragmentSpread",
        "name": "TestRelayUserResolver"
      },
      "kind": "RelayResolver",
      "name": "fullName",
      "resolverModule": rescript_module_TestRelayUserResolver,
      "path": "fullName"
    }
  ],
  "type": "User",
  "abstractKey": null
}`)
})
let node: operationType = makeNode(TestRelayUserResolver.default)

