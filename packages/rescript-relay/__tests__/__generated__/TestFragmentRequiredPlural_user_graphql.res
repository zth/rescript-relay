/* @sourceLoc Test_fragment_required.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment_t = {
    onlineStatus: RelaySchemaAssets_graphql.enum_OnlineStatus,
  }
  type fragment = array<option<fragment_t>>
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
  array<RescriptRelay.fragmentRefs<[> | #TestFragmentRequiredPlural_user]>> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
  @live
  external onlineStatus_toString: RelaySchemaAssets_graphql.enum_OnlineStatus => string = "%identity"
  @live
  external onlineStatus_input_toString: RelaySchemaAssets_graphql.enum_OnlineStatus_input => string = "%identity"
  @live
  let onlineStatus_decode = (enum: RelaySchemaAssets_graphql.enum_OnlineStatus): option<RelaySchemaAssets_graphql.enum_OnlineStatus_input> => {
    switch enum {
      | FutureAddedValue(_) => None
      | valid => Some(Obj.magic(valid))
    }
  }
  @live
  let onlineStatus_fromString = (str: string): option<RelaySchemaAssets_graphql.enum_OnlineStatus_input> => {
    onlineStatus_decode(Obj.magic(str))
  }
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": {
    "plural": true
  },
  "name": "TestFragmentRequiredPlural_user",
  "selections": [
    {
      "kind": "RequiredField",
      "field": {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "onlineStatus",
        "storageKey": null
      },
      "action": "NONE"
    }
  ],
  "type": "User",
  "abstractKey": null
} `)

