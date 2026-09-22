// Dynamic Relay values include jsNull, jsUndefined, custom scalar instances and
// ReScript option markers. Keep unchecked property access at this FFI boundary.
type value
type converter = value => value
external jsUndefined: value = "%undefined"
external jsNull: value = "%null"
external cast: 'a => 'b = "%identity"
external isNullable: value => bool = "%is_nullable"
external typeOf: 'a => string = "%typeof"
@get_index external get: ('object, string) => 'value = ""
@set_index external set: ('object, string, 'value) => unit = ""
@get_index external unsafeAt: (array<'a>, int) => 'a = ""
@get_index external at: (value, int) => value = ""
@set_index external put: (value, int, value) => unit = ""
@get external length: 'a => int = "length"
@send external slice: value => value = "slice"
@send external startsWith: (string, string) => bool = "startsWith"
@val external isArray: 'a => bool = "Array.isArray"
@val external keys: 'a => array<string> = "Object.keys"
@val external create: (@as(json`null`) _, unit) => dict<'a> = "Object.create"
@val external isSafeInteger: value => bool = "Number.isSafeInteger"
@val external truthy: 'a => bool = "Boolean"
let hasOwn: (
  'object,
  string,
) => bool = %raw(`(object, key) => Object.prototype.hasOwnProperty.call(object, key)`)
let hasIndex: (int, value) => bool = %raw(`(index, value) => index in value`)
let unwrapInputUnion: value => value = %raw(`value => ({[value.__$inputUnion]: value._0})`)
let fail: string => 'a = %raw(`message => {throw new Error(message);}`)
// ReScript has no allocation-free `for ... in` construct. These two kernels
// preserve own-key order and lazy copying without allocating a keys array.
let plainRecord: (
  value,
  converter,
  string => bool,
) => value = %raw(`(value, convert, isMetadata) => {
  let result;
  for (const key in value) {
    if (!Object.prototype.hasOwnProperty.call(value,key) || isMetadata(key)) continue;
    const original = value[key];
    const next = convert(original);
    if (next !== original) {
      if (result === undefined) result = {...value};
      result[key] = next;
    }
  }
  return result === undefined ? value : result;
}`)
let makeRecord: (
  dict<converter>,
  bool,
  converter,
  string => bool,
) => converter = %raw(`(fields, fragments, any, isMetadata) => value => {
  let result;
  if (fragments) {
    const refs = {...value};
    result = {...value, fragmentRefs: refs, updatableFragmentRefs: refs};
  }
  for (const key in value) {
    if (!Object.prototype.hasOwnProperty.call(value,key) || isMetadata(key)) continue;
    const original = value[key];
    const convert = fields[key];
    const next = convert === undefined ? any(original) : convert(original);
    if (next !== original) {
      if (result === undefined) result = {...value};
      result[key] = next;
    }
  }
  return result === undefined ? value : result;
}`)
let withLegacyFragments: value => value = %raw(`value => {const result = Object.assign({},value); result.fragmentRefs = Object.assign({},value); result.updatableFragmentRefs = result.fragmentRefs; return result;}`)
let hasProperty: (string, value) => bool = %raw(`(key, value) => key in value`)
@send external map: (value, (value, int, value) => value) => value = "map"
let legacyRecord: (
  value,
  string,
  value,
  value,
  value,
  value,
  bool,
  (value, value, value, string, value, value, value) => value,
) => value = %raw(`(maps, prefix, obj, instructions, converters, nullable, fragment, convertField) => {
  let result;
  if (fragment) {
    result = Object.assign({},obj);
    result.fragmentRefs = Object.assign({},obj);
    result.updatableFragmentRefs = result.fragmentRefs;
  }
  for (const key in obj) {
    if (key.startsWith('__') && key !== '__typename' && key !== '__id' && !key.startsWith('__relay_internal')) continue;
    const value = obj[key];
    let converted;
    if (value == null) converted = nullable;
    else if (value.BS_PRIVATE_NESTED_SOME_NONE >= 0) continue;
    else {
      const path = prefix + key;
      let instruction = instructions[path];
      if (instruction === undefined && typeof value !== 'object') continue;
      converted = convertField(value, instruction, maps, path, instructions, converters, nullable);
    }
    if (converted !== value) {
      if (result === undefined) result = Object.assign({},obj);
      result[key] = converted;
    }
  }
  return result === undefined ? obj : result;
}`)
