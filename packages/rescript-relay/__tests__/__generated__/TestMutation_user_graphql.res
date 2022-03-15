/* @sourceLoc Test_mutation.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type enum_OnlineStatus = private [>
      | #Idle
      | #Offline
      | #Online
    ]

  @live
  type enum_OnlineStatus_input = [
      | #Idle
      | #Offline
      | #Online
    ]



  type rec fragment_memberOf_Group = {
    @live __typename: [ | #Group],
    name: string,
  }
  and fragment_memberOf_User = {
    @live __typename: [ | #User],
    firstName: string,
  }
  and fragment_memberOf = [
    | #Group(fragment_memberOf_Group)
    | #User(fragment_memberOf_User)
    | #UnselectedUnionMember(string)
  ]

  type fragment = {
    firstName: string,
    @live id: string,
    lastName: string,
    memberOf: option<array<option<fragment_memberOf>>>,
    onlineStatus: option<enum_OnlineStatus>,
  }
}

@live
let unwrap_fragment_memberOf: {. "__typename": string } => [
  | #Group(Types.fragment_memberOf_Group)
  | #User(Types.fragment_memberOf_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "Group" => #Group(u->Obj.magic)
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_fragment_memberOf: [
  | #Group(Types.fragment_memberOf_Group)
  | #User(Types.fragment_memberOf_User)
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
    json`{"__root":{"memberOf":{"u":"fragment_memberOf"}}}`
  )
  @live
  let fragmentConverterMap = {
    "fragment_memberOf": unwrap_fragment_memberOf,
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
  RescriptRelay.fragmentRefs<[> | #TestMutation_user]> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  @live
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  @live
  let onlineStatus_decode = (enum: enum_OnlineStatus): option<enum_OnlineStatus_input> => {
    switch enum {
      | #...enum_OnlineStatus_input as valid => Some(valid)
      | _ => None
    }
  }
  @live
  let onlineStatus_fromString = (str: string): option<enum_OnlineStatus_input> => {
    onlineStatus_decode(Obj.magic(str))
  }
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
};
return {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestMutation_user",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "id",
      "storageKey": null
    },
    (v0/*: any*/),
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "lastName",
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
      "alias": null,
      "args": null,
      "concreteType": null,
      "kind": "LinkedField",
      "name": "memberOf",
      "plural": true,
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
            (v0/*: any*/)
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
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
};
})() `)

