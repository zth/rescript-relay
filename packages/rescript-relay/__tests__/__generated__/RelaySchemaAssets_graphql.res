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
type rec input_InputA = {
  time: TestsUtils.Datetime.t,
  recursiveA: option<input_InputA>,
  usingB: option<input_InputB>,
}

@live
and input_InputA_nullable = {
  time: TestsUtils.Datetime.t,
  recursiveA?: Js.Nullable.t<input_InputA_nullable>,
  usingB?: Js.Nullable.t<input_InputB_nullable>,
}

@live
and input_InputB = {
  time: option<TestsUtils.Datetime.t>,
  usingA: option<input_InputA>,
  @as("constraint") constraint_: option<bool>,
}

@live
and input_InputB_nullable = {
  time?: Js.Nullable.t<TestsUtils.Datetime.t>,
  usingA?: Js.Nullable.t<input_InputA_nullable>,
  @as("constraint") constraint_?: Js.Nullable.t<bool>,
}

@live
and input_InputC = {
  intStr: TestsUtils.IntString.t,
  recursiveC: option<input_InputC>,
}

@live
and input_InputC_nullable = {
  intStr: TestsUtils.IntString.t,
  recursiveC?: Js.Nullable.t<input_InputC_nullable>,
}

@live
and input_SomeInput = {
  str: option<string>,
  bool: option<bool>,
  float: option<float>,
  int: option<int>,
  datetime: option<TestsUtils.Datetime.t>,
  recursive: option<input_SomeInput>,
  @as("private") private_: option<bool>,
}

@live
and input_SomeInput_nullable = {
  str?: Js.Nullable.t<string>,
  bool?: Js.Nullable.t<bool>,
  float?: Js.Nullable.t<float>,
  int?: Js.Nullable.t<int>,
  datetime?: Js.Nullable.t<TestsUtils.Datetime.t>,
  recursive?: Js.Nullable.t<input_SomeInput_nullable>,
  @as("private") private_?: Js.Nullable.t<bool>,
}

@live
and input_RecursiveSetOnlineStatusInput = {
  someValue: TestsUtils.IntString.t,
  setOnlineStatus: option<input_SetOnlineStatusInput>,
}

@live
and input_RecursiveSetOnlineStatusInput_nullable = {
  someValue: TestsUtils.IntString.t,
  setOnlineStatus?: Js.Nullable.t<input_SetOnlineStatusInput_nullable>,
}

@live
and input_SetOnlineStatusInput = {
  onlineStatus: [#Online | #Idle | #Offline],
  someJsonValue: Js.Json.t,
  recursed: option<input_RecursiveSetOnlineStatusInput>,
}

@live
and input_SetOnlineStatusInput_nullable = {
  onlineStatus: [#Online | #Idle | #Offline],
  someJsonValue: Js.Json.t,
  recursed?: Js.Nullable.t<input_RecursiveSetOnlineStatusInput_nullable>,
}

@live
and input_SearchInput = {
  names: option<array<option<string>>>,
  id: int,
  someOtherId: option<float>,
}

@live
and input_SearchInput_nullable = {
  names?: Js.Nullable.t<array<Js.Nullable.t<string>>>,
  id: int,
  someOtherId?: Js.Nullable.t<float>,
}

@live
and input_PesticideListSearchInput = {
  companyName: option<array<string>>,
  pesticideIds: option<array<int>>,
  skip: int,
  take: int,
}

@live
and input_PesticideListSearchInput_nullable = {
  companyName?: Js.Nullable.t<array<string>>,
  pesticideIds?: Js.Nullable.t<array<int>>,
  skip: int,
  take: int,
}
@live @obj
external make_InputA: (
  ~time: TestsUtils.Datetime.t,
  ~recursiveA: input_InputA=?,
  ~usingB: input_InputB=?,
  unit,
) => input_InputA = ""

@live @obj
external make_InputB: (
  ~time: TestsUtils.Datetime.t=?,
  ~usingA: input_InputA=?,
  ~_constraint: bool=?,
  unit,
) => input_InputB = ""

@live @obj
external make_InputC: (
  ~intStr: TestsUtils.IntString.t,
  ~recursiveC: input_InputC=?,
  unit,
) => input_InputC = ""

@live @obj
external make_SomeInput: (
  ~str: string=?,
  ~bool: bool=?,
  ~float: float=?,
  ~int: int=?,
  ~datetime: TestsUtils.Datetime.t=?,
  ~recursive: input_SomeInput=?,
  ~_private: bool=?,
  unit,
) => input_SomeInput = ""

@live @obj
external make_RecursiveSetOnlineStatusInput: (
  ~someValue: TestsUtils.IntString.t,
  ~setOnlineStatus: input_SetOnlineStatusInput=?,
  unit,
) => input_RecursiveSetOnlineStatusInput = ""

@live @obj
external make_SetOnlineStatusInput: (
  ~onlineStatus: [#Online | #Idle | #Offline],
  ~someJsonValue: Js.Json.t,
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

@live @obj
external make_PesticideListSearchInput: (
  ~companyName: array<string>=?,
  ~pesticideIds: array<int>=?,
  ~skip: int,
  ~take: int,
  unit,
) => input_PesticideListSearchInput = ""

