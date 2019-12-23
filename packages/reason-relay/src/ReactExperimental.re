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

[@bs.val] [@bs.return nullable]
external _getElementById: string => option(Dom.element) =
  "document.getElementById";

module ConcurrentModeRoot = {
  type t = {. "render": [@bs.meth] (React.element => unit)};
  let render = (t: t, element) => t##render(element);
};

[@bs.module "react-dom"]
external createRoot: Dom.element => ConcurrentModeRoot.t = "createRoot";

let renderConcurrentRootAtElementWithId = (reactElement, id) =>
  switch (_getElementById(id)) {
  | None =>
    raise(
      Invalid_argument(
        "ReactExperimental.createRootAtElementWithId : no element of id "
        ++ id
        ++ " found in the HTML.",
      ),
    )
  | Some(element) =>
    createRoot(element)->ConcurrentModeRoot.render(reactElement)
  };

module Suspense = {
  [@react.component] [@bs.module "react"]
  external make:
    (~children: React.element, ~fallback: ReasonReact.reactElement=?) =>
    React.element =
    "Suspense";
};

module SuspenseList = {
  type revealOrder = [ | `forwards | `backwards | `together];

  module Component = {
    [@react.component] [@bs.module "react"]
    external make:
      (~children: React.element, ~revealOrder: string) => React.element =
      "SuspenseList";
  };

  let mapRevealOrder = revealOrder =>
    switch (revealOrder) {
    | `forwards => "forwards"
    | `backwards => "backwards"
    | `together => "together"
    };

  [@react.component]
  let make = (~children, ~revealOrder: revealOrder) =>
    <Component revealOrder={revealOrder |> mapRevealOrder}>
      children
    </Component>;
};

[@bs.module "react"]
external unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit =
  "unstable_withSuspenseConfig";