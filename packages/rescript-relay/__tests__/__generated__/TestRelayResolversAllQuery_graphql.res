/* @sourceLoc Test_relayResolversAll.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_localUser_meta = {
    online: option<bool>,
  }
  and response_localUser = {
    hasBeenOnlineToday: option<bool>,
    meta: response_localUser_meta,
    name: option<string>,
    nameRepeated: option<string>,
  }
  type response = {
    localUser: option<response_localUser>,
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
  let variablesConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    None
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    null
  )
  @live
  type responseRaw
  @live
  let responseConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    None
  )
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


%%private(let makeNode = (rescript_graphql_node_LocalUser__id, rescript_graphql_node_LocalUser____relay_model_instance, rescript_graphql_node_UserMeta____relay_model_instance, resolverDataInjector, rescript_module_RelayLocalUserModel_LocalUser, rescript_module_TestRelayResolvers_localUser, rescript_module_TestRelayResolvers_name, rescript_module_TestRelayResolvers_nameRepeated, rescript_module_TestRelayResolvers_meta, rescript_module_TestRelayResolvers_online, rescript_module_TestRelayResolvers_hasBeenOnlineToday): operationType => {
  ignore(rescript_graphql_node_LocalUser__id)
  ignore(rescript_graphql_node_LocalUser____relay_model_instance)
  ignore(rescript_graphql_node_UserMeta____relay_model_instance)
  ignore(resolverDataInjector)
  ignore(rescript_module_RelayLocalUserModel_LocalUser)
  ignore(rescript_module_TestRelayResolvers_localUser)
  ignore(rescript_module_TestRelayResolvers_name)
  ignore(rescript_module_TestRelayResolvers_nameRepeated)
  ignore(rescript_module_TestRelayResolvers_meta)
  ignore(rescript_module_TestRelayResolvers_online)
  ignore(rescript_module_TestRelayResolvers_hasBeenOnlineToday)
  %raw(json`(function(){
var v0 = {
  "args": null,
  "kind": "FragmentSpread",
  "name": "LocalUser____relay_model_instance"
},
v1 = [
  {
    "kind": "Literal",
    "name": "times",
    "value": 2
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v3 = {
  "kind": "InlineFragment",
  "selections": [
    {
      "name": "__relay_model_instance",
      "args": null,
      "fragment": {
        "kind": "InlineFragment",
        "selections": [
          (v2/*: any*/)
        ],
        "type": "LocalUser",
        "abstractKey": null
      },
      "kind": "RelayResolver",
      "storageKey": null,
      "isOutputType": false
    }
  ],
  "type": "LocalUser",
  "abstractKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": {
      "hasClientEdges": true
    },
    "name": "TestRelayResolversAllQuery",
    "selections": [
      {
        "kind": "ClientEdgeToClientObject",
        "concreteType": "LocalUser",
        "modelResolvers": {
          "LocalUser": {
            "alias": null,
            "args": null,
            "fragment": {
              "args": null,
              "kind": "FragmentSpread",
              "name": "LocalUser__id"
            },
            "kind": "RelayResolver",
            "name": "localUser",
            "resolverModule": resolverDataInjector(rescript_graphql_node_LocalUser__id, rescript_module_RelayLocalUserModel_LocalUser, 'id', true),
            "path": "localUser.__relay_model_instance"
          }
        },
        "backingField": {
          "alias": null,
          "args": null,
          "fragment": null,
          "kind": "RelayResolver",
          "name": "localUser",
          "resolverModule": rescript_module_TestRelayResolvers_localUser,
          "path": "localUser"
        },
        "linkedField": {
          "alias": null,
          "args": null,
          "concreteType": "LocalUser",
          "kind": "LinkedField",
          "name": "localUser",
          "plural": false,
          "selections": [
            {
              "alias": null,
              "args": null,
              "fragment": (v0/*: any*/),
              "kind": "RelayResolver",
              "name": "name",
              "resolverModule": resolverDataInjector(rescript_graphql_node_LocalUser____relay_model_instance, rescript_module_TestRelayResolvers_name, '__relay_model_instance', true),
              "path": "localUser.name"
            },
            {
              "alias": null,
              "args": (v1/*: any*/),
              "fragment": (v0/*: any*/),
              "kind": "RelayResolver",
              "name": "nameRepeated",
              "resolverModule": resolverDataInjector(rescript_graphql_node_LocalUser____relay_model_instance, rescript_module_TestRelayResolvers_nameRepeated, '__relay_model_instance', true),
              "path": "localUser.nameRepeated"
            },
            {
              "kind": "RequiredField",
              "field": {
                "kind": "ClientEdgeToClientObject",
                "concreteType": "UserMeta",
                "modelResolvers": null,
                "backingField": {
                  "alias": null,
                  "args": null,
                  "fragment": (v0/*: any*/),
                  "kind": "RelayResolver",
                  "name": "meta",
                  "resolverModule": resolverDataInjector(rescript_graphql_node_LocalUser____relay_model_instance, rescript_module_TestRelayResolvers_meta, '__relay_model_instance', true),
                  "path": "localUser.meta",
                  "normalizationInfo": {
                    "kind": "WeakModel",
                    "concreteType": "UserMeta",
                    "plural": false
                  }
                },
                "linkedField": {
                  "alias": null,
                  "args": null,
                  "concreteType": "UserMeta",
                  "kind": "LinkedField",
                  "name": "meta",
                  "plural": false,
                  "selections": [
                    {
                      "alias": null,
                      "args": null,
                      "fragment": {
                        "args": null,
                        "kind": "FragmentSpread",
                        "name": "UserMeta____relay_model_instance"
                      },
                      "kind": "RelayResolver",
                      "name": "online",
                      "resolverModule": resolverDataInjector(rescript_graphql_node_UserMeta____relay_model_instance, rescript_module_TestRelayResolvers_online, '__relay_model_instance', true),
                      "path": "localUser.meta.online"
                    }
                  ],
                  "storageKey": null
                }
              },
              "action": "NONE"
            },
            {
              "alias": null,
              "args": null,
              "fragment": (v0/*: any*/),
              "kind": "RelayLiveResolver",
              "name": "hasBeenOnlineToday",
              "resolverModule": resolverDataInjector(rescript_graphql_node_LocalUser____relay_model_instance, rescript_module_TestRelayResolvers_hasBeenOnlineToday, '__relay_model_instance', true),
              "path": "localUser.hasBeenOnlineToday"
            }
          ],
          "storageKey": null
        }
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestRelayResolversAllQuery",
    "selections": [
      {
        "kind": "ClientEdgeToClientObject",
        "backingField": {
          "name": "localUser",
          "args": null,
          "fragment": null,
          "kind": "RelayResolver",
          "storageKey": null,
          "isOutputType": false
        },
        "linkedField": {
          "alias": null,
          "args": null,
          "concreteType": "LocalUser",
          "kind": "LinkedField",
          "name": "localUser",
          "plural": false,
          "selections": [
            {
              "name": "name",
              "args": null,
              "fragment": (v3/*: any*/),
              "kind": "RelayResolver",
              "storageKey": null,
              "isOutputType": true
            },
            {
              "name": "nameRepeated",
              "args": (v1/*: any*/),
              "fragment": (v3/*: any*/),
              "kind": "RelayResolver",
              "storageKey": "nameRepeated(times:2)",
              "isOutputType": true
            },
            {
              "kind": "ClientEdgeToClientObject",
              "backingField": {
                "name": "meta",
                "args": null,
                "fragment": (v3/*: any*/),
                "kind": "RelayResolver",
                "storageKey": null,
                "isOutputType": true
              },
              "linkedField": {
                "alias": null,
                "args": null,
                "concreteType": "UserMeta",
                "kind": "LinkedField",
                "name": "meta",
                "plural": false,
                "selections": [
                  {
                    "name": "online",
                    "args": null,
                    "fragment": {
                      "kind": "InlineFragment",
                      "selections": [
                        {
                          "alias": null,
                          "args": null,
                          "kind": "ScalarField",
                          "name": "__relay_model_instance",
                          "storageKey": null
                        }
                      ],
                      "type": "UserMeta",
                      "abstractKey": null
                    },
                    "kind": "RelayResolver",
                    "storageKey": null,
                    "isOutputType": true
                  }
                ],
                "storageKey": null
              }
            },
            {
              "name": "hasBeenOnlineToday",
              "args": null,
              "fragment": (v3/*: any*/),
              "kind": "RelayResolver",
              "storageKey": null,
              "isOutputType": true
            },
            (v2/*: any*/)
          ],
          "storageKey": null
        }
      }
    ]
  },
  "params": {
    "cacheID": "78b07c2523c4fb3b1d121a8dd72fc715",
    "id": null,
    "metadata": {},
    "name": "TestRelayResolversAllQuery",
    "operationKind": "query",
    "text": null
  }
};
})()`)
})
let node: operationType = makeNode(LocalUser__id_graphql.node, LocalUser____relay_model_instance_graphql.node, UserMeta____relay_model_instance_graphql.node, RescriptRelay.resolverDataInjector, RelayLocalUserModel.localUser, TestRelayResolvers.localUser, TestRelayResolvers.name, TestRelayResolvers.nameRepeated, TestRelayResolvers.meta, TestRelayResolvers.online, TestRelayResolvers.hasBeenOnlineToday)

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
