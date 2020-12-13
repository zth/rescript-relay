// This is the actual entry point for the language plugin.
// The language plugin get both the content (Flow types) and operation type from Relay.

let printFromFlowTypes =
    (~content, ~operationType, ~config: Types.printConfig) => {
  ParseFlowTypes.flowTypesToFullState(~content, ~operationType)
  |> PrintState.getPrintedFullState(~operationType, ~config)
  |> Printer.printCode;
};
