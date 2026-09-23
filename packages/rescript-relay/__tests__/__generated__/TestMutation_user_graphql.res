/* @sourceLoc Test_mutation.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type fragment_memberOf = 
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
    firstName: string,
    @live id: string,
    lastName: string,
    memberOf: option<array<option<fragment_memberOf>>>,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
  }
}

@live
let unwrap_fragment_memberOf: Types.fragment_memberOf => Types.fragment_memberOf = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_fragment_memberOf: Types.fragment_memberOf => Types.fragment_memberOf = RescriptRelay_Internal.wrapUnion
module Internal = {
  @live
  type fragmentRaw
  %%private(
  @live
  let fragmentConverter: JSON.t = %raw(json`{"roots":{"__root":[{"list":1,"path":["memberOf"],"union":"0"}]},"version":2}`)
  @live
  let fragmentCallbacks = {
    "0": unwrap_fragment_memberOf,
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
  RescriptRelay.fragmentRefs<[> | #TestMutation_user]> => fragmentRef = "%identity"

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

