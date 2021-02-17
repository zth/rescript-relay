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
  ++ "Converter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(json`"
  ++ UtilsPrinter.converterInstructionsToJson(assets.converterInstructions)
  ++ "`)"
  ++ "let "
  ++ name
  ++ "ConverterMap = "
  ++ assets.convertersDefinition
  ++ "let convert"
  ++ Tablecloth.String.capitalize(name)
  ++ " = v => v->ReasonRelay.convertObj("
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
  ++ ")";
};
