exception No_extractable_operations_found;

let transformVariables =
    (~variables: Types.object_, ~config: Types.printConfig) => {
  switch (config.variables_holding_connection_ids) {
  | None => variables
  | Some(variable_names) => {
      ...variables,
      values:
        variables.values
        |> List.map(v =>
             switch (v) {
             | Types.Prop(variable_name, prop_value)
                 when List.exists(v => v == variable_name, variable_names) =>
               Types.Prop(
                 variable_name,
                 {
                   ...prop_value,
                   propType:
                     Array({
                       comment: None,
                       nullable: false,
                       propType: DataId,
                     }),
                 },
               )
             | v => v
             }
           ),
    }
  };
};

/**
 * Print the full state, and whatever utils/types etc are needed.
 */
let getPrintedFullState =
    (~operationType, ~config: Types.printConfig, state: Types.fullState)
    : string => {
  let finalStr = ref("/* @generated */\n");
  let addToStr = Utils.makeAddToStr(finalStr);

  addToStr({|%%raw("/* @generated */")|});

  let definitions: ref(list(Types.rootType)) = ref([]);
  let addDefinition = Utils.makeAddToList(definitions);

  let typeDeclarations: ref(list(Types.rootType)) = ref([]);
  let addTypeDeclaration = Utils.makeAddToList(typeDeclarations);

  // Gather all type declarations and definitions.
  state.objects
  |> Tablecloth.List.sortBy(
       ~f=
         fun
         | {Types.originalFlowTypeName: Some(_)} => (-1)
         | {originalFlowTypeName: None} => 1,
     )
  |> Tablecloth.List.iter(
       ~f=
         fun
         | {Types.foundInUnion: false, recordName: Some(name)} as obj =>
           addTypeDeclaration(
             Types.(
               ObjectTypeDeclaration({
                 name,
                 definition:
                   switch (config.connection) {
                   | Some({atObjectPath}) when atObjectPath == obj.atPath => {
                       ...obj.definition,
                       comment:
                         Some(
                           "Hint: You can extract all nodes from this connection to an array of non-nullable nodes using the `FragmentModule.getConnectionNodes` helper, like `let nodes = FragmentModule.getConnectionNodes(connectionGoesHere)`. `FragmentModule` is whatever you've named the module where you have defined your fragment.",
                         ),
                     }
                   | _ => obj.definition
                   },
                 atPath: obj.atPath,
               })
             ),
           )
         | _ => (),
     );

  // We check and add all definitions we've found to a list that'll later be printed as types.
  switch (state.variables) {
  | Some(variables) =>
    addDefinition(
      Types.(Variables(Object(transformVariables(~variables, ~config)))),
    )
  | None => ()
  };

  // Adds refetchVariables only to query output
  switch (state.variables, operationType) {
  | (Some(variables), Types.Query(_)) =>
    addDefinition(Types.(RefetchVariables(variables)))
  | _ => ()
  };

  switch (state.fragment, state.rawResponse) {
  | (None, Some(rawResponse)) =>
    addDefinition(Types.(RawResponse(Some(Object(rawResponse)))))
  | (None, None) => addDefinition(Types.(RawResponse(None)))
  | (Some(_), _) => ()
  };

  switch (state.response) {
  | Some(response) => addDefinition(Types.(Operation(Object(response))))
  | None => ()
  };

  switch (state.fragment) {
  | Some({definition, plural}) =>
    addDefinition(
      plural ? Types.PluralFragment(definition) : Types.Fragment(definition),
    )
  | None => ()
  };

  // Print definitions and declarations
  addToStr("\nmodule Types = {\n");
  let insideTypes = ref("");
  let addToTypesModule = Utils.makeAddToStr(insideTypes);
  // We turn off warning 30 because it's quite likely that record field labels will overlap in GraphQL
  addToTypesModule("@@ocaml.warning(\"-30\")\n\n");

  // Print enums
  state.enums
  |> List.iter(enum => {addToTypesModule(Printer.printEnum(enum) ++ "\n")});

  state.unions
  |> List.iter(({union, printName}: Types.unionInState) => {
       Printer.printUnionTypes(union, ~state, ~printName) |> addToTypesModule
     });

  // Split declarations so we can print object declarations first and as mutuals
  let (otherDeclarations, objectDeclarations) =
    typeDeclarations^
    |> Tablecloth.List.splitWhen(
         ~f=
           fun
           | Types.ObjectTypeDeclaration(_) => true
           | _ => false,
       );

  let numObjectDeclarations = Tablecloth.List.length(objectDeclarations);

  // Print object declarations first

  Printer.(
    objectDeclarations
    |> List.iteri((index, def) => {
         def
         |> printRootType(
              ~recursiveMode=
                switch (index, numObjectDeclarations) {
                | (0, _) => Some(`Head)
                | (index, num) when index + 1 == num => Some(`Tail)
                | _ => Some(`Member)
                },
              ~state,
            )
         |> addToTypesModule
       })
  );

  Printer.(
    otherDeclarations
    |> List.iter(def =>
         def
         |> printRootType(
              ~recursiveMode=None,
              ~state,
            )
         |> addToTypesModule
       )
  );

  Printer.(
    definitions^
    |> List.iter(def => {
         def
         |> printRootType(
              ~state,
            )
         |> addToTypesModule
       })
  );

  addToStr(Utils.print_indented(2, insideTypes^));
  addToStr("\n}\n\n");

  if (state.unions |> List.length > 0) {
    state.unions
    |> List.iter(({union}: Types.unionInState) =>
         union |> Printer.printUnionConverters |> addToStr
       );
  };

  // This emits extra assets for the generated modules,
  // like code for converting nullable fields, enums and unions,
  // and code for extracting fragment refs.
  addToStr("module Internal = {\n");
  let in_internal = ref("");
  let add_to_internal = Utils.makeAddToStr(in_internal);

  let rootObjects =
    state.objects
    |> Tablecloth.List.filter(
         ~f=
           fun
           | {Types.originalFlowTypeName: Some(_), recordName: Some(_)} =>
             true
           | _ => false,
       );

  switch (state.fragment) {
  | Some({definition}) =>
    add_to_internal(
      TypesTransformerUtils.printConverterAssets(
        ~rootObjects,
        ~definition,
        "fragment",
      )
      ++ "\n",
    )
  | None => ()
  };

  switch (state.response) {
  | Some(definition) =>
    switch (operationType) {
    | Query(_)
    | Mutation(_) =>
      add_to_internal(
        TypesTransformerUtils.printConverterAssets(
          ~rootObjects,
          ~direction=Wrap,
          ~nullableType=Null,
          ~definition=Object(definition),
          "wrapResponse",
        )
        ++ "\n",
      )
    | _ => ()
    };

    add_to_internal(
      TypesTransformerUtils.printConverterAssets(
        ~rootObjects,
        ~definition=Object(definition),
        "response",
      )
      ++ "\n",
    );
  | None => ()
  };

  switch (state.response, state.rawResponse) {
  | (Some(_), Some(definition)) =>
    switch (operationType) {
    | Query(_)
    | Mutation(_) =>
      add_to_internal(
        TypesTransformerUtils.printConverterAssets(
          ~rootObjects,
          ~direction=Wrap,
          ~nullableType=Null,
          ~definition=Object(definition),
          "wrapRawResponse",
        )
        ++ "\n",
      )
    | _ => ()
    };

    add_to_internal(
      TypesTransformerUtils.printConverterAssets(
        ~rootObjects,
        ~definition=Object(definition),
        "rawResponse",
      )
      ++ "\n",
    );
  | (Some(_), None) =>
    switch (operationType) {
    | Query(_)
    | Mutation(_) =>
      add_to_internal(
        "type wrapRawResponseRaw = wrapResponseRaw\n"
        ++ "let convertWrapRawResponse = convertWrapResponse\n",
      )
    | _ => ()
    };

    add_to_internal(
      "type rawResponseRaw = responseRaw\n"
      ++ "let convertRawResponse = convertResponse\n",
    );
  | (None, _) => ()
  };

  switch (state.variables) {
  | Some(definition) =>
    add_to_internal(
      TypesTransformerUtils.printConverterAssets(
        ~rootObjects,
        ~includeRaw=false,
        ~direction=Wrap,
        ~definition=Object(definition),
        "variables",
      )
      ++ "\n",
    )
  | None => ()
  };
  addToStr(Utils.print_indented(2, in_internal^));
  addToStr("\n}\n");

  // Print fragment assets
  switch (state.fragment) {
  | Some({name, plural}) =>
    addToStr(Printer.fragmentRefAssets(~plural, name) ++ "\n")
  | None => ()
  };

  // Print query assets
  switch (operationType) {
  | Query(_) => addToStr("\ntype queryRef")
  | _ => ()
  };

  // Utils that'll be included and accessible at the top level of the generated module
  addToStr("\n\nmodule Utils = {\n");
  let utils_content = ref("");
  let add_to_utils = Utils.makeAddToStr(utils_content);

  // Enum toString functions
  state.enums
  |> List.iter(enum => {
       enum |> Printer.printEnumToStringFn |> add_to_utils;
       add_to_utils("\n");
     });

  // We print a helper for extracting connection nodes whenever there's a connection present.
  switch (config.connection) {
  | Some(connection) =>
    let connPath = connection.atObjectPath;

    // Print the connection key so it can be referenced from the outside if needed.
    add_to_utils("@inline\nlet connectionKey = \"" ++ connection.key ++ "\"\n\n")

    switch (
      state.objects
      |> Tablecloth.List.find(~f=(o: Types.finalizedObj) => {
           o.atPath == connPath
         }),
      state.fragment,
    ) {
    | (Some(obj), _) =>
      obj.definition
      |> UtilsPrinter.printGetConnectionNodesFunction(
           ~functionName="getConnectionNodes",
           ~state,
           ~connectionLocation=connection.fieldName,
         )
      |> add_to_utils
    | (None, Some({definition: Object(definition)}))
        when connPath == ["fragment"] =>
      definition
      |> UtilsPrinter.printGetConnectionNodesFunction(
           ~functionName="getConnectionNodes",
           ~state,
           ~connectionLocation=connection.fieldName,
         )
      |> add_to_utils
    | (None, Some({definition: Union(_)}))
    | (None, Some(_))
    | (None, None) => ()
    };
  | None => ()
  };

  // We print maker functions for all input objects
  state.objects
  |> Tablecloth.List.iter(
       ~f=
         fun
         | {Types.originalFlowTypeName: Some(typeName), definition} => {
             definition
             |> Printer.printObjectMaker(
                  ~targetType=Tablecloth.String.uncapitalize(typeName),
                  ~name="make_" ++ Tablecloth.String.uncapitalize(typeName),
                )
             |> add_to_utils;
             add_to_utils("\n");
           }
         | _ => (),
     );

  // Add a maker function for the variables if variables exist
  switch (state.variables) {
  | None => ()
  | Some(variables) =>
    variables |> Printer.objHasPrintableContents
      ? {
        Printer.printObjectMaker(
          variables,
          ~targetType="variables",
          ~name="makeVariables",
        )
        |> add_to_utils;
      }
      : ()
  };

  // Emit make function for optimistic responses
  switch (operationType, state.response) {
  | (Mutation(_), Some(response)) =>
    state.objects
    |> Tablecloth.List.filter_map(
         ~f=
           fun
           | {
               Types.definition,
               originalFlowTypeName: None,
               recordName: Some(name),
             } =>
             Some((name, definition))
           | _ => None,
       )
    |> List.iter(((name, obj)) => {
         Printer.printObjectMaker(
           obj,
           ~targetType=name,
           ~name="make_" ++ name,
         )
         |> add_to_utils
       });

    Printer.printObjectMaker(
      response,
      ~targetType="rawResponse",
      ~name="makeOptimisticResponse",
    )
    |> add_to_utils;
  | _ => ()
  };

  if (utils_content^ != "") {
    addToStr("  open Types\n");
  };

  addToStr(Utils.print_indented(2, utils_content^) ++ "\n}\n");

  // Open Types locally here if we have any content to print

  // This adds operationType, which is referenced in the raw output of the Relay
  // runtime representation.
  addToStr(Printer.printOperationType(operationType));

  switch (state) {
  | {fragment: None, response: None, variables: None} =>
    raise(No_extractable_operations_found)
  | _ => ()
  };

  finalStr^;
};
