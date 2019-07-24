[@genType]
type scalarValues =
  | Int
  | String
  | Float
  | Boolean
  | CustomScalar(string)
  | Any
[@genType]
and propType =
  | Scalar(scalarValues)
  | Enum(string)
  | Object(object_)
  | Array(propValue)
  | FragmentRefValue(string)
  | TypeReference(string)
  | Union(string)
[@genType]
and propValue = {
  nullable: bool,
  propType,
}
[@genType]
and propValues =
  | FragmentRef(string)
  | Prop(string, propValue)
[@genType]
and object_ = {values: array(propValues)}
[@genType]
and rootType =
  | Operation(object_)
  | Fragment(object_)
  | Variables(object_)
  | InputObject(string, object_)
  | PluralFragment(object_);

[@genType]
type fullEnum = {
  name: string,
  values: array(string),
};