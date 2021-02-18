// @ts-ignore
import * as RelayFlowGenerator from "relay-compiler/lib/language/javascript/RelayFlowGenerator";
import { Fragment, Node } from "relay-compiler";
import { TypeGeneratorOptions } from "relay-compiler/lib/language/RelayLanguagePluginInterface";
import {
  makeOperationDescriptor,
  extractOperationInfo,
} from "./transformer/transformerUtils";
import { ScalarTypeMapping } from "relay-compiler/lib/language/javascript/RelayFlowTypeTransformers";
import * as DisallowReservedReasonWordsTransform from "./transforms/DisallowReservedReasonWordsTransform";
import * as EnforceManualTypeNameSelectionOnUnions from "./transforms/EnforceManualTypeNameSelectionOnUnions";
import { generateFromFlowTypes } from "./RescriptRelayBin";
import { maskDots } from "./generator/Utils";

function mapCustomScalars(customScalars: ScalarTypeMapping): ScalarTypeMapping {
  const newCustomScalars: ScalarTypeMapping = {
    Int: "int",
    Float: "float",
    ...customScalars,
  };
  Object.keys(newCustomScalars).forEach((key) => {
    newCustomScalars[key] = maskDots(newCustomScalars[key]);
  });

  return newCustomScalars;
}

export function generate(
  schema: any,
  node: Node | Fragment,
  options: TypeGeneratorOptions
): string {
  let flowTypes = RelayFlowGenerator.generate(schema, node, {
    ...options,
    customScalars: mapCustomScalars(options.customScalars),
  });

  const operationDescriptor = makeOperationDescriptor(node);
  const opInfo = extractOperationInfo(node);

  return generateFromFlowTypes({
    content: flowTypes,
    // @ts-ignore
    operation_type: ["Query", "Mutation", "Subscription"].includes(
      operationDescriptor.tag
    )
      ? {
          operation: operationDescriptor.tag,
          operation_value: operationDescriptor.value,
        }
      : {
          operation: "Fragment",
          fragment_value: operationDescriptor.value,
        },
    print_config: {
      variables_holding_connection_ids:
        opInfo.variablesHoldingConnectionIds ?? null,
      connection: opInfo.connection
        ? {
            at_object_path: opInfo.connection.atObjectPath,
            field_name: opInfo.connection.fieldName,
            key: opInfo.connection.key,
          }
        : null,
    },
  });
}

export const transforms = [
  EnforceManualTypeNameSelectionOnUnions.transform,
  DisallowReservedReasonWordsTransform.transform,
  ...RelayFlowGenerator.transforms,
];
