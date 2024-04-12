/* @sourceLoc Test_providedVariables.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live type inputC = RelaySchemaAssets_graphql.input_InputC
  type rec response_loggedInUser = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestProvidedVariables_user]>,
  }
  type response = {
    loggedInUser: response_loggedInUser,
  }
  @live
  type rawResponse = response
  @live
  type variables = unit
  @live
  type refetchVariables = unit
  @live let makeRefetchVariables = () => ()
}


type queryRef

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"inputC":{"recursiveC":{"r":"inputC"},"intStr":{"c":"TestsUtils.IntString"}},"__root":{"__relay_internal__pv__ProvidedVariablesIntStrArr":{"ca":"TestsUtils.IntString"},"__relay_internal__pv__ProvidedVariablesIntStr":{"c":"TestsUtils.IntString"},"__relay_internal__pv__ProvidedVariablesInputCArr":{"r":"inputC"},"__relay_internal__pv__ProvidedVariablesInputC":{"r":"inputC"}}}`
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
    json`{"__root":{"loggedInUser":{"f":""}}}`
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
    json`{"__root":{"loggedInUser":{"f":""}}}`
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
  type rawPreloadToken<'response> = {source: Js.Nullable.t<RescriptRelay.Observable.t<'response>>}
  external tokenToRaw: queryRef => rawPreloadToken<Types.response> = "%identity"
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
  __relay_internal__pv__ProvidedVariablesIntStrArr: providedVariable<array<TestsUtils.IntString.t>>,
}
@live let providedVariablesDefinition: providedVariablesType = {
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
  __relay_internal__pv__ProvidedVariablesIntStrArr: {
    providedVariable: ProvidedVariables.IntStrArr.get,
    get: () => Internal.convertVariables(Js.Dict.fromArray([("__relay_internal__pv__ProvidedVariablesIntStrArr", ProvidedVariables.IntStrArr.get())]))->Js.Dict.unsafeGet("__relay_internal__pv__ProvidedVariablesIntStrArr"),
  },
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


%%private(let makeNode = (providedVariablesDefinition): operationType => {
  ignore(providedVariablesDefinition)
  %raw(json`{
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestProvidedVariablesQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestProvidedVariables_user"
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "__relay_internal__pv__ProvidedVariablesBool"
      },
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "__relay_internal__pv__ProvidedVariablesInputC"
      },
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "__relay_internal__pv__ProvidedVariablesInputCArr"
      },
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "__relay_internal__pv__ProvidedVariablesIntStr"
      },
      {
        "defaultValue": null,
        "kind": "LocalArgument",
        "name": "__relay_internal__pv__ProvidedVariablesIntStrArr"
      }
    ],
    "kind": "Operation",
    "name": "TestProvidedVariablesQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": [
              {
                "kind": "Variable",
                "name": "bool",
                "variableName": "__relay_internal__pv__ProvidedVariablesBool"
              },
              {
                "kind": "Variable",
                "name": "inputC",
                "variableName": "__relay_internal__pv__ProvidedVariablesInputC"
              },
              {
                "kind": "Variable",
                "name": "inputCArr",
                "variableName": "__relay_internal__pv__ProvidedVariablesInputCArr"
              },
              {
                "kind": "Variable",
                "name": "intStr",
                "variableName": "__relay_internal__pv__ProvidedVariablesIntStr"
              },
              {
                "kind": "Variable",
                "name": "intStrArr",
                "variableName": "__relay_internal__pv__ProvidedVariablesIntStrArr"
              }
            ],
            "kind": "ScalarField",
            "name": "someRandomArgField",
            "storageKey": null
          },
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
    "cacheID": "089cd98a77f01b819f764cce3917652a",
    "id": null,
    "metadata": {},
    "name": "TestProvidedVariablesQuery",
    "operationKind": "query",
    "text": "query TestProvidedVariablesQuery(\n  $__relay_internal__pv__ProvidedVariablesBool: Boolean!\n  $__relay_internal__pv__ProvidedVariablesInputC: InputC!\n  $__relay_internal__pv__ProvidedVariablesInputCArr: [InputC!]\n  $__relay_internal__pv__ProvidedVariablesIntStr: IntString!\n  $__relay_internal__pv__ProvidedVariablesIntStrArr: [IntString!]!\n) {\n  loggedInUser {\n    ...TestProvidedVariables_user\n    id\n  }\n}\n\nfragment TestProvidedVariables_user on User {\n  someRandomArgField(bool: $__relay_internal__pv__ProvidedVariablesBool, inputC: $__relay_internal__pv__ProvidedVariablesInputC, inputCArr: $__relay_internal__pv__ProvidedVariablesInputCArr, intStr: $__relay_internal__pv__ProvidedVariablesIntStr, intStrArr: $__relay_internal__pv__ProvidedVariablesIntStrArr)\n}\n",
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

@live
let queryRefToObservable = token => {
  let raw = token->Internal.tokenToRaw
  raw.source->Js.Nullable.toOption
}
  
@live
let queryRefToPromise = token => {
  Js.Promise.make((~resolve, ~reject as _) => {
    switch token->queryRefToObservable {
    | None => resolve(Error())
    | Some(o) =>
      open RescriptRelay.Observable
      let _: subscription = o->subscribe(makeObserver(~complete=() => resolve(Ok())))
    }
  })
}
