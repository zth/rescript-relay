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
        let commitMutation:
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
            ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
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
            ~environment: ReasonRelay.Environment.t,
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
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
                  ->[%e
                      valFromGeneratedModule(["Internal", "convertVariables"])
                    ]
                  ->ReasonRelay.internal_cleanVariablesRaw,
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
            ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
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
            ~environment: ReasonRelay.Environment.t,
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
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
                      ->[%e
                          valFromGeneratedModule([
                            "Internal",
                            "convertVariables",
                          ])
                        ]
                      ->ReasonRelay.internal_cleanVariablesRaw,
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
              ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
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
              ReasonRelay.internal_useMutation(
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
                    variables
                    ->[%e
                        valFromGeneratedModule([
                          "Internal",
                          "convertVariables",
                        ])
                      ]
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
