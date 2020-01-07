/* TypeScript file generated from TestUtils.re by genType. */
/* eslint-disable import/first */


// tslint:disable-next-line:no-var-requires
const Curry = require('bs-platform/lib/js/curry.js');

// tslint:disable-next-line:no-var-requires
const TestUtilsBS = require('./TestUtils.bs');

import {Dict_t as Js_Dict_t} from '../src/shims/Js.shim';

export const getDefinitionDecoder: (_1:{
  readonly fragmentName: string; 
  readonly plural: boolean; 
  readonly flowTypes: string
}) => (null | undefined | Js_Dict_t<Array<[number, string]>>) = function (Arg1: any) {
  const result = Curry._3(TestUtilsBS.getDefinitionDecoder, Arg1.fragmentName, Arg1.plural, Arg1.flowTypes);
  return result
};
