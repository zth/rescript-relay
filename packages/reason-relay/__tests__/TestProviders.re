type testReturn = {
  render: unit => React.element,
  environment: ReasonRelay.Environment.t,
};

module Wrapper = {
  [@react.component]
  let make = (~environment, ~children) =>
    <ReactExperimental.Suspense
      fallback={<div> {React.string("Loading...")} </div>}>
      <ReasonRelay.Context.Provider environment>
        children
      </ReasonRelay.Context.Provider>
    </ReactExperimental.Suspense>;
};