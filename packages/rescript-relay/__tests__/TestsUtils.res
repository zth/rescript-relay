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
  @live let parse = v => v->Int.fromString(~radix=10)

  let serialize = int => {
    // This log is used for testing purposes - do not remove
    Console.log2("serialize", int)
    Int.toString(int)
  }
}

type number = array<int>

module Number = {
  type t = number
  let serialize = t => JSON.Encode.float(Float.fromInt(t->Array.reduce(0, (x, y) => y + x)))

  let parse = t =>
    switch t->JSON.Decode.float {
    | None => throw(Malformed_number)
    | Some(_) => []
    }
}

type s = {
  a: string,
  b: ?string,
  c: ?string
}
module Number = {
  type t = s
  let serialize = _ => Json.Encode.string("serialized")
  let parse = _ => {a: "a", b: None, c: None}
}
