exception Malformed_date

module Datetime = {
  type t = Js.Date.t
  let parse = t =>
    switch t->Js.Json.decodeString {
    | None => raise(Malformed_date)
    | Some(dateStr) => dateStr->Js.Date.fromString
    }
  let serialize = t => t->Js.Date.toJSONUnsafe->Js.Json.string
}

module IntString = {
  type t = int
  @live let parse = Belt.Int.fromString
  let serialize = Belt.Int.toString
}

module SomeRecord = {
  type t = {
    name: string,
    timestamp: Js.Date.t,
  }

  let parse = s => {
    open Belt
    let json = s->Js.Json.decodeString->Option.getExn->Js.Json.parseExn
    let o = Js.Json.decodeObject(json)->Option.getExn
    let name = Js.Dict.get(o, "name")->Option.getExn->Js.Json.decodeString->Option.getExn
    let timestamp =
      Js.Dict.get(o, "timestamp")
      ->Option.getExn
      ->Js.Json.decodeString
      ->Option.getExn
      ->Js.Date.fromString
    {
      name: name,
      timestamp: timestamp,
    }
  }

  let serialize = ({name, timestamp}) => {
    let json =
      [
        ("name", Js.Json.string(name)),
        ("timestamp", timestamp->Js.Date.toISOString->Js.Json.string),
      ]
      ->Js.Dict.fromArray
      ->Js.Json.object_
    json->Js.Json.stringify->Js.Json.string
  }
}
