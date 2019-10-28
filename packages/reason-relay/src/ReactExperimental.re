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

[@bs.module "react"]
external _useDeferredValue:
  (
    'value,
    {
      .
      "timeoutMs": int,
      "busyDelayMs": option(int),
      "busyMinDurationMs": option(int),
    }
  ) =>
  'value =
  "useDeferredValue";

let useDeferredValue =
    (~value, ~timeoutMs, ~busyDelayMs=?, ~busyMinDurationMs=?, ()) =>
  _useDeferredValue(
    value,
    {
      "timeoutMs": timeoutMs,
      "busyDelayMs": busyDelayMs,
      "busyMinDurationMs": busyMinDurationMs,
    },
  );

[@bs.val] [@bs.return nullable]
external _getElementById: string => option(Dom.element) =
  "document.getElementById";

[@bs.module "react-dom"]
external createRoot: (ReasonReact.reactElement, Dom.element) => unit =
  "createRoot";

let createRootAtElementWithId = (reactElement, id) =>
  switch (_getElementById(id)) {
  | None =>
    raise(
      Invalid_argument(
        "ReactExperimental.createRootAtElementWithId : no element of id "
        ++ id
        ++ " found in the HTML.",
      ),
    )
  | Some(element) => createRoot(reactElement, element)
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
  type tail = [ | `collapsed | `hidden];

  let mapRevealOrder = revealOrder =>
    switch (revealOrder) {
    | `forwards => "forwards"
    | `backwards => "backwards"
    | `together => "together"
    };

  let mapTail = tail =>
    switch (tail) {
    | `collapsed => "collapsed"
    | `hidden => "hidden"
    };

  [@react.component] [@bs.module "react"]
  external _make:
    (~children: React.element, ~revealOrder: string, ~tail: string=?) =>
    React.element =
    "Suspense";

  [@react.component]
  let make = (~children, ~revealOrder, ~tail=?) =>
    _make({
      "children": children,
      "revealOrder": revealOrder |> mapRevealOrder,
      "tail":
        switch (tail) {
        | Some(tail) => Some(tail |> mapTail)
        | None => None
        },
    });
};