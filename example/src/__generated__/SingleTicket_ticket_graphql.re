/* @generated */

module Unions = {
  module Union_fragment_assignee: {
    type wrapped;
    type user;
    type workingGroup;
    type t = [
      | `User(user)
      | `WorkingGroup(workingGroup)
      | `UnmappedUnionMember
    ];
    let unwrapFragment_user:
      user => {. "__$fragment_ref__Avatar_user": Avatar_user_graphql.t};
    let unwrapFragment_workingGroup:
      workingGroup =>
      {
        .
        "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": SingleTicketWorkingGroup_workingGroup_graphql.t,
      };
    let unwrap: wrapped => t;
  } = {
    type wrapped;
    type user;
    type workingGroup;
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

    external unwrapFragment_user:
      user => {. "__$fragment_ref__Avatar_user": Avatar_user_graphql.t} =
      "%identity";
    external unwrapFragment_workingGroup:
      workingGroup =>
      {
        .
        "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": SingleTicketWorkingGroup_workingGroup_graphql.t,
      } =
      "%identity";
  };
};

open Unions;

module Types = {};

type fragment = {
  assignee: option(Union_fragment_assignee.t),
  id: string,
  subject: string,
  lastUpdated: option(string),
  trackingId: string,
  __wrappedFragment__TicketStatusBadge_ticket: ReasonRelay.wrappedFragmentRef,
};

module FragmentConverters: {
  let unwrapFragment_fragment:
    fragment =>
    {
      .
      "__$fragment_ref__TicketStatusBadge_ticket": TicketStatusBadge_ticket_graphql.t,
    };
} = {
  external unwrapFragment_fragment:
    fragment =>
    {
      .
      "__$fragment_ref__TicketStatusBadge_ticket": TicketStatusBadge_ticket_graphql.t,
    } =
    "%identity";
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"assignee":[[0,""],[3,"fragment_assignee"]],"lastUpdated":[[0,""]]} |}
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
