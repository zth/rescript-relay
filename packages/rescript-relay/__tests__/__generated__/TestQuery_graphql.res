/* @sourceLoc Test_query.res */
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



  type rec response_users_edges_node = {
    firstName: string,
    @live id: string,
    onlineStatus: option<enum_OnlineStatus>,
  }
  and response_users_edges = {
    node: option<response_users_edges_node>,
  }
  and response_users = {
    edges: option<array<option<response_users_edges>>>,
  }
  type response = {
    users: option<response_users>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    status: option<[
      | #Idle
      | #Offline
      | #Online
    ]
>,
  }
  @live
  type refetchVariables = {
    status: option<[
      | #Idle
      | #Offline
      | #Online
    ]
>,
  }
  @live let makeRefetchVariables = (
    ~status=?,
    ()
  ): refetchVariables => {
    status: status
  }
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
    json`{}`
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
    json`{}`
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
  @live let makeVariables = (
    ~status=?,
    ()
  ): variables => {
    status: status
  }
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "status"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "status",
        "variableName": "status"
      }
    ],
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
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "id",
                "storageKey": null
              },
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
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "123064f3c998fd5b717ca05be99d7ee1",
    "id": null,
    "metadata": {},
    "name": "TestQuery",
    "operationKind": "query",
    "text": "query TestQuery(\n  $status: OnlineStatus\n) {\n  users(status: $status) {\n    edges {\n      node {\n        id\n        firstName\n        onlineStatus\n      }\n    }\n  }\n}\n"
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
