module GraphQLIncrementalResponse: {
  type data = {.}
  type t<'a> = {incremental: array<'a>, hasNext: bool}
  constraint 'a = {..}
  let mapWithDefault: (.
  Js.Json.t,
  (. 'a) => array<'d>,
  (. 'c) => array<'d>,
) => array<Js.Json.t>
  let fromJson: (. Js.Json.t) => t<{..}>
}

module RelayDeferResponse: {
  type extension = {is_final: bool}
  type t<'a> = 'a
  constraint 'a = {..
    "extensions": extension,
    "hasNext": bool,
  }
  let fromIncrementalResponse: (.
  GraphQLIncrementalResponse.t<
    {.."extensions": extension, "hasNext": bool},
  >,
) => array<t<{.."extensions": extension, "hasNext": bool}>>
  let toJson: (.
  t<{.."extensions": extension, "hasNext": bool}>,
) => Js.Json.t
}

let adaptIncrementalResponseToRelay:
(. Js.Json.t) => array<Js.Json.t>
