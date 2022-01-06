/* @sourceLoc Test_unionFragment.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type enum_OnlineStatus = private [>
      | #Online
      | #Idle
      | #Offline
    ]

  type enum_OnlineStatus_input = [
      | #Online
      | #Idle
      | #Offline
    ]



  type rec fragment_User = {
    __typename: [ | #User],
    firstName: string,
    onlineStatus: option<enum_OnlineStatus>,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestUnionFragmentUser_user]>,
  }
  and fragment_Group = {
    __typename: [ | #Group],
    name: string,
  }
  type fragment_t = [
    | #User(fragment_User)
    | #Group(fragment_Group)
    | #UnselectedUnionMember(string)
  ]

  type fragment = array<fragment_t>
}

let unwrap_fragment: {. "__typename": string } => [
  | #User(Types.fragment_User)
  | #Group(Types.fragment_Group)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | "Group" => #Group(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

let wrap_fragment: [
  | #User(Types.fragment_User)
  | #Group(Types.fragment_Group)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #Group(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
module Internal = {
  type fragmentRaw
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"User":{"f":""},"":{"u":"fragment"}}}`
  )
  let fragmentConverterMap = {
    "fragment": unwrap_fragment,
  }
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    Js.undefined
  )
}

type t
type fragmentRef
external getFragmentRef:
  array<RescriptRelay.fragmentRefs<[> | #TestUnionFragment_plural_member]>> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  let onlineStatus_decode = (enum: enum_OnlineStatus): option<enum_OnlineStatus_input> => {
    switch enum {
      | #...enum_OnlineStatus_input as valid => Some(valid)
      | _ => None
    }
  }
  let onlineStatus_fromString = (str: string): option<enum_OnlineStatus_input> => {
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
  "name": "TestUnionFragment_plural_member",
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

