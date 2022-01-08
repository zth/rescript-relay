open Ppxlib;

let makeGeneratedModuleImports = (~loc, ~moduleIdentFromGeneratedModule) => [
  [%stri [@ocaml.warning "-32-34-60"]],
  [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
  [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
];

let makeInternalExternals = (~loc, ~typeFromGeneratedModule) => [
  [%stri
    %private
    [@live] [@module "react-relay"]
    external internal_readInlineData:
      (
        RescriptRelay.fragmentNode(
          [%t typeFromGeneratedModule(["relayOperationNode"])],
        ),
        [%t typeFromGeneratedModule(["fragmentRef"])]
      ) =>
      [%t typeFromGeneratedModule(["Types", "fragment"])] =
      "readInlineData"
  ],
  [%stri
    %private
    [@live] [@module "react-relay/hooks"]
    external internal_useFragment:
      (
        RescriptRelay.fragmentNode(
          [%t typeFromGeneratedModule(["relayOperationNode"])],
        ),
        [%t typeFromGeneratedModule(["fragmentRef"])]
      ) =>
      [%t typeFromGeneratedModule(["Types", "fragment"])] =
      "useFragment"
  ],
  [%stri
    %private
    [@live] [@module "react-relay/hooks"]
    external internal_useFragmentOpt:
      (
        RescriptRelay.fragmentNode(
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
        [@deriving abstract] [@live]
        type refetchableFnOpts = {
          [@optional]
          fetchPolicy: string,
          [@optional]
          onComplete: Js.Nullable.t(Js.Exn.t) => unit,
        }
      ],
      [%stri
        [@live] let internal_makeRefetchableFnOpts =
            (~fetchPolicy=?, ~onComplete=?, ()) =>
          refetchableFnOpts(
            ~fetchPolicy=?fetchPolicy->RescriptRelay.mapFetchPolicy,
            ~onComplete=?
              onComplete->RescriptRelay_Internal.internal_nullableToOptionalExnHandler,
            (),
          )
      ],
      [%stri
        [@live] type paginationLoadMoreOptions = {
          onComplete: option(Js.nullable(Js.Exn.t) => unit),
        }
      ],
      [%stri
        [@live] type paginationLoadMoreFn =
          (~count: int, ~onComplete: option(Js.Exn.t) => unit=?, unit) =>
          RescriptRelay.Disposable.t
      ],
      [%stri
        [@live] type paginationFragmentReturnRaw = {
          data: [%t typeFromGeneratedModule(["Types", "fragment"])],
          loadNext:
            (. int, paginationLoadMoreOptions) => RescriptRelay.Disposable.t,
          loadPrevious:
            (. int, paginationLoadMoreOptions) => RescriptRelay.Disposable.t,
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
            RescriptRelay.Disposable.t,
        }
      ],
      [%stri
        [@live] type paginationBlockingFragmentReturn = {
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
              ~fetchPolicy: RescriptRelay.fetchPolicy=?,
              ~onComplete: option(Js.Exn.t) => unit=?,
              unit
            ) =>
            RescriptRelay.Disposable.t,
        }
      ],
      [%stri
        [@live] type paginationFragmentReturn = {
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
              ~fetchPolicy: RescriptRelay.fetchPolicy=?,
              ~onComplete: option(Js.Exn.t) => unit=?,
              unit
            ) =>
            RescriptRelay.Disposable.t,
        }
      ],
      [%stri
        %private
        [@module "react-relay/hooks"] [@live]
        external internal_usePaginationFragment:
          (
            RescriptRelay.fragmentNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["fragmentRef"])]
          ) =>
          paginationFragmentReturnRaw =
          "usePaginationFragment"
      ],
      [%stri
        %private
        [@module "react-relay/hooks"] [@live]
        external internal_useBlockingPaginationFragment:
          (
            RescriptRelay.fragmentNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["fragmentRef"])]
          ) =>
          paginationFragmentReturnRaw =
          "useBlockingPaginationFragment"
      ],
      [%stri
        %private
        [@module "react-relay/hooks"] [@live]
        external internal_useRefetchableFragment:
          (
            RescriptRelay.fragmentNode(
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
            RescriptRelay.Disposable.t,
          ) =
          "useRefetchableFragment"
      ],
      [%stri
        /**React hook for using a fragment that you want to refetch. Returns a tuple of `(fragmentData, refetchFn)`.

### Refetching and variables
You supply a _diff_ of your variables to Relay when refetching. Diffed variables here means that any new value you supply when refetching will be merged with the variables you last used when fetching data for this fragment.

### `Fragment.makeRefetchVariables` - helper for making the refetch variables
There's a helper generated for you to create those diffed variables more easily at `Fragment.makeRefetchVariables`.*/
        [@live] let useRefetchable = fRef => {
          let (fragmentData, refetchFn) =
            internal_useRefetchableFragment(
              [%e valFromGeneratedModule(["node"])],
              fRef->[%e valFromGeneratedModule(["getFragmentRef"])],
            );

          let data: [%t typeFromGeneratedModule(["Types", "fragment"])] =
            RescriptRelay_Internal.internal_useConvertedValue(
              [%e valFromGeneratedModule(["Internal", "convertFragment"])],
              fragmentData,
            );
          (
            data,
            React.useMemo1(
              (
                (),
                ~variables: [%t
                   makeTypeAccessor(
                     ~loc,
                     ~moduleName=queryName,
                     ["Types", "refetchVariables"],
                   )
                 ],
                ~fetchPolicy: option(RescriptRelay.fetchPolicy)=?,
                ~onComplete: option(option(Js.Exn.t) => unit)=?,
                (),
              ): RescriptRelay.Disposable.t =>
                refetchFn(
                  variables
                  ->[%e
                      makeExprAccessor(
                        ~loc,
                        ~moduleName=queryName,
                        ["Internal", "convertVariables"],
                      )
                    ]
                  ->RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw,
                  internal_makeRefetchableFnOpts(
                    ~fetchPolicy?,
                    ~onComplete?,
                    (),
                  ),
                ),
              [|refetchFn|],
            ),
          );
        }
      ],
    ]
  };
