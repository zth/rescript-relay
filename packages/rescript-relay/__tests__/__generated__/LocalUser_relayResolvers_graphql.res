/* @generated */
@@warning("-30")

type metaResolver = (RelayLocalUserModel.t, ) => option<RelayUserMetaModel.t>

type nameResolver = (RelayLocalUserModel.t, ) => option<string>

type nameRepeatedResolverArgs = {
  times: int,
}
type nameRepeatedResolver = (RelayLocalUserModel.t, nameRepeatedResolverArgs) => option<string>

