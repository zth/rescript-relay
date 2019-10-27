let useTransition:
  (~timeoutMs: int, ~busyDelayMs: int=?, ~busyMinDurationMs: int=?, unit) =>
  (unit => unit, bool);