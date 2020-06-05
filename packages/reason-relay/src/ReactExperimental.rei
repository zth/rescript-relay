type suspenseConfig = {
  timeoutMs: int,
  busyDelayMs: option(int),
  busyMinDurationMs: option(int),
};

let useDeferredValue:
  (
    ~value: 'value,
    ~timeoutMs: int,
    ~busyDelayMs: int=?,
    ~busyMinDurationMs: int=?,
    unit
  ) =>
  'value;

let renderConcurrentRootAtElementWithId:
  (ReasonReact.reactElement, string) => unit;

let unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit;
