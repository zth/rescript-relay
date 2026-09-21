/* @sourceLoc Test_mutation.res */
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
  let fragmentConverter: JSON.t = %raw(
    json`{"roots":{"__root":[]},"version":2}`
  )
  @live
  let fragmentConverterMap = ()
  @live
  let preparedFragmentConverter = RescriptRelay.prepareConversion(
    fragmentConverter,
    fragmentConverterMap,
    None
  )
  @live
  let convertFragment = value => RescriptRelay.runConversion(preparedFragmentConverter, value)
}

type t
type fragmentRef
external getFragmentRef:
  RescriptRelay.fragmentRefs<[> | #TestMutationProvidedVariable_user]> => fragmentRef = "%identity"

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
    }
  ],
  "kind": "Fragment",
  "metadata": null,
  "name": "TestMutationProvidedVariable_user",
  "selections": [
    {
      "alias": null,
      "args": [
        {
          "kind": "Variable",
          "name": "bool",
          "variableName": "__relay_internal__pv__ProvidedVariablesBool"
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

