open Ppxlib;
open Util;

module Util = Util;

let commonExtension =
  Extension.declare(
    "relay",
    Extension.Context.module_expr,
    Ast_pattern.__,
    (~loc, ~path as _, expr) => {
      let (operationStr, operationStrLoc) = extractOperationStr(~loc, ~expr);
      let op = extractGraphQLOperation(~loc, operationStr);

      switch (op) {
      | Graphql_parser.Fragment({name: _, selection_set}) =>
        let refetchableQueryName =
          op |> extractFragmentRefetchableQueryName(~loc=operationStrLoc);

        Fragment.make(
          ~moduleName=op |> extractTheFragmentName(~loc=operationStrLoc),
          ~refetchableQueryName,
          ~hasConnection=
            switch (
              refetchableQueryName,
              op |> fragmentHasConnectionNotation(~loc=operationStrLoc),
            ) {
            | (Some(_), true) => true
            | _ => false
            },
          ~hasInlineDirective=
            op |> fragmentHasInlineDirective(~loc=operationStrLoc),
          ~loc=operationStrLoc,
        );
      | Operation({optype: Query}) =>
        Query.make(
          ~moduleName=op |> extractTheQueryName(~loc=operationStrLoc),
          ~hasRawResponseType=
            op |> queryHasRawResponseTypeDirective(~loc=operationStrLoc),
          ~loc=operationStrLoc,
        )
      | Operation({optype: Mutation}) =>
        Mutation.make(
          ~moduleName=op |> extractTheMutationName(~loc=operationStrLoc),
          ~loc=operationStrLoc,
        )
      | Operation({optype: Subscription}) =>
        Subscription.make(
          ~moduleName=op |> extractTheSubscriptionName(~loc=operationStrLoc),
          ~loc=operationStrLoc,
        )
      };
    },
  );

// This registers all defined extension points to the "reason-relay" ppx.
let () =
  Driver.register_transformation(
    ~extensions=[commonExtension],
    "reason-relay",
  );
