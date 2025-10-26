/* @sourceLoc Test_catch.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type fragment_t = 
    | @live Group(
      {
        @live id: string,
        name: string,
      }
    )
    | @live User(
      {
        createdAt: TestsUtils.Datetime.t,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  type fragment = RescriptRelay.CatchResult.t<fragment_t>
}

@live
let unwrap_fragment_t: Types.fragment_t => Types.fragment_t = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_fragment_t: Types.fragment_t => Types.fragment_t = RescriptRelay_Internal.wrapUnion
module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: dict<dict<dict<string>>> = %raw(
    json`{"__root":{"value_User_createdAt":{"c":"TestsUtils.Datetime"},"value":{"u":"fragment_t"}}}`
  )
  @live
  let fragmentConverterMap = {
    "TestsUtils.Datetime": TestsUtils.Datetime.parse,
    "fragment_t": unwrap_fragment_t,
  }
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
  RescriptRelay.fragmentRefs<[> | #TestCatchUnionMember_member]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": {
    "catchTo": "RESULT"
  },
  "name": "TestCatchUnionMember_member",
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
        (v0/*: any*/),
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
        (v0/*: any*/),
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
  "type": "Member",
  "abstractKey": "__isMember"
};
})() `)

