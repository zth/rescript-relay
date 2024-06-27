/* @sourceLoc Test_relayResolvers.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment = {
    fullName: option<TestRelayUserResolver.t>,
    fullName2: option<string>,
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
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (resolverDataInjector, rescript_module_TestRelayUserResolver_fullName, rescript_module_TestRelayUserResolver2_fullName2): operationType => {
  ignore(resolverDataInjector)
  ignore(rescript_module_TestRelayUserResolver_fullName)
  ignore(rescript_module_TestRelayUserResolver2_fullName2)
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
      "resolverModule": rescript_module_TestRelayUserResolver_fullName,
      "path": "fullName"
    },
    {
      "alias": null,
      "args": [
        {
          "kind": "Literal",
          "name": "maxLength",
          "value": 2
        }
      ],
      "fragment": {
        "args": null,
        "kind": "FragmentSpread",
        "name": "TestRelayUserResolver2"
      },
      "kind": "RelayResolver",
      "name": "fullName2",
      "resolverModule": rescript_module_TestRelayUserResolver2_fullName2,
      "path": "fullName2"
    }
  ],
  "type": "User",
  "abstractKey": null
}`)
})
let node: operationType = makeNode(RescriptRelay.resolverDataInjector, TestRelayUserResolver.fullName, TestRelayUserResolver2.fullName2)

