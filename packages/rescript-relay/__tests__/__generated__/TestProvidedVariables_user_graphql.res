/* @sourceLoc Test_providedVariables.res */
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
  let fragmentConverter: dict<dict<dict<string>>> = %raw(
    json`{}`
  )
  @live
  let fragmentConverterMap = ()
  @live
  let convertFragment = v => v->RescriptRelay.convertObj(
    fragmentConverter,
    fragmentConverterMap,
    None
  )
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #TestProvidedVariables_user]> => fragmentRef = "%identity"

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
    },
    {
      "kind": "RootArgument",
      "name": "__relay_internal__pv__ProvidedVariablesIntStrArr"
    }
  ],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestProvidedVariables_user",
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
        },
        {
          "kind": "Variable",
          "name": "intStrArr",
          "variableName": "__relay_internal__pv__ProvidedVariablesIntStrArr"
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

