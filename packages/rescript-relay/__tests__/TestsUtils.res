exception Malformed_date
exception Malformed_number

module Datetime = {
  @editor.completeFrom(Js.Date)
  type t = Date.t

  let parse = t =>
    switch t->JSON.Decode.string {
    | None => throw(Malformed_date)
    | Some(dateStr) => dateStr->Date.fromString
    }
  let serialize = t =>
    t
    ->Date.toJSON
    ->Option.getOr("-")
    ->JSON.Encode.string
}

module IntString = {
  type t = int
  @live let parse = Belt.Int.fromString
  let serialize = int => {
    // This log is used for testing purposes - do not remove
    Console.log2("serialize", int)
    Belt.Int.toString(int)
  }
}

type number = array<int>

module Number = {
  type t = number
  let serialize = t =>
    JSON.Encode.float(Belt.Float.fromInt(t->Belt.Array.reduce(0, (x, y) => y + x)))

  let parse = t =>
    switch t->JSON.Decode.float {
    | None => throw(Malformed_number)
    | Some(_) => []
    }
}
