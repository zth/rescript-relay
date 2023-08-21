let unsafeMergeJson: (Js.Json.t, Js.Json.t) => Js.Json.t = %raw("function (a, b) {
  return { ...a, ...b};
}")


module GraphQLIncrementalResponse = {
  type t<'a> = {incremental: array<'a>, hasNext: bool}
}

module GraphQLResponse = {
  type data = {.}
  type t<'a> = Incremental(GraphQLIncrementalResponse.t<'a>) | Response('a)

  let mapIncrementalWithDefault: (
    t<'a>,
    GraphQLIncrementalResponse.t<'a> => array<'b>,
    'a => array<'b>,
  ) => array<'b> = (t, withIncremental, default) => {
    switch t {
    | Incremental(incremental) => withIncremental(incremental)
    | Response(json) => default(json)
    }
  }
  let fromIncremental = data => Incremental(data)
  let makeResponse = data => Response(data)

  // Use parser to parse fully type-safe response
  let parse: type a. (Js.Json.t, Js.Json.t => option<a>) => option<t<a>> = (json, parseFn) =>
    switch json->Js.Json.decodeObject {
    | Some(dict) =>
      switch dict->Js.Dict.get("incremental") {
      | Some(data) =>
        switch data->Js.Json.decodeArray {
        | Some(arrayData) =>
          Some(
            Incremental({
              incremental: arrayData->Array.map(parseFn)->Array.filterMap(x => x),
              hasNext: dict
              ->Js.Dict.get("hasNext")
              ->Option.mapWithDefault(false, v =>
                v->Js.Json.decodeBoolean->Option.mapWithDefault(false, v => v)
              ),
            }),
          )
        | None => {

          let data = parseFn(json)
          switch data {
            | Some(data) => Some(Response(data))
            | None => None
          }
        }
      }
      | None => {
          let data = parseFn(json)
          switch data {
            | Some(data) => Some(Response(data))
            | None => None
          }
        }
      }
    | None => None
    }

  // Partially parse response
  let fromJson: Js.Json.t => t<'a> = json =>
    switch json->Js.Json.decodeObject {
    | Some(dict) =>
      switch dict->Js.Dict.get("incremental") {
      | Some(data) =>
        switch data->Js.Json.decodeArray {
        | Some(arrayData) =>
          Incremental({
            incremental: arrayData,
            hasNext: dict
            ->Js.Dict.get("hasNext")
            ->Option.mapWithDefault(false, v =>
              v->Js.Json.decodeBoolean->Option.mapWithDefault(false, v => v)
            ),
          })
        | None => Response(json)
        }
      | None => Response(json)
      }
    | None => Response(json)
    }
}

module RelayDeferResponse = {
  type t<'a> = array<'a>

  let fromIncrementalResponse: GraphQLIncrementalResponse.t<{..} as 'a> => t<{..} as 'a> = ({
    incremental,
    hasNext,
  }) => {
    incremental->Array.mapWithIndex((data, i) => {
      let hasNext = i === incremental->Array.length - 1 ? hasNext : true

      Object.assign(data, {"hasNext": hasNext, "extensions": {"is_final": !hasNext}})
    })
  }

  external toJson: 'a => Js.Json.t = "%identity"

  let fromJsonIncrementalResponse: GraphQLIncrementalResponse.t<Js.Json.t> => array<Js.Json.t> = ({
    incremental,
    hasNext,
  }) => {
    incremental->Array.mapWithIndex((data, i) => {
      let hasNext = i === incremental->Array.length - 1 ? hasNext : true

      unsafeMergeJson(data, {"hasNext": hasNext, "extensions": {"is_final": !hasNext}}->toJson)
    })
  }
}

let adaptJsonIncrementalResponseToRelay: Js.Json.t => array<Js.Json.t> = part =>
  part
  ->GraphQLResponse.fromJson
  ->GraphQLResponse.mapIncrementalWithDefault(
    RelayDeferResponse.fromJsonIncrementalResponse,
    part => [part],
  )
