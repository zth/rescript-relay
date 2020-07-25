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

module Types = {
  type fragment = {
    status: [
      | `Done
      | `OnHold
      | `Progress
      | `Rejected
      | `FutureAddedValue(string)
    ],
    dbId: string,
  };
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"status":{"e":"enum_TicketStatus"}}} |json}
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
external getFragmentRef:
  ReasonRelay.fragmentRefs([> | `TicketStatusBadge_ticket]) => fragmentRef =
  "%identity";

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%raw
  {json| {
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
} |json}
];
