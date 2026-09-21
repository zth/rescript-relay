/* @sourceLoc Test_testingHelpers.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_loggedInUser = {
    firstName: string,
    @live id: string,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus>,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestTestingHelpers_user]>,
  }
  @live
  and rawResponse_loggedInUser = {
    @live __id: option<RescriptRelay.dataId>,
    firstName: string,
    @live id: string,
    lastName: string,
    onlineStatus: option<RelaySchemaAssets_graphql.enum_OnlineStatus_input>,
  }
  type response = {
    loggedInUser: response_loggedInUser,
  }
  @live
  type rawResponse = {
    loggedInUser: rawResponse_loggedInUser,
  }
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
    json`{"roots":{"__root":[{"fragments":true,"path":["loggedInUser"]}]},"version":2}`
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
    json`{"roots":{"__root":[{"fragments":true,"path":["loggedInUser"]}]},"version":2}`
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
  @live
  type wrapRawResponseRaw
  @live
  let wrapRawResponseConverter: JSON.t = %raw(
    json`{"roots":{"__root":[]},"version":2}`
  )
  @live
  let wrapRawResponseConverterMap = ()
  @live
  let preparedWrapRawResponseConverter = RescriptRelay.prepareConversion(
    wrapRawResponseConverter,
    wrapRawResponseConverterMap,
    null
  )
  @live
  let convertWrapRawResponse = value => RescriptRelay.runConversion(preparedWrapRawResponseConverter, value)
  @live
  type rawResponseRaw
  @live
  let rawResponseConverter: JSON.t = %raw(
    json`{"roots":{"__root":[]},"version":2}`
  )
  @live
  let rawResponseConverterMap = ()
  @live
  let preparedRawResponseConverter = RescriptRelay.prepareConversion(
    rawResponseConverter,
    rawResponseConverterMap,
    None
  )
  @live
  let convertRawResponse = value => RescriptRelay.runConversion(preparedRawResponseConverter, value)
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
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "onlineStatus",
  "storageKey": null
},
v3 = {
  "enumValues": null,
  "nullable": false,
  "plural": false,
  "type": "ID"
},
v4 = {
  "enumValues": null,
  "nullable": false,
  "plural": false,
  "type": "String"
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestTestingHelpersQuery",
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
          (v1/*: any*/),
          (v2/*: any*/),
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestTestingHelpers_user"
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
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestTestingHelpersQuery",
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
          (v1/*: any*/),
          (v2/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "lastName",
            "storageKey": null
          },
          {
            "kind": "ClientExtension",
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "__id",
                "storageKey": null
              }
            ]
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "79d8f121d62e528a53256df555a012c8",
    "id": null,
    "metadata": {
      "relayTestingSelectionTypeInfo": {
        "loggedInUser": {
          "enumValues": null,
          "nullable": false,
          "plural": false,
          "type": "User"
        },
        "loggedInUser.__id": (v3/*: any*/),
        "loggedInUser.firstName": (v4/*: any*/),
        "loggedInUser.id": (v3/*: any*/),
        "loggedInUser.lastName": (v4/*: any*/),
        "loggedInUser.onlineStatus": {
          "enumValues": [
            "Online",
            "Idle",
            "offline"
          ],
          "nullable": true,
          "plural": false,
          "type": "OnlineStatus"
        }
      }
    },
    "name": "TestTestingHelpersQuery",
    "operationKind": "query",
    "text": "query TestTestingHelpersQuery {\n  loggedInUser {\n    id\n    firstName\n    onlineStatus\n    ...TestTestingHelpers_user\n  }\n}\n\nfragment TestTestingHelpers_sub_user on User {\n  lastName\n}\n\nfragment TestTestingHelpers_user on User {\n  firstName\n  onlineStatus\n  ...TestTestingHelpers_sub_user\n}\n"
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
