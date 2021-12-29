/* @sourceLoc Test_localPayload.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type rec response_node = {
    __typename: [ | #User],
    firstName: string,
    avatarUrl: option<string>,
  }
  and rawResponse_node = {
    __typename: [ | #User],
    id: string,
    firstName: string,
    avatarUrl: option<string>,
  }
  type response = {
    node: option<response_node>,
  }
  type rawResponse = {
    node: option<rawResponse_node>,
  }
  type variables = {
    id: string,
  }
  type refetchVariables = {
    id: option<string>,
  }
  let makeRefetchVariables = (
    ~id=?,
    ()
  ): refetchVariables => {
    id: id
  }
}

module Internal = {
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  let variablesConverterMap = ()
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  type wrapResponseRaw
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"node_avatarUrl":{"n":""},"node":{"tnf":"User","n":""}}}`
  )
  let wrapResponseConverterMap = ()
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  type responseRaw
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"node_avatarUrl":{"n":""},"node":{"tnf":"User","n":""}}}`
  )
  let responseConverterMap = ()
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw
  let wrapRawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"node_avatarUrl":{"n":""},"node":{"tnf":"User","n":""}}}`
  )
  let wrapRawResponseConverterMap = ()
  let convertWrapRawResponse = v => v->RescriptRelay.convertObj(
    wrapRawResponseConverter,
    wrapRawResponseConverterMap,
    Js.null
  )
  type rawResponseRaw
  let rawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"node_avatarUrl":{"n":""},"node":{"tnf":"User","n":""}}}`
  )
  let rawResponseConverterMap = ()
  let convertRawResponse = v => v->RescriptRelay.convertObj(
    rawResponseConverter,
    rawResponseConverterMap,
    Js.undefined
  )
}

type queryRef

module Utils = {
  @@ocaml.warning("-33")
  open Types
  let makeVariables = (
    ~id
  ): variables => {
    id: id
  }
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "id"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "id"
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v3 = {
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
      "name": "avatarUrl",
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestLocalPayloadViaNodeInterfaceQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          (v3/*: any*/)
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestLocalPayloadViaNodeInterfaceQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          (v3/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "d851554a00ee2457821847cd2dd1eede",
    "id": null,
    "metadata": {},
    "name": "TestLocalPayloadViaNodeInterfaceQuery",
    "operationKind": "query",
    "text": "query TestLocalPayloadViaNodeInterfaceQuery(\n  $id: ID!\n) {\n  node(id: $id) {\n    __typename\n    ... on User {\n      firstName\n      avatarUrl\n    }\n    id\n  }\n}\n"
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
