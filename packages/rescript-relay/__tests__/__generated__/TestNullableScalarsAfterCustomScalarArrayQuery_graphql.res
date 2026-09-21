/* @sourceLoc Test_nullableScalarsAfterCustomScalarArray.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_loggedInUser = {
    avatarUrl: option<string>,
    @live id: string,
    intStrings: option<array<TestsUtils.IntString.t>>,
    isOnline: option<bool>,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
    @as("private") private_: option<bool>,
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
  let variablesConverter: JSON.t = %raw(
    json`{"roots":{"__root":[]},"version":2}`
  )
  @live
  let variablesConverterMap = ()
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
    json`{"roots":{"__root":[{"list":1,"path":["loggedInUser","intStrings"],"scalar":"TestsUtils.IntString"}]},"version":2}`
  )
  @live
  let wrapResponseConverterMap = {
    "TestsUtils.IntString": TestsUtils.IntString.serialize,
  }
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
    json`{"roots":{"__root":[{"list":1,"path":["loggedInUser","intStrings"],"scalar":"TestsUtils.IntString"}]},"version":2}`
  )
  @live
  let responseConverterMap = {
    "TestsUtils.IntString": TestsUtils.IntString.parse,
  }
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
  type rawPreloadToken<'response> = {source: Nullable.t<RescriptRelay.Observable.t<'response>>}
  external tokenToRaw: queryRef => rawPreloadToken<Types.response> = "%identity"
}
module Utils = {
  @@warning("-33")
  open Types
  @live
  external onlineStatus_toString: RelaySchemaAssets_graphql.enum_OnlineStatus => string = "%identity"
  @live
  external onlineStatus_input_toString: RelaySchemaAssets_graphql.enum_OnlineStatus_input => string = "%identity"
  @live
  let onlineStatus_decode = (enum: RelaySchemaAssets_graphql.enum_OnlineStatus): option<RelaySchemaAssets_graphql.enum_OnlineStatus_input> => {
    switch enum {
      | FutureAddedValue(_) => None
      | valid => Some(Obj.magic(valid))
    }
  }
  @live
  let onlineStatus_fromString = (str: string): option<RelaySchemaAssets_graphql.enum_OnlineStatus_input> => {
    onlineStatus_decode(Obj.magic(str))
  }
}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
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
        "args": null,
        "kind": "ScalarField",
        "name": "id",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "intStrings",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "avatarUrl",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "isOnline",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "private",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "onlineStatus",
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestNullableScalarsAfterCustomScalarArrayQuery",
    "selections": (v0/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestNullableScalarsAfterCustomScalarArrayQuery",
    "selections": (v0/*: any*/)
  },
  "params": {
    "cacheID": "060acca966292ed2c3be1b6610260bf1",
    "id": null,
    "metadata": {},
    "name": "TestNullableScalarsAfterCustomScalarArrayQuery",
    "operationKind": "query",
    "text": "query TestNullableScalarsAfterCustomScalarArrayQuery {\n  loggedInUser {\n    id\n    intStrings\n    avatarUrl\n    isOnline\n    private\n    onlineStatus\n  }\n}\n"
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
