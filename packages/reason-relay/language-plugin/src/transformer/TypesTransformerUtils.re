open Types;

type nullableType =
  | Null
  | Undefined;

let printConverterAssets =
    (
      ~direction: UtilsPrinter.conversionDirection=Unwrap,
      ~nullableType=Undefined,
      ~includeRaw=true,
      ~definition: object_,
      name,
    ) => {
  let assets = definition |> UtilsPrinter.objectToAssets(~direction);

  (includeRaw ? "type " ++ name ++ "Raw;" : "")
  ++ "let "
  ++ name
  ++ "Converter: Js.Dict.t(array((int, string))) = [%raw {| "
  ++ (
    assets.converterInstructions
    |> Js.Json.stringifyAny
    |> Tablecloth.Option.withDefault(~default="")
  )
  ++ " |}];"
  ++ "let "
  ++ name
  ++ "ConverterMap = "
  ++ assets.convertersDefinition
  ++ "let convert"
  ++ Tablecloth.String.capitalize(name)
  ++ " = v => v->ReasonRelay._convertObj("
  ++ name
  ++ "Converter, "
  ++ name
  ++ "ConverterMap, "
  ++ (
    switch (nullableType) {
    | Null => "Js.null"
    | Undefined => "Js.undefined"
    }
  )
  ++ ");";
};

let findObjWithConnection = (obj: object_): option(object_) => {
  let theObj = ref(None);

  let rec traverse = values =>
    values
    |> Tablecloth.Array.forEach(~f=v =>
         switch (v) {
         | FragmentRef(_) => ()
         | Prop(_, {propType: Object(def)}) =>
           switch (def) {
           | {connection: Some(_)} => theObj := Some(def)
           | _ => traverse(def.values)
           }
         | _ => ()
         }
       );

  traverse(obj.values);

  theObj^;
};