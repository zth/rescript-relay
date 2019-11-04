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

module Suspense: {
  [@react.component]
  let make:
    (
      ~children: ReasonReact.reactElement,
      ~fallback: ReasonReact.reactElement=?
    ) =>
    ReasonReact.reactElement;
};

module SuspenseList: {
  type revealOrder = [ | `forwards | `backwards | `together];

  [@react.component]
  let make:
    (~children: ReasonReact.reactElement, ~revealOrder: revealOrder) =>
    ReasonReact.reactElement;
};

module SuspenseConfig: {
  type t;
  let make:
    (
      ~timeOutMs: float,
      ~busyDelayMs: float=?,
      ~busyMinDurationMs: float=?,
      unit
    ) =>
    t;
};

let unstable_withSuspenseConfig: (unit => unit, SuspenseConfig.t) => unit;