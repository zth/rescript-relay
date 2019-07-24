module Query = [%relay.query
  {|
    query BooksOverviewQuery {
        books {
            id
            ...BookDisplayer_book
        }
    }
|}
];

[@react.component]
let make = () => {
  let query = Query.use(~variables=(), ~dataFrom=StoreOrNetwork, ());

  switch (query) {
  | Loading => <div> {React.string("Loading...")} </div>
  | Error(_) => <div> {React.string("Error!")} </div>
  | Data(data) =>
    data##books
    |> Array.mapi((index, book) =>
         <div key={string_of_int(index)}>
           <BookDisplayer book />
           <p>
             <button
               onClick={_ => ReasonReactRouter.push("/book/" ++ book##id)}>
               {React.string("More info")}
             </button>
           </p>
         </div>
       )
    |> React.array
  };
};