let internal_useConvertedValue: ('a => 'a, 'a) => 'a
let internal_cleanObjectFromUndefinedRaw: 't => 't
let internal_removeUndefinedAndConvertNullsRaw: 't => 't
let internal_nullableToOptionalExnHandler: option<option<'b> => 'a> => option<
  Js.Nullable.t<'b> => 'a,
>
let wrapUnion: 'value => 'wrapped
let unwrapUnion: ('value, array<string>) => 'unwrapped
@live @unboxed type rec arg = Arg(_): arg
