/* @sourceLoc Test_conversionPlural.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_members_edges_node = {
    @live __typename: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestConversionPluralNode_node | #TestConversionPluralUnion_member]>,
  }
  and response_members_edges = {
    node: option<response_members_edges_node>,
  }
  and response_members = {
    edges: option<array<option<response_members_edges>>>,
  }
  and response_users_edges_node = {
    @live id: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestConversionPluralCatch_user | #TestConversionPluralNode_node | #TestConversionPluralNullable_user | #TestConversionPlural_user]>,
  }
  and response_users_edges = {
    node: option<response_users_edges_node>,
  }
  and response_users = {
    edges: option<array<option<response_users_edges>>>,
  }
  type response = {
    members: option<response_members>,
    users: option<response_users>,
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
  let wrapResponseConverter: JSON.t = %raw(json`{"roots":{"__root":[{"list":1,"path":["members","edges"]},{"fragments":true,"path":["members","edges","node"]},{"list":1,"path":["users","edges"]},{"fragments":true,"path":["users","edges","node"]}]},"version":2}`)
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
  "name": "id",
  "storageKey": null
},
v1 = {
  "args": null,
  "kind": "FragmentSpread",
  "name": "TestConversionPluralNode_node"
},
v2 = [
  {
    "kind": "Literal",
    "name": "groupId",
    "value": "group"
  }
],
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "createdAt",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v6 = {
  "kind": "InlineFragment",
  "selections": [
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "name",
      "storageKey": null
    }
  ],
  "type": "Group",
  "abstractKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestConversionPluralQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "UserConnection",
        "kind": "LinkedField",
        "name": "users",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "UserEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": "User",
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v0/*: any*/),
                  {
                    "args": null,
                    "kind": "FragmentSpread",
                    "name": "TestConversionPlural_user"
                  },
                  {
                    "args": null,
                    "kind": "FragmentSpread",
                    "name": "TestConversionPluralCatch_user"
                  },
                  {
                    "args": null,
                    "kind": "FragmentSpread",
                    "name": "TestConversionPluralNullable_user"
                  },
                  (v1/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": (v2/*: any*/),
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
                  (v3/*: any*/),
                  {
                    "args": null,
                    "kind": "FragmentSpread",
                    "name": "TestConversionPluralUnion_member"
                  },
                  (v1/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": "members(groupId:\"group\")"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TestConversionPluralQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "UserConnection",
        "kind": "LinkedField",
        "name": "users",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "UserEdge",
            "kind": "LinkedField",
            "name": "edges",
            "plural": true,
            "selections": [
              {
                "alias": null,
                "args": null,
                "concreteType": "User",
                "kind": "LinkedField",
                "name": "node",
                "plural": false,
                "selections": [
                  (v0/*: any*/),
                  (v4/*: any*/),
                  (v5/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v3/*: any*/),
                      (v6/*: any*/)
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
        "storageKey": null
      },
      {
        "alias": null,
        "args": (v2/*: any*/),
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
                  (v3/*: any*/),
                  {
                    "kind": "TypeDiscriminator",
                    "abstractKey": "__isMember"
                  },
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v5/*: any*/),
                      (v4/*: any*/)
                    ],
                    "type": "User",
                    "abstractKey": null
                  },
                  (v6/*: any*/),
                  {
                    "kind": "InlineFragment",
                    "selections": [
                      (v0/*: any*/)
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
        "storageKey": "members(groupId:\"group\")"
      }
    ]
  },
  "params": {
    "cacheID": "12b21ea36baea2bc4e53962113b3c70f",
    "id": null,
    "metadata": {},
    "name": "TestConversionPluralQuery",
    "operationKind": "query",
    "text": "query TestConversionPluralQuery {\n  users {\n    edges {\n      node {\n        id\n        ...TestConversionPlural_user\n        ...TestConversionPluralCatch_user\n        ...TestConversionPluralNullable_user\n        ...TestConversionPluralNode_node\n      }\n    }\n  }\n  members(groupId: \"group\") {\n    edges {\n      node {\n        __typename\n        ...TestConversionPluralUnion_member\n        ...TestConversionPluralNode_node\n        ... on Node {\n          __isNode: __typename\n          __typename\n          id\n        }\n      }\n    }\n  }\n}\n\nfragment TestConversionPluralCatch_user on User {\n  firstName\n  id\n  createdAt\n}\n\nfragment TestConversionPluralNode_node on Node {\n  __isNode: __typename\n  __typename\n  ... on User {\n    createdAt\n  }\n  ... on Group {\n    name\n  }\n}\n\nfragment TestConversionPluralNullable_user on User {\n  firstName\n  createdAt\n}\n\nfragment TestConversionPluralUnion_member on Member {\n  __isMember: __typename\n  __typename\n  ... on User {\n    firstName\n    createdAt\n  }\n  ... on Group {\n    name\n  }\n}\n\nfragment TestConversionPlural_user on User {\n  id\n  createdAt\n}\n"
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
