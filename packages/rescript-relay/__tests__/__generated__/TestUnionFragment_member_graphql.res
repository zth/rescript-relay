/* @sourceLoc Test_unionFragment.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type enum_OnlineStatus = RelaySchemaAssets_graphql.enum_OnlineStatus

  type enum_OnlineStatus_input = RelaySchemaAssets_graphql.enum_OnlineStatus_input



  type rec fragment_Group = {
    @live __typename: [ | #Group],
    name: string,
  }
  and fragment_User = {
    @live __typename: [ | #User],
    firstName: string,
    onlineStatus: option<enum_OnlineStatus>,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestUnionFragmentUser_user]>,
  }
  type fragment = [
    | #Group(fragment_Group)
    | #User(fragment_User)
    | #UnselectedUnionMember(string)
  ]

}

@live
let unwrap_fragment: {. "__typename": string } => [
  | #Group(Types.fragment_Group)
  | #User(Types.fragment_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "Group" => #Group(u->Obj.magic)
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_fragment: [
  | #Group(Types.fragment_Group)
  | #User(Types.fragment_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #Group(v) => v->Obj.magic
  | #User(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"User":{"f":""},"":{"u":"fragment"}}}`
  )
  @live
  let fragmentConverterMap = {
    "fragment": unwrap_fragment,
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
  RescriptRelay.fragmentRefs<[> | #TestUnionFragment_member]> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live
  external onlineStatus_toString: RelaySchemaAssets_graphql.enum_OnlineStatus => string = "%identity"
  @live
  external onlineStatus_input_toString: RelaySchemaAssets_graphql.enum_OnlineStatus_input => string = "%identity"
  @live
  let onlineStatus_decode = (enum: RelaySchemaAssets_graphql.enum_OnlineStatus): option<RelaySchemaAssets_graphql.enum_OnlineStatus_input> => {
    switch enum {
      | #...RelaySchemaAssets_graphql.enum_OnlineStatus_input as valid => Some(valid)
      | _ => None
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
  "metadata": null,
  "name": "TestUnionFragment_member",
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
          "name": "firstName",
          "storageKey": null
        },
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "onlineStatus",
          "storageKey": null
        },
        {
          "args": null,
          "kind": "FragmentSpread",
          "name": "TestUnionFragmentUser_user"
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
  "type": "Member",
  "abstractKey": "__isMember"
} `)

