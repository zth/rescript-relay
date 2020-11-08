open Ppxlib;
open Util;

/**
 * This constructs a module definition AST, in this case for fragments. Note it's only the definition structure,
 * not the full definition.
 */
let make =
    (
      ~loc,
      ~moduleName,
      ~refetchableQueryName,
      ~hasConnection,
      ~hasInlineDirective,
    ) => {
  let typeFromGeneratedModule = makeTypeAccessor(~loc, ~moduleName);
  let valFromGeneratedModule = makeExprAccessor(~loc, ~moduleName);
  let moduleIdentFromGeneratedModule = makeModuleIdent(~loc, ~moduleName);

  Ast_helper.Mod.mk(
    Pmod_structure([
      // The %stri PPX comes from Ppxlib and means "make a structure item AST out of this raw string"
      [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
      [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
      [%stri
        module Internal = {
          [@bs.module "react-relay"]
          external internal_readInlineData:
            (
              ReasonRelay.fragmentNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
              [%t typeFromGeneratedModule(["fragmentRef"])]
            ) =>
            [%t typeFromGeneratedModule(["Types", "fragment"])] =
            "readInlineData";

          [@bs.module "react-relay/hooks"]
          external internal_useFragment:
            (
              ReasonRelay.fragmentNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
              [%t typeFromGeneratedModule(["fragmentRef"])]
            ) =>
            [%t typeFromGeneratedModule(["Types", "fragment"])] =
            "useFragment";

          [@bs.module "react-relay/hooks"]
          external internal_useFragmentOpt:
            (
              ReasonRelay.fragmentNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
              Js.Nullable.t([%t typeFromGeneratedModule(["fragmentRef"])])
            ) =>
            Js.Nullable.t(
              [%t typeFromGeneratedModule(["Types", "fragment"])],
            ) =
            "useFragment";
        }
      ],
      // Internal refetch module
      switch (refetchableQueryName) {
      | None =>
        %stri
        ()
      | Some(queryName) => [%stri
          module InternalRefetch = {
            [@bs.deriving abstract]
            type refetchableFnOpts = {
              [@bs.optional]
              fetchPolicy: string,
              [@bs.optional] [@bs.as "UNSTABLE_renderPolicy"]
              renderPolicy: string,
              [@bs.optional]
              onComplete: Js.Nullable.t(Js.Exn.t) => unit,
            };

            let internal_makeRefetchableFnOpts =
                (~fetchPolicy=?, ~renderPolicy=?, ~onComplete=?, ()) =>
              refetchableFnOpts(
                ~fetchPolicy=?fetchPolicy->ReasonRelay.mapFetchPolicy,
                ~renderPolicy=?renderPolicy->ReasonRelay.mapRenderPolicy,
                ~onComplete=?
                  onComplete->ReasonRelay_Internal.internal_nullableToOptionalExnHandler,
                (),
              );

            type paginationLoadMoreOptions = {
              onComplete: option(Js.nullable(Js.Exn.t) => unit),
            };

            type paginationLoadMoreFn =
              (~count: int, ~onComplete: option(Js.Exn.t) => unit=?, unit) =>
              ReasonRelay.Disposable.t;

            type paginationFragmentReturnRaw = {
              data: [%t typeFromGeneratedModule(["Types", "fragment"])],
              loadNext:
                (. int, paginationLoadMoreOptions) => ReasonRelay.Disposable.t,
              loadPrevious:
                (. int, paginationLoadMoreOptions) => ReasonRelay.Disposable.t,
              hasNext: bool,
              hasPrevious: bool,
              isLoadingNext: bool,
              isLoadingPrevious: bool,
              refetch:
                (
                  . [%t
                      makeTypeAccessor(
                        ~loc,
                        ~moduleName=queryName,
                        ["Types", "refetchVariables"],
                      )
                    ],
                  refetchableFnOpts
                ) =>
                ReasonRelay.Disposable.t,
            };

            type paginationBlockingFragmentReturn = {
              data: [%t typeFromGeneratedModule(["Types", "fragment"])],
              loadNext: paginationLoadMoreFn,
              loadPrevious: paginationLoadMoreFn,
              hasNext: bool,
              hasPrevious: bool,
              refetch:
                (
                  ~variables: [%t
                                makeTypeAccessor(
                                  ~loc,
                                  ~moduleName=queryName,
                                  ["Types", "refetchVariables"],
                                )
                              ],
                  ~fetchPolicy: ReasonRelay.fetchPolicy=?,
                  ~renderPolicy: ReasonRelay.renderPolicy=?,
                  ~onComplete: option(Js.Exn.t) => unit=?,
                  unit
                ) =>
                ReasonRelay.Disposable.t,
            };

            type paginationFragmentReturn = {
              data: [%t typeFromGeneratedModule(["Types", "fragment"])],
              loadNext: paginationLoadMoreFn,
              loadPrevious: paginationLoadMoreFn,
              hasNext: bool,
              hasPrevious: bool,
              isLoadingNext: bool,
              isLoadingPrevious: bool,
              refetch:
                (
                  ~variables: [%t
                                makeTypeAccessor(
                                  ~loc,
                                  ~moduleName=queryName,
                                  ["Types", "refetchVariables"],
                                )
                              ],
                  ~fetchPolicy: ReasonRelay.fetchPolicy=?,
                  ~renderPolicy: ReasonRelay.renderPolicy=?,
                  ~onComplete: option(Js.Exn.t) => unit=?,
                  unit
                ) =>
                ReasonRelay.Disposable.t,
            };

            [@bs.module "react-relay/hooks"]
            external internal_usePaginationFragment:
              (
                ReasonRelay.fragmentNode(
                  [%t typeFromGeneratedModule(["relayOperationNode"])],
                ),
                [%t typeFromGeneratedModule(["fragmentRef"])]
              ) =>
              paginationFragmentReturnRaw =
              "usePaginationFragment";

            [@bs.module "react-relay/hooks"]
            external internal_useBlockingPaginationFragment:
              (
                ReasonRelay.fragmentNode(
                  [%t typeFromGeneratedModule(["relayOperationNode"])],
                ),
                [%t typeFromGeneratedModule(["fragmentRef"])]
              ) =>
              paginationFragmentReturnRaw =
              "useBlockingPaginationFragment";

            [@bs.module "react-relay/hooks"]
            external internal_useRefetchableFragment:
              (
                ReasonRelay.fragmentNode(
                  [%t typeFromGeneratedModule(["relayOperationNode"])],
                ),
                [%t typeFromGeneratedModule(["fragmentRef"])]
              ) =>
              (
                [%t typeFromGeneratedModule(["Types", "fragment"])],
                (
                  [%t
                    makeTypeAccessor(
                      ~loc,
                      ~moduleName=queryName,
                      ["Types", "refetchVariables"],
                    )
                  ],
                  refetchableFnOpts
                ) =>
                ReasonRelay.Disposable.t,
              ) =
              "useRefetchableFragment";
          }
        ]
      },
      switch (refetchableQueryName) {
      | Some(queryName) => [%stri
          let useRefetchable = fRef => {
            let (fragmentData, refetchFn) =
              InternalRefetch.internal_useRefetchableFragment(
                [%e valFromGeneratedModule(["node"])],
                fRef->[%e valFromGeneratedModule(["getFragmentRef"])],
              );

            let data: [%t typeFromGeneratedModule(["Types", "fragment"])] =
              ReasonRelay_Internal.internal_useConvertedValue(
                [%e valFromGeneratedModule(["Internal", "convertFragment"])],
                fragmentData,
              );
            (
              data,
              (
                (
                  ~variables: [%t
                     makeTypeAccessor(
                       ~loc,
                       ~moduleName=queryName,
                       ["Types", "refetchVariables"],
                     )
                   ],
                  ~fetchPolicy: option(ReasonRelay.fetchPolicy)=?,
                  ~renderPolicy: option(ReasonRelay.renderPolicy)=?,
                  ~onComplete: option(option(Js.Exn.t) => unit)=?,
                  (),
                ) => (
                  refetchFn(
                    variables
                    ->[%e
                        makeExprAccessor(
                          ~loc,
                          ~moduleName=queryName,
                          ["Internal", "convertVariables"],
                        )
                      ]
                    ->ReasonRelay_Internal.internal_cleanObjectFromUndefinedRaw,
                    InternalRefetch.internal_makeRefetchableFnOpts(
                      ~fetchPolicy?,
                      ~renderPolicy?,
                      ~onComplete?,
                      (),
                    ),
                  ): ReasonRelay.Disposable.t
                )
              ),
            );
          }
        ]
      | None =>
        %stri
        ()
      },
      [%stri
        let use = (fRef): [%t typeFromGeneratedModule(["Types", "fragment"])] => {
          let data =
            Internal.internal_useFragment(
              [%e valFromGeneratedModule(["node"])],
              fRef->[%e valFromGeneratedModule(["getFragmentRef"])],
            );

          ReasonRelay_Internal.internal_useConvertedValue(
            [%e valFromGeneratedModule(["Internal", "convertFragment"])],
            data,
          );
        }
      ],
      [%stri
        let useOpt =
            (opt_fRef)
            : option([%t typeFromGeneratedModule(["Types", "fragment"])]) => {
          let fr =
            switch (opt_fRef) {
            | Some(fRef) =>
              Some(fRef->[%e valFromGeneratedModule(["getFragmentRef"])])
            | None => None
            };

          let nullableFragmentData:
            Js.Nullable.t(
              [%t typeFromGeneratedModule(["Types", "fragment"])],
            ) =
            Internal.internal_useFragmentOpt(
              [%e valFromGeneratedModule(["node"])],
              switch (fr) {
              | Some(fr) => Some(fr)->Js.Nullable.fromOption
              | None => Js.Nullable.null
              },
            );

          let data = nullableFragmentData->Js.Nullable.toOption;

          ReasonRelay_Internal.internal_useConvertedValue(
            rawFragment =>
              switch (rawFragment) {
              | Some(rawFragment) =>
                Some(
                  rawFragment->[%e
                                 valFromGeneratedModule([
                                   "Internal",
                                   "convertFragment",
                                 ])
                               ],
                )
              | None => None
              },
            data,
          );
        }
      ],
      hasInlineDirective
        ? [%stri
          let readInline =
              (fRef): [%t typeFromGeneratedModule(["Types", "fragment"])] => {
            Internal.internal_readInlineData(
              [%e valFromGeneratedModule(["node"])],
              fRef->[%e valFromGeneratedModule(["getFragmentRef"])],
            )
            ->[%e valFromGeneratedModule(["Internal", "convertFragment"])];
          }
        ]
        : [%stri ()],
      switch (hasConnection, refetchableQueryName) {
      | (true, Some(queryName)) => [%stri
          let usePagination = (fr): InternalRefetch.paginationFragmentReturn => {
            let p =
              InternalRefetch.internal_usePaginationFragment(
                [%e valFromGeneratedModule(["node"])],
                [%e valFromGeneratedModule(["getFragmentRef"])](fr),
              );
            let data =
              ReasonRelay_Internal.internal_useConvertedValue(
                [%e valFromGeneratedModule(["Internal", "convertFragment"])],
                p.data,
              );

            {
              data,
              loadNext: (~count, ~onComplete=?, ()) =>
                p.loadNext(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay_Internal.internal_nullableToOptionalExnHandler,
                  },
                ),
              loadPrevious: (~count, ~onComplete=?, ()) =>
                p.loadPrevious(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay_Internal.internal_nullableToOptionalExnHandler,
                  },
                ),
              hasNext: p.hasNext,
              hasPrevious: p.hasPrevious,
              isLoadingNext: p.isLoadingNext,
              isLoadingPrevious: p.isLoadingPrevious,
              refetch:
                (
                  ~variables: [%t
                     makeTypeAccessor(
                       ~loc,
                       ~moduleName=queryName,
                       ["Types", "refetchVariables"],
                     )
                   ],
                  ~fetchPolicy=?,
                  ~renderPolicy=?,
                  ~onComplete=?,
                  (),
                ) =>
                p.refetch(.
                  variables
                  ->[%e
                      makeExprAccessor(
                        ~loc,
                        ~moduleName=queryName,
                        ["Internal", "convertVariables"],
                      )
                    ]
                  ->ReasonRelay_Internal.internal_cleanObjectFromUndefinedRaw,
                  InternalRefetch.internal_makeRefetchableFnOpts(
                    ~onComplete?,
                    ~fetchPolicy?,
                    ~renderPolicy?,
                    (),
                  ),
                ),
            };
          }
        ]
      | _ =>
        %stri
        ()
      },
      switch (hasConnection, refetchableQueryName) {
      | (true, Some(queryName)) => [%stri
          let useBlockingPagination =
              (fRef): InternalRefetch.paginationBlockingFragmentReturn => {
            let p =
              InternalRefetch.internal_useBlockingPaginationFragment(
                [%e valFromGeneratedModule(["node"])],
                fRef->[%e valFromGeneratedModule(["getFragmentRef"])],
              );
            let data =
              ReasonRelay_Internal.internal_useConvertedValue(
                [%e valFromGeneratedModule(["Internal", "convertFragment"])],
                p.data,
              );

            {
              data,
              loadNext: (~count, ~onComplete=?, ()) =>
                p.loadNext(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay_Internal.internal_nullableToOptionalExnHandler,
                  },
                ),
              loadPrevious: (~count, ~onComplete=?, ()) =>
                p.loadPrevious(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay_Internal.internal_nullableToOptionalExnHandler,
                  },
                ),
              hasNext: p.hasNext,
              hasPrevious: p.hasPrevious,
              refetch:
                (
                  ~variables: [%t
                     makeTypeAccessor(
                       ~loc,
                       ~moduleName=queryName,
                       ["Types", "refetchVariables"],
                     )
                   ],
                  ~fetchPolicy=?,
                  ~renderPolicy=?,
                  ~onComplete=?,
                  (),
                ) =>
                p.refetch(.
                  variables
                  ->[%e
                      makeExprAccessor(
                        ~loc,
                        ~moduleName=queryName,
                        ["Internal", "convertVariables"],
                      )
                    ]
                  ->ReasonRelay_Internal.internal_cleanObjectFromUndefinedRaw,
                  InternalRefetch.internal_makeRefetchableFnOpts(
                    ~onComplete?,
                    ~fetchPolicy?,
                    ~renderPolicy?,
                    (),
                  ),
                ),
            };
          }
        ]
      | _ =>
        %stri
        ()
      },
      switch (refetchableQueryName, hasConnection) {
      | (Some(queryName), _) => [%stri
          let makeRefetchVariables = [%e
            makeExprAccessor(
              ~loc,
              ~moduleName=queryName,
              ["Types", "makeRefetchVariables"],
            )
          ]
        ]
      | _ =>
        %stri
        ()
      },
    ]),
  );
};
