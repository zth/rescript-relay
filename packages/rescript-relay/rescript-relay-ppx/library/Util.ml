open Ppxlib
let extractGraphQLOperation ~loc str =
  match str |> Graphql_parser.parse with
  | Ok definitions -> (
    match definitions with
    | [op] -> op
    | _ ->
      Location.raise_errorf ~loc
        "Only one GraphQL operation per %%relay-node is allowed.")
  | Error err ->
    Location.raise_errorf ~loc
      "%%relay-nodes must define a single, valid GraphQL operation. GraphQL \
       error message: %s"
      err
let extractTheQueryName ~loc op =
  match op with
  | Graphql_parser.Operation {optype = Query; name = Some name} -> name
  | Operation {optype = Query; name = None} ->
    Location.raise_errorf ~loc "GraphQL query must be named."
  | _ ->
    Location.raise_errorf ~loc
      "%%relay must contain a query definition, and nothing else."
let extractTheMutationName ~loc op =
  match op with
  | Graphql_parser.Operation {optype = Mutation; name = Some name} -> name
  | Operation {optype = Mutation; name = None} ->
    Location.raise_errorf ~loc "GraphQL mutation must be named."
  | _ ->
    Location.raise_errorf ~loc
      "%%relay must contain a mutation definition, and nothing else."
let extractTheFragmentName ~loc op =
  match op with
  | Graphql_parser.Fragment {name} -> name
  | _ ->
    Location.raise_errorf ~loc
      "%%relay must contain a fragment definition with a name, and nothing \
       else."
let extractTheSubscriptionName ~loc op =
  match op with
  | Graphql_parser.Operation {optype = Subscription; name = Some name} -> name
  | Operation {optype = Subscription; name = None} ->
    Location.raise_errorf ~loc "GraphQL subscription must be named."
  | _ ->
    Location.raise_errorf ~loc
      "%%relay must contain a subscription definition, and nothing else."
let extractFragmentRefetchableQueryName ~loc op =
  match op with
  | Graphql_parser.Fragment {name = _; directives} ->
    let refetchableQueryName = ref None in
    directives
    |> List.iter (fun (dir : Graphql_parser.directive) ->
           match dir with
           | {
            name = "refetchable";
            arguments = [("queryName", `String queryName)];
           } ->
             refetchableQueryName := Some queryName
           | _ -> ());
    !refetchableQueryName
  | _ -> None
let rec selectionSetHasConnection selections =
  match
    selections
    |> List.find_opt (fun sel ->
           match sel with
           | Graphql_parser.Field {directives; selection_set} -> (
             match
               directives
               |> List.find_opt (fun (dir : Graphql_parser.directive) ->
                      match dir with
                      | {name = "connection"} -> true
                      | _ -> false)
             with
             | Some _ -> true
             | None -> selectionSetHasConnection selection_set)
           | InlineFragment {selection_set} ->
             selectionSetHasConnection selection_set
           | _ -> false)
  with
  | Some _ -> true
  | None -> false
let queryHasRawResponseTypeDirective ~loc op =
  match op with
  | Graphql_parser.Operation {optype = Query; name = Some _; directives} ->
    directives
    |> List.exists (fun (directive : Graphql_parser.directive) ->
           directive.name = "raw_response_type")
  | _ -> false
let fragmentIsUpdatable op =
  match op with
  | Graphql_parser.Fragment {directives} ->
    directives
    |> List.exists (fun (directive : Graphql_parser.directive) ->
           directive.name = "updatable")
  | _ -> false
let queryIsUpdatable op =
  match op with
  | Graphql_parser.Operation {optype = Query; directives} ->
    directives
    |> List.exists (fun (directive : Graphql_parser.directive) ->
           directive.name = "updatable")
  | _ -> false
type connectionConfig = {key: string}
let extractFragmentConnectionInfo ~loc op =
  match op with
  | Graphql_parser.Fragment {name = _; selection_set} ->
    selectionSetHasConnection selection_set
  | _ -> false
let fragmentHasInlineDirective ~loc op =
  match op with
  | Graphql_parser.Fragment {name = _; directives} ->
    directives
    |> List.exists (fun (directive : Graphql_parser.directive) ->
           directive.name = "inline")
  | _ -> false

let fragmentIsPlural ~loc op =
  match op with
  | Graphql_parser.Fragment {name = _; directives} ->
    directives
    |> List.exists (fun (directive : Graphql_parser.directive) ->
           directive.name = "relay"
           && directive.arguments
              |> List.exists (fun (n, v) -> n = "plural" && v = `Bool true))
  | _ -> false
let getGraphQLModuleName opName = String.capitalize_ascii opName ^ "_graphql"

let rec longidentFromStrings = function
  | [] -> failwith "Cannot create Longident from empty list"
  | [s] -> Longident.Lident s
  | s :: rest -> Longident.Ldot (longidentFromStrings rest, s)

let makeTypeAccessorRaw ~loc path =
  Ppxlib.Ast_helper.Typ.constr ~loc
    {txt = longidentFromStrings (path |> List.rev); loc}
    []

let makeTypeAccessor ~loc ~moduleName path =
  let gqlModuleName = getGraphQLModuleName moduleName in
  let path = gqlModuleName :: path |> List.rev in
  Ppxlib.Ast_helper.Typ.constr ~loc {txt = longidentFromStrings path; loc} []
let makeTypeAccessorWithParams ~loc ~params path =
  Ppxlib.Ast_helper.Typ.constr ~loc
    {txt = longidentFromStrings (path |> List.rev); loc}
    params
let makeExprAccessor ~loc ~moduleName path =
  let gqlModuleName = getGraphQLModuleName moduleName in
  let path = gqlModuleName :: path |> List.rev in
  Ppxlib.Ast_helper.Exp.ident ~loc {txt = longidentFromStrings path; loc}
let makeStringExpr ~loc str =
  Ppxlib.Ast_helper.Exp.constant ~loc (Ppxlib.Ast_helper.Const.string str)
let makeModuleIdent ~loc ~moduleName path =
  let gqlModuleName = getGraphQLModuleName moduleName in
  let path = gqlModuleName :: path |> List.rev in
  Ppxlib.Ast_helper.Mod.ident ~loc {txt = longidentFromStrings path; loc}
