/* @sourceLoc Test_refetchingInNode.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type response_node = 
    | @live User(
      {
        fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestRefetchingInNode_user]>,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  type response = {
    node: option<response_node>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    friendsOnlineStatuses?: array<RelaySchemaAssets_graphql.enum_OnlineStatus_input>,
    userId: string,
  }
  @live
  type refetchVariables = {
    friendsOnlineStatuses?: option<array<RelaySchemaAssets_graphql.enum_OnlineStatus_input>>,
    userId?: string,
  }
  @live let makeRefetchVariables = (
    ~friendsOnlineStatuses=?,
    ~userId=?,
  ): refetchVariables => {
    friendsOnlineStatuses: ?friendsOnlineStatuses,
    userId: ?userId
  }

}

@live
let unwrap_response_node: Types.response_node => Types.response_node = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_response_node: Types.response_node => Types.response_node = RescriptRelay_Internal.wrapUnion

type queryRef

module Internal = {
  @live
  let variablesConverter: JSON.t = %raw(
    json`{"roots":{"__root":[{"list":1,"path":["friendsOnlineStatuses"]}]},"version":2}`
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
    json`{"roots":{"__root":[{"path":["node"],"union":"response_node"},{"fragments":true,"path":["node","User"]}]},"version":2}`
  )
  @live
  let wrapResponseConverterMap = {
    "response_node": wrap_response_node,
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
    json`{"roots":{"__root":[{"path":["node"],"union":"response_node"},{"fragments":true,"path":["node","User"]}]},"version":2}`
  )
  @live
  let responseConverterMap = {
    "response_node": unwrap_response_node,
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
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "friendsOnlineStatuses"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "userId"
},
v2 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "userId"
  }
],
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestRefetchingInNodeQuery",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v3/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": [
              {
                "args": [
                  {
                    "kind": "Variable",
                    "name": "friendsOnlineStatuses",
                    "variableName": "friendsOnlineStatuses"
                  }
                ],
                "kind": "FragmentSpread",
                "name": "TestRefetchingInNode_user"
              }
            ],
            "type": "User",
            "abstractKey": null
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
      (v1/*: any*/),
      (v0/*: any*/)
    ],
    "kind": "Operation",
    "name": "TestRefetchingInNodeQuery",
    "selections": [
      {
        "alias": null,
        "args": (v2/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v3/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          },
          {
            "kind": "InlineFragment",
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "firstName",
                "storageKey": null
              },
              {
                "alias": null,
                "args": [
                  {
                    "kind": "Variable",
                    "name": "statuses",
                    "variableName": "friendsOnlineStatuses"
                  }
                ],
                "concreteType": "UserConnection",
                "kind": "LinkedField",
                "name": "friendsConnection",
                "plural": false,
                "selections": [
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "totalCount",
                    "storageKey": null
                  }
                ],
                "storageKey": null
              }
            ],
            "type": "User",
            "abstractKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "d84a2530c9a2a6effabea58320339901",
    "id": null,
    "metadata": {},
    "name": "TestRefetchingInNodeQuery",
    "operationKind": "query",
    "text": "query TestRefetchingInNodeQuery(\n  $userId: ID!\n  $friendsOnlineStatuses: [OnlineStatus!]\n) {\n  node(id: $userId) {\n    __typename\n    ... on User {\n      ...TestRefetchingInNode_user_4itqcE\n    }\n    id\n  }\n}\n\nfragment TestRefetchingInNode_user_4itqcE on User {\n  firstName\n  friendsConnection(statuses: $friendsOnlineStatuses) {\n    totalCount\n  }\n  id\n}\n"
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
