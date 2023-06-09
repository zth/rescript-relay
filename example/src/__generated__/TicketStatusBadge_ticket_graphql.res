/* @sourceLoc TicketStatusBadge.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type fragment = {
    status: RelaySchemaAssets_graphql.enum_TicketStatus,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let fragmentConverterMap = ()
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
  RescriptRelay.fragmentRefs<[> | #TicketStatusBadge_ticket]> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live
  external ticketStatus_toString: RelaySchemaAssets_graphql.enum_TicketStatus => string = "%identity"
  @live
  external ticketStatus_input_toString: RelaySchemaAssets_graphql.enum_TicketStatus_input => string = "%identity"
  @live
  let ticketStatus_decode = (enum: RelaySchemaAssets_graphql.enum_TicketStatus): option<RelaySchemaAssets_graphql.enum_TicketStatus_input> => {
    switch enum {
      | #...RelaySchemaAssets_graphql.enum_TicketStatus_input as valid => Some(valid)
      | _ => None
    }
  }
  @live
  let ticketStatus_fromString = (str: string): option<RelaySchemaAssets_graphql.enum_TicketStatus_input> => {
    ticketStatus_decode(Obj.magic(str))
  }
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


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
    }
  ],
  "type": "Ticket",
  "abstractKey": null
} `)

