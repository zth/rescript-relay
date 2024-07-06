exception Graphql_error(string)

let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = async (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  let resp = await fetch(
    "http://graphql/",
    {
      method: #POST,
      body: {"query": operation.text, "id": operation.id, "variables": variables}
      ->Js.Json.stringifyAny
      ->Belt.Option.getExn
      ->Body.string,
      headers: Headers.fromObject({
        "content-type": "application/json",
        "accept": "application/json",
      }),
    },
  )

  if Response.ok(resp) {
    let json = await Response.json(resp)
    RescriptRelay.Network.preloadResources(operation, json)
    json
  } else {
    raise(Graphql_error("Request failed: " ++ Response.statusText(resp)))
  }
}
