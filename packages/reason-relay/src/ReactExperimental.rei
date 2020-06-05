type suspenseConfig = {
  timeoutMs: int,
  busyDelayMs: option(int),
  busyMinDurationMs: option(int),
};

let useTransition:
  (~timeoutMs: int, ~busyDelayMs: int=?, ~busyMinDurationMs: int=?, unit) =>
  ((unit => unit) => unit, bool);

let useDeferredValue:
  (
    ~value: 'value,
    ~timeoutMs: int,
    ~busyDelayMs: int=?,
    ~busyMinDurationMs: int=?,
    unit
  ) =>
  'value;

module ConcurrentModeRoot: {
  type t;
  let render: (t, ReasonReact.reactElement) => unit;
};

let createRoot: Dom.element => ConcurrentModeRoot.t;

let renderConcurrentRootAtElementWithId:
  (ReasonReact.reactElement, string) => unit;

let unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit;
