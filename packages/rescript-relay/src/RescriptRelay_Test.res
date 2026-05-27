@module("relay-test-utils")
external createMockEnvironment: unit => RescriptRelay.Environment.t = "createMockEnvironment"

let queuePendingOperation = (
  ~environment: RescriptRelay.Environment.t,
  ~node: RescriptRelay.queryNode<'node>,
  ~variables: 'variables,
) => {
  ignore(environment)
  ignore(node)
  ignore(variables)
  ignore(%raw(`environment.mock.queuePendingOperation(node, variables)`))
}

let resolveMostRecentOperation = (
  ~environment: RescriptRelay.Environment.t,
  ~payload: 'rawResponse,
) => {
  ignore(environment)
  ignore(payload)
  ignore(%raw(`environment.mock.resolveMostRecentOperation({data: payload})`))
}
