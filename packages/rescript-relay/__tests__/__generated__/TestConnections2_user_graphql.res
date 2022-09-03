/* @sourceLoc Test_connections.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type rec fragment_member_User_friendsConnection_edges_node = {
    @live id: string,
  }
  and fragment_member_User_friendsConnection_edges = {
    node: option<fragment_member_User_friendsConnection_edges_node>,
  }
  and fragment_member_User_friendsConnection = {
    edges: option<array<option<fragment_member_User_friendsConnection_edges>>>,
  }
  and fragment_member_User = {
    @live __typename: [ | #User],
    friendsConnection: fragment_member_User_friendsConnection,
  }
  and fragment_member = [
    | #User(fragment_member_User)
    | #UnselectedUnionMember(string)
  ]

  type fragment = {
    member: option<fragment_member>,
  }
}

@live
let unwrap_fragment_member: {. "__typename": string } => [
  | #User(Types.fragment_member_User)
  | #UnselectedUnionMember(string)
] = u => switch u["__typename"] {
  | "User" => #User(u->Obj.magic)
  | v => #UnselectedUnionMember(v)
}

@live
let wrap_fragment_member: [
  | #User(Types.fragment_member_User)
  | #UnselectedUnionMember(string)
] => {. "__typename": string } = v => switch v {
  | #User(v) => v->Obj.magic
  | #UnselectedUnionMember(v) => {"__typename": v}
}
module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"member":{"u":"fragment_member"}}}`
  )
  @live
  let fragmentConverterMap = {
    "fragment_member": unwrap_fragment_member,
  }
  @live
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    Js.undefined
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #TestConnections2_user]> => fragmentRef = "%identity"

@live
@inline
let connectionKey = "TestConnections2_user_member_friendsConnection"

%%private(
  @live @module("relay-runtime") @scope("ConnectionHandler")
  external internal_makeConnectionId: (RescriptRelay.dataId, @as("TestConnections2_user_member_friendsConnection") _, 'arguments) => RescriptRelay.dataId = "getConnectionID"
)

let makeConnectionId = (connectionParentDataId: RescriptRelay.dataId, ) => {
  let args = ()
  internal_makeConnectionId(connectionParentDataId, args)
}
@live
let getConnectionNodes: Types.fragment_member_User_friendsConnection => array<Types.fragment_member_User_friendsConnection_edges_node> = connection => 
  switch connection.edges {
    | None => []
    | Some(edges) => edges
      ->Belt.Array.keepMap(edge => switch edge {
        | None => None
        | Some(edge) => edge.node
      })
  }


module Utils = {
  @@ocaml.warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
};
return {
  "argumentDefinitions": [
    {
      "defaultValue": 2,
      "kind": "LocalArgument",
      "name": "count"
    },
    {
      "defaultValue": "",
      "kind": "LocalArgument",
      "name": "cursor"
    }
  ],
  "kind": "Fragment",
  "metadata": {
    "connection": [
      {
        "count": "count",
        "cursor": "cursor",
        "direction": "forward",
        "path": [
          "member",
          "friendsConnection"
        ]
      }
    ]
  },
  "name": "TestConnections2_user",
  "selections": [
    {
      "alias": null,
      "args": [
        {
          "kind": "Literal",
          "name": "id",
          "value": "123"
        }
      ],
      "concreteType": null,
      "kind": "LinkedField",
      "name": "member",
      "plural": false,
      "selections": [
        (v0/*: any*/),
        {
          "kind": "InlineFragment",
          "selections": [
            {
              "alias": "friendsConnection",
              "args": null,
              "concreteType": "UserConnection",
              "kind": "LinkedField",
              "name": "__TestConnections2_user_member_friendsConnection_connection",
              "plural": false,
              "selections": [
                {
                  "alias": null,
                  "args": null,
                  "concreteType": "UserEdge",
                  "kind": "LinkedField",
                  "name": "edges",
                  "plural": true,
                  "selections": [
                    {
                      "alias": null,
                      "args": null,
                      "concreteType": "User",
                      "kind": "LinkedField",
                      "name": "node",
                      "plural": false,
                      "selections": [
                        {
                          "alias": null,
                          "args": null,
                          "kind": "ScalarField",
                          "name": "id",
                          "storageKey": null
                        },
                        (v0/*: any*/)
                      ],
                      "storageKey": null
                    },
                    {
                      "alias": null,
                      "args": null,
                      "kind": "ScalarField",
                      "name": "cursor",
                      "storageKey": null
                    }
                  ],
                  "storageKey": null
                },
                {
                  "alias": null,
                  "args": null,
                  "concreteType": "PageInfo",
                  "kind": "LinkedField",
                  "name": "pageInfo",
                  "plural": false,
                  "selections": [
                    {
                      "alias": null,
                      "args": null,
                      "kind": "ScalarField",
                      "name": "endCursor",
                      "storageKey": null
                    },
                    {
                      "alias": null,
                      "args": null,
                      "kind": "ScalarField",
                      "name": "hasNextPage",
                      "storageKey": null
                    }
                  ],
                  "storageKey": null
                }
              ],
              "storageKey": null
            }
          ],
          "type": "User",
          "abstractKey": null
        }
      ],
      "storageKey": "member(id:\"123\")"
    }
  ],
  "type": "Query",
  "abstractKey": null
};
})() `)

