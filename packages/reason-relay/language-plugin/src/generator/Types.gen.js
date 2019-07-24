/** 
 * @flow strict
 * @generated
 * @nolint
 */
/* eslint-disable */

export type scalarValues = 
  | "Int"
  | "String"
  | "Float"
  | "Boolean"
  | "Any"
  | {| tag: "CustomScalar", value: string |};

export type propType = 
  | {| tag: "Scalar", value: scalarValues |}
  | {| tag: "Enum", value: string |}
  | {| tag: "Object", value: object_ |}
  | {| tag: "Array", value: propValue |}
  | {| tag: "FragmentRefValue", value: string |}
  | {| tag: "TypeReference", value: string |}
  | {| tag: "Union", value: string |};

export type propValue = {| +nullable: boolean, +propType: propType |};

export type propValues = 
  | {| tag: "FragmentRef", value: string |}
  | {| tag: "Prop", value: [string, propValue] |};

export type object_ = {| +values: Array<propValues> |};

export type rootType = 
  | {| tag: "Operation", value: object_ |}
  | {| tag: "Fragment", value: object_ |}
  | {| tag: "Variables", value: object_ |}
  | {| tag: "InputObject", value: [string, object_] |}
  | {| tag: "PluralFragment", value: object_ |};

export type fullEnum = {| +name: string, +values: Array<string> |};
