module Wrapper = {
  [@react.component]
  let make = (~environment, ~children) =>
    <React.Suspense fallback={<div> {React.string("Loading...")} </div>}>
      <ReasonRelay.EnvironmentProvider environment>
        children
      </ReasonRelay.EnvironmentProvider>
    </React.Suspense>;
};
