/* @generated */
%%raw("/* @generated */")
module Types = {
@@ocaml.warning("-30")

type rec response_loggedInUser = {
  fragmentRefs: ReasonRelay.fragmentRefs<[ | #TestMutation_user]>
}
type response = {
  loggedInUser: response_loggedInUser,
}
type rawResponse = response
type variables = unit
}

module Internal = {
type wrapResponseRaw
let wrapResponseConverter: 
  Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = 
  %raw(
    json`{"__root":{"loggedInUser":{"f":""}}}`
  )

let wrapResponseConverterMap = ()
let convertWrapResponse = v => v->ReasonRelay.convertObj(
  wrapResponseConverter, 
  wrapResponseConverterMap, 
  Js.null
)
type responseRaw
let responseConverter: 
  Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = 
  %raw(
    json`{"__root":{"loggedInUser":{"f":""}}}`
  )

let responseConverterMap = ()
let convertResponse = v => v->ReasonRelay.convertObj(
  responseConverter, 
  responseConverterMap, 
  Js.undefined
)
type wrapRawResponseRaw = wrapResponseRaw
let convertWrapRawResponse = convertWrapResponse
type rawResponseRaw = responseRaw
let convertRawResponse = convertResponse
let variablesConverter: 
  Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = 
  %raw(
    json`{}`
  )

let variablesConverterMap = ()
let convertVariables = v => v->ReasonRelay.convertObj(
  variablesConverter, 
  variablesConverterMap, 
  Js.undefined
)
}

type queryRef

module Utils = {
}

type relayOperationNode
type operationType = ReasonRelay.queryNode<relayOperationNode>


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
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TestMutationQuery",
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
            "args": null,
            "kind": "FragmentSpread",
            "name": "TestMutation_user"
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
    "name": "TestMutationQuery",
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
            "name": "lastName",
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
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "__typename",
                "storageKey": null
              },
              {
                "kind": "InlineFragment",
                "selections": [
                  (v1/*: any*/)
                ],
                "type": "User",
                "abstractKey": null
              },
              {
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
              },
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
    ]
  },
  "params": {
    "cacheID": "367ab31b7c5cebe2e00b1d0315cf2da4",
    "id": null,
    "metadata": {},
    "name": "TestMutationQuery",
    "operationKind": "query",
    "text": "query TestMutationQuery {\n  loggedInUser {\n    ...TestMutation_user\n    id\n  }\n}\n\nfragment TestMutation_user on User {\n  id\n  firstName\n  lastName\n  onlineStatus\n  memberOf {\n    __typename\n    ... on User {\n      firstName\n    }\n    ... on Group {\n      name\n    }\n    ... on Node {\n      __isNode: __typename\n      id\n    }\n  }\n}\n"
  }
};
})() `)

include ReasonRelay.MakeLoadQuery({
    type variables = Types.variables
    type loadedQueryRef = queryRef
    type response = Types.response
    type node = relayOperationNode
    let query = node
    let convertVariables = Internal.convertVariables
  });
