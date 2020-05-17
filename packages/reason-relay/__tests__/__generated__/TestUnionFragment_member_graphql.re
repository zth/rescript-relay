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
  type fragment_Group_members_User = {id: string};
  type fragment_Group_members_Group = {id: string};
  type fragment_Group_members = [
    | `User(fragment_Group_members_User)
    | `Group(fragment_Group_members_Group)
    | `UnselectedUnionMember(string)
  ];
  type fragment_User = {
    onlineStatus:
      option([ | `Idle | `Offline | `Online | `FutureAddedValue(string)]),
    firstName: string,
    id: string,
  };
  type fragment_Group = {
    members:
      option(
        array(
          option(
            [
              | `User(fragment_Group_members_User)
              | `Group(fragment_Group_members_Group)
              | `UnselectedUnionMember(string)
            ],
          ),
        ),
      ),
    name: string,
    id: string,
  };

  type fragment = [
    | `User(fragment_User)
    | `Group(fragment_Group)
    | `UnselectedUnionMember(string)
  ];
};

let unwrap_fragment_Group_members:
  {. "__typename": string} =>
  [
    | `User(Types.fragment_Group_members_User)
    | `Group(Types.fragment_Group_members_Group)
    | `UnselectedUnionMember(string)
  ] =
  u =>
    switch (u##__typename) {
    | "User" => `User(u->Obj.magic)
    | "Group" => `Group(u->Obj.magic)
    | v => `UnselectedUnionMember(v)
    };

let wrap_fragment_Group_members:
  [
    | `User(Types.fragment_Group_members_User)
    | `Group(Types.fragment_Group_members_Group)
    | `UnselectedUnionMember(string)
  ] =>
  {. "__typename": string} =
  fun
  | `User(v) => v->Obj.magic
  | `Group(v) => v->Obj.magic
  | `UnselectedUnionMember(v) => {"__typename": v};

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
    {json| {"__root":{"":{"u":"fragment"},"onlineStatus":{"n":"","e":"enum_OnlineStatus"},"members":{"n":"","na":"","u":"fragment_Group_members"}}} |json}
  ];
  let fragmentConverterMap = {
    "fragment": unwrap_fragment,
    "enum_OnlineStatus": unwrap_enum_OnlineStatus,
    "fragment_Group_members": unwrap_fragment_Group_members,
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
  {.. "__$fragment_ref__TestUnionFragment_member": t} as 'a;
external getFragmentRef: fragmentRefSelector('a) => fragmentRef = "%identity";

module Utils = {};

type operationType = ReasonRelay.fragmentNode;

let node: operationType = [%raw
  {json| (function(){
var v0 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "__typename",
  "args": null,
  "storageKey": null
},
v1 = {
  "kind": "ScalarField",
  "alias": null,
  "name": "id",
  "args": null,
  "storageKey": null
},
v2 = [
  (v1/*: any*/)
];
return {
  "kind": "Fragment",
  "name": "TestUnionFragment_member",
  "type": "Member",
  "metadata": null,
  "argumentDefinitions": [],
  "selections": [
    (v0/*: any*/),
    {
      "kind": "InlineFragment",
      "type": "User",
      "selections": [
        (v1/*: any*/),
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
        (v1/*: any*/),
        {
          "kind": "ScalarField",
          "alias": null,
          "name": "name",
          "args": null,
          "storageKey": null
        },
        {
          "kind": "LinkedField",
          "alias": null,
          "name": "members",
          "storageKey": null,
          "args": null,
          "concreteType": null,
          "plural": true,
          "selections": [
            (v0/*: any*/),
            {
              "kind": "InlineFragment",
              "type": "User",
              "selections": (v2/*: any*/)
            },
            {
              "kind": "InlineFragment",
              "type": "Group",
              "selections": (v2/*: any*/)
            }
          ]
        }
      ]
    }
  ]
};
})() |json}
];
