/* @sourceLoc Test_serializeCustomScalarArray.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live
  type rec response_serializeCustomScalarArray = {
    works: option<bool>,
  }
  @live
  type response = {
    serializeCustomScalarArray: option<response_serializeCustomScalarArray>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    input: array<TestsUtils.IntString.t>,
  }
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"input":{"ca":"TestsUtils.IntString"}}}`
  )
  @live
  let variablesConverterMap = {
    "TestsUtils.IntString": TestsUtils.IntString.serialize,
  }
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
    "concreteType": "SerializeCustomScalarArrayPayload",
    "kind": "LinkedField",
    "name": "serializeCustomScalarArray",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "works",
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
    "name": "TestSerializeCustomScalarArrayMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestSerializeCustomScalarArrayMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "60e0cb6f3560d2abc1a1641098c430a1",
    "id": null,
    "metadata": {},
    "name": "TestSerializeCustomScalarArrayMutation",
    "operationKind": "mutation",
    "text": "mutation TestSerializeCustomScalarArrayMutation(\n  $input: [IntString!]!\n) {\n  serializeCustomScalarArray(input: $input) {\n    works\n  }\n}\n"
  }
};
})() `)


