module Wrapper = {
  @react.component
  let make = (~environment, ~children) =>
    <React.Suspense fallback={<div> {React.string("Loading...")} </div>}>
      <RescriptRelayReact.Context.Provider environment> children </RescriptRelayReact.Context.Provider>
    </React.Suspense>
}
