/* @sourceLoc Test_serializeMultipleCustomScalars.res */
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
  let variablesConverter: JSON.t = %raw(
    json`{"roots":{"__root":[{"path":["input"],"reference":"serializeMultipleCustomScalars"}],"serializeMultipleCustomScalars":[{"list":1,"path":["os1s"],"scalar":"TestsUtils.ObjectScalar1"},{"path":["os2"],"scalar":"TestsUtils.ObjectScalar2"}]},"version":2}`
  )
  @live
  let variablesConverterMap = {
    "TestsUtils.ObjectScalar1": TestsUtils.ObjectScalar1.serialize,
    "TestsUtils.ObjectScalar2": TestsUtils.ObjectScalar2.serialize,
  }
  @live
  let preparedVariablesConverter = RescriptRelay.prepareConversion(
    variablesConverter,
    variablesConverterMap,
    None
  )
  @live
  let convertVariables = value => RescriptRelay.runConversion(preparedVariablesConverter, value)
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: JSON.t = %raw(
    json`{"roots":{"__root":[]},"version":2}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let preparedWrapResponseConverter = RescriptRelay.prepareConversion(
    wrapResponseConverter,
    wrapResponseConverterMap,
    null
  )
  @live
  let convertWrapResponse = value => RescriptRelay.runConversion(preparedWrapResponseConverter, value)
  @live
  type responseRaw
  @live
  let responseConverter: JSON.t = %raw(
    json`{"roots":{"__root":[]},"version":2}`
  )
  @live
  let responseConverterMap = ()
  @live
  let preparedResponseConverter = RescriptRelay.prepareConversion(
    responseConverter,
    responseConverterMap,
    None
  )
  @live
  let convertResponse = value => RescriptRelay.runConversion(preparedResponseConverter, value)
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
    "name": "TestSerializeMultipleCustomScalarsMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestSerializeMultipleCustomScalarsMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "d86ec951867af25200a3ad2b01b9f1d9",
    "id": null,
    "metadata": {},
    "name": "TestSerializeMultipleCustomScalarsMutation",
    "operationKind": "mutation",
    "text": "mutation TestSerializeMultipleCustomScalarsMutation(\n  $input: SerializeMultipleCustomScalars!\n) {\n  serializeMultipleCustomScalars(input: $input)\n}\n"
  }
};
})() `)


