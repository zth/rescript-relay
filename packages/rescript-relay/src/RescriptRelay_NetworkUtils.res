
module GraphQLIncrementalResponse = {
  type data = {.}
  type t<'a> = {incremental: array<{..} as 'a>, hasNext: bool}

  let mapWithDefault: (
    Js.Json.t,
    'a => array<'d>,
    'c => array<'d>,
  ) => array<Js.Json.t> = %raw(`function(response, f, b) {
  if (response.incremental)
    return f(response);
  else return b(response);

}`)
  external fromJson: Js.Json.t => t<'a> = "%identity"
}

module RelayDeferResponse = {
  type extension = {is_final: bool}
  type t<'a> = {.."hasNext": bool, "extensions": extension} as 'a

  let fromIncrementalResponse: GraphQLIncrementalResponse.t<'a> => array<t<'a>> = ({
    incremental,
    hasNext,
  }) => {
    incremental->Array.mapWithIndex((data, i) => {
      let hasNext = i === incremental->Array.length - 1 ? hasNext : true

      Object.assign(data, {"hasNext": hasNext, "extensions": {"is_final": !hasNext}})
    })
  }
  external toJson: t<'a> => Js.Json.t = "%identity"
}
let adaptIncrementalResponseToRelay = part =>
  part->GraphQLIncrementalResponse.mapWithDefault(
    json => {
      open RelayDeferResponse
      json->GraphQLIncrementalResponse.fromJson->fromIncrementalResponse->Array.map(toJson)
    },
    part => [part],
  )
