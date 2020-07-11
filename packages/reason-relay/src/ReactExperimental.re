type suspenseConfig = {timeoutMs: int};

[@bs.module "react"]
external _useDeferredValue: ('value, option(suspenseConfig)) => 'value =
  "useDeferredValue";

let useDeferredValue = (~value, ~config=?, ()) =>
  _useDeferredValue(value, config);

[@bs.module "react"]
external unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit =
  "unstable_withSuspenseConfig";
