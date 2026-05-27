let createMockEnvironment: unit => RescriptRelay.Environment.t

let queuePendingOperation: (
  ~environment: RescriptRelay.Environment.t,
  ~node: RescriptRelay.queryNode<'node>,
  ~variables: 'variables,
) => unit

let resolveMostRecentOperation: (
  ~environment: RescriptRelay.Environment.t,
  ~payload: 'rawResponse,
) => unit
