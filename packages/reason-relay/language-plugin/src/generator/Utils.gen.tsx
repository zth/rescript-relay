/* TypeScript file generated from Utils.re by genType. */
/* eslint-disable import/first */


// tslint:disable-next-line:no-var-requires
const Curry = require('bs-platform/lib/js/curry.js');

// tslint:disable-next-line:no-var-requires
const UtilsBS = require('./Utils.bs');

import {connectionInfo as Types_connectionInfo} from './Types.gen';

export const maskDots: (_1:string) => string = UtilsBS.maskDots;

export const unmaskDots: (_1:string) => string = UtilsBS.unmaskDots;

export const findObjName: (_1:{
  readonly usedRecordNames: string[]; 
  readonly path: string[]; 
  readonly prefix: (null | undefined | string)
}) => string = function (Arg1: any) {
  const result = Curry._3(UtilsBS.findObjName, Arg1.usedRecordNames, Arg1.path, (Arg1.prefix == null ? undefined : Arg1.prefix));
  return result
};

export const extractConnectionInfo: (_1:string) => (null | undefined | Types_connectionInfo) = UtilsBS.extractConnectionInfo;
