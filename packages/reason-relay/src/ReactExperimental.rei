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

let unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit;
