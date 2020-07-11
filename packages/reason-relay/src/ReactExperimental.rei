type suspenseConfig = {timeoutMs: int};

let useDeferredValue:
  (~value: 'value, ~config: suspenseConfig=?, unit) => 'value;

[@bs.module "react"]
external unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit =
  "unstable_withSuspenseConfig";
