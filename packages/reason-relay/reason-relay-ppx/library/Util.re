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

let makeTypeAccessor = (~loc, ~moduleName, path) =>
  Ppxlib.Ast_helper.Typ.constr(
    ~loc,
    {
      txt:
        switch (path) {
        | [t] => Ldot(Lident(getGraphQLModuleName(moduleName)), t)
        | [innerModule, t] =>
          Ldot(
            Ldot(Lident(getGraphQLModuleName(moduleName)), innerModule),
            t,
          )
        | _ => Lident(getGraphQLModuleName(moduleName))
        },
      loc,
    },
    [],
  );

let makeExprAccessor = (~loc, ~moduleName, path) =>
  Ppxlib.Ast_helper.Exp.ident(
    ~loc,
    {
      txt:
        switch (path) {
        | [t] => Ldot(Lident(getGraphQLModuleName(moduleName)), t)
        | [innerModule, t] =>
          Ldot(
            Ldot(Lident(getGraphQLModuleName(moduleName)), innerModule),
            t,
          )
        | _ => Lident(getGraphQLModuleName(moduleName))
        },
      loc,
    },
  );

let makeModuleIdent = (~loc, ~moduleName, path) =>
  Ppxlib.Ast_helper.Mod.ident(
    ~loc,
    {
      txt:
        switch (path) {
        | [t] => Ldot(Lident(getGraphQLModuleName(moduleName)), t)
        | [innerModule, t] =>
          Ldot(
            Ldot(Lident(getGraphQLModuleName(moduleName)), innerModule),
            t,
          )
        | _ => Lident(getGraphQLModuleName(moduleName))
        },
      loc,
    },
  );

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

let makeModuleAccessorAst = (~loc, ~moduleName, ~path) => {
  pmod_attributes: [],
  pmod_loc: loc,
  pmod_desc:
    Pmod_ident({loc, txt: Ldot(path, getGraphQLModuleName(moduleName))}),
};

let makeGraphQLModuleAccessor1 =
    (~loc, ~moduleName, ~innerModuleName, ~typeName) => {
  Ldot(
    Ldot(Lident(typeName), innerModuleName),
    getGraphQLModuleName(moduleName),
  );
};
