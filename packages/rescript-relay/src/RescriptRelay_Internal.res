let internal_keepMapFieldsRaw = (record, f) =>
  record
  ->Obj.magic
  ->Belt.Option.map(obj => obj->Js.Dict.entries->Belt.Array.keepMap(f)->Js.Dict.fromArray)
  ->Obj.magic

// we need to do this until we can use @obj on record types
// see https://github.com/rescript-lang/rescript-compiler/pull/5253
let internal_cleanObjectFromUndefinedRaw = record =>
  switch internal_keepMapFieldsRaw(record, ((key, value)) => {
    switch value {
    | Some(value) => Some((key, value))
    | None => None
    }
  }) {
  | None => /* Relay expects an empty object, not undefined */ %raw(json`{}`)
  | Some(v) => v
  }

let internal_removeUndefinedAndConvertNullsRaw = record =>
  internal_keepMapFieldsRaw(record, ((key, value)) => {
    switch (value, value == Some(None)) {
    | (Some(value), _) => Some((key, Js.Nullable.return(value)))
    | (_, true) => Some((key, Js.Nullable.null))
    | (None, _) => None
    }
  })

let internal_useConvertedValue = (convert, v) => React.useMemo1(() => convert(v), [v])

let internal_nullableToOptionalExnHandler = x =>
  switch x {
  | None => None
  | Some(handler) => Some(maybeExn => maybeExn->Js.Nullable.toOption->handler)
  }

@live @unboxed type rec arg = Arg(_): arg

let unwrapUnion: ('a, array<string>) => 'a = %raw(`
  function unwrapUnion(union, members) {
    if (union != null && members.indexOf(union.__typename) === -1) { 
      return Object.assign({}, union, {__typename: "__unselected"});
    }

    return union;
  }
`)

let wrapUnion = union => union

external internal_resolverFragmentRefsToFragmentRefs: RescriptRelay.resolverFragmentRefs<
  'a,
> => RescriptRelay.fragmentRefs<'a> = "%identity"

external internal_resolverFragmentRefsToFragmentRefsPlural: RescriptRelay.resolverFragmentRefs<
  'a,
> => array<RescriptRelay.fragmentRefs<'a>> = "%identity"

let applyCodesplitMetadata: ('node, array<(string, dict<Js.Json.t> => unit)>) => 'node = %raw(`
  function applyCodesplitMetadata(node, meta) {
    if (node != null && node.params != null) {
      let metadata = node.params.metadata;
      if (metadata == null) {
        node.params.metadata = {codesplits: meta}
      } else if (typeof metadata === "object") {
        node.params.metadata.codesplits = meta
      }
    }
    return node;
  }
`)
