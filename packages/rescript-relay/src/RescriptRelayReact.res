open RescriptRelay

module Context = {
  type t
  type contextShape = {"environment": Environment.t}
  @module("react-relay")
  external context: React.Context.t<option<contextShape>> = "ReactRelayContext"

  module Provider = {
    @react.component
    let make = (~environment: Environment.t, ~children) => {
      let provider = React.Context.provider(context)
      React.createElement(provider, {value: Some({"environment": environment}), children})
    }
  }
}

exception EnvironmentNotFoundInContext

let useEnvironmentFromContext = () => {
  let context = React.useContext(Context.context)
  switch context {
  | Some(ctx) => ctx["environment"]
  | None => throw(EnvironmentNotFoundInContext)
  }
}

type loadQueryConfig = {
  fetchKey: option<string>,
  fetchPolicy: option<fetchPolicy>,
  networkCacheConfig: option<cacheConfig>,
}

@module("react-relay")
external loadQuery: (Environment.t, queryNode<'a>, 'variables, loadQueryConfig) => 'queryResponse =
  "loadQuery"

module type MakeLoadQueryConfig = {
  type variables
  type loadedQueryRef
  type response
  type node
  let query: queryNode<node>
  let convertVariables: variables => variables
}

module MakeLoadQuery = (C: MakeLoadQueryConfig) => {
  let load: (
    ~environment: Environment.t,
    ~variables: C.variables,
    ~fetchPolicy: fetchPolicy=?,
    ~fetchKey: string=?,
    ~networkCacheConfig: cacheConfig=?,
  ) => C.loadedQueryRef = (
    ~environment,
    ~variables,
    ~fetchPolicy=?,
    ~fetchKey=?,
    ~networkCacheConfig=?,
  ) =>
    loadQuery(
      environment,
      C.query,
      variables->C.convertVariables,
      {
        fetchKey,
        fetchPolicy,
        networkCacheConfig,
      },
    )

  type rawPreloadToken<'response> = {source: Nullable.t<Observable.t<'response>>}
  external tokenToRaw: C.loadedQueryRef => rawPreloadToken<C.response> = "%identity"

  let queryRefToObservable = token => {
    let raw = token->tokenToRaw
    raw.source->Nullable.toOption
  }

  let queryRefToPromise = token => {
    Promise.make((resolve, _) => {
      switch token->queryRefToObservable {
      | None => resolve(Error())
      | Some(o) =>
        open Observable
        let _: subscription = o->subscribe(makeObserver(~complete=() => resolve(Ok())))
      }
    })
  }
}

@module("react-relay")
external useSubscribeToInvalidationState: (array<dataId>, unit => unit) => Disposable.t =
  "useSubscribeToInvalidationState"
