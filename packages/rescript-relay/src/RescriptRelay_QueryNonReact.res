/* React-free Query runtime: fetch, fetchPromised, retain, commitLocalPayload */

type subscription
type observable<'a>
type operationDescriptor

type queryNode<'node>

@module("relay-runtime")
external fetchQuery: (
  RescriptRelay.Environment.t,
  queryNode<'node>,
  'variables,
  option<RescriptRelay.fetchQueryOptions>,
) => observable<'response> = "fetchQuery"

@module("relay-runtime")
external createOperationDescriptor: (queryNode<'node>, 'variables) => operationDescriptor =
  "createOperationDescriptor"

/* moved type decls above */

@obj
external makeObserver: (
  ~next: 'a => unit=?,
  ~error: JsExn.t => unit=?,
  ~complete: unit => unit=?,
) => 'obs = ""

@send
external subscribe: (observable<'a>, 'obs) => subscription = "subscribe"

@send
external toPromise: observable<'a> => promise<'a> = "toPromise"

external ignoreSubscription: subscription => unit = "%ignore"

let fetch = (
  ~node,
  ~convertResponse: 'response => 'response,
  ~convertVariables: 'variables => 'variables,
) => {
  (
    ~environment: RescriptRelay.Environment.t,
    ~variables: 'variables,
    ~onResult,
    ~networkCacheConfig=?,
    ~fetchPolicy=?,
  ) => {
    fetchQuery(
      environment,
      node,
      variables->convertVariables,
      Some({?networkCacheConfig, ?fetchPolicy}),
    )
    ->subscribe(
      makeObserver(
        ~next=res => onResult(Ok(res->convertResponse)),
        ~error=err => onResult(Error(err)),
      ),
    )
    ->ignoreSubscription
  }
}

let fetchPromised = (
  ~node,
  ~convertResponse: 'response => 'response,
  ~convertVariables: 'variables => 'variables,
) => {
  (~environment: RescriptRelay.Environment.t, ~variables: 'variables, ~networkCacheConfig=?, ~fetchPolicy=?) =>
    fetchQuery(
      environment,
      node,
      variables->convertVariables,
      Some({?networkCacheConfig, ?fetchPolicy}),
    )
    ->toPromise
    ->Promise.then(res => res->convertResponse->Promise.resolve)
}

@send external retain_: (RescriptRelay.Environment.t, operationDescriptor) => RescriptRelay.Disposable.t = "retain"
@send
external commitPayload: (RescriptRelay.Environment.t, operationDescriptor, 'payload) => unit =
  "commitPayload"

let retain = (~node, ~convertVariables: 'variables => 'variables) => {
  (~environment: RescriptRelay.Environment.t, ~variables: 'variables) =>
    environment->retain_(createOperationDescriptor(node, variables->convertVariables))
}

let commitLocalPayload = (
  ~node,
  ~convertVariables: 'variables => 'variables,
  ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
) =>
  (~environment: RescriptRelay.Environment.t, ~variables: 'variables, ~payload: 'rawResponse) =>
    environment->commitPayload(
      createOperationDescriptor(node, variables->convertVariables),
      payload->convertWrapRawResponse,
    )
