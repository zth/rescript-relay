/**
 * Various helpers.
 */

// We occasionally have to remove undefined keys from objects, something I haven't figured out how to do with pure BuckleScript
let internal_cleanObjectFromUndefinedRaw = [%raw
  {|
  function (obj) {
    if (!obj) {
      return obj;
    }

    var newObj = {};

    Object.keys(obj).forEach(function(key) {
      if (typeof obj[key] !== 'undefined') {
        newObj[key] = obj[key];
      }
    });

    return newObj;
  }
|}
];

let internal_useConvertedValue = (convert, v) =>
  React.useMemo1(() => convert(v), [|v|]);

let internal_nullableToOptionalExnHandler =
  fun
  | None => None
  | Some(handler) =>
    Some(maybeExn => maybeExn->Js.Nullable.toOption->handler);
