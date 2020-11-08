open Ppxlib;
open Util;

/**
 * Check out the comments for makeFragment, this does the same thing but for mutations.
 */
let make = (~loc, ~moduleName) => {
  let typeFromGeneratedModule = makeTypeAccessor(~loc, ~moduleName);
  let valFromGeneratedModule = makeExprAccessor(~loc, ~moduleName);
  let moduleIdentFromGeneratedModule = makeModuleIdent(~loc, ~moduleName);

  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
      [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
      [%stri
        module Internal = {
          type updaterFn =
            (
              ReasonRelay.RecordSourceSelectorProxy.t,
              [%t typeFromGeneratedModule(["Types", "response"])]
            ) =>
            unit;
          type optimisticUpdaterFn =
            ReasonRelay.RecordSourceSelectorProxy.t => unit;

          type useMutationConfig = {
            onError: option(ReasonRelay.mutationError => unit),
            onCompleted:
              option(
                (
                  [%t typeFromGeneratedModule(["Types", "response"])],
                  option(array(ReasonRelay.mutationError))
                ) =>
                unit,
              ),
            onUnsubscribe: option(unit => unit),
            optimisticResponse:
              option([%t typeFromGeneratedModule(["Types", "rawResponse"])]),
            optimisticUpdater: option(optimisticUpdaterFn),
            updater: option(updaterFn),
            variables: [%t typeFromGeneratedModule(["Types", "variables"])],
          };

          type useMutationConfigRaw = {
            onError: option(ReasonRelay.mutationError => unit),
            onCompleted:
              option(
                (
                  [%t typeFromGeneratedModule(["Types", "response"])],
                  Js.Nullable.t(array(ReasonRelay.mutationError))
                ) =>
                unit,
              ),
            onUnsubscribe: option(unit => unit),
            optimisticResponse:
              option([%t typeFromGeneratedModule(["Types", "rawResponse"])]),
            optimisticUpdater: option(optimisticUpdaterFn),
            updater: option(updaterFn),
            variables: [%t typeFromGeneratedModule(["Types", "variables"])],
          };

          type commitMutationConfigRaw = {
            mutation:
              ReasonRelay.mutationNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
            variables: [%t typeFromGeneratedModule(["Types", "variables"])],
            onCompleted:
              option(
                (
                  [%t typeFromGeneratedModule(["Types", "response"])],
                  Js.Nullable.t(array(ReasonRelay.mutationError))
                ) =>
                unit,
              ),
            onError:
              option(Js.Nullable.t(ReasonRelay.mutationError) => unit),
            optimisticResponse:
              option([%t typeFromGeneratedModule(["Types", "rawResponse"])]),
            optimisticUpdater: option(optimisticUpdaterFn),
            updater: option(updaterFn),
          };

          [@bs.module "relay-runtime"]
          external internal_commitMutation:
            (ReasonRelay.Environment.t, commitMutationConfigRaw) =>
            ReasonRelay.Disposable.t =
            "commitMutation";

          [@bs.module "react-relay/lib/relay-experimental"]
          external internal_useMutation:
            ReasonRelay.mutationNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ) =>
            (useMutationConfigRaw => ReasonRelay.Disposable.t, bool) =
            "useMutation";
        }
      ],
      [%stri
        let commitMutation:
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
            ~optimisticUpdater: Internal.optimisticUpdaterFn=?,
            ~optimisticResponse: [%t
                                   typeFromGeneratedModule([
                                     "Types",
                                     "rawResponse",
                                   ])
                                 ]
                                   =?,
            ~updater: (
                        ReasonRelay.RecordSourceSelectorProxy.t,
                        [%t typeFromGeneratedModule(["Types", "response"])]
                      ) =>
                      unit
                        =?,
            ~onCompleted: (
                            [%t
                              typeFromGeneratedModule(["Types", "response"])
                            ],
                            option(array(ReasonRelay.mutationError))
                          ) =>
                          unit
                            =?,
            ~onError: option(ReasonRelay.mutationError) => unit=?,
            unit
          ) =>
          ReasonRelay.Disposable.t =
          (
            ~environment,
            ~variables,
            ~optimisticUpdater=?,
            ~optimisticResponse=?,
            ~updater=?,
            ~onCompleted=?,
            ~onError=?,
            (),
          ) => (
            Internal.internal_commitMutation(
              environment,
              {
                variables:
                  variables->[%e
                               valFromGeneratedModule([
                                 "Internal",
                                 "convertVariables",
                               ])
                             ],

                mutation: [%e valFromGeneratedModule(["node"])],
                onCompleted:
                  Some(
                    (res, err) =>
                      switch (onCompleted) {
                      | Some(cb) =>
                        cb(
                          res->[%e
                                 valFromGeneratedModule([
                                   "Internal",
                                   "convertResponse",
                                 ])
                               ],
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
                    Some(
                      r->[%e
                           valFromGeneratedModule([
                             "Internal",
                             "convertWrapRawResponse",
                           ])
                         ],
                    )
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
                          r->[%e
                               valFromGeneratedModule([
                                 "Internal",
                                 "convertResponse",
                               ])
                             ],
                        ),
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
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
            ~optimisticUpdater: Internal.optimisticUpdaterFn=?,
            ~optimisticResponse: [%t
                                   typeFromGeneratedModule([
                                     "Types",
                                     "rawResponse",
                                   ])
                                 ]
                                   =?,
            ~updater: (
                        ReasonRelay.RecordSourceSelectorProxy.t,
                        [%t typeFromGeneratedModule(["Types", "response"])]
                      ) =>
                      unit
                        =?,
            unit
          ) =>
          Promise.t(
            Belt.Result.t(
              (
                [%t typeFromGeneratedModule(["Types", "response"])],
                option(array(ReasonRelay.mutationError)),
              ),
              option(ReasonRelay.mutationError),
            ),
          ) =
          (
            ~environment,
            ~variables,
            ~optimisticUpdater=?,
            ~optimisticResponse=?,
            ~updater=?,
            (),
          ) => (
            {
              let (promise, resolve) = Promise.pending();

              let _: ReasonRelay.Disposable.t =
                Internal.internal_commitMutation(
                  environment,
                  {
                    variables:
                      variables->[%e
                                   valFromGeneratedModule([
                                     "Internal",
                                     "convertVariables",
                                   ])
                                 ],

                    mutation: [%e valFromGeneratedModule(["node"])],
                    onCompleted:
                      Some(
                        (res, err) =>
                          resolve(
                            Ok((
                              res->[%e
                                     valFromGeneratedModule([
                                       "Internal",
                                       "convertResponse",
                                     ])
                                   ],
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
                        Some(
                          r->[%e
                               valFromGeneratedModule([
                                 "Internal",
                                 "convertWrapRawResponse",
                               ])
                             ],
                        )
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
                              r->[%e
                                   valFromGeneratedModule([
                                     "Internal",
                                     "convertResponse",
                                   ])
                                 ],
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
                    [%t typeFromGeneratedModule(["Types", "response"])],
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
                              [%t
                                typeFromGeneratedModule(["Types", "response"])
                              ],
                              option(array(ReasonRelay.mutationError))
                            ) =>
                            unit
                              =?,
              ~onUnsubscribe: unit => unit=?,
              ~optimisticResponse: [%t
                                     typeFromGeneratedModule([
                                       "Types",
                                       "rawResponse",
                                     ])
                                   ]
                                     =?,
              ~optimisticUpdater: Internal.optimisticUpdaterFn=?,
              ~updater: (
                          ReasonRelay.RecordSourceSelectorProxy.t,
                          [%t typeFromGeneratedModule(["Types", "response"])]
                        ) =>
                        unit
                          =?,
              ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
              unit
            ) =>
            ReasonRelay.Disposable.t,
            bool,
          ) =
          () => {
            let (mutate, mutating) =
              Internal.internal_useMutation(
                [%e valFromGeneratedModule(["node"])],
              );
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
                            r->[%e
                                 valFromGeneratedModule([
                                   "Internal",
                                   "convertResponse",
                                 ])
                               ],
                            Js.Nullable.toOption(errors),
                          ),
                      )

                    | None => None
                    },
                  optimisticResponse:
                    switch (optimisticResponse) {
                    | None => None
                    | Some(r) =>
                      Some(
                        r->[%e
                             valFromGeneratedModule([
                               "Internal",
                               "convertWrapRawResponse",
                             ])
                           ],
                      )
                    },
                  onUnsubscribe,
                  variables:
                    variables->[%e
                                 valFromGeneratedModule([
                                   "Internal",
                                   "convertVariables",
                                 ])
                               ],

                  optimisticUpdater,
                  updater:
                    switch (updater) {
                    | None => None
                    | Some(updater) =>
                      Some(
                        (store, r) =>
                          updater(
                            store,
                            r->[%e
                                 valFromGeneratedModule([
                                   "Internal",
                                   "convertResponse",
                                 ])
                               ],
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
};
