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
