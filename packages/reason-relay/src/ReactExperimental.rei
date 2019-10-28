let useTransition:
  (~timeoutMs: int, ~busyDelayMs: int=?, ~busyMinDurationMs: int=?, unit) =>
  (unit => unit, bool);

let useDeferredValue:
  (
    ~value: 'value,
    ~timeoutMs: int,
    ~busyDelayMs: int=?,
    ~busyMinDurationMs: int=?,
    unit
  ) =>
  'value;

let createRoot: (ReasonReact.reactElement, Dom.element) => unit;

let createRootAtElementWithId: (ReasonReact.reactElement, string) => unit;

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
  type tail = [ | `collapsed | `hidden];

  [@react.component]
  let make:
    (
      ~children: ReasonReact.reactElement,
      ~revealOrder: revealOrder,
      ~tail: tail=?
    ) =>
    ReasonReact.reactElement;
};