type suspenseConfig = {
  timeoutMs: int,
  busyDelayMs: option(int),
  busyMinDurationMs: option(int),
};

[@bs.module "react"]
external _useTransition: suspenseConfig => ((unit => unit) => unit, bool) =
  "useTransition";

let useTransition = (~timeoutMs, ~busyDelayMs=?, ~busyMinDurationMs=?, ()) =>
  _useTransition({timeoutMs, busyDelayMs, busyMinDurationMs});

[@bs.module "react"]
external _useDeferredValue: ('value, suspenseConfig) => 'value =
  "useDeferredValue";

let useDeferredValue =
    (~value, ~timeoutMs, ~busyDelayMs=?, ~busyMinDurationMs=?, ()) =>
  _useDeferredValue(value, {timeoutMs, busyDelayMs, busyMinDurationMs});

let renderConcurrentRootAtElementWithId = (reactElement, id) =>
  switch (ReactDOMRe.Experimental.createRootWithId(id)) {
  | Error(error) => raise(Invalid_argument(error))
  | Ok(root) => ReactDOMRe.Experimental.render(root, reactElement)
  };

[@bs.module "react"]
external unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit =
  "unstable_withSuspenseConfig";
