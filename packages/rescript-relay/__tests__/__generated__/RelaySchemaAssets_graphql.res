/* @generated */
@@warning("-30")

@live @unboxed
type enum_OnlineStatus = 
  | Online
  | Idle
  | @as("offline") Offline
  | FutureAddedValue(string)


@live @unboxed
type enum_OnlineStatus_input = 
  | Online
  | Idle
  | @as("offline") Offline


@live @unboxed
type enum_RequiredFieldAction = 
  | NONE
  | LOG
  | THROW
  | FutureAddedValue(string)


@live @unboxed
type enum_RequiredFieldAction_input = 
  | NONE
  | LOG
  | THROW


@live
type rec input_InputA = {
  time: TestsUtils.Datetime.t,
  recursiveA?: input_InputA,
  usingB?: input_InputB,
}

@live
and input_InputA_nullable = {
  time: TestsUtils.Datetime.t,
  recursiveA?: Js.Null.t<input_InputA_nullable>,
  usingB?: Js.Null.t<input_InputB_nullable>,
}

@live
and input_InputB = {
  time?: TestsUtils.Datetime.t,
  usingA?: input_InputA,
  @as("constraint") constraint_?: bool,
}

@live
and input_InputB_nullable = {
  time?: Js.Null.t<TestsUtils.Datetime.t>,
  usingA?: Js.Null.t<input_InputA_nullable>,
  @as("constraint") constraint_?: Js.Null.t<bool>,
}

@live
and input_InputC = {
  intStr: TestsUtils.IntString.t,
  recursiveC?: input_InputC,
}

@live
and input_InputC_nullable = {
  intStr: TestsUtils.IntString.t,
  recursiveC?: Js.Null.t<input_InputC_nullable>,
}

@live
and input_SomeInput = {
  str?: string,
  bool?: bool,
  float?: float,
  int?: int,
  datetime?: TestsUtils.Datetime.t,
  recursive?: input_SomeInput,
  @as("private") private_?: bool,
  enum?: enum_OnlineStatus,
}

@live
and input_SomeInput_nullable = {
  str?: Js.Null.t<string>,
  bool?: Js.Null.t<bool>,
  float?: Js.Null.t<float>,
  int?: Js.Null.t<int>,
  datetime?: Js.Null.t<TestsUtils.Datetime.t>,
  recursive?: Js.Null.t<input_SomeInput_nullable>,
  @as("private") private_?: Js.Null.t<bool>,
  enum?: Js.Null.t<enum_OnlineStatus>,
}

@live
and input_RecursiveSetOnlineStatusInput = {
  someValue: TestsUtils.IntString.t,
  setOnlineStatus?: input_SetOnlineStatusInput,
}

@live
and input_RecursiveSetOnlineStatusInput_nullable = {
  someValue: TestsUtils.IntString.t,
  setOnlineStatus?: Js.Null.t<input_SetOnlineStatusInput_nullable>,
}

@live
and input_SetOnlineStatusInput = {
  onlineStatus: enum_OnlineStatus,
  someJsonValue: Js.Json.t,
  recursed?: input_RecursiveSetOnlineStatusInput,
}

@live
and input_SetOnlineStatusInput_nullable = {
  onlineStatus: enum_OnlineStatus,
  someJsonValue: Js.Json.t,
  recursed?: Js.Null.t<input_RecursiveSetOnlineStatusInput_nullable>,
}

@live
and input_SearchInput = {
  names?: array<option<string>>,
  id: int,
  someOtherId?: float,
}

@live
and input_SearchInput_nullable = {
  names?: Js.Null.t<array<Js.Null.t<string>>>,
  id: int,
  someOtherId?: Js.Null.t<float>,
}

@live
and input_PesticideListSearchInput = {
  companyName?: array<string>,
  pesticideIds?: array<int>,
  skip: int,
  take: int,
}

@live
and input_PesticideListSearchInput_nullable = {
  companyName?: Js.Null.t<array<string>>,
  pesticideIds?: Js.Null.t<array<int>>,
  skip: int,
  take: int,
}
