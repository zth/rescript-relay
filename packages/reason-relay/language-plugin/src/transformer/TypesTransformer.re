/**
 * The TypesTransformer does the following:
 * 1. Traverse the generated Flow types coming from Relay and extract an intermediate state from them,
 *    containing all enums, unions, objects, operations, variables etc.
 * 2. Convert the intermediate state to a full state, applying conversions as needed.
 * 3. Print the full state to Reason types + utils and helpers needed.
 */
open GabnorBsFlowParser;

exception Missing_typename_field_on_union;
exception Could_not_map_number;
exception No_extractable_operations_found;
exception Object_path_empty;

let parse_options: option(Parser_env.parse_options) =
  Some({
    esproposal_class_instance_fields: true,
    esproposal_class_static_fields: true,
    esproposal_decorators: true,
    esproposal_export_star_as: true,
    esproposal_optional_chaining: true,
    esproposal_nullish_coalescing: true,
    types: true,
    use_strict: false,
  });

type propList('a, 'b) = list(Flow_ast.Type.Object.property('a, 'b));

/**
 * Produce a fullState from an intermediateState, extracting enums, unions, all objects
 * and what not.
 */
let intermediateToFull =
    (intermediateState: Types.intermediateState): Types.fullState => {
  let initialState: Types.fullState = {
    enums: intermediateState.enums,
    unions: [],
    objects:
      intermediateState.objects
      |> List.map((obj: Types.obj) =>
           (
             {
               name: obj.name,
               typeName: obj.name,
               atPath: ["root"],
               definition: obj.definition,
             }: Types.finalizedObj
           )
         ),
    variables:
      switch (intermediateState.variables) {
      | Some(v) => Some(v.definition)
      | None => None
      },
    response:
      switch (intermediateState.response) {
      | Some(v) => Some(v.definition)
      | None => None
      },
    fragment: intermediateState.fragment,
  };

  let state = ref(initialState);

  let usedRecordNames: ref(list(string)) = ref([]);
  let addUsedRecordName = Utils.makeAddToList(usedRecordNames);

  let setState = updater => state := updater(state^);
  let addEnum = enum => setState(s => {...s, enums: [enum, ...s.enums]});
  let addUnion = union =>
    setState(s => {...s, unions: [union, ...s.unions]});
  let addObject = obj => setState(s => {...s, objects: [obj, ...s.objects]});

  let rec traverseDefinition =
          (~atPath: list(string), definition: Types.object_) =>
    definition.values |> Array.iter(traversePropValue(~atPath))
  and traversePropValue =
      (~atPath: list(string), propValue: Types.propValues) =>
    switch (propValue) {
    | FragmentRef(_) => ()
    | Prop(name, {propType}) =>
      let newAtPath = [name, ...atPath];
      switch (propType) {
      | Array({propType: Enum(enum)})
      | Enum(enum) => addEnum(enum)
      | Array({propType: Union(union)})
      | Union(union) => addUnion(union)
      | Array({propType: Object(definition)})
      | Object(definition) =>
        addObject({
          atPath: newAtPath,
          typeName: None,
          name: None,
          definition,
        });
        definition |> traverseDefinition(~atPath=newAtPath);
      | Array(_)
      | Scalar(_)
      | FragmentRefValue(_)
      | TypeReference(_)
      | ObjectReference(_) => ()
      };
    };

  switch (state^.variables) {
  | Some(d) => d |> traverseDefinition(~atPath=["variables"])
  | None => ()
  };

  switch (state^.response) {
  | Some(d) => d |> traverseDefinition(~atPath=["response"])
  | None => ()
  };

  switch (state^.fragment) {
  | Some(d) => d.definition |> traverseDefinition(~atPath=["fragment"])
  | None => ()
  };

  setState(s =>
    {
      ...s,
      objects:
        s.objects
        |> List.map((obj: Types.finalizedObj) => {
             let typeName =
               switch (obj.typeName) {
               | None =>
                 let name =
                   Utils.findAppropriateObjName(
                     ~prefix=None,
                     ~usedRecordNames=usedRecordNames^,
                     ~path=obj.atPath,
                   );
                 addUsedRecordName(name);
                 Some(name);
               | s => s
               };

             {...obj, typeName};
           }),
    }
  );

  state^;
};

/**
 * Print the full state, and whatever utils/types etc are needed.
 */
let getPrintedFullState = (~operationType, state: Types.fullState): string => {
  let finalStr = ref("/* @generated */\n\n");
  let addToStr = Utils.makeAddToStr(finalStr);

  let addSpacing = () => addToStr("\n\n\n");

  let definitions: ref(list(Types.rootType)) = ref([]);
  let addDefinition = Utils.makeAddToList(definitions);

  let typeDeclarations: ref(list(Types.rootType)) = ref([]);
  let addTypeDeclaration = Utils.makeAddToList(typeDeclarations);

  // Gather all type declarations and definitions.
  state.objects
  |> List.iter((obj: Types.finalizedObj) => {
       switch (obj.typeName, obj.name) {
       | (Some(name), Some(_)) =>
         addTypeDeclaration(
           Types.(
             ObjectTypeDeclaration({
               name,
               definition: obj.definition,
               atPath: obj.atPath,
             })
           ),
         )
       | (Some(name), None) =>
         addTypeDeclaration(
           Types.(
             ObjectTypeDeclaration({
               name,
               definition: obj.definition,
               atPath: obj.atPath,
             })
           ),
         )
       | _ => ()
       }
     });

  // We check and add all definitions we've found to a list that'll later be printed as types.
  switch (state.variables) {
  | Some(variables) => addDefinition(Types.(Variables(variables)))
  | None => ()
  };

  // Adds refetchVariables only to query output
  switch (state.variables, operationType) {
  | (Some(variables), Types.Query(_)) =>
    addDefinition(Types.(RefetchVariables(variables)))
  | _ => ()
  };

  switch (state.response) {
  | Some(response) => addDefinition(Types.(Operation(response)))
  | None => ()
  };

  switch (state.fragment) {
  | Some({definition, plural}) =>
    addDefinition(
      plural ? Types.PluralFragment(definition) : Types.Fragment(definition),
    )
  | None => ()
  };

  // Print unions
  addToStr("module Unions = {\n");
  addToStr(
    state.unions
    |> Tablecloth.List.map(~f=Printer.printUnion(~state))
    |> Tablecloth.String.join(~sep="\n\n"),
  );

  addToStr("};");
  addSpacing();

  // We'll open the Union module locally in our generated file if there's contents
  switch (state.unions |> Tablecloth.List.length) {
  | 0 => ()
  | _ =>
    addToStr("open Unions;");
    addSpacing();
  };

  // Print definitions and declarations
  addToStr("module Types = {\n");
  Printer.(
    typeDeclarations^
    |> List.rev
    |> List.iter(def => {def |> printRootType(~state) |> addToStr})
  );

  addToStr("};");
  addSpacing();

  // We'll open the Types module locally in our generated file if there's contents
  switch (typeDeclarations^ |> Tablecloth.List.length) {
  | 0 => ()
  | _ =>
    addToStr("open Types;");
    addSpacing();
  };

  Printer.(
    definitions^
    |> List.iter(def => {def |> printRootType(~state) |> addToStr})
  );

  addSpacing();

  /**
 * Since our type checking for fragments/fragment references rely on Js.t due
 * to needing structural typing, we emit converters that take a record (that's
 * backed by an object containing fragment references) and converting it to a
 * Js.t object _only_ containing the fragment reference(s). This can then be
 * passed to the fragment use hook to get the actual fragment data.
 *
 * Not the cleanest solution, can hopefully revisit this in the future.
 */
  addToStr("module FragmentConverters: {");
  Printer.(
    typeDeclarations^
    |> List.rev
    |> List.iter(def => {
         def
         |> printRootObjectTypeConverters(~state, ~printMode=Signature)
         |> addToStr
       })
  );
  Printer.(
    definitions^
    |> List.rev
    |> List.iter(def => {
         def
         |> printRootObjectTypeConverters(~state, ~printMode=Signature)
         |> addToStr
       })
  );

  addToStr("\n} = {");
  Printer.(
    typeDeclarations^
    |> List.iter(def => {
         def
         |> printRootObjectTypeConverters(~state, ~printMode=Full)
         |> addToStr
       })
  );
  Printer.(
    definitions^
    |> List.iter(def => {
         def
         |> printRootObjectTypeConverters(~state, ~printMode=Full)
         |> addToStr
       })
  );
  addToStr("};");

  // This emits extra assets for the generated modules,
  // like code for converting nullable fields, enums and unions,
  // and code for extracting fragment refs.
  addSpacing();
  addToStr("module Internal = {");
  switch (state.fragment) {
  | Some({definition}) =>
    addToStr(
      TypesTransformerUtils.printConverterAssets(~definition, "fragment"),
    );
    addSpacing();
  | None => ()
  };

  switch (state.response) {
  | Some(definition) =>
    switch (operationType) {
    | Mutation(_) =>
      addToStr(
        TypesTransformerUtils.printConverterAssets(
          ~direction=Wrap,
          ~nullableType=Null,
          ~definition,
          "wrapResponse",
        ),
      );
      addSpacing();
    | _ => ()
    };

    addToStr(
      TypesTransformerUtils.printConverterAssets(~definition, "response"),
    );
    addSpacing();
  | None => ()
  };

  switch (state.variables) {
  | Some(definition) =>
    addToStr(
      TypesTransformerUtils.printConverterAssets(
        ~includeRaw=false,
        ~direction=Wrap,
        ~definition,
        "variables",
      ),
    );
    addSpacing();
  | None => ()
  };
  addToStr("};");
  addSpacing();

  switch (state.fragment) {
  | Some({name, plural}) =>
    addToStr(Printer.fragmentRefAssets(~plural, name));
    addSpacing();
  | None => ()
  };

  /**
   * We'll emit a helper function for dealing with connection nodes if there's
   * a connection present.
   *
  switch (state.response, state.fragment) {
  | (Some({connection: Some(_)} as obj), _) => Js.log2(obj, "response")
  | (_, Some({definition: {connection: Some(_)}} as obj)) => Js.log(obj)
  | _ => ()
  };


  switch (
    state.objects
    |> Tablecloth.List.filterMap(~f=(o: Types.finalizedObj) =>
         switch (o) {
         | {definition: {connection: Some(_)} as obj} => Some(obj)
         | _ => None
         }
       )
  ) {
  | [obj] =>
    addToStr(
      obj
      |> UtilsPrinter.printGetConnectionNodesFunction(
           ~state,
           ~connectionLocation="friendsConnection",
         ),
    )
  | o =>
    Js.log(o);
    ();
  };
  */
  /**
     * This adds operationType, which is referenced in the raw output of the Relay
     * runtime representation.
     */
  addToStr(Printer.operationType(operationType));
  addSpacing();

  switch (state) {
  | {fragment: None, response: None, variables: None} =>
    raise(No_extractable_operations_found)
  | _ => ()
  };

  finalStr^;
};

/**
 * Maps an object prop (represented by a Flow type) to a prop value
 * in our own model of the selections.
 */
let rec mapObjProp =
        (
          ~optional,
          ~state: Types.intermediateState,
          ~path: list(string),
          (_, prop): Flow_ast.Type.t('a, 'b),
        )
        : Types.propValue =>
  switch (prop) {
  | String => {nullable: optional, propType: Scalar(String)}
  | StringLiteral(_) => {nullable: optional, propType: Scalar(String)} // Reason does not have string literals, so we map literals to normal strings
  | Nullable((_, String)) => {nullable: true, propType: Scalar(String)}
  | Nullable((_, StringLiteral(_))) => {
      nullable: true,
      propType: Scalar(String),
    }

  // Our compiler fork already emits int/float as generic Flow types instead of number, so these are probably not needed, but leaving them in there anyway just in case.
  | Number
  | NumberLiteral(_) => {nullable: optional, propType: Scalar(Float)}
  | Nullable((_, Number))
  | Nullable((_, NumberLiteral(_))) => {
      nullable: true,
      propType: Scalar(Float),
    }

  // Booleans
  | Boolean => {nullable: optional, propType: Scalar(Boolean)}
  | BooleanLiteral(_) => {nullable: optional, propType: Scalar(Boolean)}
  | Nullable((_, Boolean)) => {nullable: true, propType: Scalar(Boolean)}
  | Nullable((_, BooleanLiteral(_))) => {
      nullable: true,
      propType: Scalar(Boolean),
    }

  // Arrays
  | Array(typ) => {
      nullable: optional,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }
  | Nullable((_, Array(typ))) => {
      nullable: true,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }
  | Generic({
      id: Unqualified((_, "$ReadOnlyArray")),
      targs: Some((_, [typ])),
    }) => {
      nullable: optional,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }
  | Nullable((
      _,
      Generic({
        id: Unqualified((_, "$ReadOnlyArray")),
        targs: Some((_, [typ])),
      }),
    )) => {
      nullable: true,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }

  // Objects
  | Object({properties}) => {
      nullable: optional,
      propType: Object(makeObjShape(~path, ~state, properties)),
    }
  | Nullable((_, Object({properties}))) => {
      nullable: true,
      propType: Object(makeObjShape(~path, ~state, properties)),
    }

  // Unions
  | Nullable((
      _,
      Union(
        (_, Object({properties: firstProps})),
        (_, Object({properties: secondProps})),
        maybeMoreMembers,
      ),
    )) =>
    makeUnion(
      ~firstProps,
      ~secondProps,
      ~maybeMoreMembers,
      ~state,
      ~path,
      ~optional=true,
    )

  | Union(
      (_, Object({properties: firstProps})),
      (_, Object({properties: secondProps})),
      maybeMoreMembers,
    ) =>
    makeUnion(
      ~firstProps,
      ~state,
      ~secondProps,
      ~maybeMoreMembers,
      ~path,
      ~optional,
    )

  // This handles generic type references, extracting it if it's an enum
  | Generic({id: Unqualified((_, typeName))}) => {
      nullable: optional,
      propType:
        switch (
          state.enums |> Tablecloth.List.find(~f=name => name == typeName)
        ) {
        | Some(name) => Enum(name)
        | None => TypeReference(typeName |> Utils.unmaskDots)
        },
    }
  | Nullable((_, Generic({id: Unqualified((_, typeName))}))) => {
      nullable: true,
      propType:
        switch (
          state.enums |> Tablecloth.List.find(~f=name => name == typeName)
        ) {
        | Some(name) => Enum(name)
        | None => TypeReference(typeName |> Utils.unmaskDots)
        },
    }

  // Handle anything we haven't matched above, including any which needs no explicit match as it's handled here
  | _ => {nullable: optional, propType: Scalar(Any)}
  }

/**
 * This turns a list of props from the Flow AST into our own object definition.
 */
and makeObjShape =
    (
      ~path: list(string),
      ~state,
      props: list(Flow_ast.Type.Object.property('a, 'b)),
    )
    : Types.object_ => {
  let values: ref(list(Types.propValues)) = ref([]);
  let connectionInfo: ref(option(Types.connectionInfo)) = ref(None);
  let addValue = value => values := [value, ...values^];
  let addFragmentRef = rawFragmentRef =>
    addValue(
      Types.(
        FragmentRef(
          Tablecloth.String.dropRight(
            ~count=String.length("$ref"),
            rawFragmentRef,
          ),
        )
      ),
    );

  props
  |> List.iter((prop: Flow_ast.Type.Object.property('a, 'b)) =>
       switch (prop) {
       // Map all $fragmentRefs. These are either a single type (+$fragmentRefs: SomeFragment_someType$ref), or an intersection of types (+$fragmentRefs: SomeFragment_someType$ref & SomeOtherFragment_someType$ref)
       | Property((
           _,
           {value: Init((_, typ)), key: Identifier((_, "$fragmentRefs"))},
         )) =>
         switch (typ) {
         | Generic({id: Unqualified((_, firstId))}) =>
           addFragmentRef(firstId)
         | Intersection(
             (_, Generic({id: Unqualified((_, firstId))})),
             (_, Generic({id: Unqualified((_, secondId))})),
             maybeMore,
           ) =>
           addFragmentRef(firstId);
           addFragmentRef(secondId);
           maybeMore
           |> List.iter((intersectionMember: Flow_ast.Type.t('a, 'b)) =>
                switch (intersectionMember) {
                | (_, Generic({id: Unqualified((_, fragmentName))})) =>
                  addFragmentRef(fragmentName)
                | _ => ()
                }
              );
         | _ => ()
         }
       // Do not add any props that start with "$". These are usually internal Flow types that we don't need/use in Reason
       | Property((_, {key: Identifier((_, id))}))
           when Tablecloth.String.startsWith(~prefix="$", id) =>
         ()
       // Handle our own internal types
       | Property((_, {key: Identifier((_, id))}))
           when
             Tablecloth.String.startsWith(
               ~prefix=Constants.generatedPrefix,
               id,
             ) =>
         id
         |> Tablecloth.String.startsWith(
              ~prefix=Constants.connectionIndicatorKey,
            )
           ? connectionInfo := Utils.extractConnectionInfo(id) : ()
       | Property((
           _,
           {optional, value: Init(typ), key: Identifier((_, id))},
         )) =>
         addValue(
           Types.(
             Prop(
               id,
               typ |> mapObjProp(~state, ~path=[id, ...path], ~optional),
             )
           ),
         )
       | _ => ()
       }
     );

  {
    atPath: path,
    connection: connectionInfo^,
    values: values^ |> Tablecloth.List.reverse |> Tablecloth.Array.fromList,
  };
}
and makeUnionMember =
    (~state, props: list(Flow_ast.Type.Object.property('a, 'b)))
    : Types.unionMember => {
  let name = ref(None);
  let filteredProps = ref([]);

  props
  |> Tablecloth.List.iter(~f=(prop: Flow_ast.Type.Object.property('a, 'b)) =>
       switch (prop) {
       | Property((
           _,
           {
             value: Init((_, StringLiteral({value: typeName}))),
             key: Identifier((_, "__typename")),
           },
         )) =>
         name := Some(typeName)
       | _ => filteredProps := [prop, ...filteredProps^]
       }
     );

  switch (name^) {
  | Some(name) => {
      name,
      shape:
        filteredProps^
        |> makeObjShape(
             ~state,
             ~path=[name |> Tablecloth.String.uncapitalize],
           ),
    }
  | None => raise(Missing_typename_field_on_union)
  };
}
and makeUnion =
    (~firstProps, ~secondProps, ~maybeMoreMembers, ~path, ~optional, ~state) => {
  let unionMembers =
    ref([
      firstProps |> makeUnionMember(~state),
      secondProps |> makeUnionMember(~state),
    ]);

  maybeMoreMembers
  |> Tablecloth.List.iter(~f=(prop: Flow_ast.Type.t('a, 'b)) =>
       switch (prop) {
       | (_, Object({properties})) =>
         unionMembers :=
           [properties |> makeUnionMember(~state), ...unionMembers^]
       | _ => ()
       }
     );

  let union: Types.union = {
    members:
      unionMembers^
      |> Tablecloth.List.filter(~f=(member: Types.unionMember) =>
           member.name != {|%other|}
         ),
    atPath: path,
  };

  {nullable: optional, propType: Union(union)};
};

let flowTypesToFullState = (~content, ~operationType) => {
  let initialState: Types.intermediateState = {
    enums: [],
    objects: [],
    variables: None,
    response: None,
    fragment: None,
  };

  let state = ref(initialState);

  let setState = updater => state := updater(state^);

  // This iterates through all top level type declarations from the Flow types generated
  // by the Relay compiler, and extracts the things we're interested in.
  switch (
    operationType,
    Parser_flow.program(~fail=true, ~parse_options, content),
  ) {
  | (
      Types.Mutation(name) | Query(name) | Subscription(name),
      ((_, statements, _), []),
    ) =>
    statements
    |> List.iter(((_, statement): Flow_ast.Statement.t(Loc.t, Loc.t)) =>
         switch (statement) {
         /*** Avoid full mutation object */
         | ExportNamedDeclaration({
             declaration:
               Some((
                 _,
                 TypeAlias({right: (_, Object(_)), id: (_, typeName)}),
               )),
           })
             when typeName == name =>
           ()
         /***
          * Objects
          */
         | ExportNamedDeclaration({
             declaration:
               Some((
                 _,
                 TypeAlias({
                   right: (_, Object({properties})),
                   id: (_, typeName),
                 }),
               )),
           }) =>
           switch (typeName) {
           | _ when typeName == name ++ "Variables" =>
             setState(state =>
               {
                 ...state,
                 variables:
                   Some({
                     name: None,
                     definition:
                       properties
                       |> makeObjShape(~state, ~path=["variables"]),
                   }),
               }
             )
           | _ when typeName == name ++ "Response" =>
             setState(state =>
               {
                 ...state,
                 response:
                   Some({
                     name: None,
                     definition:
                       properties |> makeObjShape(~state, ~path=["response"]),
                   }),
               }
             )
           | typeName =>
             setState(state =>
               {
                 ...state,
                 objects: [
                   {
                     name: Some(typeName),
                     definition:
                       properties |> makeObjShape(~state, ~path=["objects"]),
                   },
                   ...state.objects,
                 ],
               }
             )
           }
         /***
          * Enums
          */
         | ExportNamedDeclaration({
             declaration:
               Some((
                 _,
                 TypeAlias({
                   right: (_, Union((_, StringLiteral(_)), _, _)),
                   id: (_, typeName),
                 }),
               )),
           }) =>
           setState(state => {...state, enums: [typeName, ...state.enums]})
         | _ => ()
         }
       )
  | (Fragment(name, plural), ((_, statements, _), [])) =>
    statements
    |> List.iter(((_, statement): Flow_ast.Statement.t(Loc.t, Loc.t)) =>
         switch (statement) {
         /***
          * Objects
          */
         | ExportNamedDeclaration({
             declaration:
               Some((
                 _,
                 TypeAlias({
                   right: (
                     _,
                     // Match regular object, or a $ReadOnlyArray (plural fragments)
                     Object({properties}) |
                     Generic({
                       id: Unqualified((_, "$ReadOnlyArray")),
                       targs: Some((_, [(_, Object({properties}))])),
                     }),
                   ),
                   id: (_, typeName),
                 }),
               )),
           }) =>
           switch (typeName) {
           | _ when typeName == name =>
             setState(state =>
               {
                 ...state,
                 fragment:
                   Some({
                     plural,
                     definition:
                       properties |> makeObjShape(~state, ~path=["fragment"]),
                     name,
                   }),
               }
             )
           | _ when !Tablecloth.String.contains(~substring="$", typeName) =>
             setState(state =>
               {
                 ...state,
                 objects: [
                   {
                     name: Some(typeName),
                     definition:
                       properties |> makeObjShape(~state, ~path=["objects"]),
                   },
                   ...state.objects,
                 ],
               }
             )
           | _ => ()
           }
         /***
          * Enums
          */
         | ExportNamedDeclaration({
             declaration:
               Some((
                 _,
                 TypeAlias({
                   right: (_, Union((_, StringLiteral(_)), _, _)),
                   id: (_, typeName),
                 }),
               )),
           }) =>
           setState(state => {...state, enums: [typeName, ...state.enums]})
         | _ => ()
         }
       )
  | (_, _errors) => Js.log("Parse error.")
  };

  state^ |> intermediateToFull;
};

// This is the actual entry point for the language plugin.
// The language plugin get both the content (Flow types) and operation type from Relay.
[@gentype]
let printFromFlowTypes = (~content, ~operationType) => {
  flowTypesToFullState(~content, ~operationType)
  |> getPrintedFullState(~operationType);
};