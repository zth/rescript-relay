/* @sourceLoc Test_conversionPlural.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type fragment_t = 
    | @live Group(
      {
        name: string,
      }
    )
    | @live User(
      {
        createdAt: TestsUtils.Datetime.t,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  type fragment = array<RescriptRelay.CatchResult.t<fragment_t>>
}

@live
let unwrap_fragment_t: Types.fragment_t => Types.fragment_t = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_fragment_t: Types.fragment_t => Types.fragment_t = RescriptRelay_Internal.wrapUnion
module Internal = {
  @live
  type fragmentRaw
  %%private(
  @live
  let fragmentConverter: JSON.t = %raw(json`{"roots":{"__root":[{"path":["value"],"union":"1"},{"path":["value","User","createdAt"],"scalar":"0"}]},"version":2}`)
  @live
  let fragmentCallbacks = {
    "0": TestsUtils.Datetime.parse,
    "1": unwrap_fragment_t,
  }
  @live
  let preparedFragmentConverter = RescriptRelay.prepareConversion(
    fragmentConverter,
    fragmentCallbacks,
    None
  )
  )
  @live
  let convertFragment = value => RescriptRelay.runConversion(preparedFragmentConverter, value)
}

type t
type fragmentRef
external getFragmentRef:
  array<RescriptRelay.fragmentRefs<[> | #TestConversionPluralNode_node]>> => fragmentRef = "%identity"

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
    "plural": true,
    "catchTo": "RESULT"
  },
  "name": "TestConversionPluralNode_node",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "__typename",
      "storageKey": null
    },
    {
      "kind": "InlineFragment",
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
    },
    {
      "kind": "InlineFragment",
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "name",
          "storageKey": null
        }
      ],
      "type": "Group",
      "abstractKey": null
    }
  ],
  "type": "Node",
  "abstractKey": "__isNode"
} `)

