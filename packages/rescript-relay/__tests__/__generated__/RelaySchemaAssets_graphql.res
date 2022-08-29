/* @generated */
@@ocaml.warning("-30")

@live
type enum_OnlineStatus = private [>
  | #Online
  | #Idle
  | #Offline
]

@live
type enum_OnlineStatus_input = [
  | #Online
  | #Idle
  | #Offline
]

@live
type enum_RequiredFieldAction = private [>
  | #NONE
  | #LOG
  | #THROW
]

@live
type enum_RequiredFieldAction_input = [
  | #NONE
  | #LOG
  | #THROW
]

@live
type rec input_RecursiveSetOnlineStatusInput = {
  someValue: TestsUtils.IntString.t,
  setOnlineStatus: option<input_SetOnlineStatusInput>,
}

@live
and input_SetOnlineStatusInput = {
  onlineStatus: [#Online | #Idle | #Offline],
  recursed: option<input_RecursiveSetOnlineStatusInput>,
}

@live
and input_SearchInput = {
  names: option<array<option<string>>>,
  id: int,
  someOtherId: option<float>,
}
@live @obj
external make_RecursiveSetOnlineStatusInput: (
  ~someValue: TestsUtils.IntString.t,
  ~setOnlineStatus: input_SetOnlineStatusInput=?,
  unit,
) => input_RecursiveSetOnlineStatusInput = ""

@live @obj
external make_SetOnlineStatusInput: (
  ~onlineStatus: [#Online | #Idle | #Offline],
  ~recursed: input_RecursiveSetOnlineStatusInput=?,
  unit,
) => input_SetOnlineStatusInput = ""

@live @obj
external make_SearchInput: (
  ~names: array<option<string>>=?,
  ~id: int,
  ~someOtherId: float=?,
  unit,
) => input_SearchInput = ""

