/*** Internal file, do not use directly.*/

open RescriptRelay

type updaterFn<'response> = (RecordSourceSelectorProxy.t, 'response) => unit
type optimisticUpdaterFn = RecordSourceSelectorProxy.t => unit

@live
type useMutationConfig<'response, 'rawResponse, 'variables> = {
  onError?: mutationError => unit,
  onCompleted?: ('response, option<array<mutationError>>) => unit,
  onUnsubscribe?: unit => unit,
  optimisticResponse?: 'rawResponse,
  optimisticUpdater?: optimisticUpdaterFn,
  updater?: updaterFn<'response>,
  variables: 'variables,
  uploadables?: uploadables,
}

let commitMutation: (
  ~convertVariables: 'variables => 'variables,
  ~node: mutationNode<'a>,
  ~convertResponse: 'response => 'response,
  ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
) => (
  ~environment: Environment.t,
  ~variables: 'variables,
  ~optimisticUpdater: optimisticUpdaterFn=?,
  ~optimisticResponse: 'rawResponse=?,
  ~updater: (RecordSourceSelectorProxy.t, 'response) => unit=?,
  ~onCompleted: ('response, option<array<mutationError>>) => unit=?,
  ~onError: mutationError => unit=?,
  ~uploadables: uploadables=?,
) => Disposable.t

let useMutation: (
  ~convertVariables: 'variables => 'variables,
  ~node: mutationNode<'node>,
  ~convertResponse: 'response => 'response,
  ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
) => unit => (
  (
    ~variables: 'variables,
    ~optimisticUpdater: optimisticUpdaterFn=?,
    ~optimisticResponse: 'rawResponse=?,
    ~updater: (RecordSourceSelectorProxy.t, 'response) => unit=?,
    ~onCompleted: ('response, option<array<mutationError>>) => unit=?,
    ~onError: mutationError => unit=?,
    ~uploadables: uploadables=?,
  ) => Disposable.t,
  bool,
)
