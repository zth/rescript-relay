/* @sourceLoc Test_codesplit.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_member_bestFriend_description = {
    @as("RichContent_content") richContent_content: option<RescriptRelay.fragmentRefs<[ | #RichContent_content]>>,
  }
  and response_member_bestFriend = {
    @as("UserAvatar_user") userAvatar_user: option<RescriptRelay.fragmentRefs<[ | #UserAvatar_user]>>,
    description: option<response_member_bestFriend_description>,
  }
  and response_member_description = {
    @as("RichContent_content") richContent_content: RescriptRelay.fragmentRefs<[ | #RichContent_content]>,
  }
  and response_member = {
    @live __typename: string,
    @as("GroupAvatar_group") groupAvatar_group: option<RescriptRelay.fragmentRefs<[ | #GroupAvatar_group]>>,
    @as("HasNameComponent_hasName") hasNameComponent_hasName: option<RescriptRelay.fragmentRefs<[ | #HasNameComponent_hasName]>>,
    @as("UserAvatar_user") userAvatar_user: option<RescriptRelay.fragmentRefs<[ | #UserAvatar_user]>>,
    bestFriend: option<response_member_bestFriend>,
    description: option<response_member_description>,
  }
  type response = {
    member: option<response_member>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    includeBestFriendDescription: bool,
  }
  @live
  type refetchVariables = {
    includeBestFriendDescription: option<bool>,
  }
  @live let makeRefetchVariables = (
    ~includeBestFriendDescription=?,
  ): refetchVariables => {
    includeBestFriendDescription: includeBestFriendDescription
  }

}


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
    json`{}`
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
    json`{}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
  type rawPreloadToken<'response> = {source: Js.Nullable.t<RescriptRelay.Observable.t<'response>>}
  external tokenToRaw: queryRef => rawPreloadToken<Types.response> = "%identity"
}
module Utils = {
  @@warning("-33")
  open Types
}

module CodesplitComponents = {
  module HasNameComponent = {
    let make = React.lazy_(() => Js.import(HasNameComponent.make))
  }
  module UserAvatar = {
    let make = React.lazy_(() => Js.import(UserAvatar.make))
  }
  module RichContent = {
    let make = React.lazy_(() => Js.import(RichContent.make))
  }
  module GroupAvatar = {
    let make = React.lazy_(() => Js.import(GroupAvatar.make))
  }
}


type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "includeBestFriendDescription"
  }
],
v1 = [
  {
    "kind": "Literal",
    "name": "id",
    "value": "1"
  }
],
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "__typename",
  "storageKey": null
},
v3 = {
  "fragment": {
    "kind": "InlineFragment",
    "selections": [
      {
        "args": null,
        "kind": "FragmentSpread",
        "name": "UserAvatar_user"
      }
    ],
    "type": "User",
    "abstractKey": null
  },
  "kind": "AliasedInlineFragmentSpread",
  "name": "UserAvatar_user"
},
v4 = [
  {
    "fragment": {
      "kind": "InlineFragment",
      "selections": [
        {
          "args": null,
          "kind": "FragmentSpread",
          "name": "RichContent_content"
        }
      ],
      "type": "RichContent",
      "abstractKey": null
    },
    "kind": "AliasedInlineFragmentSpread",
    "name": "RichContent_content"
  }
],
v5 = [
  {
    "alias": null,
    "args": null,
    "kind": "ScalarField",
    "name": "name",
    "storageKey": null
  }
],
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "avatarUrl",
  "storageKey": null
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v8 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "lastName",
  "storageKey": null
},
v9 = [
  {
    "alias": null,
    "args": null,
    "kind": "ScalarField",
    "name": "content",
    "storageKey": null
  }
],
v10 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestCodesplitQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "member",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          {
            "fragment": {
              "kind": "InlineFragment",
              "selections": [
                {
                  "args": null,
                  "kind": "FragmentSpread",
                  "name": "HasNameComponent_hasName"
                }
              ],
              "type": "HasName",
              "abstractKey": "__isHasName"
            },
            "kind": "AliasedInlineFragmentSpread",
            "name": "HasNameComponent_hasName"
          },
          {
            "kind": "InlineFragment",
            "selections": [
              (v3/*: any*/),
              {
                "alias": null,
                "args": null,
                "concreteType": "RichContent",
                "kind": "LinkedField",
                "name": "description",
                "plural": false,
                "selections": (v4/*: any*/),
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
                  {
                    "condition": "includeBestFriendDescription",
                    "kind": "Condition",
                    "passingValue": false,
                    "selections": [
                      (v3/*: any*/)
                    ]
                  },
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": "RichContent",
                    "kind": "LinkedField",
                    "name": "description",
                    "plural": false,
                    "selections": [
                      {
                        "condition": "includeBestFriendDescription",
                        "kind": "Condition",
                        "passingValue": true,
                        "selections": (v4/*: any*/)
                      }
                    ],
                    "storageKey": null
                  }
                ],
                "storageKey": null
              }
            ],
            "type": "User",
            "abstractKey": null
          },
          {
            "kind": "InlineFragment",
            "selections": [
              {
                "fragment": {
                  "kind": "InlineFragment",
                  "selections": [
                    {
                      "args": null,
                      "kind": "FragmentSpread",
                      "name": "GroupAvatar_group"
                    }
                  ],
                  "type": "Group",
                  "abstractKey": null
                },
                "kind": "AliasedInlineFragmentSpread",
                "name": "GroupAvatar_group"
              }
            ],
            "type": "Group",
            "abstractKey": null
          }
        ],
        "storageKey": "member(id:\"1\")"
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestCodesplitQuery",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": null,
        "kind": "LinkedField",
        "name": "member",
        "plural": false,
        "selections": [
          (v2/*: any*/),
          {
            "kind": "InlineFragment",
            "selections": (v5/*: any*/),
            "type": "HasName",
            "abstractKey": "__isHasName"
          },
          {
            "kind": "InlineFragment",
            "selections": [
              (v6/*: any*/),
              (v7/*: any*/),
              (v8/*: any*/),
              {
                "alias": null,
                "args": null,
                "concreteType": "RichContent",
                "kind": "LinkedField",
                "name": "description",
                "plural": false,
                "selections": (v9/*: any*/),
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
                  {
                    "condition": "includeBestFriendDescription",
                    "kind": "Condition",
                    "passingValue": false,
                    "selections": [
                      (v6/*: any*/),
                      (v7/*: any*/),
                      (v8/*: any*/)
                    ]
                  },
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": "RichContent",
                    "kind": "LinkedField",
                    "name": "description",
                    "plural": false,
                    "selections": [
                      {
                        "condition": "includeBestFriendDescription",
                        "kind": "Condition",
                        "passingValue": true,
                        "selections": (v9/*: any*/)
                      }
                    ],
                    "storageKey": null
                  },
                  (v10/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "type": "User",
            "abstractKey": null
          },
          {
            "kind": "InlineFragment",
            "selections": (v5/*: any*/),
            "type": "Group",
            "abstractKey": null
          },
          {
            "kind": "InlineFragment",
            "selections": [
              (v10/*: any*/)
            ],
            "type": "Node",
            "abstractKey": "__isNode"
          }
        ],
        "storageKey": "member(id:\"1\")"
      }
    ]
  },
  "params": {
    "cacheID": "cfb15896d28abad88b1960eeca4222d7",
    "id": null,
    "metadata": {},
    "name": "TestCodesplitQuery",
    "operationKind": "query",
    "text": "query TestCodesplitQuery(\n  $includeBestFriendDescription: Boolean!\n) {\n  member(id: \"1\") {\n    __typename\n    ...HasNameComponent_hasName\n    ... on User {\n      ...UserAvatar_user\n      description {\n        ...RichContent_content\n      }\n      bestFriend {\n        ...UserAvatar_user @skip(if: $includeBestFriendDescription)\n        description {\n          ...RichContent_content @include(if: $includeBestFriendDescription)\n        }\n        id\n      }\n    }\n    ... on Group {\n      ...GroupAvatar_group\n    }\n    ... on Node {\n      __isNode: __typename\n      __typename\n      id\n    }\n  }\n}\n\nfragment GroupAvatar_group on Group {\n  name\n}\n\nfragment HasNameComponent_hasName on HasName {\n  __isHasName: __typename\n  __typename\n  name\n}\n\nfragment RichContent_content on RichContent {\n  content\n}\n\nfragment UserAvatar_user on User {\n  avatarUrl\n  ...UserName_user\n}\n\nfragment UserName_user on User {\n  firstName\n  lastName\n}\n"
  }
};
})() `)

let node = RescriptRelay_Internal.applyCodesplitMetadata(node, [
  ("member.$$i$$HasName", (_variables: dict<Js.Json.t>) => {Js.import(HasNameComponent.make)->ignore}), 
  ("member.$$u$$User", (_variables: dict<Js.Json.t>) => {Js.import(UserAvatar.make)->ignore; Js.import(UserName.make)->ignore}), 
  ("member.$$u$$User.description", (_variables: dict<Js.Json.t>) => {Js.import(RichContent.make)->ignore}), 
  ("member.$$u$$User.bestFriend", (variables: dict<Js.Json.t>) => {if variables->Js.Dict.get("includeBestFriendDescription") === Some(Js.Json.Boolean(false)) {Js.import(UserAvatar.make)->ignore}}), 
  ("member.$$u$$User.bestFriend.description", (variables: dict<Js.Json.t>) => {if variables->Js.Dict.get("includeBestFriendDescription") === Some(Js.Json.Boolean(true)) {Js.import(RichContent.make)->ignore}}), 
  ("member.$$u$$Group", (_variables: dict<Js.Json.t>) => {Js.import(GroupAvatar.make)->ignore}), 
])
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
