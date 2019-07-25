let collectConnectionNodes = obj =>
  switch (obj##edges |> Js.Nullable.toOption) {
  | Some(edges) =>
    edges->Belt.Array.keepMap(edge =>
      switch (edge |> Js.Nullable.toOption) {
      | Some(edge) =>
        switch (edge##node |> Js.Nullable.toOption) {
        | Some(node) => Some(node)
        | None => None
        }
      | None => None
      }
    )
  | None => [||]
  };

let collectConnectionNodesFromNullable = maybeObj =>
  switch (maybeObj |> Js.Nullable.toOption) {
  | Some(obj) => collectConnectionNodes(obj)
  | None => [||]
  };

let collectNodes = nodes =>
  nodes->Belt.Array.keepMap(node => node |> Js.Nullable.toOption);

let collectNodesFromNullable = maybeNodes =>
  switch (maybeNodes |> Js.Nullable.toOption) {
  | Some(nodes) => collectNodes(nodes)
  | None => [||]
  };
