/* @sourceLoc Test_preloadedQuery.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  type variables = TestPreloadedQuery_graphql.Types.variables
}
module Internal = {
  module Variables = {
    include TestPreloadedQuery_graphql.Internal.Variables
  }
  let convertVariables = Variables.convertVariables
}
module ProvidedVariables = {
  include TestPreloadedQuery_graphql.ProvidedVariables
  }
let providedVariablesDefinition = ProvidedVariables.providedVariablesDefinition
type queryRef = TestPreloadedQuery_graphql.queryRef

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
