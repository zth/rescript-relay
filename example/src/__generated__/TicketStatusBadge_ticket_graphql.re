/* @generated */

type enum_TicketStatus = [
  | `Done
  | `OnHold
  | `Progress
  | `Rejected
  | `FutureAddedValue(string)
];

let unwrap_enum_TicketStatus: string => enum_TicketStatus =
  fun
  | "Done" => `Done
  | "OnHold" => `OnHold
  | "Progress" => `Progress
  | "Rejected" => `Rejected
  | v => `FutureAddedValue(v);

let wrap_enum_TicketStatus: enum_TicketStatus => string =
  fun
  | `Done => "Done"
  | `OnHold => "OnHold"
  | `Progress => "Progress"
  | `Rejected => "Rejected"
  | `FutureAddedValue(v) => v;

module Unions = {};

module Types = {};

type fragment = {
  status: enum_TicketStatus,
  dbId: string,
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {| {"__root":{"status":{"e":"enum_TicketStatus"}}} |}
  ];
  let fragmentConverterMap = {"enum_TicketStatus": unwrap_enum_TicketStatus};
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
  {.. "__$fragment_ref__TicketStatusBadge_ticket": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "TicketStatusBadge_ticket",
  "type": "Ticket",
  "metadata": null,
  "argumentDefinitions": [],
  "selections": [
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "status",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "dbId",
      "args": null,
      "storageKey": null
    }
  ]
} |}
];
