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
  let get = () => Some([({intStr: 123}: RelaySchemaAssets_graphql.input_InputC)])
}

module IntStr = {
  let get = () => 456
}

module IntStrArr = {
  let get = () => [456]
}
