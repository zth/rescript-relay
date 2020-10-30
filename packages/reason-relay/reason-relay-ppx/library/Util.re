/**
 * This PPX defines the [%relay.<operation> {| ... |}] extension points.
 */
// Ppxlib provides a number of helpers for writing and registering PPXs that life is very difficult without.
open Ppxlib;

/**
 * This function takes a GraphQL document as a string (typically extracted from the [%relay.<operation>] nodes),
 * uses Graphql_parser to parse the string into a list of GraphQL definitions, and then extracts the _first_ operation
 * of the document only. This is because Relay disallows multiple operations in the same definition.
 */
let extractGraphQLOperation = (~loc, str) =>
  switch (str |> Graphql_parser.parse) {
  | Ok(definitions) =>
    switch (definitions) {
    | [op] => op
    | _ =>
      Location.raise_errorf(
        ~loc,
        "Only one GraphQL operation per [%%relay]-node is allowed.",
      )
    }
  | Error(err) =>
    Location.raise_errorf(
      ~loc,
      "[%%relay]-nodes must define a single, valid GraphQL operation. GraphQL error message: %s",
      err,
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the query name. Raises an error if it's not a query
 * or the query has no name.
 */
let extractTheQueryName = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Operation({optype: Query, name: Some(name)}) => name
  | Operation({optype: Query, name: None}) =>
    Location.raise_errorf(~loc, "GraphQL query must be named.")
  | _ =>
    Location.raise_errorf(
      ~loc,
      "[%%relay.query] must contain a query definition, and nothing else.",
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the mutation name. Raises an error if it's not a mutation
 * or the mutation has no name.
 */
let extractTheMutationName = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Operation({optype: Mutation, name: Some(name)}) => name
  | Operation({optype: Mutation, name: None}) =>
    Location.raise_errorf(~loc, "GraphQL mutation must be named.")
  | _ =>
    Location.raise_errorf(
      ~loc,
      "[%%relay.mutation] must contain a mutation definition, and nothing else.",
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the fragment name. Raises an error if it's not a fragment
 * or the fragment has no name.
 */
let extractTheFragmentName = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Fragment({name}) => name
  | _ =>
    Location.raise_errorf(
      ~loc,
      "[%%relay.fragment] must contain a fragment definition with a name, and nothing else.",
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the subscription name. Raises an error if it's not a subscription
 * or the subscription has no name.
 */
let extractTheSubscriptionName = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Operation({optype: Subscription, name: Some(name)}) => name
  | Operation({optype: Subscription, name: None}) =>
    Location.raise_errorf(~loc, "GraphQL subscription must be named.")

  | _ =>
    Location.raise_errorf(
      ~loc,
      "[%%relay.subscription] must contain a subscription definition, and nothing else.",
    )
  };

/**
 * Takes a raw GraphQL document as a string and attempts to extract the refetchable query name if there's one defined.
 * Relay wants you to define refetchable fragments roughly like this:
 *
 * fragment SomeFragment_someName on SomeType @refetchable(queryName: "SomeFragmentRefetchQuery") {
 *   ...
 * }
 *
 * So, this functions makes sure that @refetchable is defined and the queryName arg exists, and if so, extracts and
 * returns "SomeFragmentRefetchQuery" as an option string.
 */
let extractFragmentRefetchableQueryName = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Fragment({name: _, directives}) =>
    let refetchableQueryName = ref(None);

    directives
    |> List.iter((dir: Graphql_parser.directive) =>
         switch (dir) {
         | {
             name: "refetchable",
             arguments: [("queryName", `String(queryName))],
           } =>
           refetchableQueryName := Some(queryName)
         | _ => ()
         }
       );

    refetchableQueryName^;
  | _ => None
  };

/**
 * This recursively traverses all selection sets and looks for a @connection directive.
 */
let rec selectionSetHasConnection = selections =>
  switch (
    selections
    |> List.find_opt(sel =>
         switch (sel) {
         | Graphql_parser.Field({directives, selection_set}) =>
           switch (
             directives
             |> List.find_opt((dir: Graphql_parser.directive) =>
                  switch (dir) {
                  | {name: "connection"} => true
                  | _ => false
                  }
                )
           ) {
           | Some(_) => true
           | None => selectionSetHasConnection(selection_set)
           }
         | _ => false
         }
       )
  ) {
  | Some(_) => true
  | None => false
  };

// Returns whether a query has a @raw_response_type
let queryHasRawResponseTypeDirective = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Operation({optype: Query, name: Some(_), directives}) =>
    directives
    |> List.exists((directive: Graphql_parser.directive) =>
         directive.name == "raw_response_type"
       )
  | _ => false
  };

// Returns whether a fragment has a @connection annotation or not
let fragmentHasConnectionNotation = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Fragment({name: _, selection_set}) =>
    selectionSetHasConnection(selection_set)
  | _ => false
  };

// Returns whether a fragment has an @inline directive defined or not
let fragmentHasInlineDirective = (~loc, str) =>
  switch (extractGraphQLOperation(~loc, str)) {
  | Fragment({name: _, directives}) =>
    directives
    |> List.exists((directive: Graphql_parser.directive) =>
         directive.name == "inline"
       )
  | _ => false
  };

let getGraphQLModuleName = opName =>
  String.capitalize_ascii(opName) ++ "_graphql";

/**
 * This is some AST voodoo to extract the provided string from [%relay.<operation> {| ...string here... |}].
 * It basically just matches on the correct AST structure for having an extension node with a string, and
 * returns that string.
 *
 * It also returns loc, which keeps track of *where* in the code the string is located, so editors can highlight
 * the actual operation string as a whole when it errors, rather than just the module keyword.
 */
let extractOperationStr = (~loc, ~expr) =>
  switch (expr) {
  | PStr([
      {
        pstr_desc:
          [@implicit_arity]
          Pstr_eval(
            {
              pexp_loc: loc,
              pexp_desc:
                Pexp_constant(
                  [@implicit_arity] Pconst_string(operationStr, _),
                ),
              _,
            },
            _,
          ),
        _,
      },
    ]) => (
      operationStr,
      loc,
    )
  | _ =>
    Location.raise_errorf(
      ~loc,
      "All [%%relay] operations must be provided a string, like [%%relay.query {| { query SomeQuery { id } |}]",
    )
  };

/**
 * This returns an AST record representing a module name definition.
 */
let makeModuleNameAst = (~loc, ~moduleName) => {
  pmod_attributes: [],
  pmod_loc: loc,
  pmod_desc:
    Pmod_ident({loc, txt: Lident(getGraphQLModuleName(moduleName))}),
};

/**
 * This constructs a module definition AST, in this case for fragments. Note it's only the definition structure,
 * not the full definition.
 */
let makeFragment =
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
      hasConnection
        ? [%stri
          module UsePaginationFragment =
            ReasonRelay.MakeUsePaginationFragment({
              type fragmentRaw = Operation.Internal.fragmentRaw;
              type fragment = Types.fragment;
              type fragmentRef = Operation.fragmentRef;
              type variables = RefetchableOperation.Types.refetchVariables;
              let fragmentSpec = Operation.node;
              let convertFragment = Operation.Internal.convertFragment;
              let convertVariables = RefetchableOperation.Internal.convertVariables;
            })
        ]
        : [%stri ()],
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
          let usePagination = fRef =>
            UsePaginationFragment.usePagination(
              fRef |> Operation.getFragmentRef,
            )
        ]
        : [%stri ()],
      hasConnection
        ? [%stri
          let useBlockingPagination = fRef =>
            UsePaginationFragment.useBlockingPagination(
              fRef |> Operation.getFragmentRef,
            )
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

/**
 * Check out the comments for makeFragment, this does the same thing but for queries.
 */
let makeQuery = (~loc, ~moduleName, ~hasRawResponseType) =>
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

/**
 * Check out the comments for makeFragment, this does the same thing but for mutations.
 */
let makeMutation = (~loc, ~moduleName) =>
  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri module Operation = [%m makeModuleNameAst(~loc, ~moduleName)]],
      [%stri include Operation.Utils],
      [%stri module Types = Operation.Types],
      [%stri
        let commitMutation:
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
            ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
            ~optimisticResponse: Types.rawResponse=?,
            ~updater: (
                        ReasonRelay.RecordSourceSelectorProxy.t,
                        Types.response
                      ) =>
                      unit
                        =?,
            ~onCompleted: (
                            Types.response,
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
            ~variables: Types.variables,
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
                  ->Operation.Internal.convertVariables
                  ->ReasonRelay.internal_cleanVariablesRaw,
                mutation: Operation.node,
                onCompleted:
                  Some(
                    (res, err) =>
                      switch (onCompleted) {
                      | Some(cb) =>
                        cb(
                          res->Operation.Internal.convertResponse,
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
                    Some(r->Operation.Internal.convertWrapRawResponse)
                  },
                optimisticUpdater,
                updater:
                  switch (updater) {
                  | None => None
                  | Some(updater) =>
                    Some(
                      (store, r) =>
                        updater(store, r->Operation.Internal.convertResponse),
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
            ~variables: Types.variables,
            ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
            ~optimisticResponse: Types.rawResponse=?,
            ~updater: (
                        ReasonRelay.RecordSourceSelectorProxy.t,
                        Types.response
                      ) =>
                      unit
                        =?,
            unit
          ) =>
          Promise.t(
            Belt.Result.t(
              (Types.response, option(array(ReasonRelay.mutationError))),
              option(ReasonRelay.mutationError),
            ),
          ) =
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
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
                      ->Operation.Internal.convertVariables
                      ->ReasonRelay.internal_cleanVariablesRaw,
                    mutation: Operation.node,
                    onCompleted:
                      Some(
                        (res, err) =>
                          resolve(
                            Ok((
                              res->Operation.Internal.convertResponse,
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
                        Some(r->Operation.Internal.convertWrapRawResponse)
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
                              r->Operation.Internal.convertResponse,
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
                    Types.response,
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
                              Types.response,
                              option(array(ReasonRelay.mutationError))
                            ) =>
                            unit
                              =?,
              ~onUnsubscribe: unit => unit=?,
              ~optimisticResponse: Types.rawResponse=?,
              ~optimisticUpdater: ReasonRelay.optimisticUpdaterFn=?,
              ~updater: (
                          ReasonRelay.RecordSourceSelectorProxy.t,
                          Types.response
                        ) =>
                        unit
                          =?,
              ~variables: Types.variables,
              unit
            ) =>
            ReasonRelay.Disposable.t,
            bool,
          ) =
          () => {
            let (mutate, mutating) =
              ReasonRelay.internal_useMutation(Operation.node);
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
                            r->Operation.Internal.convertResponse,
                            Js.Nullable.toOption(errors),
                          ),
                      )

                    | None => None
                    },
                  optimisticResponse:
                    switch (optimisticResponse) {
                    | None => None
                    | Some(r) =>
                      Some(r->Operation.Internal.convertWrapRawResponse)
                    },
                  onUnsubscribe,
                  variables:
                    variables
                    ->Operation.Internal.convertVariables
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
                            r->Operation.Internal.convertResponse,
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

/**
 * Check out the comments for makeFragment, this does the same thing but for subscriptions.
 */
let makeSubscription = (~loc, ~moduleName) =>
  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri module Operation = [%m makeModuleNameAst(~loc, ~moduleName)]],
      [%stri include Operation.Utils],
      [%stri module Types = Operation.Types],
      [%stri
        module Subscription =
          ReasonRelay.MakeUseSubscription({
            type variables = Types.variables;
            type responseRaw = Operation.Internal.responseRaw;
            type response = Types.response;
            let node = Operation.node;
            let convertResponse = Operation.Internal.convertResponse;
            let convertVariables = Operation.Internal.convertVariables;
          })
      ],
      [%stri let subscribe = Subscription.subscribe],
    ]),
  );
