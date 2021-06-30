let doStuffWithString = s => {
  Js.log(s)
  s.pageInfo->Belt.Option.getWithDefault("") ++ "hej"
}
