/* @generated */
@@warning("-30")

@live @unboxed
type enum_TicketStatus = 
  | Done
  | Progress
  | OnHold
  | Rejected
  | FutureAddedValue(string)


@live @unboxed
type enum_TicketStatus_input = 
  | Done
  | Progress
  | OnHold
  | Rejected


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
type rec input_AddTodoItemInput = {
  text: string,
  clientMutationId?: string,
}

@live
and input_AddTodoItemInput_nullable = {
  text: string,
  clientMutationId?: Js.Null.t<string>,
}

@live
and input_DeleteTodoItemInput = {
  id: string,
  clientMutationId?: string,
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
  clientMutationId?: string,
}

@live
and input_UpdateTodoItemInput_nullable = {
  id: string,
  text: string,
  completed: bool,
  clientMutationId?: Js.Null.t<string>,
}
