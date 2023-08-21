let unsafeMergeJson: (. Js.Json.t, Js.Json.t) => Js.Json.t

module GraphQLIncrementalResponse: {
  type t<'a> = {incremental: array<'a>, hasNext: bool}
}

module GraphQLResponse: {
  type data = {.}
  type t<'a> =
  | Incremental(GraphQLIncrementalResponse.t<'a>)
  | Response('a)
  let mapIncrementalWithDefault: (.
  t<'a>,
  (. GraphQLIncrementalResponse.t<'a>) => array<'b>,
  (. 'a) => array<'b>,
) => array<'b>
  let fromIncremental: (. GraphQLIncrementalResponse.t<'a>) => t<'a>
  let makeResponse: (. 'a) => t<'a>
  let parse: (. Js.Json.t, (. Js.Json.t) => option<'a>) => option<
  t<'a>,
>
  let fromJson: (. Js.Json.t) => t<Js.Json.t>
}

module RelayDeferResponse: {
  type t<'a> = array<'a>
  // Type safe conversion from a GraphQL spec response
  let fromIncrementalResponse: (. GraphQLIncrementalResponse.t<{..} as 'a>) => t<{..} as 'a>

  let toJson: (. 'a) => Js.Json.t

  // Not type safe conversion due to use of Json.t and object merging
  let fromJsonIncrementalResponse: (.
  GraphQLIncrementalResponse.t<Js.Json.t>,
) => array<Js.Json.t>
}

// Not type safe conversion of GraphQL spec defer response to Relay-compatible
// version
let adaptJsonIncrementalResponseToRelay: (. Js.Json.t) => array<Js.Json.t>
