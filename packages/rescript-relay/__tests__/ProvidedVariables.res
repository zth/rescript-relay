module Bool = {
  let get = () => true
}

module InputC = {
  open RelaySchemaAssets_graphql
  let get = () => make_InputC(~intStr=123, ~recursiveC=make_InputC(~intStr=234, ()), ())
}

module InputCArr = {
  open RelaySchemaAssets_graphql
  let get = () => Some([make_InputC(~intStr=123, ())])
}

module IntStr = {
  let get = () => 456
}
