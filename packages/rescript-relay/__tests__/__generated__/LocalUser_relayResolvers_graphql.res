/* @generated */
@@warning("-30")

type metaResolver = (RelayLocalUserModel.t, ) => RelayUserMetaModel.t

type nameResolver = (RelayLocalUserModel.t, ) => string

type nameRepeatedResolverArgs = {
  times: int,
}
type nameRepeatedResolver = (RelayLocalUserModel.t, nameRepeatedResolverArgs) => string

type hasBeenOnlineTodayResolver = (RelayLocalUserModel.t, ) => RescriptRelay.liveState<bool>

