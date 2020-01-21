/* @generated */

module Unions = {
  module Union_fragment_assignee: {
    type wrapped;
    type user = {
      getFragmentRefs:
        unit => {. "__$fragment_ref__Avatar_user": Avatar_user_graphql.t},
    };
    type workingGroup = {
      getFragmentRefs:
        unit =>
        {
          .
          "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": SingleTicketWorkingGroup_workingGroup_graphql.t,
        },
    };
    type t = [
      | `User(user)
      | `WorkingGroup(workingGroup)
      | `UnmappedUnionMember
    ];
    let unwrap: wrapped => t;
  } = {
    type wrapped;
    type user = {
      getFragmentRefs:
        unit => {. "__$fragment_ref__Avatar_user": Avatar_user_graphql.t},
    };
    type workingGroup = {
      getFragmentRefs:
        unit =>
        {
          .
          "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": SingleTicketWorkingGroup_workingGroup_graphql.t,
        },
    };
    external __unwrap_union: wrapped => {. "__typename": string} =
      "%identity";
    type t = [
      | `User(user)
      | `WorkingGroup(workingGroup)
      | `UnmappedUnionMember
    ];
    external __unwrap_user: wrapped => user = "%identity";
    external __unwrap_workingGroup: wrapped => workingGroup = "%identity";
    let unwrap = wrapped => {
      let unwrappedUnion = wrapped |> __unwrap_union;
      switch (unwrappedUnion##__typename) {
      | "User" => `User(wrapped |> __unwrap_user)
      | "WorkingGroup" => `WorkingGroup(wrapped |> __unwrap_workingGroup)
      | _ => `UnmappedUnionMember
      };
    };
  };

  type union_fragment_assignee = [
    | `User(Union_fragment_assignee.user)
    | `WorkingGroup(Union_fragment_assignee.workingGroup)
    | `UnmappedUnionMember
  ];
};

open Unions;

module Types = {};

type fragment = {
  assignee: option(union_fragment_assignee),
  id: string,
  subject: string,
  lastUpdated: option(string),
  trackingId: string,
  getFragmentRefs:
    unit =>
    {
      .
      "__$fragment_ref__TicketStatusBadge_ticket": TicketStatusBadge_ticket_graphql.t,
    },
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(string)) = [%raw
    {| {"assignee":{"n":"","u":"fragment_assignee"},"assignee_user":{"f":""},"assignee_workinggroup":{"f":""},"lastUpdated":{"n":""},"":{"f":""}} |}
  ];
  let fragmentConverterMap = {
    "fragment_assignee": Union_fragment_assignee.unwrap,
  };
  let convertFragment = v =>
    v
    ->ReasonRelay._convertObj(
        fragmentConverter,
        fragmentConverterMap,
        Js.undefined,
      );
};

type t;
type fragmentRef;
type fragmentRefSelector('a) =
  {.. "__$fragment_ref__SingleTicket_ticket": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

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
              "kind": "FragmentSpread",
              "name": "SingleTicketWorkingGroup_workingGroup",
              "args": null
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
