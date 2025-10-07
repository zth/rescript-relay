/* @sourceLoc Test_localPayload.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type fragment_memberOf_Group_topMember = 
    | @live User(
      {
        firstName: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type fragment_memberOf = 
    | @live Group(
      {
        name: string,
        topMember: option<fragment_memberOf_Group_topMember>,
      }
    )
    | @live User(
      {
        firstName: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type fragment_memberOfSingular = 
    | @live Group(
      {
        name: string,
      }
    )
    | @live User(
      {
        firstName: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  type fragment = {
    avatarUrl: option<string>,
    firstName: string,
    memberOf: option<array<option<fragment_memberOf>>>,
    memberOfSingular: option<fragment_memberOfSingular>,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
  }
}

@live
let unwrap_fragment_memberOf_Group_topMember: Types.fragment_memberOf_Group_topMember => Types.fragment_memberOf_Group_topMember = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_fragment_memberOf_Group_topMember: Types.fragment_memberOf_Group_topMember => Types.fragment_memberOf_Group_topMember = RescriptRelay_Internal.wrapUnion
@live
let unwrap_fragment_memberOf: Types.fragment_memberOf => Types.fragment_memberOf = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_fragment_memberOf: Types.fragment_memberOf => Types.fragment_memberOf = RescriptRelay_Internal.wrapUnion
@live
let unwrap_fragment_memberOfSingular: Types.fragment_memberOfSingular => Types.fragment_memberOfSingular = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_fragment_memberOfSingular: Types.fragment_memberOfSingular => Types.fragment_memberOfSingular = RescriptRelay_Internal.wrapUnion
module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"memberOf_Group_topMember":{"u":"fragment_memberOf_Group_topMember"},"memberOfSingular":{"u":"fragment_memberOfSingular"},"memberOf":{"u":"fragment_memberOf"}}}`
  )
  @live
  let fragmentConverterMap = {
    "fragment_memberOf_Group_topMember": unwrap_fragment_memberOf_Group_topMember,
    "fragment_memberOf": unwrap_fragment_memberOf,
    "fragment_memberOfSingular": unwrap_fragment_memberOfSingular,
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
  RescriptRelay.fragmentRefs<[> | #TestLocalPayload_user]> => fragmentRef = "%identity"

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


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "name",
  "storageKey": null
},
v3 = {
  "kind": "InlineFragment",
  "selections": [
    (v0/*: any*/)
  ],
  "type": "User",
  "abstractKey": null
};
return {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestLocalPayload_user",
  "selections": [
    (v0/*: any*/),
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "avatarUrl",
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
        (v1/*: any*/),
        {
          "kind": "InlineFragment",
          "selections": [
            (v2/*: any*/),
            {
              "alias": null,
              "args": null,
              "concreteType": null,
              "kind": "LinkedField",
              "name": "topMember",
              "plural": false,
              "selections": [
                (v1/*: any*/),
                (v3/*: any*/)
              ],
              "storageKey": null
            }
          ],
          "type": "Group",
          "abstractKey": null
        },
        (v3/*: any*/)
      ],
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "concreteType": null,
      "kind": "LinkedField",
      "name": "memberOfSingular",
      "plural": false,
      "selections": [
        (v1/*: any*/),
        {
          "kind": "InlineFragment",
          "selections": [
            (v2/*: any*/)
          ],
          "type": "Group",
          "abstractKey": null
        },
        (v3/*: any*/)
      ],
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
};
})() `)

