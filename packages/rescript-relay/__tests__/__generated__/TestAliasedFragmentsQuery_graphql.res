/* @sourceLoc Test_aliasedFragments.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type rec response_loggedInUser_TestAliasedFragments_userFirstName = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestAliasedFragments_userFirstName]>,
  }
  and response_loggedInUser_TestAliasedFragments_userLastName = {
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestAliasedFragments_userLastName]>,
  }
  and response_loggedInUser = {
    @as("TestAliasedFragments_userFirstName") testAliasedFragments_userFirstName: response_loggedInUser_TestAliasedFragments_userFirstName,
    @as("TestAliasedFragments_userLastName") testAliasedFragments_userLastName: option<response_loggedInUser_TestAliasedFragments_userLastName>,
  }
  type response = {
    loggedInUser: response_loggedInUser,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    skipThing: bool,
  }
  @live
  type refetchVariables = {
    skipThing: option<bool>,
  }
  @live let makeRefetchVariables = (
    ~skipThing=?,
  ): refetchVariables => {
    skipThing: skipThing
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
    json`{"__root":{"loggedInUser_TestAliasedFragments_userLastName":{"f":""},"loggedInUser_TestAliasedFragments_userFirstName":{"f":""}}}`
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
    json`{"__root":{"loggedInUser_TestAliasedFragments_userLastName":{"f":""},"loggedInUser_TestAliasedFragments_userFirstName":{"f":""}}}`
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

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "skipThing"
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestAliasedFragmentsQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "loggedInUser",
        "plural": false,
        "selections": [
          {
            "fragment": {
              "args": null,
              "kind": "FragmentSpread",
              "name": "TestAliasedFragments_userFirstName"
            },
            "kind": "AliasedFragmentSpread",
            "name": "TestAliasedFragments_userFirstName",
            "type": "User",
            "abstractKey": null
          },
          {
            "condition": "skipThing",
            "kind": "Condition",
            "passingValue": false,
            "selections": [
              {
                "fragment": {
                  "args": null,
                  "kind": "FragmentSpread",
                  "name": "TestAliasedFragments_userLastName"
                },
                "kind": "AliasedFragmentSpread",
                "name": "TestAliasedFragments_userLastName",
                "type": "User",
                "abstractKey": null
              }
            ]
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
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestAliasedFragmentsQuery",
    "selections": [
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
            "name": "firstName",
            "storageKey": null
          },
          {
            "condition": "skipThing",
            "kind": "Condition",
            "passingValue": false,
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "lastName",
                "storageKey": null
              }
            ]
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "7904bbabe4aaf72255a7e48d9de20bab",
    "id": null,
    "metadata": {},
    "name": "TestAliasedFragmentsQuery",
    "operationKind": "query",
    "text": "query TestAliasedFragmentsQuery(\n  $skipThing: Boolean!\n) {\n  loggedInUser {\n    ...TestAliasedFragments_userFirstName\n    ...TestAliasedFragments_userLastName @skip(if: $skipThing)\n    id\n  }\n}\n\nfragment TestAliasedFragments_userFirstName on User {\n  firstName\n}\n\nfragment TestAliasedFragments_userLastName on User {\n  lastName\n}\n"
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
