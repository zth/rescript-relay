module ShelfFragment = [%relay.fragment
  {|
    fragment ShelfDisplayer_shelf on Shelf {
      name
    }
  |}
];

[@react.component]
let make = (~shelf as shelfRef) => {
  let shelf = ShelfFragment.use(shelfRef);

  <div>
    <p>
      {React.string("on shelf: ")}
      <strong> {React.string(shelf##name)} </strong>
    </p>
  </div>;
};