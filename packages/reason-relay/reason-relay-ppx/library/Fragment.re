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
    ) =>
  Ast_helper.Mod.mk(
    Pmod_structure([
      // The %stri PPX comes from Ppxlib and means "make a structure item AST out of this raw string"
      [%stri module Operation = [%m makeModuleNameAst(~loc, ~moduleName)]], // %m also comes from Ppxlib and means "make a module definition"
      switch (refetchableQueryName) {
      | Some(queryName) => [%stri
          module RefetchableOperation = [%m
            makeModuleNameAst(~loc, ~moduleName=queryName)
          ]
        ]
      | None =>
        %stri
        ()
      },
      [%stri include Operation.Utils],
      [%stri module Types = Operation.Types],
      switch (refetchableQueryName) {
      | Some(queryName) => [%stri
          let useRefetchable = fRef => {
            let (fragmentData, refetchFn) =
              ReasonRelay.internal_useRefetchableFragment(
                Operation.node,
                fRef->Operation.getFragmentRef,
              );

            let data: Types.fragment =
              ReasonRelay.internal_useConvertedValue(
                Operation.Internal.convertFragment,
                fragmentData,
              );
            (
              data,
              (
                (
                  ~variables: RefetchableOperation.Types.refetchVariables,
                  ~fetchPolicy: option(ReasonRelay.fetchPolicy),
                  ~renderPolicy: option(ReasonRelay.renderPolicy),
                  ~onComplete: option(option(Js.Exn.t) => unit),
                  (),
                ) => (
                  refetchFn(
                    variables
                    ->RefetchableOperation.Internal.convertVariables
                    ->ReasonRelay.internal_cleanVariablesRaw
                    ->ReasonRelay.internal_cleanObjectFromUndefinedRaw,
                    ReasonRelay.internal_makeRefetchableFnOpts(
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
        let use = (fRef): Types.fragment => {
          let data =
            ReasonRelay.internal_useFragment(
              Operation.node,
              fRef->Operation.getFragmentRef,
            );

          ReasonRelay.internal_useConvertedValue(
            Operation.Internal.convertFragment,
            data,
          );
        }
      ],
      [%stri
        let useOpt = (opt_fRef): option(Types.fragment) => {
          let fr =
            switch (opt_fRef) {
            | Some(fRef) => Some(fRef->Operation.getFragmentRef)
            | None => None
            };

          let nullableFragmentData: Js.Nullable.t(Types.fragment) =
            ReasonRelay.internal_useFragmentOpt(
              Operation.node,
              switch (fr) {
              | Some(fr) => Some(fr)->Js.Nullable.fromOption
              | None => Js.Nullable.null
              },
            );

          let data = nullableFragmentData->Js.Nullable.toOption;

          ReasonRelay.internal_useConvertedValue(
            rawFragment =>
              switch (rawFragment) {
              | Some(rawFragment) =>
                Some(rawFragment->Operation.Internal.convertFragment)
              | None => None
              },
            data,
          );
        }
      ],
      hasInlineDirective
        ? [%stri
          let readInline = (fRef): Types.fragment => {
            ReasonRelay.internal_readInlineData(
              Operation.node,
              fRef->Operation.getFragmentRef,
            )
            ->Operation.Internal.convertFragment;
          }
        ]
        : [%stri ()],
      hasConnection
        ? [%stri
          let usePagination =
              (fr)
              : ReasonRelay.paginationFragmentReturn(
                  Types.fragment,
                  RefetchableOperation.Types.refetchVariables,
                ) => {
            let p =
              ReasonRelay.internal_usePaginationFragment(
                Operation.node,
                Operation.getFragmentRef(fr),
              );
            let data =
              ReasonRelay.internal_useConvertedValue(
                Operation.Internal.convertFragment,
                p.data,
              );

            {
              data,
              loadNext: (~count, ~onComplete=?, ()) =>
                p.loadNext(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay.internal_nullableToOptionalExnHandler,
                  },
                ),
              loadPrevious: (~count, ~onComplete=?, ()) =>
                p.loadPrevious(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay.internal_nullableToOptionalExnHandler,
                  },
                ),
              hasNext: p.hasNext,
              hasPrevious: p.hasPrevious,
              isLoadingNext: p.isLoadingNext,
              isLoadingPrevious: p.isLoadingPrevious,
              refetch:
                (
                  ~variables: RefetchableOperation.Types.refetchVariables,
                  ~fetchPolicy=?,
                  ~renderPolicy=?,
                  ~onComplete=?,
                  (),
                ) =>
                p.refetch(.
                  variables
                  ->RefetchableOperation.Internal.convertVariables
                  ->ReasonRelay.internal_cleanVariablesRaw
                  ->ReasonRelay.internal_cleanObjectFromUndefinedRaw,
                  ReasonRelay.internal_makeRefetchableFnOpts(
                    ~onComplete?,
                    ~fetchPolicy?,
                    ~renderPolicy?,
                    (),
                  ),
                ),
            };
          }
        ]
        : [%stri ()],
      hasConnection
        ? [%stri
          let useBlockingPagination =
              (fRef)
              : ReasonRelay.paginationBlockingFragmentReturn(
                  Types.fragment,
                  RefetchableOperation.Types.refetchVariables,
                ) => {
            let p =
              ReasonRelay.internal_useBlockingPaginationFragment(
                Operation.node,
                Operation.getFragmentRef(fRef),
              );
            let data =
              ReasonRelay.internal_useConvertedValue(
                Operation.Internal.convertFragment,
                p.data,
              );

            {
              data,
              loadNext: (~count, ~onComplete=?, ()) =>
                p.loadNext(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay.internal_nullableToOptionalExnHandler,
                  },
                ),
              loadPrevious: (~count, ~onComplete=?, ()) =>
                p.loadPrevious(.
                  count,
                  {
                    onComplete:
                      onComplete->ReasonRelay.internal_nullableToOptionalExnHandler,
                  },
                ),
              hasNext: p.hasNext,
              hasPrevious: p.hasPrevious,
              refetch:
                (
                  ~variables: RefetchableOperation.Types.refetchVariables,
                  ~fetchPolicy=?,
                  ~renderPolicy=?,
                  ~onComplete=?,
                  (),
                ) =>
                p.refetch(.
                  variables
                  ->RefetchableOperation.Internal.convertVariables
                  ->ReasonRelay.internal_cleanVariablesRaw
                  ->ReasonRelay.internal_cleanObjectFromUndefinedRaw,
                  ReasonRelay.internal_makeRefetchableFnOpts(
                    ~onComplete?,
                    ~fetchPolicy?,
                    ~renderPolicy?,
                    (),
                  ),
                ),
            };
          }
        ]
        : [%stri ()],
      switch (refetchableQueryName, hasConnection) {
      | (_, true)
      | (Some(_), _) => [%stri
          let makeRefetchVariables = RefetchableOperation.Types.makeRefetchVariables
        ]
      | _ =>
        %stri
        ()
      },
    ]),
  );
