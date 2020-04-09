open Types;

type nullableType =
  | Null
  | Undefined;

let printConverterAssets =
    (
      ~rootObjects: list(finalizedObj),
      ~direction: UtilsPrinter.conversionDirection=Unwrap,
      ~nullableType=Undefined,
      ~includeRaw=true,
      ~definition: object_,
      name,
    ) => {
  let assets =
    definition |> UtilsPrinter.objectToAssets(~rootObjects, ~direction);

  (includeRaw ? "type " ++ name ++ "Raw;" : "")
  ++ "let "
  ++ name
  ++ "Converter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw {json| "
  ++ (
    assets.converterInstructions
    |> Js.Json.stringifyAny
    |> Tablecloth.Option.withDefault(~default="")
  )
  ++ " |json}];"
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