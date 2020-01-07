let fragmentFlowTypesToDefinition =
    (~fragmentName, ~plural, flowTypes): option(Types.object_) =>
  switch (
    TypesTransformer.flowTypesToFullState(
      ~content=flowTypes,
      ~operationType=Fragment(fragmentName, plural),
    )
  ) {
  | {fragment: Some({definition})} => Some(definition)
  | _ => None
  };

let objectToConverterDict = obj => {
  let assets = obj |> UtilsPrinter.objectToAssets;
  assets.converterInstructions;
};

[@gentype]
let getDefinitionDecoder = (~fragmentName, ~plural, ~flowTypes) =>
  switch (flowTypes |> fragmentFlowTypesToDefinition(~fragmentName, ~plural)) {
  | Some(definition) => Some(definition |> objectToConverterDict)
  | None => None
  };