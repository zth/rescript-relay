/* @sourceLoc UserAvatar.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment = {
    @as("UserName_user") userName_user: RescriptRelay.fragmentRefs<[ | #UserName_user]>,
    avatarUrl: option<string>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let convertFragment = value => RescriptRelay.convertWithoutPlan(value, None)
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
    let make = React.lazy_(() => import(UserName.make))
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
        "kind": "InlineFragment",
        "selections": [
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "UserName_user"
          }
        ],
        "type": "User",
        "abstractKey": null
      },
      "kind": "AliasedInlineFragmentSpread",
      "name": "UserName_user"
    }
  ],
  "type": "User",
  "abstractKey": null
} `)

