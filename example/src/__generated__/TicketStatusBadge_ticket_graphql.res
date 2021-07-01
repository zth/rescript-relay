/* @sourceLoc TicketStatusBadge.res */
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
  
  type enum_TicketStatus_input = [
    | #Done
    | #OnHold
    | #Progress
    | #Rejected
    ]
  
  type fragment_assignee_User = {
    fullName: string,
  }
  
  
  type fragment_assignee = [
    | #User(fragment_assignee_User)
    | #UnselectedUnionMember(string)
  ]
  type fragment = {
    status: enum_TicketStatus,
    dbId: string,
    assignee: option<[
      | #User(fragment_assignee_User)
      | #UnselectedUnionMember(string)
    ]>,
  }
}

let unwrap_fragment_assignee: {. "__typename": string } => [
  | #User(Types.fragment_assignee_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
 | "User" => #User(u->Obj.magic) 
 | v => #UnselectedUnionMember(v)
}

let wrap_fragment_assignee: [
  | #User(Types.fragment_assignee_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
 | #User(v) => v->Obj.magic 
 | #UnselectedUnionMember(v) => {"__typename": v} 
}

module Internal = {
  type fragmentRaw
  let fragmentConverter: 
    Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = 
    %raw(
      json`{"__root":{"assignee":{"n":"","u":"fragment_assignee"}}}`
    )
  
  let fragmentConverterMap = {
    "fragment_assignee": unwrap_fragment_assignee,
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
  RescriptRelay.fragmentRefs<[> | #TicketStatusBadge_ticket]> => fragmentRef = "%identity"


module Utils = {
  @@ocaml.warning("-33")
  open Types
  external ticketStatus_toString:
  enum_TicketStatus => string = "%identity"
  external ticketStatus_input_toString:
  enum_TicketStatus_input => string = "%identity"
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
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "dbId",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "concreteType": null,
      "kind": "LinkedField",
      "name": "assignee",
      "plural": false,
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
              "name": "fullName",
              "storageKey": null
            }
          ],
          "type": "User",
          "abstractKey": null
        }
      ],
      "storageKey": null
    }
  ],
  "type": "Ticket",
  "abstractKey": null
} `)


