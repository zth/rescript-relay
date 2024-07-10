/* @sourceLoc UserAvatar.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec fragment_UserName_user = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #UserName_user]>,
  }
  type fragment = {
    @as("UserName_user") userName_user: fragment_UserName_user,
    avatarUrl: option<string>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"UserName_user":{"f":""}}}`
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
  RescriptRelay.fragmentRefs<[> | #UserAvatar_user]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>



module CodesplitComponents = {
  module UserName = {
    let make = React.lazy_(() => Js.import(UserName.make))
  }
}

let node: operationType = %raw(json` {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "UserAvatar_user",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "avatarUrl",
      "storageKey": null
    },
    {
      "fragment": {
        "args": null,
        "kind": "FragmentSpread",
        "name": "UserName_user"
      },
      "kind": "AliasedFragmentSpread",
      "name": "UserName_user",
      "type": "User",
      "abstractKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
} `)

