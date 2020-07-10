/* @generated */

type enum_OnlineStatus = [
  | `Idle
  | `Offline
  | `Online
  | `FutureAddedValue(string)
];

let unwrap_enum_OnlineStatus: string => enum_OnlineStatus =
  fun
  | "Idle" => `Idle
  | "Offline" => `Offline
  | "Online" => `Online
  | v => `FutureAddedValue(v);

let wrap_enum_OnlineStatus: enum_OnlineStatus => string =
  fun
  | `Idle => "Idle"
  | `Offline => "Offline"
  | `Online => "Online"
  | `FutureAddedValue(v) => v;

module Types = {
  type fragment_User = {
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
    firstName: string,
  };
  type fragment_Group = {name: string};

  type fragment = [
    | `User(fragment_User)
    | `Group(fragment_Group)
    | `UnselectedUnionMember(string)
  ];
};

let unwrap_fragment:
  {. "__typename": string} =>
  [
    | `User(Types.fragment_User)
    | `Group(Types.fragment_Group)
    | `UnselectedUnionMember(string)
  ] =
  u =>
    switch (u##__typename) {
    | "User" => `User(u->Obj.magic)
    | "Group" => `Group(u->Obj.magic)
    | v => `UnselectedUnionMember(v)
    };

let wrap_fragment:
  [
    | `User(Types.fragment_User)
    | `Group(Types.fragment_Group)
    | `UnselectedUnionMember(string)
  ] =>
  {. "__typename": string} =
  fun
  | `User(v) => v->Obj.magic
  | `Group(v) => v->Obj.magic
  | `UnselectedUnionMember(v) => {"__typename": v};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"":{"u":"fragment"},"onlineStatus":{"n":"","e":"enum_OnlineStatus"}}} |json}
  ];
  let fragmentConverterMap = {
    "fragment": unwrap_fragment,
    "enum_OnlineStatus": unwrap_enum_OnlineStatus,
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
type fragmentRef = t;

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%raw
  {json| {
  "kind": "Fragment",
  "name": "TestUnionFragment_member",
  "type": "Member",
  "metadata": null,
  "argumentDefinitions": [],
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
    },
    {
      "kind": "InlineFragment",
      "type": "Group",
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
} |json}
];
