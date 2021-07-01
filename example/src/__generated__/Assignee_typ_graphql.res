/* @sourceLoc Assignee.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")
  
  type fragment_User = {
    id: string,
  }
  
  type fragment_WorkingGroup = {
    name: string,
    id: string,
  }
  
  
  type fragment = [
    | #User(fragment_User)
  
    | #WorkingGroup(fragment_WorkingGroup)
    | #UnselectedUnionMember(string)
  ]
}

let unwrap_fragment: {. "__typename": string } => [
  | #User(Types.fragment_User)

  | #WorkingGroup(Types.fragment_WorkingGroup)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
 | "User" => #User(u->Obj.magic) 
 | "WorkingGroup" => #WorkingGroup(u->Obj.magic) 
 | v => #UnselectedUnionMember(v)
}

let wrap_fragment: [
  | #User(Types.fragment_User)

  | #WorkingGroup(Types.fragment_WorkingGroup)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
 | #User(v) => v->Obj.magic 
 | #WorkingGroup(v) => v->Obj.magic 
 | #UnselectedUnionMember(v) => {"__typename": v} 
}

module Internal = {
  type fragmentRaw
  let fragmentConverter: 
    Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = 
    %raw(
      json`{"__root":{"":{"u":"fragment"}}}`
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
  RescriptRelay.fragmentRefs<[> | #Assignee_typ]> => fragmentRef = "%identity"


module Utils = {

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
  "metadata": null,
  "name": "Assignee_typ",
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
        (v0/*: any*/),
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "name",
          "storageKey": null
        }
      ],
      "type": "WorkingGroup",
      "abstractKey": null
    }
  ],
  "type": "AssigneeType",
  "abstractKey": "__isAssigneeType"
};
})() `)


