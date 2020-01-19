/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FUTURE_ADDED_VALUE__
];

module Unions = {};

module Types = {};

type fragment = {
  firstName: string,
  onlineStatus: option(enum_OnlineStatus),
};

module FragmentConverters: {} = {};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(array((int, string))) = [%raw
    {| {"onlineStatus":[[0,""],[2,"enum_OnlineStatus"]]} |}
  ];
  let fragmentConverterMap = {
    "enum_OnlineStatus": SchemaAssets.Enum_OnlineStatus.unwrap,
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
  {.. "__$fragment_ref__TestFragment_user": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%bs.raw
  {| {
  "kind": "Fragment",
  "name": "TestFragment_user",
  "type": "User",
  "metadata": null,
  "argumentDefinitions": [],
  "selections": [
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "firstName",
      "args": null,
      "storageKey": null
    },
    {
      "kind": "ScalarField",
      "alias": null,
      "name": "onlineStatus",
      "args": null,
      "storageKey": null
    }
  ]
} |}
];
