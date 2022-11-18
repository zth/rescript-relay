open Belt

@unboxed type rec converted = Converted('a): converted

@unboxed type rec from = From('a): from

type rec scalar =
  | WithoutConverter: scalar
  | WithConverter(from => converted): scalar

type rec unionMember = {
  typename: string,
  object: object,
}

and union = {
  recordName: string,
  members: array<unionMember>,
  // payload => converted variant
  converter: converted => converted,
}

and propType =
  | DataId
  | Scalar(scalar)
  | Enum(from => converted)
  | Array({nullable: bool, propType: propType})
  | Fragment
  | InputObject(object)
  | Record(object)
  | Union(union)
  | RelayResolver

and propValue = {
  nullable: bool,
  propType: propType,
}

and object = {
  fields: Js.Dict.t<propValue>,
  hasFragments: bool,
  convertTopLevelNodeField: option<string>,
}

type rec topLevelFragmentType =
  | Object(object)
  | Union(union)
  | ArrayWithObject(object)
  | ArrayWithUnion(union)

type rec ast =
  | Fragment(topLevelFragmentType)
  | Response(object)
  | RawResponse(object)
  | Variables(object)
  | InputObject(object)

module Dict = {
  let mapWithKey = (source, f) => {
    open Js.Dict
    let target = empty()
    let keys = keys(source)
    let l = Js_array2.length(keys)
    for i in 0 to l - 1 {
      let key = Js.Array2.unsafe_get(keys, i)
      set(target, key, f(key, unsafeGet(source, key)))
    }
    target
  }

  let map2 = (dict1, dict2, f) =>
    mapWithKey(dict1, (key, v1) => f(v1, Js.Dict.unsafeGet(dict2, key)))

  let some = (dict, p) => Array.some(Js.Dict.values(dict), p)
}

let createScalarConverter = scalar =>
  switch scalar {
  | WithoutConverter => None
  | WithConverter(converter) => Some(v => v->From->converter->Converted)
  }

let convertNullable = (f, nullableValue) => Some(
  v =>
    if Js.Nullable.isNullable(v) {
      nullableValue
    } else {
      Converted(f(v))
    },
)

let rec createUnionConverter = ({members, converter}, nullableValue) => Some(
  v => {
    let unionTypename = switch Obj.magic(v)["NAME"] {
    | None => Obj.magic(v)["__typename"] // to rescript
    | Some(typename) => typename // from rescript
    }
    let unionMember = Array.getBy(members, ({typename}) => unionTypename == typename)->Option.getExn
    Option.map(createObjectConverter(unionMember.object, nullableValue), payloadConverter =>
      payloadConverter(v)
    )
    ->Option.getWithDefault(v->Converted)
    ->converter
  },
)
and createConverter = (nullable, propType, nullableValue) => {
  let nonNullableConverter = switch propType {
  | DataId => None
  | Scalar(scalar) => createScalarConverter(scalar)
  | Enum(converter) => Some(converter)
  | Array({nullable, propType}) =>
    switch createConverter(nullable, propType, nullableValue) {
    | Some(converter) =>
      Some(array => Converted(Array.map(array->Obj.magic, item => converter(item))))
    | None => None
    }
  | Fragment => None
  | InputObject(inputObject) => createObjectConverter(inputObject, nullableValue)
  | Record(object) => createObjectConverter(object, nullableValue)
  | Union(union) => createUnionConverter(union, nullableValue)
  | RelayResolver => None
  }

  switch nonNullableConverter {
  | Some(converter) =>
    Some(
      v =>
        if Js.Nullable.isNullable(v) {
          nullableValue
        } else {
          Converted(converter(Obj.magic(v)))
        },
    )
  | None =>
    if nullable {
      Some(
        v =>
          if Js.Nullable.isNullable(v) {
            nullableValue
          } else {
            Converted(v)
          },
      )
    } else {
      None
    }
  }
}

and createObjectConverter = (object: object, nullableValue): option<from => converted> => {
  let fieldConverters = Js.Dict.map(
    (. {nullable, propType}) => createConverter(nullable, propType, nullableValue),
    object.fields,
  )
  if Dict.some(fieldConverters, Option.isSome) {
    Some(
      (v: from): converted =>
        Dict.map2(Obj.magic(v), fieldConverters, (field, converter) =>
          switch converter {
          | Some(converter) => converter(field)
          | None => Converted(field)
          }
        )->Converted,
    )
  } else {
    None
  }
}

let convert = (converter, v) =>
  switch converter {
  | Some(converter) => converter(v)
  | None => Converted(v)
  }

let convertArray = (converter, v) =>
  switch converter {
  | Some(converter) => Converted(Array.map(Obj.magic(v), converter))
  | None => Converted(v)
  }

let convertObj = (nullableValue, ast, v): converted => {
  switch ast {
  | Response(object)
  | RawResponse(object)
  | Variables(object)
  | InputObject(object)
  | Fragment(Object(object)) =>
    convert(createObjectConverter(object, nullableValue), v)
  | Fragment(Union(union)) => convert(createUnionConverter(union, nullableValue), v)
  | Fragment(ArrayWithObject(object)) =>
    convertArray(createObjectConverter(object, nullableValue), v)
  | Fragment(ArrayWithUnion(union)) => convertArray(createUnionConverter(union, nullableValue), v)
  }
}
