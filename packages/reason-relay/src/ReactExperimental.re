[@bs.module "react"]
external _useTransition:
  {
    .
    "timeoutMs": int,
    "busyDelayMs": option(int),
    "busyMinDurationMs": option(int),
  } =>
  (unit => unit, bool) =
  "useTransition";

let useTransition = (~timeoutMs, ~busyDelayMs=?, ~busyMinDurationMs=?, ()) =>
  _useTransition({
    "timeoutMs": timeoutMs,
    "busyDelayMs": busyDelayMs,
    "busyMinDurationMs": busyMinDurationMs,
  });