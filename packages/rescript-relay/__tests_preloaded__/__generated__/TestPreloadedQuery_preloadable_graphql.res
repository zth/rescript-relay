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
  let variablesConverter: dict<dict<dict<string>>> = %raw(
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
    None
  )
}
module Utils = {
  @@warning("-33")
  open Types
}
@live type providedVariable<'t> = { providedVariable: unit => 't, get: unit => 't }
@live type providedVariablesType = {
  __relay_internal__pv__ProvidedVariablesBool: providedVariable<bool>,
  __relay_internal__pv__ProvidedVariablesInputC: providedVariable<RelaySchemaAssets_graphql.input_InputC>,
  __relay_internal__pv__ProvidedVariablesInputCArr: providedVariable<option<array<RelaySchemaAssets_graphql.input_InputC>>>,
  __relay_internal__pv__ProvidedVariablesIntStr: providedVariable<TestsUtils.IntString.t>,
}
@live let providedVariablesDefinition: providedVariablesType = {
  __relay_internal__pv__ProvidedVariablesBool: {
    providedVariable: ProvidedVariables.Bool.get,
    get: ProvidedVariables.Bool.get,
  },
  __relay_internal__pv__ProvidedVariablesInputC: {
    providedVariable: ProvidedVariables.InputC.get,
    get: () => Internal.convertVariables(Dict.fromArray([("__relay_internal__pv__ProvidedVariablesInputC", ProvidedVariables.InputC.get())]))->Dict.getUnsafe("__relay_internal__pv__ProvidedVariablesInputC"),
  },
  __relay_internal__pv__ProvidedVariablesInputCArr: {
    providedVariable: ProvidedVariables.InputCArr.get,
    get: () => Internal.convertVariables(Dict.fromArray([("__relay_internal__pv__ProvidedVariablesInputCArr", ProvidedVariables.InputCArr.get())]))->Dict.getUnsafe("__relay_internal__pv__ProvidedVariablesInputCArr"),
  },
  __relay_internal__pv__ProvidedVariablesIntStr: {
    providedVariable: ProvidedVariables.IntStr.get,
    get: () => Internal.convertVariables(Dict.fromArray([("__relay_internal__pv__ProvidedVariablesIntStr", ProvidedVariables.IntStr.get())]))->Dict.getUnsafe("__relay_internal__pv__ProvidedVariablesIntStr"),
  },
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


%%private(let makeNode = (providedVariablesDefinition): operationType => {
  ignore(providedVariablesDefinition)
  %raw(json`{
  "kind": "PreloadableConcreteRequest",
  "params": {
    "id": "43cd03101ac04ecf392bdc41dcefc4c1",
    "metadata": {},
    "name": "TestPreloadedQuery",
    "operationKind": "query",
    "text": null,
    "providedVariables": providedVariablesDefinition
  }
}`)
})
let node: operationType = makeNode(providedVariablesDefinition)

@live let load: (
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
