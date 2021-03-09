module Wrapper = {
  @react.component
  let make = (~environment, ~children) =>
    <React.Suspense fallback={<div> {React.string("Loading...")} </div>}>
      <RescriptRelay.Context.Provider environment> children </RescriptRelay.Context.Provider>
    </React.Suspense>
}
