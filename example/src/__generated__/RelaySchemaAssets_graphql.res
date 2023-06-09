/* @generated */
@@ocaml.warning("-30")

@live
type enum_TicketStatus = private [>
  | #Done
  | #Progress
  | #OnHold
  | #Rejected
]

@live
type enum_TicketStatus_input = [
  | #Done
  | #Progress
  | #OnHold
  | #Rejected
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
type rec input_AddTodoItemInput = {
  text: string,
  clientMutationId: option<string>,
}

@live
and input_AddTodoItemInput_nullable = {
  text: string,
  clientMutationId?: Js.Null.t<string>,
}

@live
and input_DeleteTodoItemInput = {
  id: string,
  clientMutationId: option<string>,
}

@live
and input_DeleteTodoItemInput_nullable = {
  id: string,
  clientMutationId?: Js.Null.t<string>,
}

@live
and input_UpdateTodoItemInput = {
  id: string,
  text: string,
  completed: bool,
  clientMutationId: option<string>,
}

@live
and input_UpdateTodoItemInput_nullable = {
  id: string,
  text: string,
  completed: bool,
  clientMutationId?: Js.Null.t<string>,
}
@live @obj
external make_AddTodoItemInput: (
  ~text: string,
  ~clientMutationId: string=?,
  unit,
) => input_AddTodoItemInput = ""

@live @obj
external make_DeleteTodoItemInput: (
  ~id: string,
  ~clientMutationId: string=?,
  unit,
) => input_DeleteTodoItemInput = ""

@live @obj
external make_UpdateTodoItemInput: (
  ~id: string,
  ~text: string,
  ~completed: bool,
  ~clientMutationId: string=?,
  unit,
) => input_UpdateTodoItemInput = ""

