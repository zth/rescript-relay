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
      ~definition: rootStructure,
      name,
    )
    : string => {
  let assets =
    definition |> UtilsPrinter.definitionToAssets(~rootObjects, ~direction);

  (includeRaw ? "type " ++ name ++ "Raw\n" : "")
  ++ "let "
  ++ name
  ++ "Converter: \n  Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = \n  %raw(\n    json`"
  ++ UtilsPrinter.converterInstructionsToJson(assets.converterInstructions)
  ++ "`\n  )\n\n"
  ++ "let "
  ++ name
  ++ "ConverterMap = "
  ++ assets.convertersDefinition
  ++ "\nlet convert"
  ++ Tablecloth.String.capitalize(name)
  ++ " = v => v->ReasonRelay.convertObj(\n  "
  ++ name
  ++ "Converter, \n  "
  ++ name
  ++ "ConverterMap, \n  "
  ++ (
    switch (nullableType) {
    | Null => "Js.null"
    | Undefined => "Js.undefined"
    }
  )
  ++ "\n)";
};
