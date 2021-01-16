
/* @generated */

module Types = {
  type enum_OnlineStatus = pri [> | `Idle | `Offline | `Online];

  [@ocaml.warning "-30"];

  type fragment = {
    __id: ReasonRelay.dataId,
    firstName: string,
    onlineStatus: option(enum_OnlineStatus),
    fragmentRefs: ReasonRelay.fragmentRefs([ | `TestFragment_sub_user]),
  };
};

module Internal = {
  type fragmentRaw;
  let fragmentConverter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw
    {json| {"__root":{"":{"f":""},"onlineStatus":{"n":""}}} |json}
  ];
  let fragmentConverterMap = ();
  let convertFragment = v =>
    v->ReasonRelay.convertObj(
      fragmentConverter,
      fragmentConverterMap,
      Js.undefined,
    );
};

type t;
type fragmentRef;
external getFragmentRef:
  ReasonRelay.fragmentRefs([> | `TestFragment_user]) => fragmentRef =
  "%identity";

module Utils = {
  external onlineStatus_toString: Types.enum_OnlineStatus => string =
    "%identity";
};

type relayOperationNode;

type operationType = ReasonRelay.fragmentNode(relayOperationNode);



let node: operationType = [%raw {json| {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestFragment_user",
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
    },
    {
      "args": null,
      "kind": "FragmentSpread",
      "name": "TestFragment_sub_user"
    },
    {
      "kind": "ClientExtension",
      "selections": [
        {
          "alias": null,
          "args": null,
          "kind": "ScalarField",
          "name": "__id",
          "storageKey": null
        }
      ]
    }
  ],
  "type": "User",
  "abstractKey": null
} |json}];


