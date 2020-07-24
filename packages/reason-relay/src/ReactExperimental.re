type suspenseConfig = {timeoutMs: int};

[@bs.module "react"]
external _useDeferredValue: ('value, option(suspenseConfig)) => 'value =
  "useDeferredValue";

let useDeferredValue = (~value, ~config=?, ()) =>
  _useDeferredValue(value, config);

[@bs.module "react"]
external unstable_withSuspenseConfig: (unit => unit, suspenseConfig) => unit =
  "unstable_withSuspenseConfig";

[@bs.val] [@bs.return nullable]
external getElementById: string => option(Dom.element) =
  "document.getElementById";

let renderConcurrentRootAtElementWithId: (React.element, string) => unit =
  (content, id) => {
    switch (getElementById(id)) {
    | None =>
      raise(
        Invalid_argument(
          "ReactExperimental.renderConcurrentRootAtElementWithId : no element of id "
          ++ id
          ++ " found in the HTML.",
        ),
      )
    | Some(element) =>
      ReactDOMRe.Experimental.createRoot(element)
      ->ReactDOMRe.Experimental.render(content)
    };
  };
