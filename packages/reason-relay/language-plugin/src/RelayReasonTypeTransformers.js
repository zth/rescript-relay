/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow strict-local
 * @format
 */

'use strict';

import { getInputTypeName } from './generator/Printer.gen';

const {
  GraphQLEnumType,
  GraphQLInputObjectType,
  GraphQLInterfaceType,
  GraphQLList,
  GraphQLNonNull,
  GraphQLObjectType,
  GraphQLScalarType,
  GraphQLUnionType
} = require('graphql');

import type { GraphQLInputType, GraphQLType } from 'graphql';
import {
  makeObj,
  makeObjProp,
  makePropArray,
  makePropEnum,
  makePropObject,
  makePropScalar,
  makePropUnion,
  makePropValue,
  makeScalarAny,
  makeScalarBoolean,
  makeScalarCustom,
  makeScalarFloat,
  makeScalarInt,
  makeScalarString,
  makeTypeReference
} from './generator/Generators.gen';
import type { propType, propValue, propValues } from './generator/Types.gen';

import type { State } from './RelayReasonGenerator';

function getInputObjectTypeIdentifier(type: GraphQLInputObjectType): string {
  return type.name;
}

function transformScalarType(
  type: GraphQLType,
  state: State,
  objectProps?: Array<propValues>,
  conditional?: boolean,
  parentKey?: string
): propValue {
  if (type instanceof GraphQLNonNull) {
    return makePropValue({
      nullable: !!conditional,
      propType: transformNonNullableScalarType(
        type.ofType,
        state,
        objectProps,
        parentKey
      )
    });
  } else {
    return makePropValue({
      nullable: true,
      propType: transformNonNullableScalarType(
        type,
        state,
        objectProps,
        parentKey
      )
    });
  }
}

function transformNonNullableScalarType(
  type: GraphQLType,
  state: State,
  objectProps,
  parentKey?: string
): propType {
  if (type instanceof GraphQLList) {
    return makePropArray(
      transformScalarType(
        type.ofType,
        state,
        objectProps,
        undefined,
        parentKey
      )
    );
  } else if (
    objectProps &&
    (type instanceof GraphQLObjectType || type instanceof GraphQLInterfaceType)
  ) {
    return makePropObject(makeObj(objectProps));
  } else if (type instanceof GraphQLUnionType && parentKey != null) {
    return makePropUnion(parentKey);
  } else if (type instanceof GraphQLScalarType) {
    return transformGraphQLScalarType(type, state);
  } else if (type instanceof GraphQLEnumType) {
    return transformGraphQLEnumType(type, state);
  } else {
    return makePropScalar(makeScalarAny());
  }
}

function transformGraphQLScalarType(
  type: GraphQLScalarType,
  state: State
): propType {
  const customType = state.customScalars[type.name];
  switch (customType || type.name) {
    case 'ID':
    case 'String':
      return makePropScalar(makeScalarString());
    case 'Float':
      return makePropScalar(makeScalarFloat());
    case 'Int':
      return makePropScalar(makeScalarInt());
    case 'Boolean':
      return makePropScalar(makeScalarBoolean());
    default:
      return customType == null
        ? makePropScalar(makeScalarAny())
        : makePropScalar(makeScalarCustom(customType));
  }
}

function transformGraphQLEnumType(
  type: GraphQLEnumType,
  state: State
): propType {
  state.usedEnums[type.name] = type;
  return makePropEnum(type.name);
}

function transformInputType(
  type: GraphQLInputType,
  state: State
): propValue {
  if (type instanceof GraphQLNonNull) {
    return makePropValue({
      nullable: false,
      propType: transformNonNullableInputType(type.ofType, state)
    });
  } else {
    return makePropValue({
      nullable: true,
      propType: transformNonNullableInputType(type, state)
    });
  }
}

function transformNonNullableInputType(
  type: GraphQLInputType,
  state: State
): propType {
  if (type instanceof GraphQLList) {
    return makePropArray(transformInputType(type.ofType, state));
  } else if (type instanceof GraphQLScalarType) {
    return transformGraphQLScalarType(type, state);
  } else if (type instanceof GraphQLEnumType) {
    return transformGraphQLEnumType(type, state);
  } else if (type instanceof GraphQLInputObjectType) {
    const typeIdentifier = getInputObjectTypeIdentifier(type);
    if (state.generatedInputObjectTypes[typeIdentifier]) {
      return makeTypeReference(getInputTypeName(typeIdentifier));
    }

    state.generatedInputObjectTypes[typeIdentifier] = 'pending';
    const fields = type.getFields();
    const props: Array<propValues> = Object.keys(fields)
      .map(key => fields[key])
      .map(field => {
        return makeObjProp({
          name: field.name,
          propValue: transformInputType(field.type, state)
        });
      });
    state.generatedInputObjectTypes[typeIdentifier] = props;
    return makeTypeReference(getInputTypeName(typeIdentifier));
  } else {
    throw new Error(`Could not convert from GraphQL type ${type.toString()}`);
  }
}

module.exports = {
  transformInputType: transformInputType,
  transformScalarType: transformScalarType
};
