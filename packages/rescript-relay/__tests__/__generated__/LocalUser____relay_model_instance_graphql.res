/* @sourceLoc RelayLocalUserModel.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@warning("-30")

  type fragment = unit
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
  RescriptRelay.fragmentRefs<[> | #LocalUser____relay_model_instance]> => fragmentRef = "%identity"

module Utils = {
  @@warning("-33")
  open Types
}

type relayOperationNode
type operationType = RescriptRelay.fragmentNode<relayOperationNode>


%%private(let makeNode = (rescript_graphql_node_LocalUser__id, resolverDataInjector, rescript_module_RelayLocalUserModel_LocalUser): operationType => {
  ignore(rescript_graphql_node_LocalUser__id)
  ignore(resolverDataInjector)
  ignore(rescript_module_RelayLocalUserModel_LocalUser)
  %raw(json`{
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "LocalUser____relay_model_instance",
  "selections": [
    {
      "alias": null,
      "args": null,
      "fragment": {
        "args": null,
        "kind": "FragmentSpread",
        "name": "LocalUser__id"
      },
      "kind": "RelayResolver",
      "name": "__relay_model_instance",
      "resolverModule": resolverDataInjector(rescript_graphql_node_LocalUser__id, rescript_module_RelayLocalUserModel_LocalUser, 'id', true),
      "path": "__relay_model_instance"
    }
  ],
  "type": "LocalUser",
  "abstractKey": null
}`)
})
let node: operationType = makeNode(LocalUser__id_graphql.node, RescriptRelay.resolverDataInjector, RelayLocalUserModel.localUser)

