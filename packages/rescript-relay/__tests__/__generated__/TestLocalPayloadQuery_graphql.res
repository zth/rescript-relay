/* @sourceLoc Test_localPayload.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  @tag("__typename") type rawResponse_loggedInUser_memberOf_Group_topMember = 
    | @live User(
      {
        @live __typename: [ | #User],
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_loggedInUser_memberOf = 
    | @live Group(
      {
        @live __typename: [ | #Group],
        __isNode: [ | #Group],
        @live id: string,
        name: string,
        topMember: option<rawResponse_loggedInUser_memberOf_Group_topMember>,
      }
    )
    | @live User(
      {
        @live __typename: [ | #User],
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  @tag("__typename") type rawResponse_loggedInUser_memberOfSingular = 
    | @live Group(
      {
        @live __typename: [ | #Group],
        __isNode: [ | #Group],
        @live id: string,
        name: string,
      }
    )
    | @live User(
      {
        @live __typename: [ | #User],
        __isNode: [ | #User],
        firstName: string,
        @live id: string,
      }
    )
    | @live @as("__unselected") UnselectedUnionMember(string)

  type rec response_loggedInUser = {
    @live id: string,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestLocalPayload_user]>,
  }
  @live
  and rawResponse_loggedInUser = {
    avatarUrl: option<string>,
    firstName: string,
    @live id: string,
    memberOf: option<array<option<rawResponse_loggedInUser_memberOf>>>,
    memberOfSingular: option<rawResponse_loggedInUser_memberOfSingular>,
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

@live
let unwrap_rawResponse_loggedInUser_memberOf_Group_topMember: Types.rawResponse_loggedInUser_memberOf_Group_topMember => Types.rawResponse_loggedInUser_memberOf_Group_topMember = RescriptRelay_Internal.unwrapUnion(_, ["User"])
@live
let wrap_rawResponse_loggedInUser_memberOf_Group_topMember: Types.rawResponse_loggedInUser_memberOf_Group_topMember => Types.rawResponse_loggedInUser_memberOf_Group_topMember = RescriptRelay_Internal.wrapUnion
@live
let unwrap_rawResponse_loggedInUser_memberOf: Types.rawResponse_loggedInUser_memberOf => Types.rawResponse_loggedInUser_memberOf = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_rawResponse_loggedInUser_memberOf: Types.rawResponse_loggedInUser_memberOf => Types.rawResponse_loggedInUser_memberOf = RescriptRelay_Internal.wrapUnion
@live
let unwrap_rawResponse_loggedInUser_memberOfSingular: Types.rawResponse_loggedInUser_memberOfSingular => Types.rawResponse_loggedInUser_memberOfSingular = RescriptRelay_Internal.unwrapUnion(_, ["Group", "User"])
@live
let wrap_rawResponse_loggedInUser_memberOfSingular: Types.rawResponse_loggedInUser_memberOfSingular => Types.rawResponse_loggedInUser_memberOfSingular = RescriptRelay_Internal.wrapUnion

type queryRef

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let variablesConverterMap = ()
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
  @live
  type wrapRawResponseRaw
  @live
  let wrapRawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"loggedInUser_memberOf_Group_topMember":{"u":"rawResponse_loggedInUser_memberOf_Group_topMember"},"loggedInUser_memberOfSingular":{"u":"rawResponse_loggedInUser_memberOfSingular"},"loggedInUser_memberOf":{"u":"rawResponse_loggedInUser_memberOf"}}}`
  )
  @live
  let wrapRawResponseConverterMap = {
    "rawResponse_loggedInUser_memberOf_Group_topMember": wrap_rawResponse_loggedInUser_memberOf_Group_topMember,
    "rawResponse_loggedInUser_memberOf": wrap_rawResponse_loggedInUser_memberOf,
    "rawResponse_loggedInUser_memberOfSingular": wrap_rawResponse_loggedInUser_memberOfSingular,
  }
  @live
  let convertWrapRawResponse = v => v->RescriptRelay.convertObj(
    wrapRawResponseConverter,
    wrapRawResponseConverterMap,
    Js.null
  )
  @live
  type rawResponseRaw
  @live
  let rawResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"loggedInUser_memberOf_Group_topMember":{"u":"rawResponse_loggedInUser_memberOf_Group_topMember"},"loggedInUser_memberOfSingular":{"u":"rawResponse_loggedInUser_memberOfSingular"},"loggedInUser_memberOf":{"u":"rawResponse_loggedInUser_memberOf"}}}`
  )
  @live
  let rawResponseConverterMap = {
    "rawResponse_loggedInUser_memberOf_Group_topMember": unwrap_rawResponse_loggedInUser_memberOf_Group_topMember,
    "rawResponse_loggedInUser_memberOf": unwrap_rawResponse_loggedInUser_memberOf,
    "rawResponse_loggedInUser_memberOfSingular": unwrap_rawResponse_loggedInUser_memberOfSingular,
  }
  @live
  let convertRawResponse = v => v->RescriptRelay.convertObj(
    rawResponseConverter,
    rawResponseConverterMap,
    Js.undefined
  )
  type rawPreloadToken<'response> = {source: Js.Nullable.t<RescriptRelay.Observable.t<'response>>}
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
  "name": "__typename",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "name",
  "storageKey": null
},
v4 = {
  "kind": "InlineFragment",
  "selections": [
    (v1/*: any*/)
  ],
  "type": "User",
  "abstractKey": null
},
v5 = {
  "kind": "InlineFragment",
  "selections": [
    (v0/*: any*/)
  ],
  "type": "Node",
  "abstractKey": "__isNode"
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestLocalPayloadQuery",
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
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestLocalPayload_user"
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
    "name": "TestLocalPayloadQuery",
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
            "name": "onlineStatus",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "concreteType": null,
            "kind": "LinkedField",
            "name": "memberOf",
            "plural": true,
            "selections": [
              (v2/*: any*/),
              {
                "kind": "InlineFragment",
                "selections": [
                  (v3/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": null,
                    "kind": "LinkedField",
                    "name": "topMember",
                    "plural": false,
                    "selections": [
                      (v2/*: any*/),
                      (v4/*: any*/),
                      (v5/*: any*/)
                    ],
                    "storageKey": null
                  }
                ],
                "type": "Group",
                "abstractKey": null
              },
              (v4/*: any*/),
              (v5/*: any*/)
            ],
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "concreteType": null,
            "kind": "LinkedField",
            "name": "memberOfSingular",
            "plural": false,
            "selections": [
              (v2/*: any*/),
              {
                "kind": "InlineFragment",
                "selections": [
                  (v3/*: any*/)
                ],
                "type": "Group",
                "abstractKey": null
              },
              (v4/*: any*/),
              (v5/*: any*/)
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "077471b46af8ca6532731e3e3f851365",
    "id": null,
    "metadata": {},
    "name": "TestLocalPayloadQuery",
    "operationKind": "query",
    "text": "query TestLocalPayloadQuery {\n  loggedInUser {\n    id\n    ...TestLocalPayload_user\n  }\n}\n\nfragment TestLocalPayload_user on User {\n  firstName\n  avatarUrl\n  onlineStatus\n  memberOf {\n    __typename\n    ... on Group {\n      name\n      topMember {\n        __typename\n        ... on User {\n          firstName\n        }\n        ... on Node {\n          __isNode: __typename\n          __typename\n          id\n        }\n      }\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __isNode: __typename\n      __typename\n      id\n    }\n  }\n  memberOfSingular {\n    __typename\n    ... on Group {\n      name\n    }\n    ... on User {\n      firstName\n    }\n    ... on Node {\n      __isNode: __typename\n      __typename\n      id\n    }\n  }\n}\n"
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
