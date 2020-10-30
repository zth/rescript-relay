open Ppxlib;
open Util;

/**
 * Check out the comments for makeFragment, this does the same thing but for mutations.
 */
let make = (~loc, ~moduleName) =>
  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri module Operation = [%m makeModuleNameAst(~loc, ~moduleName)]],
      [%stri include Operation.Utils],
      [%stri module Types = Operation.Types],
      [%stri
        let commitMutation:
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
            ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
            ~optimisticResponse: Types.rawResponse=?,
            ~updater: (
                        ReasonRelay.RecordSourceSelectorProxy.t,
                        Types.response
                      ) =>
                      unit
                        =?,
            ~onCompleted: (
                            Types.response,
                            option(array(ReasonRelay.mutationError))
                          ) =>
                          unit
                            =?,
            ~onError: option(ReasonRelay.mutationError) => unit=?,
            unit
          ) =>
          ReasonRelay.Disposable.t =
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
            ~optimisticUpdater=?,
            ~optimisticResponse=?,
            ~updater=?,
            ~onCompleted=?,
            ~onError=?,
            (),
          ) => (
            ReasonRelay.internal_commitMutation(
              environment,
              {
                variables:
                  variables
                  ->Operation.Internal.convertVariables
                  ->ReasonRelay.internal_cleanVariablesRaw,
                mutation: Operation.node,
                onCompleted:
                  Some(
                    (res, err) =>
                      switch (onCompleted) {
                      | Some(cb) =>
                        cb(
                          res->Operation.Internal.convertResponse,
                          Js.Nullable.toOption(err),
                        )
                      | None => ()
                      },
                  ),
                onError:
                  Some(
                    err =>
                      switch (onError) {
                      | Some(cb) => cb(Js.Nullable.toOption(err))
                      | None => ()
                      },
                  ),
                optimisticResponse:
                  switch (optimisticResponse) {
                  | None => None
                  | Some(r) =>
                    Some(r->Operation.Internal.convertWrapRawResponse)
                  },
                optimisticUpdater,
                updater:
                  switch (updater) {
                  | None => None
                  | Some(updater) =>
                    Some(
                      (store, r) =>
                        updater(store, r->Operation.Internal.convertResponse),
                    )
                  },
              },
            ): ReasonRelay.Disposable.t
          )
      ],
      [%stri
        let commitMutationPromised:
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
            ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
            ~optimisticResponse: Types.rawResponse=?,
            ~updater: (
                        ReasonRelay.RecordSourceSelectorProxy.t,
                        Types.response
                      ) =>
                      unit
                        =?,
            unit
          ) =>
          Promise.t(
            Belt.Result.t(
              (Types.response, option(array(ReasonRelay.mutationError))),
              option(ReasonRelay.mutationError),
            ),
          ) =
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
            ~optimisticUpdater=?,
            ~optimisticResponse=?,
            ~updater=?,
            (),
          ) => (
            {
              let (promise, resolve) = Promise.pending();

              let _: ReasonRelay.Disposable.t =
                ReasonRelay.internal_commitMutation(
                  environment,
                  {
                    variables:
                      variables
                      ->Operation.Internal.convertVariables
                      ->ReasonRelay.internal_cleanVariablesRaw,
                    mutation: Operation.node,
                    onCompleted:
                      Some(
                        (res, err) =>
                          resolve(
                            Ok((
                              res->Operation.Internal.convertResponse,
                              Js.Nullable.toOption(err),
                            )),
                          ),
                      ),
                    onError:
                      Some(
                        err => resolve(Error(Js.Nullable.toOption(err))),
                      ),
                    optimisticResponse:
                      switch (optimisticResponse) {
                      | None => None
                      | Some(r) =>
                        Some(r->Operation.Internal.convertWrapRawResponse)
                      },
                    optimisticUpdater,
                    updater:
                      switch (updater) {
                      | None => None
                      | Some(updater) =>
                        Some(
                          (store, r) =>
                            updater(
                              store,
                              r->Operation.Internal.convertResponse,
                            ),
                        )
                      },
                  },
                );

              promise;
            }:
              Promise.t(
                Belt.Result.t(
                  (
                    Types.response,
                    option(array(ReasonRelay.mutationError)),
                  ),
                  option(ReasonRelay.mutationError),
                ),
              )
          )
      ],
      [%stri
        let use:
          unit =>
          (
            (
              ~onError: ReasonRelay.mutationError => unit=?,
              ~onCompleted: (
                              Types.response,
                              option(array(ReasonRelay.mutationError))
                            ) =>
                            unit
                              =?,
              ~onUnsubscribe: unit => unit=?,
              ~optimisticResponse: Types.rawResponse=?,
              ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
              ~updater: (
                          ReasonRelay.RecordSourceSelectorProxy.t,
                          Types.response
                        ) =>
                        unit
                          =?,
              ~variables: Types.variables,
              unit
            ) =>
            ReasonRelay.Disposable.t,
            bool,
          ) =
          () => {
            let (mutate, mutating) =
              ReasonRelay.internal_useMutation(Operation.node);
            (
              (
                ~onError=?,
                ~onCompleted=?,
                ~onUnsubscribe=?,
                ~optimisticResponse=?,
                ~optimisticUpdater=?,
                ~updater=?,
                ~variables,
                (),
              ) =>
                mutate({
                  onError,
                  onCompleted:
                    switch (onCompleted) {
                    | Some(fn) =>
                      Some(
                        (r, errors) =>
                          fn(
                            r->Operation.Internal.convertResponse,
                            Js.Nullable.toOption(errors),
                          ),
                      )

                    | None => None
                    },
                  optimisticResponse:
                    switch (optimisticResponse) {
                    | None => None
                    | Some(r) =>
                      Some(r->Operation.Internal.convertWrapRawResponse)
                    },
                  onUnsubscribe,
                  variables:
                    variables
                    ->Operation.Internal.convertVariables
                    ->ReasonRelay.internal_cleanVariablesRaw,
                  optimisticUpdater,
                  updater:
                    switch (updater) {
                    | None => None
                    | Some(updater) =>
                      Some(
                        (store, r) =>
                          updater(
                            store,
                            r->Operation.Internal.convertResponse,
                          ),
                      )
                    },
                }),
              mutating,
            );
          }
      ],
    ]),
  );
