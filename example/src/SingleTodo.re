module TodoFragment = [%relay.fragment
  {|
  fragment SingleTodo_todoItem on TodoItem {
    id
    text
    completed
  }
|}
];

module DeleteMutation = [%relay.mutation
  {|
  mutation SingleTodoDeleteMutation($input: DeleteTodoItemInput!) {
    deleteTodoItem(input: $input) {
      deletedTodoItemId
      clientMutationId
    }
  }
|}
];

module UpdateMutation = [%relay.mutation
  {|
  mutation SingleTodoUpdateMutation($input: UpdateTodoItemInput!) {
    updateTodoItem(input: $input) {
      updatedTodoItem {
        id
        text
        completed
      }
    }
  }
|}
];

[@react.component]
let make = (~checked, ~todoItem as todoItemRef) => {
  let todoItem = TodoFragment.use(todoItemRef);

  <li
    className={
      switch (todoItem.completed) {
      | Some(true) => "completed"
      | Some(false)
      | None => ""
      }
    }>
    <div className="form-check">
      <label className="form-check-label">
        <input
          className="checkbox"
          type_="checkbox"
          checked
          onChange={_ => {
            let completed =
              !Belt.Option.getWithDefault(todoItem.completed, false);
            UpdateMutation.commitMutation(
              ~environment=RelayEnv.environment,
              ~variables={
                input: {
                  clientMutationId: None,
                  id: todoItem.id,
                  completed,
                  text: todoItem.text,
                },
              },
              ~optimisticResponse={
                updateTodoItem:
                  Some({
                    updatedTodoItem:
                      Some({
                        id: todoItem.id,
                        completed: Some(completed),
                        text: todoItem.text,
                      }),
                  }),
              },
              (),
            )
            |> ignore;
          }}
        />
        {React.string(todoItem.text)}
      </label>
    </div>
    <i
      onClick={_ =>
        DeleteMutation.commitMutation(
          ~environment=RelayEnv.environment,
          ~variables={
            input: {
              clientMutationId: None,
              id: todoItem.id,
            },
          },
          ~updater=
            (store, _response) =>
              switch (
                store->ReasonRelay.RecordSourceSelectorProxy.get(
                  ~dataId=todoItem.id->ReasonRelay.makeDataId,
                )
              ) {
              | Some(node) =>
                ReasonRelayUtils.(
                  removeNodeFromConnections(
                    ~store,
                    ~node,
                    ~connections=[
                      {
                        parentID: ReasonRelay.storeRootId,
                        key: "TodoList_query_todosConnection",
                      },
                    ],
                  )
                )
              | None => ()
              },
          (),
        )
        |> ignore
      }
      role="button"
      className="remove mdi mdi-close-circle-outline"
    />
  </li>;
};