/* @sourceLoc SingleTicket.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type rec fragment_assignee_User = {
    @live __typename: [ | #User],
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #Avatar_user]>,
  }
  and fragment_assignee_WorkingGroup = {
    @live __typename: [ | #WorkingGroup],
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #SingleTicketWorkingGroup_workingGroup]>,
  }
  and fragment_assignee = [
    | #User(fragment_assignee_User)
    | #WorkingGroup(fragment_assignee_WorkingGroup)
    | #UnselectedUnionMember(string)
  ]

  type fragment = {
    assignee: option<fragment_assignee>,
    @live id: string,
    lastUpdated: option<string>,
    subject: string,
    trackingId: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TicketStatusBadge_ticket]>,
  }
}

@live
let unwrap_fragment_assignee: {. "__typename": string } => [
  | #User(Types.fragment_assignee_User)
  | #WorkingGroup(Types.fragment_assignee_WorkingGroup)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | "WorkingGroup" => #WorkingGroup(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_fragment_assignee: [
  | #User(Types.fragment_assignee_User)
  | #WorkingGroup(Types.fragment_assignee_WorkingGroup)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #WorkingGroup(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"assignee_WorkingGroup":{"f":""},"assignee_User":{"f":""},"assignee":{"u":"fragment_assignee"},"":{"f":""}}}`
  )
  @live
  let fragmentConverterMap = {
    "fragment_assignee": unwrap_fragment_assignee,
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
  RescriptRelay.fragmentRefs<[> | #SingleTicket_ticket]> => fragmentRef = "%identity"

module Utils = {
  @@ocaml.warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "SingleTicket_ticket",
  "selections": [
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
              "args": null,
              "kind": "FragmentSpread",
              "name": "Avatar_user"
            }
          ],
          "type": "User",
          "abstractKey": null
        },
        {
          "kind": "InlineFragment",
          "selections": [
            {
              "args": null,
              "kind": "FragmentSpread",
              "name": "SingleTicketWorkingGroup_workingGroup"
            }
          ],
          "type": "WorkingGroup",
          "abstractKey": null
        }
      ],
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "id",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "subject",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "lastUpdated",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "trackingId",
      "storageKey": null
    },
    {
      "args": null,
      "kind": "FragmentSpread",
      "name": "TicketStatusBadge_ticket"
    }
  ],
  "type": "Ticket",
  "abstractKey": null
} `)

