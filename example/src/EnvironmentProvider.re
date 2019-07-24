[@react.component]
let make = (~children, ~environment=RelayEnv.environment) => {
  <ReasonRelay.Context.Provider environment>
    children
  </ReasonRelay.Context.Provider>;
};