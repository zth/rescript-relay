/* @sourceLoc RelayUserMetaModel.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment = unit
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: JSON.t = %raw(
    json`{"roots":{"__root":[]},"version":2}`
  )
  @live
  let fragmentConverterMap = ()
  @live
  let preparedFragmentConverter = RescriptRelay.prepareConversion(
    fragmentConverter,
    fragmentConverterMap,
    None
  )
  @live
  let convertFragment = value => RescriptRelay.runConversion(preparedFragmentConverter, value)
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #UserMeta____relay_model_instance]> => fragmentRef = "%identity"

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
  "name": "UserMeta____relay_model_instance",
  "selections": [
    {
      "kind": "ClientExtension",
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "__relay_model_instance",
          "storageKey": null
        }
      ]
    }
  ],
  "type": "UserMeta",
  "abstractKey": null
} `)

