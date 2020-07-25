module TodoListFragment = [%relay.fragment
  {|
  fragment TodoList_query on Query
    @argumentDefinitions(
      first: {type: "Int!", defaultValue: 10}
      after: {type: "String!", defaultValue: ""}
    )
  {
    todosConnection(first: $first, after: $after)
      @connection(key: "TodoList_query_todosConnection")
    {
      edges {
        node {
          id
          ...SingleTodo_todoItem
        }
      }
    }
  }
|}
];

module AddTodoMutation = [%relay.mutation
  {|
  mutation TodoListAddTodoMutation($input: AddTodoItemInput!) {
    addTodoItem(input: $input) {
      addedTodoItem {
        id
        text
        completed
      }
    }
  }
|}
];

[@react.component]
let make = (~query as queryRef) => {
  let todoListData = TodoListFragment.use(queryRef);
  let (addTodo, _) = AddTodoMutation.use();

  let (newTodoText, setNewTodoText) = React.useState(() => "");

  <div className="card">
    <div className="card-body">
      <h4 className="card-title text-white"> {React.string("Todo")} </h4>
      <form
        onSubmit={ev => {
          ReactEvent.Form.preventDefault(ev);

          let _ =
            AddTodoMutation.(
              addTodo(
                ~variables=
                  makeVariables(
                    ~input=make_addTodoItemInput(~text=newTodoText, ()),
                  ),
                ~onCompleted=(_, _) => {setNewTodoText(_ => "")},
                ~updater=
                  (store, _response) =>
                    ReasonRelayUtils.(
                      switch (
                        resolveNestedRecord(
                          ~rootRecord=
                            store->ReasonRelay.RecordSourceSelectorProxy.getRootField(
                              ~fieldName="addTodoItem",
                            ),
                          ~path=["addedTodoItem"],
                        )
                      ) {
                      | Some(node) =>
                        createAndAddEdgeToConnections(
                          ~store,
                          ~node,
                          ~connections=[
                            {
                              parentID: ReasonRelay.storeRootId,
                              key: "TodoList_query_todosConnection",
                              filters: None,
                            },
                          ],
                          ~edgeName="TodoItemEdge",
                          ~insertAt=Start,
                        )
                      | None => ()
                      }
                    ),
                (),
              )
            );
          ();
        }}>
        <div className="add-items d-flex">
          <input
            type_="text"
            className="form-control todo-list-input"
            placeholder="What do you need to do today?"
            value=newTodoText
            onChange={event => {
              let value = ReactEvent.Form.currentTarget(event)##value;
              setNewTodoText(_ => value);
            }}
          />
          <button
            type_="submit"
            className="add btn btn-gradient-primary font-weight-bold todo-list-add-btn"
            id="add-task"
            disabled={
              switch (newTodoText) {
              | "" => true
              | _ => false
              }
            }>
            {React.string("Add")}
          </button>
        </div>
      </form>
      <div className="list-wrapper">
        <ul className="d-flex flex-column-reverse todo-list todo-list-custom">
          {todoListData.todosConnection
           ->TodoListFragment.getConnectionNodes_todosConnection
           ->Belt.Array.map(todoItem =>
               <SingleTodo
                 key={todoItem.id}
                 todoItem={todoItem.fragmentRefs}
                 checked=true
               />
             )
           ->React.array}
        </ul>
      </div>
    </div>
  </div>;
};
