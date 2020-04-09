/* @generated */

module Types = {
  type fragment_assignee_User = {
    getFragmentRefs:
      unit => {. "__$fragment_ref__Avatar_user": Avatar_user_graphql.t},
  };
  type fragment_assignee_WorkingGroup = {
    getFragmentRefs:
      unit =>
      {
        .
        "__$fragment_ref__SingleTicketWorkingGroup_workingGroup": SingleTicketWorkingGroup_workingGroup_graphql.t,
      },
  };
  type fragment_assignee = [
    | `User(fragment_assignee_User)
    | `WorkingGroup(fragment_assignee_WorkingGroup)
    | `UnselectedUnionMember(string)
  ];

  type fragment = {
    assignee:
      option(
        [
          | `User(fragment_assignee_User)
          | `WorkingGroup(fragment_assignee_WorkingGroup)
          | `UnselectedUnionMember(string)
        ],
      ),
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
};

let unwrap_fragment_assignee:
  {. "__typename": string} =>
  [
    | `User(Types.fragment_assignee_User)
    | `WorkingGroup(Types.fragment_assignee_WorkingGroup)
    | `UnselectedUnionMember(string)
  ] =
  u =>
    switch (u##__typename) {
    | "User" => `User(u->Obj.magic)
    | "WorkingGroup" => `WorkingGroup(u->Obj.magic)
    | v => `UnselectedUnionMember(v)
    };

let wrap_fragment_assignee:
  [
    | `User(Types.fragment_assignee_User)
    | `WorkingGroup(Types.fragment_assignee_WorkingGroup)
    | `UnselectedUnionMember(string)
  ] =>
  {. "__typename": string} =
  fun
  | `User(v) => v->Obj.magic
  | `WorkingGroup(v) => v->Obj.magic
  | `UnselectedUnionMember(v) => {"__typename": v};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"assignee":{"n":"","u":"fragment_assignee"},"assignee_user":{"f":""},"assignee_workinggroup":{"f":""},"lastUpdated":{"n":""},"":{"f":""}}} |}
  ];
  let fragmentConverterMap = {"fragment_assignee": unwrap_fragment_assignee};
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
