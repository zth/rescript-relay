module Query = %relay(`
  query TestConversionPluralQuery {
    users {
      edges {
        node {
          id
          ...TestConversionPlural_user
          ...TestConversionPluralCatch_user
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
