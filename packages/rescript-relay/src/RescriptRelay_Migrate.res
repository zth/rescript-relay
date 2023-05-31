open RescriptRelay

module Mutation = {
  type updaterFn<'response> = (RecordSourceSelectorProxy.t, 'response) => unit
  type optimisticUpdaterFn = RecordSourceSelectorProxy.t => unit
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

  type commitMutationConfigRaw<'m, 'variables, 'response, 'rawResponse> = {
    mutation: mutationNode<'m>,
    variables: 'variables,
    onCompleted?: ('response, Js.Nullable.t<array<mutationError>>) => unit,
    onError?: Js.Nullable.t<mutationError> => unit,
    optimisticResponse?: 'rawResponse,
    optimisticUpdater?: optimisticUpdaterFn,
    updater?: updaterFn<'response>,
    uploadables?: uploadables,
  }

  @module("relay-runtime")
  external commitMutation_: (
    Environment.t,
    commitMutationConfigRaw<'m, 'variables, 'response, 'rawResponse>,
  ) => Disposable.t = "commitMutation"

  let commitMutation = (
    ~convertVariables: 'variables => 'variables,
    ~node: 'm,
    ~convertResponse: 'response => 'response,
    ~convertWrapRawResponse: 'rawResponse => 'rawResponse,
  ) => {
    /**Commits the current mutation. Use this outside of React's \
               render. If you're inside render, you should use `Mutation.use` \
               instead, which is more convenient.\n\n\
               ### Optimistic updates\n\
               Remember to annotate your mutation with `@raw_response_type` if \
               you want to do optimistic updates. That'll make Relay emit the \
               required type information for covering everything needed when \
               doing optimistic updates.*/
    (
      ~environment: Environment.t,
      ~variables: 'variables,
      ~optimisticUpdater=?,
      ~optimisticResponse: option<'rawResponse>=?,
      ~updater=?,
      ~onCompleted=?,
      ~onError=?,
      ~uploadables=?,
      (),
    ) => {
      commitMutation_(
        environment,
        {
          mutation: node,
          onCompleted: ?switch onCompleted {
          | Some(cb) => Some((res, err) => cb(res->convertResponse, err))
          | None => None
          },
          ?onError,
          optimisticResponse: ?switch optimisticResponse {
          | Some(optimisticResponse) => Some(optimisticResponse->convertWrapRawResponse)
          | None => None
          },
          ?optimisticUpdater,
          updater: ?switch updater {
          | Some(updater) => Some((store, response) => updater(store, response->convertResponse))
          | None => None
          },
          ?uploadables,
          variables: variables->convertVariables,
        },
      )
    }
  }
}
