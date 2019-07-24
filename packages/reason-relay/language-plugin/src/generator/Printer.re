open Types;

let printQuoted = propName => "\"" ++ propName ++ "\"";
let printPropName = propName => propName |> printQuoted;
let printEnumName = name => "enum_" ++ name;

[@genType]
let printWrappedEnumName = name => "SchemaAssets.Enum_" ++ name ++ ".wrapped";

[@genType]
let printWrappedUnionName = name => "Union_" ++ name ++ ".wrapped";

let printFragmentRef = name => name ++ "_graphql.t";

[@genType]
let getFragmentRefName = name => "__$fragment_ref__" ++ name;

[@genType]
let getInputTypeName = name => "input_" ++ name;

let printAnyType = () => "ReasonRelay.any";

let printTypeReference = (typeName: string) => typeName;

type objectOptionalType =
  | JsNullable
  | Option;

let printScalar = scalarValue =>
  switch (scalarValue) {
  | String => "string"
  | Int => "int"
  | Float => "float"
  | Boolean => "bool"
  | CustomScalar(str) => str
  | Any => printAnyType()
  };

let rec printPropType = (~propType, ~optType) =>
  switch (propType) {
  | Scalar(scalar) => printScalar(scalar)
  | Object(obj) => printObject(~obj, ~optType)
  | Array(propValue) => printArray(~propValue, ~optType)
  | Enum(name) => printWrappedEnumName(name)
  | Union(name) => printWrappedUnionName(name)
  | FragmentRefValue(name) => printFragmentRef(name)
  | TypeReference(name) => printTypeReference(name)
  }
and printPropValue = (~propValue, ~optType) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  if (propValue.nullable) {
    switch (optType) {
    | JsNullable => addToStr("Js.Nullable.t(")
    | Option => addToStr("option(")
    };
  };

  printPropType(~propType=propValue.propType, ~optType) |> addToStr;

  if (propValue.nullable) {
    addToStr(")");
  };

  str^;
}
and printObject = (~obj, ~optType: objectOptionalType) => {
  switch (obj.values |> Array.length) {
  | 0 => "unit"
  | _ =>
    let str = ref("{.");
    let addToStr = s => str := str^ ++ s;

    obj.values
    |> Array.iteri((index, p) => {
         if (index > 0) {
           addToStr(",");
         };

         addToStr(
           switch (p) {
           | Prop(name, propValue) =>
             printPropName(name)
             ++ ": "
             ++ printPropValue(~propValue, ~optType)
           | FragmentRef(name) =>
             (name |> getFragmentRefName |> printQuoted)
             ++ ": "
             ++ printFragmentRef(name)
           },
         );
       });

    addToStr("}");
    str^;
  };
}
and printArray = (~propValue, ~optType) =>
  "array(" ++ printPropValue(~propValue, ~optType) ++ ")";

let printRootType = rootType =>
  switch (rootType) {
  | Operation(obj) =>
    "type response = " ++ printObject(~obj, ~optType=JsNullable) ++ ";"
  | Variables(obj) =>
    "type variables = " ++ printObject(~obj, ~optType=Option) ++ ";"
  | InputObject(name, obj) =>
    "type " ++ name ++ " = " ++ printObject(~obj, ~optType=Option) ++ ";"
  | Fragment(obj) =>
    "type fragment = " ++ printObject(~obj, ~optType=JsNullable) ++ ";"
  | PluralFragment(obj) =>
    "type fragment = array(" ++ printObject(~obj, ~optType=JsNullable) ++ ");"
  };

[@genType]
let printCode = str => str |> Reason.parseRE |> Reason.printRE;

[@genType]
let makeRootType = rootType => rootType |> printRootType |> printCode;

[@genType]
let makeEnum = fullEnum => {
  let valuesStr = ref("");

  fullEnum.values
  |> Array.iter(value => valuesStr := valuesStr^ ++ "| `" ++ value);

  "type " ++ printEnumName(fullEnum.name) ++ " = [ " ++ valuesStr^ ++ " ];";
};