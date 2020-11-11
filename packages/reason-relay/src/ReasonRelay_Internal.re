/**
 * Various helpers.
 */

let internal_useConvertedValue = (convert, v) =>
  React.useMemo1(() => convert(v), [|v|]);

let internal_nullableToOptionalExnHandler =
  fun
  | None => None
  | Some(handler) =>
    Some(maybeExn => maybeExn->Js.Nullable.toOption->handler);
