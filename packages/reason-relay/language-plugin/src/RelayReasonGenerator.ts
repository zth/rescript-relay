// @ts-ignore
import * as RelayFlowGenerator from "../../src/vendor/relay-compiler/lib/language/javascript/RelayFlowGenerator";

import { Fragment, Node } from "relay-compiler";
import { TypeGeneratorOptions } from "relay-compiler/lib/language/RelayLanguagePluginInterface";
import { printFromFlowTypes } from "./transformer/TypesTransformer.gen";
import { makeOperationDescriptor } from "./transformer/transformerUtils";
import { ScalarTypeMapping } from "relay-compiler/lib/language/javascript/RelayFlowTypeTransformers";
import { maskDots } from "./generator/Utils.gen";
import * as DisallowReservedReasonWordsTransform from "./transforms/DisallowReservedReasonWordsTransform";
import * as EnforceManualTypeNameSelectionOnUnions from "./transforms/EnforceManualTypeNameSelectionOnUnions";

function mapCustomScalars(customScalars: ScalarTypeMapping): ScalarTypeMapping {
  const newCustomScalars: ScalarTypeMapping = {
    Int: "int",
    Float: "float",
    ...customScalars
  };
  Object.keys(newCustomScalars).forEach(key => {
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
    customScalars: mapCustomScalars(options.customScalars)
  });

  return printFromFlowTypes({
    content: flowTypes,
    operationType: makeOperationDescriptor(node)
  });
}

export const transforms = [
  EnforceManualTypeNameSelectionOnUnions.transform,
  DisallowReservedReasonWordsTransform.transform,
  ...RelayFlowGenerator.transforms
];
