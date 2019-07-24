/** 
 * @flow strict
 * @generated
 * @nolint
 */
/* eslint-disable */
// $FlowExpectedError: Reason checked type sufficiently
type $any = any;

const $$toJS635221987 = {"0": "Int", "1": "String", "2": "Float", "3": "Boolean", "4": "Any"};

const $$toRE635221987 = {"Int": 0, "String": 1, "Float": 2, "Boolean": 3, "Any": 4};

// $FlowExpectedError: Reason checked type sufficiently
import * as CreateBucklescriptBlock from 'bs-platform/lib/es6/block.js';

// $FlowExpectedError: Reason checked type sufficiently
import * as Curry from 'bs-platform/lib/es6/curry.js';

// $FlowExpectedError: Reason checked type sufficiently
import * as GeneratorsBS from './Generators.bs';

// flowlint-next-line nonstrict-import:off
import type {object_ as Types_object_} from './Types.gen';

// flowlint-next-line nonstrict-import:off
import type {propType as Types_propType} from './Types.gen';

// flowlint-next-line nonstrict-import:off
import type {propValue as Types_propValue} from './Types.gen';

// flowlint-next-line nonstrict-import:off
import type {propValues as Types_propValues} from './Types.gen';

// flowlint-next-line nonstrict-import:off
import type {rootType as Types_rootType} from './Types.gen';

// flowlint-next-line nonstrict-import:off
import type {scalarValues as Types_scalarValues} from './Types.gen';

export const makeScalarInt: (void) => Types_scalarValues = function (Arg1: $any) {
  const result = GeneratorsBS.makeScalarInt(Arg1);
  return typeof(result) === 'object'
    ? {tag:"CustomScalar", value:result[0]}
    : $$toJS635221987[result]
};

export const makeScalarString: (void) => Types_scalarValues = function (Arg1: $any) {
  const result = GeneratorsBS.makeScalarString(Arg1);
  return typeof(result) === 'object'
    ? {tag:"CustomScalar", value:result[0]}
    : $$toJS635221987[result]
};

export const makeScalarFloat: (void) => Types_scalarValues = function (Arg1: $any) {
  const result = GeneratorsBS.makeScalarFloat(Arg1);
  return typeof(result) === 'object'
    ? {tag:"CustomScalar", value:result[0]}
    : $$toJS635221987[result]
};

export const makeScalarBoolean: (void) => Types_scalarValues = function (Arg1: $any) {
  const result = GeneratorsBS.makeScalarBoolean(Arg1);
  return typeof(result) === 'object'
    ? {tag:"CustomScalar", value:result[0]}
    : $$toJS635221987[result]
};

export const makeScalarCustom: (string) => Types_scalarValues = function (Arg1: $any) {
  const result = GeneratorsBS.makeScalarCustom(Arg1);
  return typeof(result) === 'object'
    ? {tag:"CustomScalar", value:result[0]}
    : $$toJS635221987[result]
};

export const makeScalarAny: (void) => Types_scalarValues = function (Arg1: $any) {
  const result = GeneratorsBS.makeScalarAny(Arg1);
  return typeof(result) === 'object'
    ? {tag:"CustomScalar", value:result[0]}
    : $$toJS635221987[result]
};

export const makePropScalar: (Types_scalarValues) => Types_propType = function (Arg1: $any) {
  const result = GeneratorsBS.makePropScalar(typeof(Arg1) === 'object'
    ? CreateBucklescriptBlock.__(0, [Arg1.value])
    : $$toRE635221987[Arg1]);
  return result.tag===0
    ? {tag:"Scalar", value:typeof(result[0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][0]}
    : $$toJS635221987[result[0]]}
    : result.tag===1
    ? {tag:"Enum", value:result[0]}
    : result.tag===2
    ? {tag:"Object", value:{values:result[0][0].map(function _element(ArrayItem: $any) { return ArrayItem.tag===0
    ? {tag:"FragmentRef", value:ArrayItem[0]}
    : {tag:"Prop", value:[ArrayItem.slice()[0], {nullable:ArrayItem.slice()[1][0], propType:ArrayItem.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem.slice()[1][1][0]]}
    : ArrayItem.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"Array", value:{nullable:result[0][0], propType:result[0][1].tag===0
    ? {tag:"Scalar", value:typeof(result[0][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][1][0][0]}
    : $$toJS635221987[result[0][1][0]]}
    : result[0][1].tag===1
    ? {tag:"Enum", value:result[0][1][0]}
    : result[0][1].tag===2
    ? {tag:"Object", value:{values:result[0][1][0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:ArrayItem1.slice()}})}}
    : result[0][1].tag===3
    ? {tag:"Array", value:result[0][1][0]}
    : result[0][1].tag===4
    ? {tag:"FragmentRefValue", value:result[0][1][0]}
    : result[0][1].tag===5
    ? {tag:"TypeReference", value:result[0][1][0]}
    : {tag:"Union", value:result[0][1][0]}}}
    : result.tag===4
    ? {tag:"FragmentRefValue", value:result[0]}
    : result.tag===5
    ? {tag:"TypeReference", value:result[0]}
    : {tag:"Union", value:result[0]}
};

export const makePropEnum: (string) => Types_propType = function (Arg1: $any) {
  const result = GeneratorsBS.makePropEnum(Arg1);
  return result.tag===0
    ? {tag:"Scalar", value:typeof(result[0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][0]}
    : $$toJS635221987[result[0]]}
    : result.tag===1
    ? {tag:"Enum", value:result[0]}
    : result.tag===2
    ? {tag:"Object", value:{values:result[0][0].map(function _element(ArrayItem: $any) { return ArrayItem.tag===0
    ? {tag:"FragmentRef", value:ArrayItem[0]}
    : {tag:"Prop", value:[ArrayItem.slice()[0], {nullable:ArrayItem.slice()[1][0], propType:ArrayItem.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem.slice()[1][1][0]]}
    : ArrayItem.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"Array", value:{nullable:result[0][0], propType:result[0][1].tag===0
    ? {tag:"Scalar", value:typeof(result[0][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][1][0][0]}
    : $$toJS635221987[result[0][1][0]]}
    : result[0][1].tag===1
    ? {tag:"Enum", value:result[0][1][0]}
    : result[0][1].tag===2
    ? {tag:"Object", value:{values:result[0][1][0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:ArrayItem1.slice()}})}}
    : result[0][1].tag===3
    ? {tag:"Array", value:result[0][1][0]}
    : result[0][1].tag===4
    ? {tag:"FragmentRefValue", value:result[0][1][0]}
    : result[0][1].tag===5
    ? {tag:"TypeReference", value:result[0][1][0]}
    : {tag:"Union", value:result[0][1][0]}}}
    : result.tag===4
    ? {tag:"FragmentRefValue", value:result[0]}
    : result.tag===5
    ? {tag:"TypeReference", value:result[0]}
    : {tag:"Union", value:result[0]}
};

export const makePropUnion: (string) => Types_propType = function (Arg1: $any) {
  const result = GeneratorsBS.makePropUnion(Arg1);
  return result.tag===0
    ? {tag:"Scalar", value:typeof(result[0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][0]}
    : $$toJS635221987[result[0]]}
    : result.tag===1
    ? {tag:"Enum", value:result[0]}
    : result.tag===2
    ? {tag:"Object", value:{values:result[0][0].map(function _element(ArrayItem: $any) { return ArrayItem.tag===0
    ? {tag:"FragmentRef", value:ArrayItem[0]}
    : {tag:"Prop", value:[ArrayItem.slice()[0], {nullable:ArrayItem.slice()[1][0], propType:ArrayItem.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem.slice()[1][1][0]]}
    : ArrayItem.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"Array", value:{nullable:result[0][0], propType:result[0][1].tag===0
    ? {tag:"Scalar", value:typeof(result[0][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][1][0][0]}
    : $$toJS635221987[result[0][1][0]]}
    : result[0][1].tag===1
    ? {tag:"Enum", value:result[0][1][0]}
    : result[0][1].tag===2
    ? {tag:"Object", value:{values:result[0][1][0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:ArrayItem1.slice()}})}}
    : result[0][1].tag===3
    ? {tag:"Array", value:result[0][1][0]}
    : result[0][1].tag===4
    ? {tag:"FragmentRefValue", value:result[0][1][0]}
    : result[0][1].tag===5
    ? {tag:"TypeReference", value:result[0][1][0]}
    : {tag:"Union", value:result[0][1][0]}}}
    : result.tag===4
    ? {tag:"FragmentRefValue", value:result[0]}
    : result.tag===5
    ? {tag:"TypeReference", value:result[0]}
    : {tag:"Union", value:result[0]}
};

export const makePropObject: (Types_object_) => Types_propType = function (Arg1: $any) {
  const result = GeneratorsBS.makePropObject([Arg1.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]);
  return result.tag===0
    ? {tag:"Scalar", value:typeof(result[0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][0]}
    : $$toJS635221987[result[0]]}
    : result.tag===1
    ? {tag:"Enum", value:result[0]}
    : result.tag===2
    ? {tag:"Object", value:{values:result[0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:[ArrayItem1.slice()[0], {nullable:ArrayItem1.slice()[1][0], propType:ArrayItem1.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem1.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem1.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem1.slice()[1][1][0]]}
    : ArrayItem1.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem1.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem1.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"Array", value:{nullable:result[0][0], propType:result[0][1].tag===0
    ? {tag:"Scalar", value:typeof(result[0][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][1][0][0]}
    : $$toJS635221987[result[0][1][0]]}
    : result[0][1].tag===1
    ? {tag:"Enum", value:result[0][1][0]}
    : result[0][1].tag===2
    ? {tag:"Object", value:{values:result[0][1][0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:ArrayItem2.slice()}})}}
    : result[0][1].tag===3
    ? {tag:"Array", value:result[0][1][0]}
    : result[0][1].tag===4
    ? {tag:"FragmentRefValue", value:result[0][1][0]}
    : result[0][1].tag===5
    ? {tag:"TypeReference", value:result[0][1][0]}
    : {tag:"Union", value:result[0][1][0]}}}
    : result.tag===4
    ? {tag:"FragmentRefValue", value:result[0]}
    : result.tag===5
    ? {tag:"TypeReference", value:result[0]}
    : {tag:"Union", value:result[0]}
};

export const makePropArray: (Types_propValue) => Types_propType = function (Arg1: $any) {
  const result = GeneratorsBS.makePropArray([Arg1.nullable, Arg1.propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(Arg1.propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [Arg1.propType.value.value])
    : $$toRE635221987[Arg1.propType.value]])
    : Arg1.propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [Arg1.propType.value])
    : Arg1.propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[Arg1.propType.value.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType]])})]])
    : Arg1.propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [[Arg1.propType.value.nullable, Arg1.propType.value.propType]])
    : Arg1.propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [Arg1.propType.value])
    : Arg1.propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [Arg1.propType.value])
    : CreateBucklescriptBlock.__(6, [Arg1.propType.value])]);
  return result.tag===0
    ? {tag:"Scalar", value:typeof(result[0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][0]}
    : $$toJS635221987[result[0]]}
    : result.tag===1
    ? {tag:"Enum", value:result[0]}
    : result.tag===2
    ? {tag:"Object", value:{values:result[0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:[ArrayItem1.slice()[0], {nullable:ArrayItem1.slice()[1][0], propType:ArrayItem1.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem1.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem1.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem1.slice()[1][1][0]]}
    : ArrayItem1.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem1.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem1.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"Array", value:{nullable:result[0][0], propType:result[0][1].tag===0
    ? {tag:"Scalar", value:typeof(result[0][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][1][0][0]}
    : $$toJS635221987[result[0][1][0]]}
    : result[0][1].tag===1
    ? {tag:"Enum", value:result[0][1][0]}
    : result[0][1].tag===2
    ? {tag:"Object", value:{values:result[0][1][0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:ArrayItem2.slice()}})}}
    : result[0][1].tag===3
    ? {tag:"Array", value:result[0][1][0]}
    : result[0][1].tag===4
    ? {tag:"FragmentRefValue", value:result[0][1][0]}
    : result[0][1].tag===5
    ? {tag:"TypeReference", value:result[0][1][0]}
    : {tag:"Union", value:result[0][1][0]}}}
    : result.tag===4
    ? {tag:"FragmentRefValue", value:result[0]}
    : result.tag===5
    ? {tag:"TypeReference", value:result[0]}
    : {tag:"Union", value:result[0]}
};

export const makeFragmentRefValue: (string) => Types_propType = function (Arg1: $any) {
  const result = GeneratorsBS.makeFragmentRefValue(Arg1);
  return result.tag===0
    ? {tag:"Scalar", value:typeof(result[0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][0]}
    : $$toJS635221987[result[0]]}
    : result.tag===1
    ? {tag:"Enum", value:result[0]}
    : result.tag===2
    ? {tag:"Object", value:{values:result[0][0].map(function _element(ArrayItem: $any) { return ArrayItem.tag===0
    ? {tag:"FragmentRef", value:ArrayItem[0]}
    : {tag:"Prop", value:[ArrayItem.slice()[0], {nullable:ArrayItem.slice()[1][0], propType:ArrayItem.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem.slice()[1][1][0]]}
    : ArrayItem.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"Array", value:{nullable:result[0][0], propType:result[0][1].tag===0
    ? {tag:"Scalar", value:typeof(result[0][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][1][0][0]}
    : $$toJS635221987[result[0][1][0]]}
    : result[0][1].tag===1
    ? {tag:"Enum", value:result[0][1][0]}
    : result[0][1].tag===2
    ? {tag:"Object", value:{values:result[0][1][0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:ArrayItem1.slice()}})}}
    : result[0][1].tag===3
    ? {tag:"Array", value:result[0][1][0]}
    : result[0][1].tag===4
    ? {tag:"FragmentRefValue", value:result[0][1][0]}
    : result[0][1].tag===5
    ? {tag:"TypeReference", value:result[0][1][0]}
    : {tag:"Union", value:result[0][1][0]}}}
    : result.tag===4
    ? {tag:"FragmentRefValue", value:result[0]}
    : result.tag===5
    ? {tag:"TypeReference", value:result[0]}
    : {tag:"Union", value:result[0]}
};

export const makePropValue: ({| +nullable: boolean, +propType: Types_propType |}, void) => Types_propValue = function (Arg1: $any, Arg2: $any) {
  const result = Curry._3(GeneratorsBS.makePropValue, Arg1.nullable, Arg1.propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(Arg1.propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [Arg1.propType.value.value])
    : $$toRE635221987[Arg1.propType.value]])
    : Arg1.propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [Arg1.propType.value])
    : Arg1.propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[Arg1.propType.value.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
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
    : Arg1.propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [[Arg1.propType.value.nullable, Arg1.propType.value.propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(Arg1.propType.value.propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [Arg1.propType.value.propType.value.value])
    : $$toRE635221987[Arg1.propType.value.propType.value]])
    : Arg1.propType.value.propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [Arg1.propType.value.propType.value])
    : Arg1.propType.value.propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[Arg1.propType.value.propType.value.values.map(function _element(ArrayItem1: $any) { return ArrayItem1.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem1.value])
    : CreateBucklescriptBlock.__(1, ArrayItem1.value)})]])
    : Arg1.propType.value.propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [Arg1.propType.value.propType.value])
    : Arg1.propType.value.propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [Arg1.propType.value.propType.value])
    : Arg1.propType.value.propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [Arg1.propType.value.propType.value])
    : CreateBucklescriptBlock.__(6, [Arg1.propType.value.propType.value])]])
    : Arg1.propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [Arg1.propType.value])
    : Arg1.propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [Arg1.propType.value])
    : CreateBucklescriptBlock.__(6, [Arg1.propType.value]), Arg2);
  return {nullable:result[0], propType:result[1].tag===0
    ? {tag:"Scalar", value:typeof(result[1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[1][0][0]}
    : $$toJS635221987[result[1][0]]}
    : result[1].tag===1
    ? {tag:"Enum", value:result[1][0]}
    : result[1].tag===2
    ? {tag:"Object", value:{values:result[1][0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:[ArrayItem2.slice()[0], {nullable:ArrayItem2.slice()[1][0], propType:ArrayItem2.slice()[1][1]}]}})}}
    : result[1].tag===3
    ? {tag:"Array", value:{nullable:result[1][0][0], propType:result[1][0][1]}}
    : result[1].tag===4
    ? {tag:"FragmentRefValue", value:result[1][0]}
    : result[1].tag===5
    ? {tag:"TypeReference", value:result[1][0]}
    : {tag:"Union", value:result[1][0]}}
};

export const makeFragmentRefProp: (string) => Types_propValues = function (Arg1: $any) {
  const result = GeneratorsBS.makeFragmentRefProp(Arg1);
  return result.tag===0
    ? {tag:"FragmentRef", value:result[0]}
    : {tag:"Prop", value:[result.slice()[0], {nullable:result.slice()[1][0], propType:result.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(result.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result.slice()[1][1][0][0]}
    : $$toJS635221987[result.slice()[1][1][0]]}
    : result.slice()[1][1].tag===1
    ? {tag:"Enum", value:result.slice()[1][1][0]}
    : result.slice()[1][1].tag===2
    ? {tag:"Object", value:{values:result.slice()[1][1][0][0].map(function _element(ArrayItem: $any) { return ArrayItem.tag===0
    ? {tag:"FragmentRef", value:ArrayItem[0]}
    : {tag:"Prop", value:ArrayItem.slice()}})}}
    : result.slice()[1][1].tag===3
    ? {tag:"Array", value:result.slice()[1][1][0]}
    : result.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:result.slice()[1][1][0]}
    : result.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:result.slice()[1][1][0]}
    : {tag:"Union", value:result.slice()[1][1][0]}}]}
};

export const makeObjProp: ({| +name: string, +propValue: Types_propValue |}, void) => Types_propValues = function (Arg1: $any, Arg2: $any) {
  const result = Curry._3(GeneratorsBS.makeObjProp, Arg1.name, [Arg1.propValue.nullable, Arg1.propValue.propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(Arg1.propValue.propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [Arg1.propValue.propType.value.value])
    : $$toRE635221987[Arg1.propValue.propType.value]])
    : Arg1.propValue.propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [Arg1.propValue.propType.value])
    : Arg1.propValue.propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[Arg1.propValue.propType.value.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType]])})]])
    : Arg1.propValue.propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [[Arg1.propValue.propType.value.nullable, Arg1.propValue.propType.value.propType]])
    : Arg1.propValue.propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [Arg1.propValue.propType.value])
    : Arg1.propValue.propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [Arg1.propValue.propType.value])
    : CreateBucklescriptBlock.__(6, [Arg1.propValue.propType.value])], Arg2);
  return result.tag===0
    ? {tag:"FragmentRef", value:result[0]}
    : {tag:"Prop", value:[result.slice()[0], {nullable:result.slice()[1][0], propType:result.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(result.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result.slice()[1][1][0][0]}
    : $$toJS635221987[result.slice()[1][1][0]]}
    : result.slice()[1][1].tag===1
    ? {tag:"Enum", value:result.slice()[1][1][0]}
    : result.slice()[1][1].tag===2
    ? {tag:"Object", value:{values:result.slice()[1][1][0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:ArrayItem1.slice()}})}}
    : result.slice()[1][1].tag===3
    ? {tag:"Array", value:result.slice()[1][1][0]}
    : result.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:result.slice()[1][1][0]}
    : result.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:result.slice()[1][1][0]}
    : {tag:"Union", value:result.slice()[1][1][0]}}]}
};

export const makeTypeReference: (string) => Types_propType = function (Arg1: $any) {
  const result = GeneratorsBS.makeTypeReference(Arg1);
  return result.tag===0
    ? {tag:"Scalar", value:typeof(result[0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][0]}
    : $$toJS635221987[result[0]]}
    : result.tag===1
    ? {tag:"Enum", value:result[0]}
    : result.tag===2
    ? {tag:"Object", value:{values:result[0][0].map(function _element(ArrayItem: $any) { return ArrayItem.tag===0
    ? {tag:"FragmentRef", value:ArrayItem[0]}
    : {tag:"Prop", value:[ArrayItem.slice()[0], {nullable:ArrayItem.slice()[1][0], propType:ArrayItem.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem.slice()[1][1][0]]}
    : ArrayItem.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem.slice()[1][1][0]}
    : ArrayItem.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"Array", value:{nullable:result[0][0], propType:result[0][1].tag===0
    ? {tag:"Scalar", value:typeof(result[0][1][0]) === 'object'
    ? {tag:"CustomScalar", value:result[0][1][0][0]}
    : $$toJS635221987[result[0][1][0]]}
    : result[0][1].tag===1
    ? {tag:"Enum", value:result[0][1][0]}
    : result[0][1].tag===2
    ? {tag:"Object", value:{values:result[0][1][0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:ArrayItem1.slice()}})}}
    : result[0][1].tag===3
    ? {tag:"Array", value:result[0][1][0]}
    : result[0][1].tag===4
    ? {tag:"FragmentRefValue", value:result[0][1][0]}
    : result[0][1].tag===5
    ? {tag:"TypeReference", value:result[0][1][0]}
    : {tag:"Union", value:result[0][1][0]}}}
    : result.tag===4
    ? {tag:"FragmentRefValue", value:result[0]}
    : result.tag===5
    ? {tag:"TypeReference", value:result[0]}
    : {tag:"Union", value:result[0]}
};

export const makeObj: (Array<Types_propValues>) => Types_object_ = function (Arg1: $any) {
  const result = GeneratorsBS.makeObj(Arg1.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values.map(function _element(ArrayItem1: $any) { return ArrayItem1.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem1.value])
    : CreateBucklescriptBlock.__(1, ArrayItem1.value)})]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])}));
  return {values:result[0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:[ArrayItem2.slice()[0], {nullable:ArrayItem2.slice()[1][0], propType:ArrayItem2.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem2.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem2.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem2.slice()[1][1][0]]}
    : ArrayItem2.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===2
    ? {tag:"Object", value:{values:ArrayItem2.slice()[1][1][0][0]}}
    : ArrayItem2.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem2.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem2.slice()[1][1][0]}}]}})}
};

export const makeOperation: (Types_object_) => Types_rootType = function (Arg1: $any) {
  const result = GeneratorsBS.makeOperation([Arg1.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]);
  return result.tag===0
    ? {tag:"Operation", value:{values:result[0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:[ArrayItem1.slice()[0], {nullable:ArrayItem1.slice()[1][0], propType:ArrayItem1.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem1.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem1.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem1.slice()[1][1][0]]}
    : ArrayItem1.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem1.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem1.slice()[1][1][0]}}]}})}}
    : result.tag===1
    ? {tag:"Fragment", value:{values:result[0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:[ArrayItem2.slice()[0], {nullable:ArrayItem2.slice()[1][0], propType:ArrayItem2.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem2.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem2.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem2.slice()[1][1][0]]}
    : ArrayItem2.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem2.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem2.slice()[1][1][0]}}]}})}}
    : result.tag===2
    ? {tag:"Variables", value:{values:result[0][0].map(function _element(ArrayItem3: $any) { return ArrayItem3.tag===0
    ? {tag:"FragmentRef", value:ArrayItem3[0]}
    : {tag:"Prop", value:[ArrayItem3.slice()[0], {nullable:ArrayItem3.slice()[1][0], propType:ArrayItem3.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem3.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem3.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem3.slice()[1][1][0]]}
    : ArrayItem3.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem3.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem3.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"InputObject", value:[result.slice()[0], {values:result.slice()[1][0].map(function _element(ArrayItem4: $any) { return ArrayItem4.tag===0
    ? {tag:"FragmentRef", value:ArrayItem4[0]}
    : {tag:"Prop", value:[ArrayItem4.slice()[0], {nullable:ArrayItem4.slice()[1][0], propType:ArrayItem4.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem4.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem4.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem4.slice()[1][1][0]]}
    : ArrayItem4.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem4.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem4.slice()[1][1][0]}}]}})}]}
    : {tag:"PluralFragment", value:{values:result[0][0].map(function _element(ArrayItem5: $any) { return ArrayItem5.tag===0
    ? {tag:"FragmentRef", value:ArrayItem5[0]}
    : {tag:"Prop", value:[ArrayItem5.slice()[0], {nullable:ArrayItem5.slice()[1][0], propType:ArrayItem5.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem5.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem5.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem5.slice()[1][1][0]]}
    : ArrayItem5.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem5.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem5.slice()[1][1][0]}}]}})}}
};

export const makeFragment: (Types_object_) => Types_rootType = function (Arg1: $any) {
  const result = GeneratorsBS.makeFragment([Arg1.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]);
  return result.tag===0
    ? {tag:"Operation", value:{values:result[0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:[ArrayItem1.slice()[0], {nullable:ArrayItem1.slice()[1][0], propType:ArrayItem1.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem1.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem1.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem1.slice()[1][1][0]]}
    : ArrayItem1.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem1.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem1.slice()[1][1][0]}}]}})}}
    : result.tag===1
    ? {tag:"Fragment", value:{values:result[0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:[ArrayItem2.slice()[0], {nullable:ArrayItem2.slice()[1][0], propType:ArrayItem2.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem2.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem2.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem2.slice()[1][1][0]]}
    : ArrayItem2.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem2.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem2.slice()[1][1][0]}}]}})}}
    : result.tag===2
    ? {tag:"Variables", value:{values:result[0][0].map(function _element(ArrayItem3: $any) { return ArrayItem3.tag===0
    ? {tag:"FragmentRef", value:ArrayItem3[0]}
    : {tag:"Prop", value:[ArrayItem3.slice()[0], {nullable:ArrayItem3.slice()[1][0], propType:ArrayItem3.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem3.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem3.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem3.slice()[1][1][0]]}
    : ArrayItem3.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem3.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem3.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"InputObject", value:[result.slice()[0], {values:result.slice()[1][0].map(function _element(ArrayItem4: $any) { return ArrayItem4.tag===0
    ? {tag:"FragmentRef", value:ArrayItem4[0]}
    : {tag:"Prop", value:[ArrayItem4.slice()[0], {nullable:ArrayItem4.slice()[1][0], propType:ArrayItem4.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem4.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem4.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem4.slice()[1][1][0]]}
    : ArrayItem4.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem4.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem4.slice()[1][1][0]}}]}})}]}
    : {tag:"PluralFragment", value:{values:result[0][0].map(function _element(ArrayItem5: $any) { return ArrayItem5.tag===0
    ? {tag:"FragmentRef", value:ArrayItem5[0]}
    : {tag:"Prop", value:[ArrayItem5.slice()[0], {nullable:ArrayItem5.slice()[1][0], propType:ArrayItem5.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem5.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem5.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem5.slice()[1][1][0]]}
    : ArrayItem5.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem5.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem5.slice()[1][1][0]}}]}})}}
};

export const makePluralFragment: (Types_object_) => Types_rootType = function (Arg1: $any) {
  const result = GeneratorsBS.makePluralFragment([Arg1.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]);
  return result.tag===0
    ? {tag:"Operation", value:{values:result[0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:[ArrayItem1.slice()[0], {nullable:ArrayItem1.slice()[1][0], propType:ArrayItem1.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem1.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem1.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem1.slice()[1][1][0]]}
    : ArrayItem1.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem1.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem1.slice()[1][1][0]}}]}})}}
    : result.tag===1
    ? {tag:"Fragment", value:{values:result[0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:[ArrayItem2.slice()[0], {nullable:ArrayItem2.slice()[1][0], propType:ArrayItem2.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem2.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem2.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem2.slice()[1][1][0]]}
    : ArrayItem2.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem2.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem2.slice()[1][1][0]}}]}})}}
    : result.tag===2
    ? {tag:"Variables", value:{values:result[0][0].map(function _element(ArrayItem3: $any) { return ArrayItem3.tag===0
    ? {tag:"FragmentRef", value:ArrayItem3[0]}
    : {tag:"Prop", value:[ArrayItem3.slice()[0], {nullable:ArrayItem3.slice()[1][0], propType:ArrayItem3.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem3.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem3.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem3.slice()[1][1][0]]}
    : ArrayItem3.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem3.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem3.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"InputObject", value:[result.slice()[0], {values:result.slice()[1][0].map(function _element(ArrayItem4: $any) { return ArrayItem4.tag===0
    ? {tag:"FragmentRef", value:ArrayItem4[0]}
    : {tag:"Prop", value:[ArrayItem4.slice()[0], {nullable:ArrayItem4.slice()[1][0], propType:ArrayItem4.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem4.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem4.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem4.slice()[1][1][0]]}
    : ArrayItem4.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem4.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem4.slice()[1][1][0]}}]}})}]}
    : {tag:"PluralFragment", value:{values:result[0][0].map(function _element(ArrayItem5: $any) { return ArrayItem5.tag===0
    ? {tag:"FragmentRef", value:ArrayItem5[0]}
    : {tag:"Prop", value:[ArrayItem5.slice()[0], {nullable:ArrayItem5.slice()[1][0], propType:ArrayItem5.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem5.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem5.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem5.slice()[1][1][0]]}
    : ArrayItem5.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem5.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem5.slice()[1][1][0]}}]}})}}
};

export const makeVariables: (Types_object_) => Types_rootType = function (Arg1: $any) {
  const result = GeneratorsBS.makeVariables([Arg1.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]);
  return result.tag===0
    ? {tag:"Operation", value:{values:result[0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:[ArrayItem1.slice()[0], {nullable:ArrayItem1.slice()[1][0], propType:ArrayItem1.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem1.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem1.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem1.slice()[1][1][0]]}
    : ArrayItem1.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem1.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem1.slice()[1][1][0]}}]}})}}
    : result.tag===1
    ? {tag:"Fragment", value:{values:result[0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:[ArrayItem2.slice()[0], {nullable:ArrayItem2.slice()[1][0], propType:ArrayItem2.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem2.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem2.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem2.slice()[1][1][0]]}
    : ArrayItem2.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem2.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem2.slice()[1][1][0]}}]}})}}
    : result.tag===2
    ? {tag:"Variables", value:{values:result[0][0].map(function _element(ArrayItem3: $any) { return ArrayItem3.tag===0
    ? {tag:"FragmentRef", value:ArrayItem3[0]}
    : {tag:"Prop", value:[ArrayItem3.slice()[0], {nullable:ArrayItem3.slice()[1][0], propType:ArrayItem3.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem3.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem3.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem3.slice()[1][1][0]]}
    : ArrayItem3.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem3.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem3.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"InputObject", value:[result.slice()[0], {values:result.slice()[1][0].map(function _element(ArrayItem4: $any) { return ArrayItem4.tag===0
    ? {tag:"FragmentRef", value:ArrayItem4[0]}
    : {tag:"Prop", value:[ArrayItem4.slice()[0], {nullable:ArrayItem4.slice()[1][0], propType:ArrayItem4.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem4.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem4.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem4.slice()[1][1][0]]}
    : ArrayItem4.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem4.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem4.slice()[1][1][0]}}]}})}]}
    : {tag:"PluralFragment", value:{values:result[0][0].map(function _element(ArrayItem5: $any) { return ArrayItem5.tag===0
    ? {tag:"FragmentRef", value:ArrayItem5[0]}
    : {tag:"Prop", value:[ArrayItem5.slice()[0], {nullable:ArrayItem5.slice()[1][0], propType:ArrayItem5.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem5.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem5.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem5.slice()[1][1][0]]}
    : ArrayItem5.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem5.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem5.slice()[1][1][0]}}]}})}}
};

export const makeStandaloneObjectType: (Types_object_) => string = function (Arg1: $any) {
  const result = GeneratorsBS.makeStandaloneObjectType([Arg1.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]);
  return result
};

export const makeInputObject: ({| +name: string, +definition: Types_object_ |}) => Types_rootType = function (Arg1: $any) {
  const result = Curry._2(GeneratorsBS.makeInputObject, Arg1.name, [Arg1.definition.values.map(function _element(ArrayItem: $any) { return ArrayItem.tag==="FragmentRef"
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value])
    : CreateBucklescriptBlock.__(1, [ArrayItem.value[0], [ArrayItem.value[1].nullable, ArrayItem.value[1].propType.tag==="Scalar"
    ? CreateBucklescriptBlock.__(0, [typeof(ArrayItem.value[1].propType.value) === 'object'
    ? CreateBucklescriptBlock.__(0, [ArrayItem.value[1].propType.value.value])
    : $$toRE635221987[ArrayItem.value[1].propType.value]])
    : ArrayItem.value[1].propType.tag==="Enum"
    ? CreateBucklescriptBlock.__(1, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="Object"
    ? CreateBucklescriptBlock.__(2, [[ArrayItem.value[1].propType.value.values]])
    : ArrayItem.value[1].propType.tag==="Array"
    ? CreateBucklescriptBlock.__(3, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="FragmentRefValue"
    ? CreateBucklescriptBlock.__(4, [ArrayItem.value[1].propType.value])
    : ArrayItem.value[1].propType.tag==="TypeReference"
    ? CreateBucklescriptBlock.__(5, [ArrayItem.value[1].propType.value])
    : CreateBucklescriptBlock.__(6, [ArrayItem.value[1].propType.value])]])})]);
  return result.tag===0
    ? {tag:"Operation", value:{values:result[0][0].map(function _element(ArrayItem1: $any) { return ArrayItem1.tag===0
    ? {tag:"FragmentRef", value:ArrayItem1[0]}
    : {tag:"Prop", value:[ArrayItem1.slice()[0], {nullable:ArrayItem1.slice()[1][0], propType:ArrayItem1.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem1.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem1.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem1.slice()[1][1][0]]}
    : ArrayItem1.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem1.slice()[1][1][0]}
    : ArrayItem1.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem1.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem1.slice()[1][1][0]}}]}})}}
    : result.tag===1
    ? {tag:"Fragment", value:{values:result[0][0].map(function _element(ArrayItem2: $any) { return ArrayItem2.tag===0
    ? {tag:"FragmentRef", value:ArrayItem2[0]}
    : {tag:"Prop", value:[ArrayItem2.slice()[0], {nullable:ArrayItem2.slice()[1][0], propType:ArrayItem2.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem2.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem2.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem2.slice()[1][1][0]]}
    : ArrayItem2.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem2.slice()[1][1][0]}
    : ArrayItem2.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem2.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem2.slice()[1][1][0]}}]}})}}
    : result.tag===2
    ? {tag:"Variables", value:{values:result[0][0].map(function _element(ArrayItem3: $any) { return ArrayItem3.tag===0
    ? {tag:"FragmentRef", value:ArrayItem3[0]}
    : {tag:"Prop", value:[ArrayItem3.slice()[0], {nullable:ArrayItem3.slice()[1][0], propType:ArrayItem3.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem3.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem3.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem3.slice()[1][1][0]]}
    : ArrayItem3.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem3.slice()[1][1][0]}
    : ArrayItem3.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem3.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem3.slice()[1][1][0]}}]}})}}
    : result.tag===3
    ? {tag:"InputObject", value:[result.slice()[0], {values:result.slice()[1][0].map(function _element(ArrayItem4: $any) { return ArrayItem4.tag===0
    ? {tag:"FragmentRef", value:ArrayItem4[0]}
    : {tag:"Prop", value:[ArrayItem4.slice()[0], {nullable:ArrayItem4.slice()[1][0], propType:ArrayItem4.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem4.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem4.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem4.slice()[1][1][0]]}
    : ArrayItem4.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem4.slice()[1][1][0]}
    : ArrayItem4.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem4.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem4.slice()[1][1][0]}}]}})}]}
    : {tag:"PluralFragment", value:{values:result[0][0].map(function _element(ArrayItem5: $any) { return ArrayItem5.tag===0
    ? {tag:"FragmentRef", value:ArrayItem5[0]}
    : {tag:"Prop", value:[ArrayItem5.slice()[0], {nullable:ArrayItem5.slice()[1][0], propType:ArrayItem5.slice()[1][1].tag===0
    ? {tag:"Scalar", value:typeof(ArrayItem5.slice()[1][1][0]) === 'object'
    ? {tag:"CustomScalar", value:ArrayItem5.slice()[1][1][0][0]}
    : $$toJS635221987[ArrayItem5.slice()[1][1][0]]}
    : ArrayItem5.slice()[1][1].tag===1
    ? {tag:"Enum", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===2
    ? {tag:"Object", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===3
    ? {tag:"Array", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===4
    ? {tag:"FragmentRefValue", value:ArrayItem5.slice()[1][1][0]}
    : ArrayItem5.slice()[1][1].tag===5
    ? {tag:"TypeReference", value:ArrayItem5.slice()[1][1][0]}
    : {tag:"Union", value:ArrayItem5.slice()[1][1][0]}}]}})}}
};
