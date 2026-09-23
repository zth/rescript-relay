/* @sourceLoc Test_updatableFragments.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_loggedInUser = {
    firstName: string,
  }
  type response = {
    loggedInUser: response_loggedInUser,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestUpdatableFragments_query]>,
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
  let convertVariables = value => RescriptRelay.convertWithoutPlan(value, None)
  @live
  type wrapResponseRaw
  %%private(
  @live
  let wrapResponseConverter: JSON.t = %raw(json`{"roots":{"__root":[{"fragments":true,"path":[]}]},"version":2}`)
  @live
  let wrapResponseCallbacks = ()
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
  let responseCallbacks = ()
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
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestUpdatableFragmentsQuery",
    "selections": [
      {
        "args": null,
        "kind": "FragmentSpread",
        "name": "TestUpdatableFragments_query"
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          (v0/*: any*/)
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestUpdatableFragmentsQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          (v0/*: any*/),
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
            "name": "__typename",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "concreteType": "User",
            "kind": "LinkedField",
            "name": "bestFriend",
            "plural": false,
            "selections": [
              (v0/*: any*/),
              (v1/*: any*/)
            ],
            "storageKey": null
          },
          (v1/*: any*/)
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "f8b22f8b79b8d5f6e84755a46f99810d",
    "id": null,
    "metadata": {},
    "name": "TestUpdatableFragmentsQuery",
    "operationKind": "query",
    "text": "query TestUpdatableFragmentsQuery {\n  ...TestUpdatableFragments_query\n  loggedInUser {\n    firstName\n    id\n  }\n}\n\nfragment TestUpdatableFragments_query on Query {\n  loggedInUser {\n    firstName\n    isOnline\n    __typename\n    bestFriend {\n      firstName\n      id\n    }\n    id\n  }\n}\n"
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
