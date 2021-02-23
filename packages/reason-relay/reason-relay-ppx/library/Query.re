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
      [%stri [@ocaml.warning "-32"]],
      [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
      [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
      [%stri
        %private
        [@module "relay-runtime"]
        external internal_createOperationDescriptor:
          (
            ReasonRelay.queryNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["Types", "variables"])]
          ) =>
          ReasonRelay.operationDescriptor =
          "createOperationDescriptor"
      ],
      [%stri
        type useQueryConfig = {
          fetchKey: option(string),
          fetchPolicy: option(string),
          [@as "UNSTABLE_renderPolicy"]
          renderPolicy: option(string),
          networkCacheConfig: option(ReasonRelay.cacheConfig),
        }
      ],
      [%stri
        %private
        [@module "react-relay/hooks"]
        external internal_useQuery:
          (
            ReasonRelay.queryNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["Types", "variables"])],
            useQueryConfig
          ) =>
          [%t typeFromGeneratedModule(["Types", "response"])] =
          "useLazyLoadQuery"
      ],
      [%stri
        %private
        [@module "react-relay/hooks"]
        external internal_usePreloadedQuery:
          (
            ReasonRelay.queryNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["queryRef"])],
            option({. "UNSTABLE_renderPolicy": option(string)})
          ) =>
          [%t typeFromGeneratedModule(["Types", "response"])] =
          "usePreloadedQuery"
      ],
      [%stri
        type useQueryLoaderOptions = {
          fetchPolicy: option(ReasonRelay.fetchPolicy),
          networkCacheConfig: option(ReasonRelay.cacheConfig),
        }
      ],
      [%stri
        %private
        [@module "react-relay/hooks"]
        external internal_useQueryLoader:
          ReasonRelay.queryNode(
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
          "useQueryLoader"
      ],
      [%stri
        %private
        [@module "react-relay/hooks"]
        external internal_fetchQuery:
          (
            ReasonRelay.Environment.t,
            ReasonRelay.queryNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
            [%t typeFromGeneratedModule(["Types", "variables"])],
            option(ReasonRelay.fetchQueryOptions)
          ) =>
          ReasonRelay.Observable.t(
            [%t typeFromGeneratedModule(["Types", "response"])],
          ) =
          "fetchQuery"
      ],
      [%stri
        /**React hook for using this query.

Prefer using `Query.useLoader()` or `YourQueryName_graphql.load()` in combination with `Query.usePreloaded()` to this whenever you can, as that will allow you to start loading data before your code actually renders.*/
        let use =
            (
              ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
              ~fetchPolicy: option(ReasonRelay.fetchPolicy)=?,
              ~renderPolicy: option(ReasonRelay.renderPolicy)=?,
              ~fetchKey: option(string)=?,
              ~networkCacheConfig: option(ReasonRelay.cacheConfig)=?,
              (),
            )
            : [%t typeFromGeneratedModule(["Types", "response"])] => {
          let data: [%t typeFromGeneratedModule(["Types", "response"])] =
            internal_useQuery(
              [%e valFromGeneratedModule(["node"])],
              variables
              ->[%e valFromGeneratedModule(["Internal", "convertVariables"])]
              ->ReasonRelay_Internal.internal_cleanObjectFromUndefinedRaw,
              {
                fetchKey,
                fetchPolicy: fetchPolicy->ReasonRelay.mapFetchPolicy,
                renderPolicy: renderPolicy->ReasonRelay.mapRenderPolicy,
                networkCacheConfig,
              },
            );

          ReasonRelay_Internal.internal_useConvertedValue(
            [%e valFromGeneratedModule(["Internal", "convertResponse"])],
            data,
          );
        }
      ],
      [%stri
        /**React hook for preloading this query. Returns a tuple of `(loadedQueryRef, loadQueryFn, dispose)`.

Use this together with `Query.usePreloaded`.*/
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
                  ~fetchPolicy: ReasonRelay.fetchPolicy=?,
                  ~networkCacheConfig: ReasonRelay.cacheConfig=?,
                  unit
                ) =>
                unit,
                unit => unit,
              ) => {
          let (nullableQueryRef, loadQueryFn, disposableFn) =
            internal_useQueryLoader([%e valFromGeneratedModule(["node"])]);

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
        /**
This fetches the query in a one-off fashion, and returns a `Belt.Result.t` in a callback for convenience. Use `Query.fetchPromised` if you need this but with promises.

Please *avoid* using `Query.fetch` unless you really need it, since the data you fetch here isn't guaranteed to stick around in the store/cache unless you explicitly use it somewhere in your views.*/
        let fetch =
            (
              ~environment: ReasonRelay.Environment.t,
              ~variables: [%t
                 typeFromGeneratedModule(["Types", "variables"])
               ],
              ~onResult:
                 Belt.Result.t(
                   [%t typeFromGeneratedModule(["Types", "response"])],
                   Js.Exn.t,
                 ) =>
                 unit,
              ~networkCacheConfig: option(ReasonRelay.cacheConfig)=?,
              ~fetchPolicy: option(ReasonRelay.fetchQueryFetchPolicy)=?,
              (),
            )
            : unit => {
          let _ =
            internal_fetchQuery(
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
                fetchPolicy: fetchPolicy->ReasonRelay.mapFetchQueryFetchPolicy,
              }),
            )
            ->ReasonRelay.Observable.(
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
        /** Promise variant of `Query.fetch`.*/
        let fetchPromised =
            (
              ~environment: ReasonRelay.Environment.t,
              ~variables: [%t
                 typeFromGeneratedModule(["Types", "variables"])
               ],
              ~networkCacheConfig: option(ReasonRelay.cacheConfig)=?,
              ~fetchPolicy: option(ReasonRelay.fetchQueryFetchPolicy)=?,
              (),
            )
            : Promise.t([%t typeFromGeneratedModule(["Types", "response"])]) => {
          internal_fetchQuery(
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
              fetchPolicy: fetchPolicy->ReasonRelay.mapFetchQueryFetchPolicy,
            }),
          )
          ->ReasonRelay.Observable.toPromise
          ->Promise.map(res =>
              res->[%e
                     valFromGeneratedModule(["Internal", "convertResponse"])
                   ]
            );
        }
      ],
      [%stri
        /**Combine this with `Query.useLoader` or `YourQueryName_graphql.load()` to use a query you've started preloading before rendering.*/
        let usePreloaded =
            (
              ~queryRef: [%t typeFromGeneratedModule(["queryRef"])],
              ~renderPolicy: option(ReasonRelay.renderPolicy)=?,
              (),
            )
            : [%t typeFromGeneratedModule(["Types", "response"])] => {
          let data: [%t typeFromGeneratedModule(["Types", "response"])] =
            internal_usePreloadedQuery(
              [%e valFromGeneratedModule(["node"])],
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
          ReasonRelay_Internal.internal_useConvertedValue(
            [%e valFromGeneratedModule(["Internal", "convertResponse"])],
            data,
          );
        }
      ],
      [%stri
        /**Calling with a set of variables will make Relay _disable garbage collection_ of this query (+ variables) until you explicitly dispose the `Disposable.t` you get back from this call.

Useful for queries and data you know you want to keep in the store regardless of what happens (like it not being used by any view and therefore potentially garbage collected).*/
        let retain =
            (
              ~environment: ReasonRelay.Environment.t,
              ~variables: [%t
                 typeFromGeneratedModule(["Types", "variables"])
               ],
            ) => {
          let operationDescriptor =
            internal_createOperationDescriptor(
              [%e valFromGeneratedModule(["node"])],
              variables->[%e
                           valFromGeneratedModule([
                             "Internal",
                             "convertVariables",
                           ])
                         ],
            );

          environment->ReasonRelay.Environment.retain(operationDescriptor);
        }
      ],
      hasRawResponseType
        ? [%stri
          /**This commits a payload into the store _locally only_. Useful for driving client-only state via Relay for example, or priming the cache with data you don't necessarily want to hit the server for.*/
          let commitLocalPayload =
              (
                ~environment: ReasonRelay.Environment.t,
                ~variables: [%t
                   typeFromGeneratedModule(["Types", "variables"])
                 ],
                ~payload: [%t
                   typeFromGeneratedModule(["Types", "rawResponse"])
                 ],
              ) => {
            let operationDescriptor =
              internal_createOperationDescriptor(
                [%e valFromGeneratedModule(["node"])],
                variables->[%e
                             valFromGeneratedModule([
                               "Internal",
                               "convertVariables",
                             ])
                           ],
              );

            environment->ReasonRelay.Environment.commitPayload(
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
