/* @sourceLoc Test_queryInputObjects.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  @live
  type rec searchInput = {
    @live id: int,
    names: option<array<option<string>>>,
    someOtherId: option<float>,
  }
  type response = {
    search: option<string>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    input: searchInput,
  }
  @live
  type refetchVariables = {
    input: option<searchInput>,
  }
  @live let makeRefetchVariables = (
    ~input=?,
    ()
  ): refetchVariables => {
    input: input
  }
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"searchInput":{},"__root":{"input":{"r":"searchInput"}}}`
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
  @live let make_searchInput = (
    ~id,
    ~names=?,
    ~someOtherId=?,
    ()
  ): searchInput => {
    id: id,
    names: names,
    someOtherId: someOtherId
  }
  @live let makeVariables = (
    ~input
  ): variables => {
    input: input
  }
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "input"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "input",
        "variableName": "input"
      }
    ],
    "kind": "ScalarField",
    "name": "search",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestQueryInputObjectsQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestQueryInputObjectsQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "8441859dad587e683a224cfc73959cdc",
    "id": null,
    "metadata": {},
    "name": "TestQueryInputObjectsQuery",
    "operationKind": "query",
    "text": "query TestQueryInputObjectsQuery(\n  $input: SearchInput!\n) {\n  search(input: $input)\n}\n"
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
