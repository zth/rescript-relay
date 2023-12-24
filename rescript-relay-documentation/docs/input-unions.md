---
id: input-unions
title: Input Unions
sidebar_label: Input Unions
---

#### Recommended background reading

- [`@oneOf` input object and fields RFC](https://github.com/graphql/graphql-spec/pull/825)

## Input Unions in RescriptRelay (available in version >=3)

Input unions aren't officially a part of the GraphQL spec yet, but there's a propsal that allows you to express them today via the `@oneOf` directive on an input object. RescriptRelay leverages that proposal to give you an ergonomic developer experience using input unions in GraphQL.

In RescriptRelay, input unions compile to _variants_, just like regular unions do. It looks like this:

```graphql
input Address {
  streetAddress: String!
  postalCode: String!
  city: String!
}

input Coordinates {
  lat: Float!
  lng: Float!
}

input Location @oneOf {
  byAddress: Address
  byCoordinates: Coordinates
  byId: ID
}

type Query {
  allShops(location: Location!): ShopConnection
}
```

This above is an example of searching for shops by a location. That location can be an address, coordinates, or an internal ID for a location. The `@oneOf` directive on `Location` tells us that the server expects _one_ of the fields of the input object to always be set. We call that an _input union_ (even though it's technically not an actual union in the schema, just an input object with a directive).

Below is an example of what using this input union from RescriptRelay looks like:

```rescript
// Shops.res
module Query = %relay(`
  query ShopsQuery($location: Location!) {
    allShops(location: $location) {
      ...ShopsResult_shops
    }
  }
`)

@react.component
let make = (~lat, ~lng) => {
  let data = Query.use(~variables={location: ByCoordinates({lat, lng})})

  ...
}
```

Notice the input union is an actual variant in RescriptRelay. Passing something else to the union is straight forward:

```rescript
@react.component
let make = (~shopLocationId) => {
  let data = Query.use(~variables={location: ById(shopLocationId)})

  ...
}
```

This brings all of the power of variants also to inputs.

## Summary

Here's all you need to remember about input unions in RescriptRelay:

- Input union support is available in RescriptRelay version `>=3`.
- Input unions are defined as input objects with the `@oneOf` directive.
- Input unions are modelled as variants in RescriptRelay.
- There's nothing extra you need to do for input unions to work, they're automatically available on any input object with a `@oneOf` directive.
