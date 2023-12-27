/* @sourceLoc Test_inputUnion.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live type location = RelaySchemaAssets_graphql.input_Location
  @live type byAddress = RelaySchemaAssets_graphql.input_ByAddress
  @live type byLoc = RelaySchemaAssets_graphql.input_ByLoc
  type response = {
    findByLocation: option<string>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    location: location,
  }
  @live
  type refetchVariables = {
    location: option<location>,
  }
  @live let makeRefetchVariables = (
    ~location=?,
  ): refetchVariables => {
    location: location
  }

}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"location":{"byLoc":{"r":"byLoc"},"byAddress":{"r":"byAddress"}},"byAddress":{},"byLoc":{},"__root":{"location":{"r":"location"}}}`
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
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "location"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "location",
        "variableName": "location"
      }
    ],
    "kind": "ScalarField",
    "name": "findByLocation",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestInputUnionQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestInputUnionQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "53a5a8069244d58a20a58e55c9f98f2e",
    "id": null,
    "metadata": {},
    "name": "TestInputUnionQuery",
    "operationKind": "query",
    "text": "query TestInputUnionQuery(\n  $location: Location!\n) {\n  findByLocation(location: $location)\n}\n"
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
