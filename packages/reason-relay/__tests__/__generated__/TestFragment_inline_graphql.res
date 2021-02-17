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
  firstName: string,
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
  ReasonRelay.fragmentRefs<[> | #TestFragment_inline]> => fragmentRef = "%identity"


module Utils = {
external onlineStatus_toString:
  Types.enum_OnlineStatus => string = "%identity"
}

type relayOperationNode
type operationType = ReasonRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "kind": "InlineDataFragment",
  "name": "TestFragment_inline"
} `)


