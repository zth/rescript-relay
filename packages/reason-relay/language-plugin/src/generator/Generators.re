open Types;

[@genType]
let makeScalarInt = () => Int;

[@genType]
let makeScalarString = () => String;

[@genType]
let makeScalarFloat = () => Float;

[@genType]
let makeScalarBoolean = () => Boolean;

[@genType]
let makeScalarCustom = identifier => CustomScalar(identifier);

[@genType]
let makeScalarAny = () => Any;

[@genType]
let makePropScalar = scalarValue => Scalar(scalarValue);

[@genType]
let makePropEnum = name => Enum(name);

[@genType]
let makePropUnion = name => Union(name);

[@genType]
let makePropObject = obj => Object(obj);

[@genType]
let makePropArray = propValue => Array(propValue);

[@genType]
let makeFragmentRefValue = name => FragmentRefValue(name);

[@genType]
let makePropValue = (~nullable, ~propType, ()) => {nullable, propType};

[@genType]
let makeFragmentRefProp = name => FragmentRef(name);

[@genType]
let makeObjProp = (~name, ~propValue, ()) => Prop(name, propValue);

[@genType]
let makeTypeReference = typeName => TypeReference(typeName);

[@genType]
let makeObj = propValues => {values: propValues};

[@genType]
let makeOperation = definition => Operation(definition);

[@genType]
let makeFragment = definition => Fragment(definition);

[@genType]
let makePluralFragment = definition => PluralFragment(definition);

[@genType]
let makeVariables = definition => Variables(definition);

[@genType]
let makeStandaloneObjectType = definition =>
  Printer.printObject(~obj=definition, ~optType=JsNullable);

[@genType]
let makeInputObject = (~name, ~definition) => InputObject(name, definition);