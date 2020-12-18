open Ppxlib;
open Util;

module Util = Util;

/**
 * This is what defines [%relay.query] as an extension point and provides the PPX
 * with how to transform the extension point when it finds one.
 */
let queryExtension =
  Extension.declare(
    "relay.query",
    Extension.Context.module_expr,
    Ast_pattern.__,
    (~loc, ~path as _, expr) => {
      let (operationStr, operationStrLoc) = extractOperationStr(~loc, ~expr);
      let op = extractGraphQLOperation(~loc, operationStr);

      Query.make(
        ~moduleName=op |> extractTheQueryName(~loc=operationStrLoc),
        ~hasRawResponseType=
          op |> queryHasRawResponseTypeDirective(~loc=operationStrLoc),
        ~loc=operationStrLoc,
      );
    },
  );

// Same as queryExtension but for [%relay.fragment]
let fragmentExtension =
  Extension.declare(
    "relay.fragment",
    Extension.Context.module_expr,
    Ast_pattern.__,
    (~loc, ~path as _, expr) => {
      let (operationStr, operationStrLoc) = extractOperationStr(~loc, ~expr);
      let op = extractGraphQLOperation(~loc, operationStr);

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
    },
  );

// Same as queryExtension but for [%relay.mutation]
let mutationExtension =
  Extension.declare(
    "relay.mutation",
    Extension.Context.module_expr,
    Ast_pattern.__,
    (~loc, ~path as _, expr) => {
      let (operationStr, operationStrLoc) = extractOperationStr(~loc, ~expr);
      let op = extractGraphQLOperation(~loc, operationStr);

      Mutation.make(
        ~moduleName=op |> extractTheMutationName(~loc=operationStrLoc),
        ~loc=operationStrLoc,
      );
    },
  );

// Same as queryExtension but for [%relay.subscription]
let subscriptionExtension =
  Extension.declare(
    "relay.subscription",
    Extension.Context.module_expr,
    Ast_pattern.__,
    (~loc, ~path as _, expr) => {
      let (operationStr, operationStrLoc) = extractOperationStr(~loc, ~expr);
      let op = extractGraphQLOperation(~loc, operationStr);

      Subscription.make(
        ~moduleName=op |> extractTheSubscriptionName(~loc=operationStrLoc),
        ~loc=operationStrLoc,
      );
    },
  );

// This registers all defined extension points to the "reason-relay" ppx.
let () =
  Driver.register_transformation(
    ~extensions=[
      queryExtension,
      fragmentExtension,
      mutationExtension,
      subscriptionExtension,
    ],
    "reason-relay",
  );
