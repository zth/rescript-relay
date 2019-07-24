/** 
 * @flow strict
 * @generated
 * @nolint
 */
/* eslint-disable */
// $FlowExpectedError: Reason checked type sufficiently
type $any = any;

const $$toRE635221987 = {"Int": 0, "String": 1, "Float": 2, "Boolean": 3, "Any": 4};

// $FlowExpectedError: Reason checked type sufficiently
import * as CreateBucklescriptBlock from 'bs-platform/lib/es6/block.js';

// $FlowExpectedError: Reason checked type sufficiently
import * as PrinterBS from './Printer.bs';

// flowlint-next-line nonstrict-import:off
import type {fullEnum as Types_fullEnum} from './Types.gen';

// flowlint-next-line nonstrict-import:off
import type {rootType as Types_rootType} from './Types.gen';

export const printWrappedEnumName: (string) => string = PrinterBS.printWrappedEnumName;

export const printWrappedUnionName: (string) => string = PrinterBS.printWrappedUnionName;

export const getFragmentRefName: (string) => string = PrinterBS.getFragmentRefName;

export const getInputTypeName: (string) => string = PrinterBS.getInputTypeName;

export const printCode: (string) => string = PrinterBS.printCode;

export const makeRootType: (Types_rootType) => string = function (Arg1: $any) {
  const result = PrinterBS.makeRootType(Arg1.tag==="Operation"
    ? CreateBucklescriptBlock.__(0, [[Arg1.value.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]])
    : Arg1.tag==="Fragment"
    ? CreateBucklescriptBlock.__(1, [[Arg1.value.values.map(function _element(ArrayItem1: $any) { return ArrayItem1.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem1.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem1.value[0], [ArrayItem1.value[1].nullable, ArrayItem1.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem1.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem1.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem1.value[1].propType.value]])
    : ArrayItem1.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem1.value[1].propType.value])
    : ArrayItem1.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [ArrayItem1.value[1].propType.value])
    : ArrayItem1.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem1.value[1].propType.value])
    : ArrayItem1.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem1.value[1].propType.value])
    : ArrayItem1.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem1.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem1.value[1].propType.value])]])})]])
    : Arg1.tag==="Variables"
    ? CreateBucklescriptBlock.__(2, [[Arg1.value.values.map(function _element(ArrayItem2: $any) { return ArrayItem2.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem2.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem2.value[0], [ArrayItem2.value[1].nullable, ArrayItem2.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem2.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem2.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem2.value[1].propType.value]])
    : ArrayItem2.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem2.value[1].propType.value])
    : ArrayItem2.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [ArrayItem2.value[1].propType.value])
    : ArrayItem2.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem2.value[1].propType.value])
    : ArrayItem2.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem2.value[1].propType.value])
    : ArrayItem2.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem2.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem2.value[1].propType.value])]])})]])
    : Arg1.tag==="InputObject"
    ? CreateBucklescriptBlock.__(3, [Arg1.value[0], [Arg1.value[1].values.map(function _element(ArrayItem3: $any) { return ArrayItem3.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem3.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem3.value[0], [ArrayItem3.value[1].nullable, ArrayItem3.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem3.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem3.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem3.value[1].propType.value]])
    : ArrayItem3.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem3.value[1].propType.value])
    : ArrayItem3.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [ArrayItem3.value[1].propType.value])
    : ArrayItem3.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem3.value[1].propType.value])
    : ArrayItem3.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem3.value[1].propType.value])
    : ArrayItem3.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem3.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem3.value[1].propType.value])]])})]])
    : CreateBucklescriptBlock.__(4, [[Arg1.value.values.map(function _element(ArrayItem4: $any) { return ArrayItem4.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem4.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem4.value[0], [ArrayItem4.value[1].nullable, ArrayItem4.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem4.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem4.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem4.value[1].propType.value]])
    : ArrayItem4.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem4.value[1].propType.value])
    : ArrayItem4.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [ArrayItem4.value[1].propType.value])
    : ArrayItem4.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem4.value[1].propType.value])
    : ArrayItem4.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem4.value[1].propType.value])
    : ArrayItem4.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem4.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem4.value[1].propType.value])]])})]]));
  return result
};

export const makeEnum: (Types_fullEnum) => string = function (Arg1: $any) {
  const result = PrinterBS.makeEnum([Arg1.name, Arg1.values]);
  return result
};
