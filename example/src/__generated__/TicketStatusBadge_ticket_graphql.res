/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")
  
  type enum_TicketStatus = private [>
    | #Done
    | #OnHold
    | #Progress
    | #Rejected
  ]
  
  type fragment = {
    status: enum_TicketStatus,
    dbId: string,
  }
}

module Internal = {
  type fragmentRaw
  let fragmentConverter: 
    Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = 
    %raw(
      json`{}`
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
  ReasonRelay.fragmentRefs<[> | #TicketStatusBadge_ticket]> => fragmentRef = "%identity"


module Utils = {
  open Types
  external ticketStatus_toString:
  enum_TicketStatus => string = "%identity"
}
type relayOperationNode
type operationType = ReasonRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TicketStatusBadge_ticket",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "status",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "dbId",
      "storageKey": null
    }
  ],
  "type": "Ticket",
  "abstractKey": null
} `)


