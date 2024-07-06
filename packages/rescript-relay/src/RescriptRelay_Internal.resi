let internal_useConvertedValue: ('a => 'a, 'a) => 'a
let internal_cleanObjectFromUndefinedRaw: 't => 't
let internal_removeUndefinedAndConvertNullsRaw: 't => 't
let internal_nullableToOptionalExnHandler: option<option<'b> => 'a> => option<
  Js.Nullable.t<'b> => 'a,
>
@live @unboxed type rec arg = Arg(_): arg

let unwrapUnion: ('a, array<string>) => 'a
let wrapUnion: 'a => 'a

external internal_resolverFragmentRefsToFragmentRefs: RescriptRelay.resolverFragmentRefs<
  'a,
> => RescriptRelay.fragmentRefs<'a> = "%identity"

external internal_resolverFragmentRefsToFragmentRefsPlural: RescriptRelay.resolverFragmentRefs<
  'a,
> => array<RescriptRelay.fragmentRefs<'a>> = "%identity"

let applyCodesplitMetadata: ('node, array<(string, unit => unit)>) => 'node
