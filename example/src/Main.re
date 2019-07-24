module GoToViewButton = {
  [@react.component]
  let make = (~label, ~target) =>
    <button onClick={_ => ReasonReactRouter.push(target)}>
      {React.string(label)}
    </button>;
};

[@react.component]
let make = () => {
  let url = ReasonReactRouter.useUrl();

  switch (url.path) {
  | ["test-mutations"] =>
    <div>
      <TestMutations />
      <GoToViewButton key="overview" label="To overview" target="/" />
    </div>
  | ["create", ..._rest] =>
    <div>
      <CreateBookView />
      <GoToViewButton key="overview" label="To overview" target="/" />
    </div>

  | ["book", bookId] =>
    <div>
      <SingleBookDisplayer bookId />
      <GoToViewButton key="overview" label="To overview" target="/" />
    </div>
  | _ =>
    <div>
      <BooksOverview />
      <GoToViewButton key="create" label="Create book" target="/create" />
    </div>
  };
};