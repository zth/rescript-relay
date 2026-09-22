export {prepareConversion, convertWithoutPlan} from './src/RescriptRelay_Conversion.mjs';
export {traverser} from './src/RescriptRelay_LegacyConversion.mjs';
export function runConversion(convert, value) {
  return convert(value);
}
