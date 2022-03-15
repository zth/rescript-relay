/* @sourceLoc Test_fragment.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type enum_OnlineStatus = private [>
      | #Idle
      | #Offline
      | #Online
    ]

  @live
  type enum_OnlineStatus_input = [
      | #Idle
      | #Offline
      | #Online
    ]



  type rec response_loggedInUser = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestFragment_inline | #TestFragment_user]>,
  }
  and response_users_edges_node = {
    @live id: string,
    onlineStatus: option<enum_OnlineStatus>,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestFragment_plural_user]>,
  }
  and response_users_edges = {
    node: option<response_users_edges_node>,
  }
  and response_users = {
    edges: option<array<option<response_users_edges>>>,
  }
  type response = {
    loggedInUser: response_loggedInUser,
    users: option<response_users>,
  }
  @live
  type rawResponse = response
  @live
  type variables = unit
  @live
  type refetchVariables = unit
  @live let makeRefetchVariables = () => ()
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"users_edges_node":{"f":""},"loggedInUser":{"f":""}}}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  @live
  type responseRaw
  @live
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"users_edges_node":{"f":""},"loggedInUser":{"f":""}}}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}

type queryRef

module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  @live
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  @live
  let onlineStatus_decode = (enum: enum_OnlineStatus): option<enum_OnlineStatus_input> => {
    switch enum {
      | #...enum_OnlineStatus_input as valid => Some(valid)
      | _ => None
    }
  }
  @live
  let onlineStatus_fromString = (str: string): option<enum_OnlineStatus_input> => {
    onlineStatus_decode(Obj.magic(str))
  }
  @live @obj external makeVariables: unit => unit = ""
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "onlineStatus",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestFragmentQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestFragment_user"
          },
          {
            "kind": "InlineDataFragmentSpread",
            "name": "TestFragment_inline",
            "selections": [
              (v0/*: any*/),
              (v1/*: any*/)
            ]
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "UserConnection",
        "kind": "LinkedField",
        "name": "users",
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
                  (v2/*: any*/),
                  (v1/*: any*/),
                  {
                    "args": null,
                    "kind": "FragmentSpread",
                    "name": "TestFragment_plural_user"
                  }
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestFragmentQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          (v0/*: any*/),
          (v1/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "lastName",
            "storageKey": null
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
          },
          (v2/*: any*/)
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "UserConnection",
        "kind": "LinkedField",
        "name": "users",
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
                  (v2/*: any*/),
                  (v1/*: any*/),
                  (v0/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "694e23796b26fa28d35a7a972e55f200",
    "id": null,
    "metadata": {},
    "name": "TestFragmentQuery",
    "operationKind": "query",
    "text": "query TestFragmentQuery {\n  loggedInUser {\n    ...TestFragment_user\n    ...TestFragment_inline\n    id\n  }\n  users {\n    edges {\n      node {\n        id\n        onlineStatus\n        ...TestFragment_plural_user\n      }\n    }\n  }\n}\n\nfragment TestFragment_inline on User {\n  firstName\n  onlineStatus\n}\n\nfragment TestFragment_plural_user on User {\n  id\n  firstName\n  onlineStatus\n}\n\nfragment TestFragment_sub_user on User {\n  lastName\n}\n\nfragment TestFragment_user on User {\n  firstName\n  onlineStatus\n  ...TestFragment_sub_user\n}\n"
  }
};
})() `)

include RescriptRelay.MakeLoadQuery({
    type variables = Types.variables
    type loadedQueryRef = queryRef
    type response = Types.response
    type node = relayOperationNode
    let query = node
    let convertVariables = Internal.convertVariables
});
