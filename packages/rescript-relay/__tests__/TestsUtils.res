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
  let serialize = t => {
    // This log is used for testing purposes - do not remove
    Console.log("Datetime.serialize")
    t->Date.toJSON->Option.getOr("-")->JSON.Encode.string
  }
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
  let serialize = t => {
    // This log is used for testing purposes - do not remove
    Console.log("Number.serialize")
    JSON.Encode.float(Float.fromInt(t->Array.reduce(0, (x, y) => y + x)))
  }

  let parse = t =>
    switch t->JSON.Decode.float {
    | None => throw(Malformed_number)
    | Some(_) => []
    }
}

type objectScalarPayload = {
  a: string,
  b?: string,
  c?: string,
}

// Custom-scalar shapes used by the regression tests for issues #582 and
// #631. The serializers log so a Jest harness can assert which converters
// actually ran for a given operation — the bug in those issues was that
// converters silently DIDN'T run for fields placed after a custom-scalar
// array in the same selection set.
module ObjectScalar1 = {
  type t = objectScalarPayload
  let serialize = (_: t) => {
    // This log is used for testing purposes - do not remove
    Console.log("ObjectScalar1.serialize")
    JSON.Encode.string("serialized1")
  }
  let parse = (_: JSON.t): t => {
    // This log is used for testing purposes - do not remove
    Console.log("ObjectScalar1.parse")
    {a: "parsed1"}
  }
}

module ObjectScalar2 = {
  type t = objectScalarPayload
  let serialize = (_: t) => {
    // This log is used for testing purposes - do not remove
    Console.log("ObjectScalar2.serialize")
    JSON.Encode.string("serialized2")
  }
  let parse = (_: JSON.t): t => {
    // This log is used for testing purposes - do not remove
    Console.log("ObjectScalar2.parse")
    {a: "parsed2"}
  }
}
