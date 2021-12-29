/* @sourceLoc Test_subscription.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type enum_OnlineStatus = private [>
      | #Online
      | #Idle
      | #Offline
    ]

  type enum_OnlineStatus_input = [
      | #Online
      | #Idle
      | #Offline
    ]



  type rec response_userUpdated_user = {
    id: string,
    onlineStatus: option<enum_OnlineStatus>,
    fragmentRefs: RescriptRelay.fragmentRefs<[ | #TestSubscription_user]>,
  }
  and response_userUpdated = {
    user: option<response_userUpdated_user>,
  }
  type response = {
    userUpdated: option<response_userUpdated>,
  }
  type rawResponse = response
  type variables = {
    userId: string,
  }
}

module Internal = {
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  let variablesConverterMap = ()
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  type responseRaw
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"__root":{"userUpdated_user_onlineStatus":{"n":""},"userUpdated_user":{"n":"","f":""},"userUpdated":{"n":""}}}`
  )
  let responseConverterMap = ()
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type rawResponseRaw = responseRaw
  let convertRawResponse = convertResponse
}
module Utils = {
  @@ocaml.warning("-33")
  open Types
  external onlineStatus_toString: enum_OnlineStatus => string = "%identity"
  external onlineStatus_input_toString: enum_OnlineStatus_input => string = "%identity"
  let makeVariables = (
    ~userId
  ): variables => {
    userId: userId
  }
}

type relayOperationNode
type operationType = RescriptRelay.subscriptionNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "userId"
  }
],
v1 = [
  {
    "kind": "Variable",
    "name": "id",
    "variableName": "userId"
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
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "onlineStatus",
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "TestSubscriptionUserUpdatedSubscription",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": "UserUpdatedPayload",
        "kind": "LinkedField",
        "name": "userUpdated",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "User",
            "kind": "LinkedField",
            "name": "user",
            "plural": false,
            "selections": [
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "args": null,
                "kind": "FragmentSpread",
                "name": "TestSubscription_user"
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Subscription",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "TestSubscriptionUserUpdatedSubscription",
    "selections": [
      {
        "alias": null,
        "args": (v1/*: any*/),
        "concreteType": "UserUpdatedPayload",
        "kind": "LinkedField",
        "name": "userUpdated",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "concreteType": "User",
            "kind": "LinkedField",
            "name": "user",
            "plural": false,
            "selections": [
              (v2/*: any*/),
              (v3/*: any*/),
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "firstName",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "avatarUrl",
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "41b8b12bc049364fa2383c462f7c13de",
    "id": null,
    "metadata": {
      "subscriptionName": "userUpdated"
    },
    "name": "TestSubscriptionUserUpdatedSubscription",
    "operationKind": "subscription",
    "text": "subscription TestSubscriptionUserUpdatedSubscription(\n  $userId: ID!\n) {\n  userUpdated(id: $userId) {\n    user {\n      id\n      onlineStatus\n      ...TestSubscription_user\n    }\n  }\n}\n\nfragment TestSubscription_user on User {\n  id\n  firstName\n  avatarUrl\n  onlineStatus\n}\n"
  }
};
})() `)


