module BookFragment = [%relay.fragment
  {|
  fragment CreateBookViewExistingBookDisplayer_book on Book {
    title
    author
  }
|}
];

[@react.component]
let make = (~book as bookRef) => {
  let book = BookFragment.use(bookRef);

  <p>
    <p> <strong> {React.string(book##title)} </strong> </p>
    <p> {React.string(book##author)} </p>
  </p>;
};