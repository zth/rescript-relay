/* @sourceLoc Test_nodeInterface.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type response__testExhaustiveInterface = 
    | @live Group(
      {
      }
    )
    | @live User(
      {
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type response_node = 
    | @live User(
      {
        firstName: string,
        fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestNodeInterface_user]>,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  type response = {
    _testExhaustiveInterface: option<response__testExhaustiveInterface>,
    node: option<response_node>,
  }
  @live
  type rawResponse = response
  @live
  type variables = unit
  @live
  type refetchVariables = unit
  @live let makeRefetchVariables = () => ()
}

@live
let unwrap_response__testExhaustiveInterface: Types.response__testExhaustiveInterface => Types.response__testExhaustiveInterface = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_response__testExhaustiveInterface: Types.response__testExhaustiveInterface => Types.response__testExhaustiveInterface = RescriptRelay_Internal.wrapUnion
@live
let unwrap_response_node: Types.response_node => Types.response_node = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_response_node: Types.response_node => Types.response_node = RescriptRelay_Internal.wrapUnion

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
    json`{"__root":{"node_User":{"f":""},"node":{"u":"response_node"},"_testExhaustiveInterface":{"u":"response__testExhaustiveInterface"}}}`
  )
  @live
  let wrapResponseConverterMap = {
    "response__testExhaustiveInterface": wrap_response__testExhaustiveInterface,
    "response_node": wrap_response_node,
  }
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
    json`{"__root":{"node_User":{"f":""},"node":{"u":"response_node"},"_testExhaustiveInterface":{"u":"response__testExhaustiveInterface"}}}`
  )
  @live
  let responseConverterMap = {
    "response__testExhaustiveInterface": unwrap_response__testExhaustiveInterface,
    "response_node": unwrap_response_node,
  }
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


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "kind": "Literal",
    "name": "id",
    "value": "123"
  }
],
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v3 = [
  (v1/*: any*/)
],
v4 = {
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
    "name": "TestNodeInterfaceQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": [
              (v2/*: any*/),
              {
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestNodeInterface_user"
              }
            ],
            "type": "User",
            "abstractKey": null
          }
        ],
        "storageKey": "node(id:\"123\")"
      },
      {
        "alias": "_testExhaustiveInterface",
        "args": (v0/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": (v3/*: any*/),
            "type": "User",
            "abstractKey": null
          },
          {
            "kind": "InlineFragment",
            "selections": (v3/*: any*/),
            "type": "Group",
            "abstractKey": null
          }
        ],
        "storageKey": "node(id:\"123\")"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestNodeInterfaceQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": [
              (v2/*: any*/)
            ],
            "type": "User",
            "abstractKey": null
          },
          (v4/*: any*/)
        ],
        "storageKey": "node(id:\"123\")"
      },
      {
        "alias": "_testExhaustiveInterface",
        "args": (v0/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "node",
        "plural": false,
        "selections": [
          (v1/*: any*/),
          (v4/*: any*/)
        ],
        "storageKey": "node(id:\"123\")"
      }
    ]
  },
  "params": {
    "cacheID": "45a362fa21af5d57a410f3e00ba11486",
    "id": null,
    "metadata": {},
    "name": "TestNodeInterfaceQuery",
    "operationKind": "query",
    "text": "query TestNodeInterfaceQuery {\n  node(id: \"123\") {\n    __typename\n    ... on User {\n      firstName\n      ...TestNodeInterface_user\n    }\n    id\n  }\n  _testExhaustiveInterface: node(id: \"123\") {\n    __typename\n    ... on User {\n      __typename\n    }\n    ... on Group {\n      __typename\n    }\n    id\n  }\n}\n\nfragment TestNodeInterface_user on User {\n  firstName\n}\n"
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
