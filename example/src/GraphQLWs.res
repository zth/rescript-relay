/**
 * Minimal required binding for graphql-wss
 * Note that those bindings are RescriptRelay-specific, and
 * would need to be adjusted in order to be used for
 * other purposes
 */
module Client = {
  type t
  type errOrCloseEvent

  type clientOptions = {url: string, shouldRetry: errOrCloseEvent => bool}

  @live @obj
  external makeClientOptions: (
    ~url: string,
    ~shouldRetry: errOrCloseEvent => bool=?,
    unit,
  ) => clientOptions = ""

  @module("graphql-ws")
  external make: clientOptions => t = "createClient"

  type subscribeOptions = {
    operationName: string,
    query: string,
    variables: Js.Json.t,
  }

  type unsubscribe = unit => unit

  @send
  external subscribe: (t, subscribeOptions, RescriptRelay.Observable.sink<_>) => unsubscribe =
    "subscribe"
}
