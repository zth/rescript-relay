module Wrapper = {
  [@react.component]
  let make = (~environment, ~children) =>
    <React.Suspense fallback={<div> {React.string("Loading...")} </div>}>
      <ReasonRelay.Context.Provider environment>
        children
      </ReasonRelay.Context.Provider>
    </React.Suspense>;
};
