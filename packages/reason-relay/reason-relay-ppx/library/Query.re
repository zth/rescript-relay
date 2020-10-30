open Ppxlib;
open Util;

/**
 * Check out the comments for makeFragment, this does the same thing but for queries.
 */
let make = (~loc, ~moduleName, ~hasRawResponseType) =>
  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri module Operation = [%m makeModuleNameAst(~loc, ~moduleName)]],
      [%stri include Operation.Utils],
      [%stri module Types = Operation.Types],
      [%stri
        let use =
            (
              ~variables: Types.variables,
              ~fetchPolicy: option(ReasonRelay.fetchPolicy)=?,
              ~renderPolicy: option(ReasonRelay.renderPolicy)=?,
              ~fetchKey: option(string)=?,
              ~networkCacheConfig: option(ReasonRelay.cacheConfig)=?,
              (),
            )
            : Types.response => {
          let data: Types.response =
            ReasonRelay.internal_useQuery(
              Operation.node,
              variables
              ->ReasonRelay.internal_cleanVariablesRaw
              ->Operation.Internal.convertVariables
              ->ReasonRelay.internal_cleanObjectFromUndefinedRaw,
              {
                fetchKey,
                fetchPolicy: fetchPolicy->ReasonRelay.mapFetchPolicy,
                renderPolicy: renderPolicy->ReasonRelay.mapRenderPolicy,
                networkCacheConfig,
              },
            );

          ReasonRelay.internal_useConvertedValue(
            Operation.Internal.convertResponse,
            data,
          );
        }
      ],
      [%stri
        let useLoader =
            ()
            : (
                option(Operation.queryRef),
                (
                  ~variables: Types.variables,
                  ~fetchPolicy: ReasonRelay.fetchPolicy=?,
                  ~networkCacheConfig: ReasonRelay.cacheConfig=?,
                  unit
                ) =>
                unit,
                unit => unit,
              ) => {
          let (nullableQueryRef, loadQueryFn, disposableFn) =
            ReasonRelay.internal_useQueryLoader(Operation.node);

          // TODO: Fix stability of this reference. Can't seem to use React.useCallback with labelled arguments for some reason.
          let loadQuery =
              (
                ~variables: Types.variables,
                ~fetchPolicy=?,
                ~networkCacheConfig=?,
                (),
              ) =>
            loadQueryFn(
              variables->Operation.Internal.convertVariables,
              {fetchPolicy, networkCacheConfig},
            );

          (Js.Nullable.toOption(nullableQueryRef), loadQuery, disposableFn);
        }
      ],
      [%stri
        let fetch =
            (
              ~environment: ReasonRelay.Environment.t,
              ~variables: Types.variables,
              ~onResult: Belt.Result.t(Types.response, Js.Exn.t) => unit,
              ~networkCacheConfig: option(ReasonRelay.cacheConfig)=?,
              ~fetchPolicy: option(ReasonRelay.fetchQueryFetchPolicy)=?,
              (),
            )
            : unit => {
          let _ =
            ReasonRelay.fetchQuery(
              environment,
              Operation.node,
              variables->Operation.Internal.convertVariables,
              Some({
                networkCacheConfig,
                fetchPolicy: fetchPolicy->ReasonRelay.mapFetchQueryFetchPolicy,
              }),
            )
            ->ReasonRelay.Observable.(
                subscribe(
                  makeObserver(
                    ~next=
                      res =>
                        onResult(
                          Ok(res->Operation.Internal.convertResponse),
                        ),
                    ~error=err => onResult(Error(err)),
                    (),
                  ),
                )
              );
          ();
        }
      ],
      [%stri
        let fetchPromised =
            (
              ~environment: ReasonRelay.Environment.t,
              ~variables: Types.variables,
              ~networkCacheConfig: option(ReasonRelay.cacheConfig)=?,
              ~fetchPolicy: option(ReasonRelay.fetchQueryFetchPolicy)=?,
              (),
            )
            : Promise.t(Belt.Result.t(Types.response, Js.Exn.t)) => {
          let (promise, resolve) = Promise.pending();

          let _ =
            ReasonRelay.fetchQuery(
              environment,
              Operation.node,
              variables->Operation.Internal.convertVariables,
              Some({
                networkCacheConfig,
                fetchPolicy: fetchPolicy->ReasonRelay.mapFetchQueryFetchPolicy,
              }),
            )
            ->ReasonRelay.Observable.(
                subscribe(
                  makeObserver(
                    ~next=
                      res => {
                        resolve(Ok(res->Operation.Internal.convertResponse))
                      },
                    ~error=err => {resolve(Error(err))},
                    (),
                  ),
                )
              );

          promise;
        }
      ],
      [%stri
        let usePreloaded =
            (
              ~queryRef: Operation.queryRef,
              ~renderPolicy: option(ReasonRelay.renderPolicy)=?,
              (),
            )
            : Types.response => {
          let data: Types.response =
            ReasonRelay.internal_usePreloadedQuery(
              Operation.node,
              queryRef,
              switch (renderPolicy) {
              | Some(_) =>
                Some({
                  "UNSTABLE_renderPolicy":
                    renderPolicy->ReasonRelay.mapRenderPolicy,
                })
              | None => None
              },
            );
          ReasonRelay.internal_useConvertedValue(
            Operation.Internal.convertResponse,
            data,
          );
        }
      ],
      hasRawResponseType
        ? [%stri
          let commitLocalPayload =
              (
                ~environment: ReasonRelay.Environment.t,
                ~variables: Types.variables,
                ~payload: Types.rawResponse,
              ) => {
            let operationDescriptor =
              ReasonRelay.internal_createOperationDescriptor(
                Operation.node,
                variables->Operation.Internal.convertVariables,
              );

            environment->ReasonRelay.Environment.commitPayload(
              operationDescriptor,
              payload->Operation.Internal.convertWrapRawResponse,
            );
          }
        ]
        : [%stri ()],
    ]),
  );
