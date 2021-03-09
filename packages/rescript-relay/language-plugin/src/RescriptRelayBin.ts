import { spawnSync } from "child_process";
import * as path from "path";

interface GenerateFromFlowConfig {
  content: string;
  operation_type:
    | {
        operation: "Query";
        operation_value: string;
      }
    | {
        operation: "Mutation";
        operation_value: string;
      }
    | {
        operation: "Subscription";
        operation_value: string;
      }
    | {
        operation: "Fragment";
        fragment_value: [string, boolean];
      };
  print_config: {
    variables_holding_connection_ids: null | string[];
    connection: null | {
      key: string;
      at_object_path: string[];
      field_name: string;
    };
  };
}

export const generateFromFlowTypes = (
  config: GenerateFromFlowConfig
): string => {
  const res = spawnSync(
    path.resolve(path.join(__dirname, "../RescriptRelayBin.exe")),
    ["generate-from-flow"],
    {
      cwd: __dirname,
      stdio: "pipe",
      encoding: "utf-8",
      input: JSON.stringify(config),
    }
  );

  if (res.status !== 0) {
    throw res.error ?? new Error("Error generating types");
  }

  return res.output.filter(Boolean).join("");
};
