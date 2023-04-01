open Ppxlib;
open Util;

module Util = Util;

let endsWithRegexp = Str.regexp(".*Resolver$");

let commonExtension =
  Extension.declare(
    "relay",
    Extension.Context.module_expr,
    Ast_pattern.(single_expr_payload(estring(__))),
    (~loc, ~path as _, operationStr) => {
      let op = extractGraphQLOperation(~loc, operationStr);

      switch (op) {
      | Graphql_parser.Fragment({name: fragmentName, selection_set}) =>
        if (Str.string_match(endsWithRegexp, fragmentName, 0)) {
          RelayResolverFragment.make(
            ~loc,
            ~moduleName=op |> extractTheFragmentName(~loc),
          );
        } else {
          let refetchableQueryName =
            op |> extractFragmentRefetchableQueryName(~loc);

          Fragment.make(
            ~moduleName=op |> extractTheFragmentName(~loc),
            ~refetchableQueryName,
            ~extractedConnectionInfo=
              op |> extractFragmentConnectionInfo(~loc),
            ~hasInlineDirective=op |> fragmentHasInlineDirective(~loc),
            ~loc,
          );
        }

      | Operation({optype: Query}) =>
        Query.make(
          ~moduleName=op |> extractTheQueryName(~loc),
          ~hasRawResponseType=op |> queryHasRawResponseTypeDirective(~loc),
          ~loc,
        )
      | Operation({optype: Mutation}) =>
        Mutation.make(~moduleName=op |> extractTheMutationName(~loc), ~loc)
      | Operation({optype: Subscription}) =>
        Subscription.make(
          ~moduleName=op |> extractTheSubscriptionName(~loc),
          ~loc,
        )
      };
    },
  );





// This registers all defined extension points to the "rescript-relay" ppx.
let () =
  Driver.register_transformation(
    ~extensions=[
      commonExtension,
      LazyComp.lazyExtension,
      DeferredComp.lazyExtension,
    ],
    ~preprocess_impl=Transform.structure_mapper,
    "rescript-relay",
  );
