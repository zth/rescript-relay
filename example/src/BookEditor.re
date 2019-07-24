module BookFragment = [%relay.fragment
  {|
    fragment BookEditor_book on Book {
      id
      title
      author
      status
    }
  |}
];

module UpdateMutation = [%relay.mutation
  {|
    mutation BookEditorUpdateMutation($input: UpdateBookInput!) {
      updateBook(input: $input) {
        book {
          title
          author
          status
        }
      }
    }
  |}
];

module DeleteMutation = [%relay.mutation
  {|
    mutation BookEditorDeleteMutation($input: DeleteBookInput!) {
      deleteBook(input: $input) {
        deleted
      }
    }
  |}
];

type state = {
  title: string,
  author: string,
};

type action =
  | SetTitle(string)
  | SetAuthor(string);

let reducer = (state, action) =>
  switch (action) {
  | SetTitle(title) => {...state, title}
  | SetAuthor(author) => {...state, author}
  };

[@react.component]
let make = (~book as bookRef) => {
  let book = BookFragment.use(bookRef);

  let (state, dispatch) =
    React.useReducer(reducer, {title: book##title, author: book##author});

  let (updateBook, mutationState) = UpdateMutation.use();

  <p>
    <p>
      <input
        type_="text"
        value={state.title}
        onChange={e =>
          dispatch(SetTitle(ReactEvent.Form.currentTarget(e)##value))
        }
      />
    </p>
    <p>
      <input
        type_="text"
        value={state.author}
        onChange={e =>
          dispatch(SetAuthor(ReactEvent.Form.currentTarget(e)##value))
        }
      />
    </p>
    <p>
      <button
        onClick={_ =>
          updateBook(
            ~variables={
              "input": {
                "clientMutationId": None,
                "id": book##id,
                "title": state.title,
                "author": state.author,
                "status": book##status |> Js.Nullable.toOption,
              },
            },
            (),
          )
          |> Js.Promise.then_((res: ReasonRelay.mutationResult('response)) =>
               switch (res) {
               | Success(res) =>
                 Js.log2("Success!", res) |> Js.Promise.resolve
               | Error(err) => Js.log2("Error...", err) |> Js.Promise.resolve
               }
             )
          |> ignore
        }>
        {React.string("Save")}
      </button>
      {switch (mutationState) {
       | Loading => React.string("Saving...")
       | Success(res) =>
         switch (res) {
         | Some(res) =>
           switch (res##updateBook##book |> Js.Nullable.toOption) {
           | Some(_) =>
             <ShowForDuration duration=2000>
               {React.string("Saved!")}
             </ShowForDuration>
           | None =>
             <ShowForDuration duration=2000>
               {React.string("Ooops, something went wrong.")}
             </ShowForDuration>
           }
         | None =>
           <ShowForDuration duration=2000>
             {React.string("No data Ooops, something went wrong.")}
           </ShowForDuration>
         }
       | Error(_) =>
         <ShowForDuration duration=2000>
           {React.string("ERROR: Ooops, something went wrong.")}
         </ShowForDuration>
       }}
    </p>
  </p>;
};