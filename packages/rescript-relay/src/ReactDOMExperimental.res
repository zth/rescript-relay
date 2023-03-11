include ReactDOM.Client

@val @return(nullable)
external getElementById: string => option<Dom.element> = "document.getElementById"

let renderConcurrentRootAtElementWithId: (React.element, string) => unit = (content, id) =>
  switch getElementById(id) {
  | None =>
    raise(
      Invalid_argument(
        "ReactExperimental.renderConcurrentRootAtElementWithId : no element of id " ++
        id ++ " found in the HTML.",
      ),
    )
  | Some(element) => createRoot(element)->Root.render(content)
  }
