module Bool = {
  let get = () => true
}

module InputC = {
  let get = (): RelaySchemaAssets_graphql.input_InputC => {
    intStr: 123,
    recursiveC: {intStr: 234},
  }
}

module InputCArr = {
  let get = (): option<array<RelaySchemaAssets_graphql.input_InputC>> => Some([{intStr: 123}])
}

module IntStr = {
  let get = () => 456
}
