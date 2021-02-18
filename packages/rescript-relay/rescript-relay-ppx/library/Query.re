open Ppxlib;
open Util;

/**
 * Check out the comments for makeFragment, this does the same thing but for queries.
 */
let make = (~loc, ~moduleName, ~hasRawResponseType) => {
  let typeFromGeneratedModule = makeTypeAccessor(~loc, ~moduleName);
  let valFromGeneratedModule = makeExprAccessor(~loc, ~moduleName);
  let moduleIdentFromGeneratedModule = makeModuleIdent(~loc, ~moduleName);

  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
      [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
      [%stri
        module Internal = {
          [@bs.module "relay-runtime"]
          external internal_createOperationDescriptor:
            (
              RescriptRelay.queryNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
              [%t typeFromGeneratedModule(["Types", "variables"])]
            ) =>
            RescriptRelay.operationDescriptor =
            "createOperationDescriptor";

          type useQueryConfig = {
            fetchKey: option(string),
            fetchPolicy: option(string),
            [@bs.as "UNSTABLE_renderPolicy"]
            renderPolicy: option(string),
            networkCacheConfig: option(RescriptRelay.cacheConfig),
          };

          [@bs.module "react-relay/hooks"]
          external internal_useQuery:
            (
              RescriptRelay.queryNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
              [%t typeFromGeneratedModule(["Types", "variables"])],
              useQueryConfig
            ) =>
            [%t typeFromGeneratedModule(["Types", "response"])] =
            "useLazyLoadQuery";

          [@bs.module "react-relay/hooks"]
          external internal_usePreloadedQuery:
            (
              RescriptRelay.queryNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
              [%t typeFromGeneratedModule(["queryRef"])],
              option({. "UNSTABLE_renderPolicy": option(string)})
            ) =>
            [%t typeFromGeneratedModule(["Types", "response"])] =
            "usePreloadedQuery";

          type useQueryLoaderOptions = {
            fetchPolicy: option(RescriptRelay.fetchPolicy),
            networkCacheConfig: option(RescriptRelay.cacheConfig),
          };

          [@bs.module "react-relay/hooks"]
          external internal_useQueryLoader:
            RescriptRelay.queryNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ) =>
            (
              Js.nullable([%t typeFromGeneratedModule(["queryRef"])]),
              (
                [%t typeFromGeneratedModule(["Types", "variables"])],
                useQueryLoaderOptions
              ) =>
              unit,
              unit => unit,
            ) =
            "useQueryLoader";

          [@bs.module "react-relay/hooks"]
          external internal_fetchQuery:
            (
              RescriptRelay.Environment.t,
              RescriptRelay.queryNode(
                [%t typeFromGeneratedModule(["relayOperationNode"])],
              ),
              [%t typeFromGeneratedModule(["Types", "variables"])],
              option(RescriptRelay.fetchQueryOptions)
            ) =>
            RescriptRelay.Observable.t(
              [%t typeFromGeneratedModule(["Types", "response"])],
            ) =
            "fetchQuery";
        }
      ],
      [%stri
        let use =
            (
              ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
              ~fetchPolicy: option(RescriptRelay.fetchPolicy)=?,
              ~renderPolicy: option(RescriptRelay.renderPolicy)=?,
              ~fetchKey: option(string)=?,
              ~networkCacheConfig: option(RescriptRelay.cacheConfig)=?,
              (),
            )
            : [%t typeFromGeneratedModule(["Types", "response"])] => {
          let data: [%t typeFromGeneratedModule(["Types", "response"])] =
            Internal.internal_useQuery(
              [%e valFromGeneratedModule(["node"])],
              variables
              ->[%e valFromGeneratedModule(["Internal", "convertVariables"])]
              ->RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw,
              {
                fetchKey,
                fetchPolicy: fetchPolicy->RescriptRelay.mapFetchPolicy,
                renderPolicy: renderPolicy->RescriptRelay.mapRenderPolicy,
                networkCacheConfig,
              },
            );

          RescriptRelay_Internal.internal_useConvertedValue(
            [%e valFromGeneratedModule(["Internal", "convertResponse"])],
            data,
          );
        }
      ],
      [%stri
        let useLoader =
            ()
            : (
                option([%t typeFromGeneratedModule(["queryRef"])]),
                (
                  ~variables: [%t
                                typeFromGeneratedModule([
                                  "Types",
                                  "variables",
                                ])
                              ],
                  ~fetchPolicy: RescriptRelay.fetchPolicy=?,
                  ~networkCacheConfig: RescriptRelay.cacheConfig=?,
                  unit
                ) =>
                unit,
                unit => unit,
              ) => {
          let (nullableQueryRef, loadQueryFn, disposableFn) =
            Internal.internal_useQueryLoader(
              [%e valFromGeneratedModule(["node"])],
            );

          // TODO: Fix stability of this reference. Can't seem to use React.useCallback with labelled arguments for some reason.
          let loadQuery =
              (
                ~variables: [%t
                   typeFromGeneratedModule(["Types", "variables"])
                 ],
                ~fetchPolicy=?,
                ~networkCacheConfig=?,
                (),
              ) =>
            loadQueryFn(
              variables->[%e
                           valFromGeneratedModule([
                             "Internal",
                             "convertVariables",
                           ])
                         ],
              {fetchPolicy, networkCacheConfig},
            );

          (Js.Nullable.toOption(nullableQueryRef), loadQuery, disposableFn);
        }
      ],
      [%stri
        let fetch =
            (
              ~environment: RescriptRelay.Environment.t,
              ~variables: [%t
                 typeFromGeneratedModule(["Types", "variables"])
               ],
              ~onResult:
                 Belt.Result.t(
                   [%t typeFromGeneratedModule(["Types", "response"])],
                   Js.Exn.t,
                 ) =>
                 unit,
              ~networkCacheConfig: option(RescriptRelay.cacheConfig)=?,
              ~fetchPolicy: option(RescriptRelay.fetchQueryFetchPolicy)=?,
              (),
            )
            : unit => {
          let _ =
            Internal.internal_fetchQuery(
              environment,
              [%e valFromGeneratedModule(["node"])],
              variables->[%e
                           valFromGeneratedModule([
                             "Internal",
                             "convertVariables",
                           ])
                         ],
              Some({
                networkCacheConfig,
                fetchPolicy: fetchPolicy->RescriptRelay.mapFetchQueryFetchPolicy,
              }),
            )
            ->RescriptRelay.Observable.(
                subscribe(
                  makeObserver(
                    ~next=
                      res =>
                        onResult(
                          Ok(
                            res->[%e
                                   valFromGeneratedModule([
                                     "Internal",
                                     "convertResponse",
                                   ])
                                 ],
                          ),
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
              ~environment: RescriptRelay.Environment.t,
              ~variables: [%t
                 typeFromGeneratedModule(["Types", "variables"])
               ],
              ~networkCacheConfig: option(RescriptRelay.cacheConfig)=?,
              ~fetchPolicy: option(RescriptRelay.fetchQueryFetchPolicy)=?,
              (),
            )
            : Promise.t([%t typeFromGeneratedModule(["Types", "response"])]) => {
          Internal.internal_fetchQuery(
            environment,
            [%e valFromGeneratedModule(["node"])],
            variables->[%e
                         valFromGeneratedModule([
                           "Internal",
                           "convertVariables",
                         ])
                       ],
            Some({
              networkCacheConfig,
              fetchPolicy: fetchPolicy->RescriptRelay.mapFetchQueryFetchPolicy,
            }),
          )
          ->RescriptRelay.Observable.toPromise
          ->Promise.map(res =>
              res->[%e
                     valFromGeneratedModule(["Internal", "convertResponse"])
                   ]
            );
        }
      ],
      [%stri
        let usePreloaded =
            (
              ~queryRef: [%t typeFromGeneratedModule(["queryRef"])],
              ~renderPolicy: option(RescriptRelay.renderPolicy)=?,
              (),
            )
            : [%t typeFromGeneratedModule(["Types", "response"])] => {
          let data: [%t typeFromGeneratedModule(["Types", "response"])] =
            Internal.internal_usePreloadedQuery(
              [%e valFromGeneratedModule(["node"])],
              queryRef,
              switch (renderPolicy) {
              | Some(_) =>
                Some({
                  "UNSTABLE_renderPolicy":
                    renderPolicy->RescriptRelay.mapRenderPolicy,
                })
              | None => None
              },
            );
          RescriptRelay_Internal.internal_useConvertedValue(
            [%e valFromGeneratedModule(["Internal", "convertResponse"])],
            data,
          );
        }
      ],
      hasRawResponseType
        ? [%stri
          let commitLocalPayload =
              (
                ~environment: RescriptRelay.Environment.t,
                ~variables: [%t
                   typeFromGeneratedModule(["Types", "variables"])
                 ],
                ~payload: [%t
                   typeFromGeneratedModule(["Types", "rawResponse"])
                 ],
              ) => {
            let operationDescriptor =
              Internal.internal_createOperationDescriptor(
                [%e valFromGeneratedModule(["node"])],
                variables->[%e
                             valFromGeneratedModule([
                               "Internal",
                               "convertVariables",
                             ])
                           ],
              );

            environment->RescriptRelay.Environment.commitPayload(
              operationDescriptor,
              payload->[%e
                         valFromGeneratedModule([
                           "Internal",
                           "convertWrapRawResponse",
                         ])
                       ],
            );
          }
        ]
        : [%stri ()],
    ]),
  );
};
