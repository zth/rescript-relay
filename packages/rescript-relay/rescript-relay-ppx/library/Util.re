// Ppxlib provides a number of helpers for writing and registering PPXs that life is very difficult without.
open Ppxlib;

/**
 * This function takes a GraphQL document as a string (typically extracted from the [%relay] nodes),
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
        "Only one GraphQL operation per %%relay-node is allowed.",
      )
    }
  | Error(err) =>
    Location.raise_errorf(
      ~loc,
      "%%relay-nodes must define a single, valid GraphQL operation. GraphQL error message: %s",
      err,
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the query name. Raises an error if it's not a query
 * or the query has no name.
 */
let extractTheQueryName = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Operation({optype: Query, name: Some(name)}) => name
  | Operation({optype: Query, name: None}) =>
    Location.raise_errorf(~loc, "GraphQL query must be named.")
  | _ =>
    Location.raise_errorf(
      ~loc,
      "%%relay must contain a query definition, and nothing else.",
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the mutation name. Raises an error if it's not a mutation
 * or the mutation has no name.
 */
let extractTheMutationName = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Operation({optype: Mutation, name: Some(name)}) => name
  | Operation({optype: Mutation, name: None}) =>
    Location.raise_errorf(~loc, "GraphQL mutation must be named.")
  | _ =>
    Location.raise_errorf(
      ~loc,
      "%%relay must contain a mutation definition, and nothing else.",
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the fragment name. Raises an error if it's not a fragment
 * or the fragment has no name.
 */
let extractTheFragmentName = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Fragment({name}) => name
  | _ =>
    Location.raise_errorf(
      ~loc,
      "%%relay must contain a fragment definition with a name, and nothing else.",
    )
  };

/**
 * Takes a raw GraphQL document as a string and extracts the subscription name. Raises an error if it's not a subscription
 * or the subscription has no name.
 */
let extractTheSubscriptionName = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Operation({optype: Subscription, name: Some(name)}) => name
  | Operation({optype: Subscription, name: None}) =>
    Location.raise_errorf(~loc, "GraphQL subscription must be named.")

  | _ =>
    Location.raise_errorf(
      ~loc,
      "%%relay must contain a subscription definition, and nothing else.",
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
let extractFragmentRefetchableQueryName = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Fragment({name: _, directives}) =>
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

let rec extractFieldWithConnectionDirective =
        (selections): option(Graphql_parser.field) =>
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
  | Some(Field(v)) => Some(v)
  | Some(FragmentSpread(_) | InlineFragment(_))
  | None => None
  };

// Returns whether a query has a @raw_response_type
let queryHasRawResponseTypeDirective = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Operation({optype: Query, name: Some(_), directives}) =>
    directives
    |> List.exists((directive: Graphql_parser.directive) =>
         directive.name == "raw_response_type"
       )
  | _ => false
  };

// Returns whether a fragment has a @connection annotation or not
let fragmentHasConnectionNotation = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Fragment({name: _, selection_set}) =>
    selectionSetHasConnection(selection_set)
  | _ => false
  };

type connectionConfig = {key: string};

let extractFragmentConnectionInfo = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Fragment({name: _, selection_set}) =>
    let fieldWithConnection =
      extractFieldWithConnectionDirective(selection_set);

    switch (fieldWithConnection) {
    | None => None
    | Some(field) =>
      let connectionDirective =
        field.directives
        |> List.find_opt((d: Graphql_parser.directive) =>
             switch (d) {
             | {Graphql_parser.name: "connection"} => true
             | _ => false
             }
           );
      switch (connectionDirective) {
      | None => None
      | Some(directive) =>
        let key =
          directive.arguments
          |> List.find_opt(((key, _)) =>
               switch (key) {
               | "key" => true
               | _ => false
               }
             );

        switch (key) {
        | Some(("key", `String(key))) => Some({key: key})
        | _ => None
        };
      };
    };
  | _ => None
  };

// Returns whether a fragment has an @inline directive defined or not
let fragmentHasInlineDirective = (~loc, op) =>
  switch (op) {
  | Graphql_parser.Fragment({name: _, directives}) =>
    directives
    |> List.exists((directive: Graphql_parser.directive) =>
         directive.name == "inline"
       )
  | _ => false
  };

let getGraphQLModuleName = opName =>
  String.capitalize_ascii(opName) ++ "_graphql";

let makeTypeAccessor = (~loc, ~moduleName, path) => {
  let gqlModuleName = Lident(getGraphQLModuleName(moduleName));

  Ppxlib.Ast_helper.Typ.constr(
    ~loc,
    {
      txt:
        switch (path) {
        | [t] => Ldot(gqlModuleName, t)
        | [innerModule, t] => Ldot(Ldot(gqlModuleName, innerModule), t)
        | _ => gqlModuleName
        },
      loc,
    },
    [],
  );
};

let makeExprAccessor = (~loc, ~moduleName, path) => {
  let gqlModuleName = Lident(getGraphQLModuleName(moduleName));

  Ppxlib.Ast_helper.Exp.ident(
    ~loc,
    {
      txt:
        switch (path) {
        | [t] => Ldot(gqlModuleName, t)
        | [innerModule, t] => Ldot(Ldot(gqlModuleName, innerModule), t)
        | _ => gqlModuleName
        },
      loc,
    },
  );
};

let makeStringExpr = (~loc, str) =>
  Ppxlib.Ast_helper.Exp.constant(~loc, Ppxlib.Ast_helper.Const.string(str));

let makeModuleIdent = (~loc, ~moduleName, path) => {
  let gqlModuleName = Lident(getGraphQLModuleName(moduleName));

  Ppxlib.Ast_helper.Mod.ident(
    ~loc,
    {
      txt:
        switch (path) {
        | [t] => Ldot(gqlModuleName, t)
        | [innerModule, t] => Ldot(Ldot(gqlModuleName, innerModule), t)
        | _ => gqlModuleName
        },
      loc,
    },
  );
};
