module Query = [%relay.query
  {|
    query SingleBookDisplayerQuery($bookId: ID!) {
        book(id: $bookId) {
            ...BookDisplayer_book
            ...BookEditor_book
        }
    }
|}
];

[@react.component]
let make = (~bookId) => {
  let query =
    Query.use(~variables={"bookId": bookId}, ~dataFrom=StoreOrNetwork, ());

  switch (query) {
  | Loading => <div> {React.string("Loading...")} </div>
  | Error(_) => <div> {React.string("Error!")} </div>
  | Data(data) =>
    switch (data##book |> Js.Nullable.toOption) {
    | Some(book) => <BookDisplayer book allowEditMode=true />
    | None => <div> {React.string("404")} </div>
    }
  };
};