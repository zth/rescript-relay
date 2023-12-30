/* @sourceLoc Test_preloadedQuery.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment = {
    someRandomArgField: option<string>,
  }
}

module Internal = {
  @live
  type fragmentRaw
  @live
  let fragmentConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let fragmentConverterMap = ()
  @live
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    Js.undefined
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #TestPreloadedQueryProvidedVariables_user]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


let node: operationType = %raw(json` {
  "argumentDefinitions": [
    {
      "kind": "RootArgument",
      "name": "__relay_internal__pv__ProvidedVariablesBool"
    },
    {
      "kind": "RootArgument",
      "name": "__relay_internal__pv__ProvidedVariablesInputC"
    },
    {
      "kind": "RootArgument",
      "name": "__relay_internal__pv__ProvidedVariablesInputCArr"
    },
    {
      "kind": "RootArgument",
      "name": "__relay_internal__pv__ProvidedVariablesIntStr"
    }
  ],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestPreloadedQueryProvidedVariables_user",
  "selections": [
    {
      "alias": null,
      "args": [
        {
          "kind": "Variable",
          "name": "bool",
          "variableName": "__relay_internal__pv__ProvidedVariablesBool"
        },
        {
          "kind": "Variable",
          "name": "inputC",
          "variableName": "__relay_internal__pv__ProvidedVariablesInputC"
        },
        {
          "kind": "Variable",
          "name": "inputCArr",
          "variableName": "__relay_internal__pv__ProvidedVariablesInputCArr"
        },
        {
          "kind": "Variable",
          "name": "intStr",
          "variableName": "__relay_internal__pv__ProvidedVariablesIntStr"
        }
      ],
      "kind": "ScalarField",
      "name": "someRandomArgField",
      "storageKey": null
    }
  ],
  "type": "User",
  "abstractKey": null
} `)

