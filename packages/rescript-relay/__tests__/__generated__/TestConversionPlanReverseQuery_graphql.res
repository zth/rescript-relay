/* @sourceLoc Test_conversionPlan.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @live type conversionContractInput = RelaySchemaAssets_graphql.input_ConversionContractInput
  type rec response_conversionContract_a = {
    b: option<TestsUtils.Datetime.t>,
  }
  and response_conversionContract = {
    a: option<response_conversionContract_a>,
    a_b: option<TestsUtils.ConversionNumber.t>,
    dates: option<array<option<TestsUtils.Datetime.t>>>,
    grid: option<array<option<array<option<TestsUtils.ConversionNumber.t>>>>>,
    raw: option<array<option<array<option<JSON.t>>>>>,
  }
  type response = {
    conversionContract: response_conversionContract,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    input?: conversionContractInput,
  }
  @live
  type refetchVariables = {
    input?: option<conversionContractInput>,
  }
  @live let makeRefetchVariables = (
    ~input=?,
  ): refetchVariables => {
    input: ?input
  }

}


type queryRef

module Internal = {
  %%private(
  @live
  let variablesConverter: JSON.t = %raw(json`{"roots":{"__root":[{"path":["input"],"reference":"conversionContractInput"}],"conversionContractInput":[{"list":1,"path":["children"],"reference":"conversionContractInput"},{"list":2,"path":["grid"],"scalar":"0"}]},"version":2}`)
  @live
  let variablesCallbacks = {
    "0": TestsUtils.ConversionNumber.serialize,
  }
  @live
  let preparedVariablesConverter = RescriptRelay.prepareConversion(
    variablesConverter,
    variablesCallbacks,
    None
  )
  )
  @live
  let convertVariables = value => RescriptRelay.runConversion(preparedVariablesConverter, value)
  @live
  type wrapResponseRaw
  %%private(
  @live
  let wrapResponseConverter: JSON.t = %raw(json`{"roots":{"__root":[{"path":["conversionContract","a","b"],"scalar":"1"},{"path":["conversionContract","a_b"],"scalar":"0"},{"list":1,"path":["conversionContract","dates"],"scalar":"1"},{"list":2,"path":["conversionContract","grid"],"scalar":"0"},{"list":2,"opaque":true,"path":["conversionContract","raw"]}]},"version":2}`)
  @live
  let wrapResponseCallbacks = {
    "0": TestsUtils.ConversionNumber.serialize,
    "1": TestsUtils.Datetime.serialize,
  }
  @live
  let preparedWrapResponseConverter = RescriptRelay.prepareConversion(
    wrapResponseConverter,
    wrapResponseCallbacks,
    null
  )
  )
  @live
  let convertWrapResponse = value => RescriptRelay.runConversion(preparedWrapResponseConverter, value)
  @live
  type responseRaw
  %%private(
  @live
  let responseConverter = wrapResponseConverter
  @live
  let responseCallbacks = {
    "0": TestsUtils.ConversionNumber.parse,
    "1": TestsUtils.Datetime.parse,
  }
  @live
  let preparedResponseConverter = RescriptRelay.prepareConversion(
    responseConverter,
    responseCallbacks,
    None
  )
  )
  @live
  let convertResponse = value => RescriptRelay.runConversion(preparedResponseConverter, value)
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
  type rawPreloadToken<'response> = {source: Nullable.t<RescriptRelay.Observable.t<'response>>}
  external tokenToRaw: queryRef => rawPreloadToken<Types.response> = "%identity"
}
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
    "name": "input"
  }
],
v1 = [
  {
    "kind": "ClientExtension",
    "selections": [
      {
        "alias": null,
        "args": [
          {
            "kind": "Variable",
            "name": "input",
            "variableName": "input"
          }
        ],
        "concreteType": "ConversionContract",
        "kind": "LinkedField",
        "name": "conversionContract",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "ConversionContractNested",
            "kind": "LinkedField",
            "name": "a",
            "plural": false,
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "b",
                "storageKey": null
              }
            ],
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "a_b",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "raw",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "dates",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "grid",
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestConversionPlanReverseQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestConversionPlanReverseQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "b2881739785e489cd64a009ebdb584d0",
    "id": null,
    "metadata": {},
    "name": "TestConversionPlanReverseQuery",
    "operationKind": "query",
    "text": null
  }
};
})() `)

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
  RescriptRelayReact.loadQuery(
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
  raw.source->Nullable.toOption
}
  
@live
let queryRefToPromise = token => {
  Promise.make((resolve, _reject) => {
    switch token->queryRefToObservable {
    | None => resolve(Error())
    | Some(o) =>
      open RescriptRelay.Observable
      let _: subscription = o->subscribe(makeObserver(~complete=() => resolve(Ok())))
    }
  })
}
