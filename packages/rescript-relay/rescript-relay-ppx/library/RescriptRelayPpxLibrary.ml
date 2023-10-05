open Ppxlib
open Util
module Util = Util
module UncurriedUtils = UncurriedUtils
let endsWithRegexp = Str.regexp ".*Resolver$"
let commonExtension =
  Extension.declare "relay" Extension.Context.module_expr
    (let open Ast_pattern in
    single_expr_payload (estring __))
    (fun ~loc ~path:_ operationStr ->
      let op = extractGraphQLOperation ~loc operationStr in
      match op with
      | Graphql_parser.Fragment {name = fragmentName; selection_set} ->
        if Str.string_match endsWithRegexp fragmentName 0 then
          RelayResolverFragment.make ~loc
            ~moduleName:(op |> extractTheFragmentName ~loc)
        else
          let refetchableQueryName =
            op |> extractFragmentRefetchableQueryName ~loc
          in
          Fragment.make
            ~moduleName:(op |> extractTheFragmentName ~loc)
            ~refetchableQueryName
            ~extractedConnectionInfo:(op |> extractFragmentConnectionInfo ~loc)
            ~hasInlineDirective:(op |> fragmentHasInlineDirective ~loc)
            ~loc
      | Operation {optype = Query} ->
        Query.make
          ~moduleName:(op |> extractTheQueryName ~loc)
          ~hasRawResponseType:(op |> queryHasRawResponseTypeDirective ~loc)
          ~loc
      | Operation {optype = Mutation} ->
        Mutation.make ~moduleName:(op |> extractTheMutationName ~loc) ~loc
      | Operation {optype = Subscription} ->
        Subscription.make
          ~moduleName:(op |> extractTheSubscriptionName ~loc)
          ~loc)
let () =
  Driver.register_transformation
    ~extensions:[commonExtension; DeferredComp.lazyExtension]
    "rescript-relay"
