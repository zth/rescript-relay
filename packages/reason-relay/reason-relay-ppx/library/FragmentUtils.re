open Ppxlib;

let makeGeneratedModuleImports = (~loc, ~moduleIdentFromGeneratedModule) => [
  [%stri [@ocaml.warning "-32"]],
  [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
  [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
];

let makeInternalExternals = (~loc, ~typeFromGeneratedModule) => [
  [%stri
    %private
    [@module "react-relay"]
    external internal_readInlineData:
      (
        ReasonRelay.fragmentNode(
          [%t typeFromGeneratedModule(["relayOperationNode"])],
        ),
        [%t typeFromGeneratedModule(["fragmentRef"])]
      ) =>
      [%t typeFromGeneratedModule(["Types", "fragment"])] =
      "readInlineData"
  ],
  [%stri
    %private
    [@module "react-relay/hooks"]
    external internal_useFragment:
      (
        ReasonRelay.fragmentNode(
          [%t typeFromGeneratedModule(["relayOperationNode"])],
        ),
        [%t typeFromGeneratedModule(["fragmentRef"])]
      ) =>
      [%t typeFromGeneratedModule(["Types", "fragment"])] =
      "useFragment"
  ],
  [%stri
    %private
    [@module "react-relay/hooks"]
    external internal_useFragmentOpt:
      (
        ReasonRelay.fragmentNode(
          [%t typeFromGeneratedModule(["relayOperationNode"])],
        ),
        Js.Nullable.t([%t typeFromGeneratedModule(["fragmentRef"])])
      ) =>
      Js.Nullable.t([%t typeFromGeneratedModule(["Types", "fragment"])]) =
      "useFragment"
  ],
];

let makeRefetchableAssets =
    (
      ~loc,
      ~refetchableQueryName,
      ~typeFromGeneratedModule,
      ~makeTypeAccessor,
      ~makeExprAccessor,
      ~valFromGeneratedModule,
    ) =>
  switch (refetchableQueryName) {
  | None => []
  | Some(queryName) => [
      [%stri
        [@deriving abstract]
        type refetchableFnOpts = {
          [@optional]
          fetchPolicy: string,
          [@optional] [@as "UNSTABLE_renderPolicy"]
          renderPolicy: string,
          [@optional]
          onComplete: Js.Nullable.t(Js.Exn.t) => unit,
        }
      ],
      [%stri
        let internal_makeRefetchableFnOpts =
            (~fetchPolicy=?, ~renderPolicy=?, ~onComplete=?, ()) =>
          refetchableFnOpts(
            ~fetchPolicy=?fetchPolicy->ReasonRelay.mapFetchPolicy,
            ~renderPolicy=?renderPolicy->ReasonRelay.mapRenderPolicy,
            ~onComplete=?
              onComplete->ReasonRelay_Internal.internal_nullableToOptionalExnHandler,
            (),
          )
      ],
      [%stri
        type paginationLoadMoreOptions = {
          onComplete: option(Js.nullable(Js.Exn.t) => unit),
        }
      ],
      [%stri
        type paginationLoadMoreFn =
          (~count: int, ~onComplete: option(Js.Exn.t) => unit=?, unit) =>
          ReasonRelay.Disposable.t
      ],
      [%stri
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
        }
      ],
      [%stri
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
        }
      ],
      [%stri
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
        }
      ],
      [%stri
        %private
        [@module "react-relay/hooks"]
        external internal_usePaginationFragment:
          (
            ReasonRelay.fragmentNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["fragmentRef"])]
          ) =>
          paginationFragmentReturnRaw =
          "usePaginationFragment"
      ],
      [%stri
        %private
        [@module "react-relay/hooks"]
        external internal_useBlockingPaginationFragment:
          (
            ReasonRelay.fragmentNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["fragmentRef"])]
          ) =>
          paginationFragmentReturnRaw =
          "useBlockingPaginationFragment"
      ],
      [%stri
        %private
        [@module "react-relay/hooks"]
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
          "useRefetchableFragment"
      ],
      [%stri
        let useRefetchable = fRef => {
          let (fragmentData, refetchFn) =
            internal_useRefetchableFragment(
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
                  internal_makeRefetchableFnOpts(
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
      ],
    ]
  };
