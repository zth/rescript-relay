open Types;

type nullableType =
  | Null
  | Undefined;

/**
  {
    "__root":{
      "onlineStatus":{
        "n":""
      },
    "":{
      "f":""
    }
    }
  } */

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

  (includeRaw ? "type " ++ name ++ "Raw;" : "")
  ++ "let "
  ++ name
  ++ "Converter: Js.Dict.t(Js.Dict.t(Js.Dict.t(string))) = [%raw {json| "
  ++ UtilsPrinter.converterInstructionsToJson(assets.converterInstructions)
  ++ " |json}];"
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
  ++ ");";
};
