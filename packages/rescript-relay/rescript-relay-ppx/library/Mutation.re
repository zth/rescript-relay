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
      [%stri [@ocaml.warning "-32-34-60"]],
      [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
      [%stri module Operation = [%m moduleIdentFromGeneratedModule([])]],
      [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
      [%stri
        [@live] type updaterFn =
          (
            RescriptRelay.RecordSourceSelectorProxy.t,
            [%t typeFromGeneratedModule(["Types", "response"])]
          ) =>
          unit
      ],
      [%stri
        [@live] type optimisticUpdaterFn =
          RescriptRelay.RecordSourceSelectorProxy.t => unit
      ],
      [%stri
        [@live] type useMutationConfig = {
          onError: option(RescriptRelay.mutationError => unit),
          onCompleted:
            option(
              (
                [%t typeFromGeneratedModule(["Types", "response"])],
                option(array(RescriptRelay.mutationError))
              ) =>
              unit,
            ),
          onUnsubscribe: option(unit => unit),
          optimisticResponse:
            option([%t typeFromGeneratedModule(["Types", "rawResponse"])]),
          optimisticUpdater: option(optimisticUpdaterFn),
          updater: option(updaterFn),
          variables: [%t typeFromGeneratedModule(["Types", "variables"])],
          uploadables: option(RescriptRelay.uploadables),
        }
      ],
      [%stri
        [@live] type useMutationConfigRaw = {
          onError: option(RescriptRelay.mutationError => unit),
          onCompleted:
            option(
              (
                [%t typeFromGeneratedModule(["Types", "response"])],
                Js.Nullable.t(array(RescriptRelay.mutationError))
              ) =>
              unit,
            ),
          onUnsubscribe: option(unit => unit),
          optimisticResponse:
            option([%t typeFromGeneratedModule(["Types", "rawResponse"])]),
          optimisticUpdater: option(optimisticUpdaterFn),
          updater: option(updaterFn),
          variables: [%t typeFromGeneratedModule(["Types", "variables"])],
          uploadables: option(RescriptRelay.uploadables),
        }
      ],
      [%stri
        [@live] type commitMutationConfigRaw = {
          mutation:
            RescriptRelay.mutationNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
          variables: [%t typeFromGeneratedModule(["Types", "variables"])],
          onCompleted:
            option(
              (
                [%t typeFromGeneratedModule(["Types", "response"])],
                Js.Nullable.t(array(RescriptRelay.mutationError))
              ) =>
              unit,
            ),
          onError: option(Js.Nullable.t(RescriptRelay.mutationError) => unit),
          optimisticResponse:
            option([%t typeFromGeneratedModule(["Types", "rawResponse"])]),
          optimisticUpdater: option(optimisticUpdaterFn),
          updater: option(updaterFn),
          uploadables: option(RescriptRelay.uploadables),
        }
      ],
      [%stri
        %private
        [@module "relay-runtime"] [@live]
        external internal_commitMutation:
          (RescriptRelay.Environment.t, commitMutationConfigRaw) =>
          RescriptRelay.Disposable.t =
          "commitMutation"
      ],
      [%stri
        %private
        [@module "react-relay"] [@live]
        external internal_useMutation:
          RescriptRelay.mutationNode(
            [%t typeFromGeneratedModule(["relayOperationNode"])],
          ) =>
          (useMutationConfigRaw => RescriptRelay.Disposable.t, bool) =
          "useMutation"
      ],
      [%stri
        /**Commits the current mutation. Use this outside of React's render. If you're inside render, you should use `Mutation.use` instead, which is more convenient.

### Optimistic updates
Remember to annotate your mutation with `@raw_response_type` if you want to do optimistic updates. That'll make Relay emit the required type information for covering everything needed when doing optimistic updates.*/

        [@live] let commitMutation:
          (
            ~environment: RescriptRelay.Environment.t,
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
            ~optimisticUpdater: optimisticUpdaterFn=?,
            ~optimisticResponse: [%t
                                   typeFromGeneratedModule([
                                     "Types",
                                     "rawResponse",
                                   ])
                                 ]
                                   =?,
            ~updater: (
                        RescriptRelay.RecordSourceSelectorProxy.t,
                        [%t typeFromGeneratedModule(["Types", "response"])]
                      ) =>
                      unit
                        =?,
            ~onCompleted: (
                            [%t
                              typeFromGeneratedModule(["Types", "response"])
                            ],
                            option(array(RescriptRelay.mutationError))
                          ) =>
                          unit
                            =?,
            ~onError: option(RescriptRelay.mutationError) => unit=?,
            ~uploadables: RescriptRelay.uploadables=?,
            unit
          ) =>
          RescriptRelay.Disposable.t =
          (
            ~environment,
            ~variables,
            ~optimisticUpdater=?,
            ~optimisticResponse=?,
            ~updater=?,
            ~onCompleted=?,
            ~onError=?,
            ~uploadables=?,
            (),
          ) => (
            internal_commitMutation(
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
                uploadables,

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
            ): RescriptRelay.Disposable.t
          )
      ],
      [%stri
        /**React hook for commiting this mutation.

### Optimistic updates
Remember to annotate your mutation with `@raw_response_type` if you want to do optimistic updates. That'll make Relay emit the required type information for covering everything needed when doing optimistic updates.*/
        [@live] let use:
          unit =>
          (
            (
              ~onError: RescriptRelay.mutationError => unit=?,
              ~onCompleted: (
                              [%t
                                typeFromGeneratedModule(["Types", "response"])
                              ],
                              option(array(RescriptRelay.mutationError))
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
              ~optimisticUpdater: optimisticUpdaterFn=?,
              ~updater: (
                          RescriptRelay.RecordSourceSelectorProxy.t,
                          [%t typeFromGeneratedModule(["Types", "response"])]
                        ) =>
                        unit
                          =?,
              ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
              ~uploadables: RescriptRelay.uploadables=?,
              unit
            ) =>
            RescriptRelay.Disposable.t,
            bool,
          ) =
          () => {
            let (mutate, mutating) =
              internal_useMutation([%e valFromGeneratedModule(["node"])]);
            (
              React.useMemo1(() => (
                ~onError=?,
                ~onCompleted=?,
                ~onUnsubscribe=?,
                ~optimisticResponse=?,
                ~optimisticUpdater=?,
                ~updater=?,
                ~variables,
                ~uploadables=?,
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
                  uploadables,
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
                }), [|mutate|]),
              mutating,
            );
          }
      ],
    ]),
  );
};
