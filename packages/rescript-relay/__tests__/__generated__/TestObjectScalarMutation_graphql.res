/* @sourceLoc TestObjectScalar.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live type serializeMultipleCustomScalars = RelaySchemaAssets_graphql.input_SerializeMultipleCustomScalars
  @live
  type response = {
    serializeMultipleCustomScalars: option<bool>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    input: serializeMultipleCustomScalars,
  }
}

module Internal = {
  @live
  let variablesConverter: dict<dict<dict<string>>> = %raw(
    json`{"serializeMultipleCustomScalars":{"os2":{"c":"TestsUtils.ObjectScalar2"},"os1s":{"ca":"TestsUtils.ObjectScalar1"}},"__root":{"input":{"r":"serializeMultipleCustomScalars"}}}`
  )
  @live
  let variablesConverterMap = {
    "TestsUtils.ObjectScalar1": TestsUtils.ObjectScalar1.serialize,
    "TestsUtils.ObjectScalar2": TestsUtils.ObjectScalar2.serialize,
  }
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    None
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    null
  )
  @live
  type responseRaw
  @live
  let responseConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    None
  )
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}
module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.mutationNode<relayOperationNode>


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
    "name": "serializeMultipleCustomScalars",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestObjectScalarMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestObjectScalarMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "86fd315903804ce86d1fea1df28f4b4a",
    "id": null,
    "metadata": {},
    "name": "TestObjectScalarMutation",
    "operationKind": "mutation",
    "text": "mutation TestObjectScalarMutation(\n  $input: SerializeMultipleCustomScalars!\n) {\n  serializeMultipleCustomScalars(input: $input)\n}\n"
  }
};
})() `)


