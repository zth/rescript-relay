exception Malformed_date
exception Malformed_number

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

type number = array<int>

module Number = {
  type t = number
  let serialize = t => Js.Json.number(Belt.Float.fromInt(t->Belt.Array.reduce(0, (x, y) => y + x)))

  let parse = t =>
    switch t->Js.Json.decodeNumber {
    | None => raise(Malformed_number)
    | Some(_) => []
    }
}
