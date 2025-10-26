open RescriptRelay

let useQuery: (
  ~convertVariables: 'variables => 'variables,
  ~node: queryNode<'a>,
  ~convertResponse: 'response => 'response,
) => (
  ~variables: 'variables,
  ~fetchPolicy: fetchPolicy=?,
  ~fetchKey: string=?,
  ~networkCacheConfig: cacheConfig=?,
) => 'response

let useLoader: (
  ~convertVariables: 'variables => 'variables,
  ~node: queryNode<'a>,
  ~mkQueryRef: option<'queryRef> => option<'queryRef>,
) => unit => (
  option<'queryRef>,
  (~variables: 'variables, ~fetchPolicy: fetchPolicy=?, ~networkCacheConfig: cacheConfig=?) => unit,
  unit => unit,
)

let usePreloaded: (
  ~node: queryNode<'a>,
  ~convertResponse: 'response => 'response,
  ~mkQueryRef: 'queryRef => 'queryRef,
) => (~queryRef: 'queryRef) => 'response

let fetch: (
  ~node: queryNode<'a>,
  ~convertResponse: 'response => 'response,
  ~convertVariables: 'variables => 'variables,
) => (
  ~environment: Environment.t,
  ~variables: 'variables,
  ~onResult: result<'response, JsExn.t> => unit,
  ~networkCacheConfig: cacheConfig=?,
  ~fetchPolicy: fetchPolicy=?,
) => unit

let fetchPromised: (
  ~node: queryNode<'a>,
  ~convertResponse: 'response => 'response,
  ~convertVariables: 'variables => 'variables,
) => (
  ~environment: Environment.t,
  ~variables: 'variables,
  ~networkCacheConfig: cacheConfig=?,
  ~fetchPolicy: fetchPolicy=?,
) => promise<'response>

let retain: (
  ~node: queryNode<'a>,
  ~convertVariables: 'variables => 'variables,
) => (~environment: Environment.t, ~variables: 'variables) => Disposable.t

let commitLocalPayload: (
  ~node: queryNode<'a>,
  ~convertVariables: 'variables => 'variables,
  ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
) => (~environment: Environment.t, ~variables: 'variables, ~payload: 'rawResponse) => unit
