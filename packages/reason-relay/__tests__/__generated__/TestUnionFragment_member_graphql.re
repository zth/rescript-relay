/* @generated */

module Types = {
  type enum_OnlineStatus = pri [> | `Idle | `Offline | `Online];

  [@ocaml.warning "-30"];
  type fragment_User = {
    onlineStatus: option(enum_OnlineStatus),
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
    {json| {"__root":{"":{"u":"fragment"},"onlineStatus":{"n":""}}} |json}
  ];
  let fragmentConverterMap = {"fragment": unwrap_fragment};
  let convertFragment = v =>
    v
    ->ReasonRelay.convertObj(
        fragmentConverter,
        fragmentConverterMap,
        Js.undefined,
      );
};

type t;
type fragmentRef;
external getFragmentRef:
  ReasonRelay.fragmentRefs([> | `TestUnionFragment_member]) => fragmentRef =
  "%identity";

module Utils = {
  external onlineStatus_toString: Types.enum_OnlineStatus => string =
    "%identity";
};

type relayOperationNode;

type operationType = ReasonRelay.fragmentNode(relayOperationNode);

let node: operationType = [%raw
  {json| {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestUnionFragment_member",
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
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "firstName",
          "storageKey": null
        },
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "onlineStatus",
          "storageKey": null
        }
      ],
      "type": "User",
      "abstractKey": null
    },
    {
      "kind": "InlineFragment",
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "name",
          "storageKey": null
        }
      ],
      "type": "Group",
      "abstractKey": null
    }
  ],
  "type": "Member",
  "abstractKey": "__isMember"
} |json}
];
