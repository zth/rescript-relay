type suspenseConfig = {
  timeoutMs: int,
  busyDelayMs: option(int),
  busyMinDurationMs: option(int),
};

[@bs.module "react"]
external _useDeferredValue: ('value, suspenseConfig) => 'value =
  "useDeferredValue";

let useDeferredValue =
    (~value, ~timeoutMs, ~busyDelayMs=?, ~busyMinDurationMs=?, ()) =>
  _useDeferredValue(value, {timeoutMs, busyDelayMs, busyMinDurationMs});

[@bs.module "react"]
external unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit =
  "unstable_withSuspenseConfig";
