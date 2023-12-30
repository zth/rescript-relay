/* @sourceLoc Test_preloadedQuery.res */
/* @generated */
%%raw("/* @generated */")
type queryRef = TestPreloadedQuery_graphql.queryRef
module Types = {
  @@warning("-30")

  @live type inputC = RelaySchemaAssets_graphql.input_InputC
  @live
  type variables = {
    status?: RelaySchemaAssets_graphql.enum_OnlineStatus_input,
  }
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"inputC":{"recursiveC":{"r":"inputC"},"intStr":{"c":"TestsUtils.IntString"}},"__root":{"__relay_internal__pv__ProvidedVariablesIntStr":{"c":"TestsUtils.IntString"},"__relay_internal__pv__ProvidedVariablesInputCArr":{"r":"inputC"},"__relay_internal__pv__ProvidedVariablesInputC":{"r":"inputC"}}}`
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
}
module Utils = {
  @@warning("-33")
  open Types
}
type providedVariable<'t> = { providedVariable: unit => 't, get: unit => 't }
type providedVariablesType = {
  __relay_internal__pv__ProvidedVariablesBool: providedVariable<bool>,
  __relay_internal__pv__ProvidedVariablesInputC: providedVariable<RelaySchemaAssets_graphql.input_InputC>,
  __relay_internal__pv__ProvidedVariablesInputCArr: providedVariable<option<array<RelaySchemaAssets_graphql.input_InputC>>>,
  __relay_internal__pv__ProvidedVariablesIntStr: providedVariable<TestsUtils.IntString.t>,
}
let providedVariablesDefinition: providedVariablesType = {
  __relay_internal__pv__ProvidedVariablesBool: {
    providedVariable: ProvidedVariables.Bool.get,
    get: ProvidedVariables.Bool.get,
  },
  __relay_internal__pv__ProvidedVariablesInputC: {
    providedVariable: ProvidedVariables.InputC.get,
    get: () => Internal.convertVariables(Js.Dict.fromArray([("__relay_internal__pv__ProvidedVariablesInputC", ProvidedVariables.InputC.get())]))->Js.Dict.unsafeGet("__relay_internal__pv__ProvidedVariablesInputC"),
  },
  __relay_internal__pv__ProvidedVariablesInputCArr: {
    providedVariable: ProvidedVariables.InputCArr.get,
    get: () => Internal.convertVariables(Js.Dict.fromArray([("__relay_internal__pv__ProvidedVariablesInputCArr", ProvidedVariables.InputCArr.get())]))->Js.Dict.unsafeGet("__relay_internal__pv__ProvidedVariablesInputCArr"),
  },
  __relay_internal__pv__ProvidedVariablesIntStr: {
    providedVariable: ProvidedVariables.IntStr.get,
    get: () => Internal.convertVariables(Js.Dict.fromArray([("__relay_internal__pv__ProvidedVariablesIntStr", ProvidedVariables.IntStr.get())]))->Js.Dict.unsafeGet("__relay_internal__pv__ProvidedVariablesIntStr"),
  },
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


%%private(let makeNode = (providedVariablesDefinition): operationType => {
  ignore(providedVariablesDefinition)
  %raw(json`{
  "kind": "PreloadableConcreteRequest",
  "params": {
    "id": "64e1bd5c44a860103e5980b544f5e454",
    "metadata": {},
    "name": "TestPreloadedQuery",
    "operationKind": "query",
    "text": null,
    "providedVariables": providedVariablesDefinition
  }
}`)
})
let node: operationType = makeNode(providedVariablesDefinition)

let load: (
  ~environment: RescriptRelay.Environment.t,
  ~variables: Types.variables,
  ~fetchPolicy: RescriptRelay.fetchPolicy=?,
  ~fetchKey: string=?,
  ~networkCacheConfig: RescriptRelay.cacheConfig=?,
) => queryRef = (
  ~environment,
  ~variables,
  ~fetchPolicy=?,
  ~fetchKey=?,
  ~networkCacheConfig=?,
) =>
  RescriptRelay.loadQuery(
    environment,
    node,
    variables->Internal.convertVariables,
    {
      fetchKey,
      fetchPolicy,
      networkCacheConfig,
    },
  )
