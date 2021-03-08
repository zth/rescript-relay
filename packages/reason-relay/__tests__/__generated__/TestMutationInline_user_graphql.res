/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")
  
  type enum_OnlineStatus = private [>
    | #Idle
    | #Offline
    | #Online
  ]
  
  type fragment = {
    id: string,
    firstName: string,
    lastName: string,
    onlineStatus: option<enum_OnlineStatus>,
  }
}

module Internal = {
  type fragmentRaw
  let fragmentConverter: 
    Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = 
    %raw(
      json`{"__root":{"onlineStatus":{"n":""}}}`
    )
  
  let fragmentConverterMap = ()
  let convertFragment = v => v->ReasonRelay.convertObj(
    fragmentConverter, 
    fragmentConverterMap, 
    Js.undefined
  )
}
type t
type fragmentRef
external getFragmentRef:
  ReasonRelay.fragmentRefs<[> | #TestMutationInline_user]> => fragmentRef = "%identity"


module Utils = {
  open Types
  external onlineStatus_toString:
  enum_OnlineStatus => string = "%identity"
}
type relayOperationNode
type operationType = ReasonRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "kind": "InlineDataFragment",
  "name": "TestMutationInline_user"
} `)


