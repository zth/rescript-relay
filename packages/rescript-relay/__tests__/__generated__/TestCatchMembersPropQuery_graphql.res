/* @sourceLoc Test_catch.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type response_members_edges_node_value = 
    | @live User(
      {
        createdAt: TestsUtils.Datetime.t,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  type rec response_members_edges = {
    node: RescriptRelay.CatchResult.t<option<response_members_edges_node_value>>,
  }
  and response_members = {
    edges: option<array<option<response_members_edges>>>,
  }
  type response = {
    members: option<response_members>,
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
let unwrap_response_members_edges_node_value: Types.response_members_edges_node_value => Types.response_members_edges_node_value = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_response_members_edges_node_value: Types.response_members_edges_node_value => Types.response_members_edges_node_value = RescriptRelay_Internal.wrapUnion

type queryRef

module Internal = {
  @live
  let convertVariables = value => RescriptRelay.convertWithoutPlan(value, None)
  @live
  type wrapResponseRaw
  %%private(
  @live
  let wrapResponseConverter: JSON.t = %raw(json`{"roots":{"__root":[{"list":1,"path":["members","edges"]},{"path":["members","edges","node","value"],"union":"1"},{"path":["members","edges","node","value","User","createdAt"],"scalar":"0"}]},"version":2}`)
  @live
  let wrapResponseCallbacks = {
    "0": TestsUtils.Datetime.serialize,
    "1": wrap_response_members_edges_node_value,
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
    "0": TestsUtils.Datetime.parse,
    "1": unwrap_response_members_edges_node_value,
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
    "kind": "Literal",
    "name": "groupId",
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
  "name": "id",
  "storageKey": null
},
v3 = {
  "kind": "InlineFragment",
  "selections": [
    (v2/*: any*/),
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "createdAt",
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestCatchMembersPropQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": "MemberConnection",
        "kind": "LinkedField",
        "name": "members",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "MemberEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "kind": "CatchField",
                "field": {
                  "alias": null,
                  "args": null,
                  "concreteType": null,
                  "kind": "LinkedField",
                  "name": "node",
                  "plural": false,
                  "selections": [
                    (v1/*: any*/),
                    (v3/*: any*/)
                  ],
                  "storageKey": null
                },
                "to": "RESULT"
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": "members(groupId:\"123\")"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestCatchMembersPropQuery",
    "selections": [
      {
        "alias": null,
        "args": (v0/*: any*/),
        "concreteType": "MemberConnection",
        "kind": "LinkedField",
        "name": "members",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "MemberEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": null,
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v1/*: any*/),
                  (v3/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v2/*: any*/)
                    ],
                    "type": "Node",
                    "abstractKey": "__isNode"
                  }
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": "members(groupId:\"123\")"
      }
    ]
  },
  "params": {
    "cacheID": "98d239a936e0ac54023a142c978b3102",
    "id": null,
    "metadata": {},
    "name": "TestCatchMembersPropQuery",
    "operationKind": "query",
    "text": "query TestCatchMembersPropQuery {\n  members(groupId: \"123\") {\n    edges {\n      node {\n        __typename\n        ... on User {\n          id\n          createdAt\n        }\n        ... on Node {\n          __isNode: __typename\n          __typename\n          id\n        }\n      }\n    }\n  }\n}\n"
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
