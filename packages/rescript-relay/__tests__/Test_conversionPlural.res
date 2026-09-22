module Query = %relay(`
  query TestConversionPluralQuery {
    users {
      edges {
        node {
          id
          ...TestConversionPlural_user
          ...TestConversionPluralCatch_user
            ...TestConversionPluralNullable_user
            ...TestConversionPluralNode_node
        }
      }
    }
    members(groupId: "group") {
      edges {
        node {
          ...TestConversionPluralUnion_member
          ...TestConversionPluralNode_node
        }
      }
    }
  }
`)

module Fragment = %relay(`
  fragment TestConversionPlural_user on User @relay(plural: true) {
    id
    createdAt
  }
`)

module CatchFragment = %relay(`
  fragment TestConversionPluralCatch_user on User @relay(plural: true) @catch {
    firstName @required(action: THROW)
    id
    createdAt
  }
`)

// Compile-time check of the plural result wrapper and its converted scalar type.
let caughtDates = (values: TestConversionPluralCatch_user_graphql.Types.fragment) =>
  values->Array.map(value =>
    switch value {
    | Ok({value}) => Some(value.createdAt->Date.toISOString)
    | Error(_) => None
    }
  )

module NullableFragment = %relay(`
  fragment TestConversionPluralNullable_user on User @relay(plural: true) @catch {
    firstName @required(action: NONE)
    createdAt
  }
`)

module UnionFragment = %relay(`
  fragment TestConversionPluralUnion_member on Member @relay(plural: true) @catch {
    ... on User {
      firstName @required(action: THROW)
      createdAt
    }
    ... on Group {
      name
    }
  }
`)

module NodeFragment = %relay(`
  fragment TestConversionPluralNode_node on Node @relay(plural: true) @catch {
    ... on User {
      createdAt
    }
    ... on Group {
      name
    }
  }
`)

let nullableDates = (values: TestConversionPluralNullable_user_graphql.Types.fragment) =>
  values->Array.map(value =>
    switch value {
    | Ok({value: Some({createdAt})}) => Some(createdAt->Date.toISOString)
    | _ => None
    }
  )

let unionValues = (values: TestConversionPluralUnion_member_graphql.Types.fragment) =>
  values->Array.map(value =>
    switch value {
    | Ok({value: User({createdAt})}) => Some(createdAt->Date.toISOString)
    | Ok({value: Group({name})}) => Some(name)
    | _ => None
    }
  )

let nodeValues = (values: TestConversionPluralNode_node_graphql.Types.fragment) =>
  values->Array.map(value =>
    switch value {
    | Ok({value: User({createdAt})}) => Some(createdAt->Date.toISOString)
    | Ok({value: Group({name})}) => Some(name)
    | _ => None
    }
  )
