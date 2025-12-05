/* React-free Mutation runtime: commitMutation only */

type mutationNode<'node>

@obj
external makeConfig: (
  ~mutation: mutationNode<'node>,
  ~variables: 'variables,
  ~onCompleted: ('response, option<JSON.t>) => unit=?,
  ~onError: JsExn.t => unit=?,
  ~optimisticResponse: 'rawResponse=?,
  ~optimisticUpdater: (RescriptRelay.RecordSourceSelectorProxy.t => unit)=?,
  ~updater: ((RescriptRelay.RecordSourceSelectorProxy.t, 'response) => unit)=?,
  ~uploadables: RescriptRelay.uploadables=?,
  unit,
) => 'config = ""

@module("relay-runtime")
external commitMutation: (RescriptRelay.Environment.t, 'config) => unit = "commitMutation"

let commitMutation = (
  ~convertVariables: 'variables => 'variables,
  ~node: 'm,
  ~convertResponse: 'response => 'response,
  ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
) =>
  (
    ~environment: RescriptRelay.Environment.t,
    ~variables: 'variables,
    ~optimisticUpdater=?,
    ~optimisticResponse: option<'rawResponse>=?,
    ~updater: option<(RescriptRelay.RecordSourceSelectorProxy.t, 'response) => unit>=?,
    ~onCompleted: option<('response, option<JSON.t>) => unit>=?,
    ~onError: option<JsExn.t => unit>=?,
    ~uploadables: option<RescriptRelay.uploadables>=?,
  ) =>
    commitMutation(
      environment,
      makeConfig(
        ~mutation=node,
        ~variables=variables->convertVariables,
        ~onCompleted=?switch onCompleted {
          | Some(f) => Some((res, err) => f(res->convertResponse, err))
          | None => None
        },
        ~onError=?onError,
        ~optimisticResponse=?optimisticResponse->Option.map(convertWrapRawResponse),
        ~optimisticUpdater=?optimisticUpdater,
        ~updater=?updater->Option.map(u => (store, response) => u(store, response->convertResponse)),
        ~uploadables=?uploadables,
        (),
      ),
    )
