module Mutation = %relay(`
  mutation TestObjectScalarMutation($input: SerializeMultipleCustomScalars!) {
    serializeMultipleCustomScalars(input: $input)
  }
`)
