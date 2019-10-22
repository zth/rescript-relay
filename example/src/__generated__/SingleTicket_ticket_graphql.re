type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__SingleTicket_ticket": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";
type union_response_assignee_wrapped;
type fragment = {
  .
  "__$fragment_ref__TicketStatusBadge_ticket": TicketStatusBadge_ticket_graphql.t,
  "trackingId": string,
  "lastUpdated": Js.Nullable.t(string),
  "subject": string,
  "id": string,
  "assignee": Js.Nullable.t(union_response_assignee_wrapped),
};
type operationType = ReasonRelay.fragmentNode;

module Unions = {
  module Union_response_assignee: {
    type type_User = {
      .
      "__$fragment_ref__Avatar_user": Avatar_user_graphql.t,
    };
    type type_WorkingGroup = {. "name": string};
    type t = [
      | `User(type_User)
      | `WorkingGroup(type_WorkingGroup)
      | `UnmappedUnionMember
    ];
    let unwrap: union_response_assignee_wrapped => t;
  } = {
    external __unwrap_union:
      union_response_assignee_wrapped => {. "__typename": string} =
      "%identity";
    type type_User = {
      .
      "__$fragment_ref__Avatar_user": Avatar_user_graphql.t,
    };
    type type_WorkingGroup = {. "name": string};
    type t = [
      | `User(type_User)
      | `WorkingGroup(type_WorkingGroup)
      | `UnmappedUnionMember
    ];
    external __unwrap_User: union_response_assignee_wrapped => type_User =
      "%identity";
    external __unwrap_WorkingGroup:
      union_response_assignee_wrapped => type_WorkingGroup =
      "%identity";
    let unwrap = wrapped => {
      let unwrappedUnion = wrapped |> __unwrap_union;
      switch (unwrappedUnion##__typename) {
      | "User" => `User(wrapped |> __unwrap_User)
      | "WorkingGroup" => `WorkingGroup(wrapped |> __unwrap_WorkingGroup)
      | _ => `UnmappedUnionMember
      };
    };
  };
};

let node: operationType = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "SingleTicket_ticket",
  "type": "Ticket",
  "metadata": null,
  "argumentDefinitions": [],
  "selections": [
    {
      "kind": "LinkedField",
      "alias": null,
      "name": "assignee",
      "storageKey": null,
      "args": null,
      "concreteType": null,
      "plural": false,
      "selections": [
        {
          "kind": "ScalarField",
          "alias": null,
          "name": "__typename",
          "args": null,
          "storageKey": null
        },
        {
          "kind": "InlineFragment",
          "type": "User",
          "selections": [
            {
              "kind": "FragmentSpread",
              "name": "Avatar_user",
              "args": null
            }
          ]
        },
        {
          "kind": "InlineFragment",
          "type": "WorkingGroup",
          "selections": [
            {
              "kind": "ScalarField",
              "alias": null,
              "name": "name",
              "args": null,
              "storageKey": null
            }
          ]
        }
      ]
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "id",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "subject",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "lastUpdated",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "trackingId",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "FragmentSpread",
      "name": "TicketStatusBadge_ticket",
      "args": null
    }
  ]
} |}
];
