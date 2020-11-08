/**
 * Internal utils.
 */

let internal_useConvertedValue: ('a => 'a, 'a) => 'a;
let internal_cleanObjectFromUndefinedRaw: 't => 't;
let internal_nullableToOptionalExnHandler:
  option(option('b) => 'a) => option(Js.Nullable.t('b) => 'a);
