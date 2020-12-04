open Flow_parser;

exception Missing_typename_field_on_union;

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
    enums: false,
  });

type propList('a, 'b) = list(Flow_ast.Type.Object.property('a, 'b));

let validStringLiteralRegex = Re.Pcre.regexp({|^[a-z_A-Z]+[a-z_A-Z0-9]*$|});

let is_valid_literal_name = v => {
  Re.Pcre.pmatch(~rex=validStringLiteralRegex, v);
};

let makeStringLiteralOrString = (value: string): Types.propType =>
  switch (
    is_valid_literal_name(value),
    ReservedKeywords.reservedKeywords
    |> Tablecloth.Array.find(~f=word => word === value),
  ) {
  | (true, None) => StringLiteral(value)
  | _ => Scalar(String)
  };

let rec mapObjProp =
        (
          ~optional,
          ~state: Types.intermediateState,
          ~path: list(string),
          (_, prop): Flow_ast.Type.t('a, 'b),
        )
        : Types.propValue =>
  switch (prop) {
  | String(_) => {nullable: optional, propType: Scalar(String)}

  | StringLiteral({value}) => {
      nullable: optional,
      propType: value |> makeStringLiteralOrString,
    }

  | Nullable({argument: (_, String(_))}) => {
      nullable: true,
      propType: Scalar(String),
    }
  | Nullable({argument: (_, StringLiteral({value}))}) => {
      nullable: true,
      propType: value |> makeStringLiteralOrString,
    }

  // Our compiler fork already emits int/float as generic Flow types instead of number, so these are probably not needed, but leaving them in there anyway just in case.
  | Number(_)
  | NumberLiteral(_) => {nullable: optional, propType: Scalar(Float)}
  | Nullable({argument: (_, Number(_))})
  | Nullable({argument: (_, NumberLiteral(_))}) => {
      nullable: true,
      propType: Scalar(Float),
    }

  // Booleans
  | Boolean(_) => {nullable: optional, propType: Scalar(Boolean)}
  | BooleanLiteral(_) => {nullable: optional, propType: Scalar(Boolean)}
  | Nullable({argument: (_, Boolean(_))}) => {
      nullable: true,
      propType: Scalar(Boolean),
    }
  | Nullable({argument: (_, BooleanLiteral(_))}) => {
      nullable: true,
      propType: Scalar(Boolean),
    }

  // Arrays
  | Array({argument: typ}) => {
      nullable: optional,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }
  | Nullable({argument: (_, Array({argument: typ}))}) => {
      nullable: true,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }
  | Generic({
      id: Unqualified((_, {name: "$ReadOnlyArray"})),
      targs: Some((_, {arguments: [typ]})),
    }) => {
      nullable: optional,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }
  | Nullable({
      argument: (
        _,
        Generic({
          id: Unqualified((_, {name: "$ReadOnlyArray"})),
          targs: Some((_, {arguments: [typ]})),
        }),
      ),
    }) => {
      nullable: true,
      propType: Array(typ |> mapObjProp(~path, ~state, ~optional=false)),
    }

  // Objects
  | Object({properties}) => {
      nullable: optional,
      propType: Object(makeObjShape(~path, ~state, properties)),
    }
  | Nullable({argument: (_, Object({properties}))}) => {
      nullable: true,
      propType: Object(makeObjShape(~path, ~state, properties)),
    }

  // Unions
  | Nullable({
      argument: (
        _,
        Union({
          types: (
            (_, Object({properties: firstProps})),
            (_, Object({properties: secondProps})),
            maybeMoreMembers,
          ),
        }),
      ),
    }) =>
    // Node interface special treatment
    // --
    // To simplify using the Node interface, we'll convert any usage of the
    // top level node field with just 1 subselection type into its own type.

    switch (path, firstProps, secondProps) {
    | (
        // Match the `node` field name one level down (from `response` or `fragment`)
        ["node", _],
        [
          Property((
            _,
            {
              value: Init((_, StringLiteral({value: nodeFieldTypeName}))),
              key: Identifier((_, {name: "__typename"})),
            },
          )),
          ..._rest,
        ],
        // This matches what Relay outputs as the last matching case for any union/interface
        [
          Property((
            _,
            {
              value:
                Init((_, StringLiteral({value: {|%other|}}) | String(_))),
              key: Identifier((_, {name: "__typename"})),
            },
          )),
          ..._r,
        ],
      ) => {
        nullable: true,
        propType:
          TopLevelNodeField(
            nodeFieldTypeName,
            firstProps |> makeObjShape(~state, ~path),
          ),
      }
    | _ =>
      makeUnion(
        ~firstProps,
        ~secondProps,
        ~maybeMoreMembers,
        ~state,
        ~path,
        ~optional=true,
      )
    }

  | Union({
      types: (
        (_, Object({properties: firstProps})),
        (_, Object({properties: secondProps})),
        maybeMoreMembers,
      ),
    }) =>
    makeUnion(
      ~firstProps,
      ~state,
      ~secondProps,
      ~maybeMoreMembers,
      ~path,
      ~optional,
    )

  // This handles generic type references, extracting it if it's an enum
  | Generic({id: Unqualified((_, {name: typeName}))}) => {
      nullable: optional,
      propType:
        switch (
          state.enums
          |> Tablecloth.List.find(~f=(enum: Types.fullEnum) =>
               enum.name == typeName
             )
        ) {
        | Some(name) => Enum(name)
        | None => TypeReference(typeName |> Utils.unmaskDots)
        },
    }
  | Nullable({
      argument: (_, Generic({id: Unqualified((_, {name: typeName}))})),
    }) => {
      nullable: true,
      propType:
        switch (
          state.enums
          |> Tablecloth.List.find(~f=(enum: Types.fullEnum) =>
               enum.name == typeName
             )
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
       // Map __id to dataId
       | Property((
           _,
           {value: Init(_), key: Identifier((_, {name: "__id" as id}))},
         )) =>
         addValue(Types.(Prop(id, {nullable: false, propType: DataId})))
       // Map all $fragmentRefs. These are either a single type (+$fragmentRefs: SomeFragment_someType$ref), or an intersection of types (+$fragmentRefs: SomeFragment_someType$ref & SomeOtherFragment_someType$ref)
       | Property((
           _,
           {
             value: Init((_, typ)),
             key: Identifier((_, {name: "$fragmentRefs"})),
           },
         )) =>
         switch (typ) {
         | Generic({id: Unqualified((_, {name: firstId}))}) =>
           addFragmentRef(firstId)
         | Intersection({
             types: (
               (_, Generic({id: Unqualified((_, {name: firstId}))})),
               (_, Generic({id: Unqualified((_, {name: secondId}))})),
               maybeMore,
             ),
           }) =>
           addFragmentRef(firstId);
           addFragmentRef(secondId);
           maybeMore
           |> Tablecloth.List.iter(
                ~f=(
                     (
                       _,
                       intersectionMember:
                         Flow_parser__Flow_ast.Type.t'(
                           Flow_parser__Loc.t,
                           Flow_parser__Loc.t,
                         ),
                     ),
                   ) =>
                switch (intersectionMember) {
                | Generic({id: Unqualified((_, {name: fragmentName}))}) =>
                  addFragmentRef(fragmentName)
                | _ => ()
                }
              );
         | _ => ()
         }
       // Do not add any props that start with "$". These are usually internal Flow types that we don't need/use in Reason
       | Property((_, {key: Identifier((_, {name: id}))}))
           when Tablecloth.String.startsWith(~prefix="$", id) =>
         ()
       | Property((
           _,
           {optional, value: Init(typ), key: Identifier((_, {name: id}))},
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

  {atPath: path, values: values^ |> List.rev};
}
and makeUnionMember =
    (
      ~state: Types.intermediateState,
      ~path,
      props: list(Flow_ast.Type.Object.property('a, 'b)),
    )
    : option(Types.unionMember) => {
  let name = ref(None);
  let filteredProps = ref([]);

  props
  |> Tablecloth.List.iter(~f=(prop: Flow_ast.Type.Object.property('a, 'b)) =>
       switch (prop) {
       | Property((
           _,
           {
             value: Init((_, StringLiteral({value: typeName}))),
             key: Identifier((_, {name: "__typename"})),
           },
         )) =>
         name := Some(typeName)
       | _ => filteredProps := [prop, ...filteredProps^]
       }
     );

  switch (name^) {
  | Some(name) =>
    Some({
      name,
      shape: filteredProps^ |> makeObjShape(~state, ~path=[name, ...path]),
    })
  | None =>
    switch (path |> List.rev) {
    /***
     * We ignore missing typenames on unions and simply don't return that
     * union member. */
    | ["rawResponse", ..._rest] => None
    | _ => raise(Missing_typename_field_on_union)
    }
  };
}
and makeUnionDefinition =
    (~firstProps, ~secondProps, ~maybeMoreMembers, ~path, ~state): Types.union => {
  let unionMembers =
    ref(
      [
        firstProps |> makeUnionMember(~state, ~path),
        secondProps |> makeUnionMember(~state, ~path),
      ]
      |> Tablecloth.List.filter_map(~f=x => x),
    );

  maybeMoreMembers
  |> Tablecloth.List.iter(~f=(prop: Flow_ast.Type.t('a, 'b)) =>
       switch (prop) {
       | (_, Object({properties})) =>
         unionMembers :=
           List.concat([
             switch (properties |> makeUnionMember(~state, ~path)) {
             | Some(member) => [member]
             | None => []
             },
             unionMembers^,
           ])

       | _ => ()
       }
     );

  {
    members:
      unionMembers^
      |> Tablecloth.List.filter(~f=(member: Types.unionMember) =>
           member.name != {|%other|}
         ),
    atPath: path,
  };
}
and makeUnion =
    (~firstProps, ~secondProps, ~maybeMoreMembers, ~path, ~optional, ~state) => {
  {
    Types.nullable: optional,
    propType:
      Union(
        makeUnionDefinition(
          ~firstProps,
          ~secondProps,
          ~maybeMoreMembers,
          ~path,
          ~state,
        ),
      ),
  };
};

let flowTypesToFullState = (~content, ~operationType) => {
  let initialState: Types.intermediateState = {
    enums: [],
    objects: [],
    variables: None,
    response: None,
    rawResponse: None,
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
      ((_, {statements, _}), []),
    ) =>
    statements
    |> Tablecloth.List.iter(
         ~f=(
              (
                _,
                statement:
                  Flow_parser__Flow_ast.Statement.t'(
                    Flow_parser__Loc.t,
                    Flow_parser__Loc.t,
                  ),
              ),
            ) =>
         switch (statement) {
         /*** Avoid full mutation object */
         | ExportNamedDeclaration({
             declaration:
               Some((
                 _,
                 TypeAlias({
                   right: (_, Object(_)),
                   id: (_, {name: typeName}),
                 }),
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
                   id: (_, {name: typeName}),
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
                     originalFlowTypeName: None,
                     foundInUnion: false,
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
                     originalFlowTypeName: None,
                     foundInUnion: false,
                     definition:
                       properties |> makeObjShape(~state, ~path=["response"]),
                   }),
               }
             )
           | _ when typeName == name ++ "RawResponse" =>
             setState(state =>
               {
                 ...state,
                 rawResponse:
                   Some({
                     originalFlowTypeName: None,
                     foundInUnion: false,
                     definition:
                       properties
                       |> makeObjShape(~state, ~path=["rawResponse"]),
                   }),
               }
             )
           | typeName =>
             setState(state =>
               {
                 ...state,
                 objects: [
                   {
                     originalFlowTypeName: Some(typeName),
                     foundInUnion: false,
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
                   right: (
                     _,
                     Union({
                       types: (
                         (_, StringLiteral({value: firstMember})),
                         maybeSecondMember,
                         maybeMore,
                       ),
                     }),
                   ),
                   id: (_, {name: typeName}),
                 }),
               )),
           }) =>
           let enum = ref({Types.name: typeName, values: [firstMember]});

           let addValue = v =>
             enum := {...enum^, values: List.concat([enum^.values, [v]])};

           [maybeSecondMember, ...maybeMore]
           |> Tablecloth.List.iter(
                ~f=(
                     (
                       _,
                       member:
                         Flow_parser__Flow_ast.Type.t'(
                           Flow_parser__Loc.t,
                           Flow_parser__Loc.t,
                         ),
                     ),
                   ) =>
                switch (member) {
                | StringLiteral({value: v}) when v != "%%future added value" =>
                  addValue(v)
                | _ => ()
                }
              );

           setState(state => {...state, enums: [enum^, ...state.enums]});
         | _ => ()
         }
       )
  | (Fragment(name, plural), ((_, {statements, _}), [])) =>
    statements
    |> List.iter(((_, statement): Flow_ast.Statement.t(Loc.t, Loc.t)) =>
         switch (statement) {
         /***
          * Objects
          */

         /***
          * Match fragments
          */
         // Union
         | ExportNamedDeclaration({
             declaration:
               Some((
                 _,
                 TypeAlias({
                   right: (
                     _,
                     // Match unions
                     Union({
                       types: (
                         (_, Object({properties: firstProps})),
                         (_, Object({properties: secondProps})),
                         maybeMoreMembers,
                       ),
                     }) |
                     Generic({
                       id: Unqualified((_, {name: "$ReadOnlyArray"})),
                       targs:
                         Some((
                           _,
                           {
                             arguments: [
                               (
                                 _,
                                 Union({
                                   types: (
                                     (_, Object({properties: firstProps})),
                                     (_, Object({properties: secondProps})),
                                     maybeMoreMembers,
                                   ),
                                 }),
                               ),
                             ],
                           },
                         )),
                     }),
                   ),
                   id: (_, {name: typeName}),
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
                       Union(
                         makeUnionDefinition(
                           ~firstProps,
                           ~state,
                           ~secondProps,
                           ~maybeMoreMembers,
                           ~path=["fragment"],
                         ),
                       ),
                     name,
                   }),
               }
             )
           | _ => ()
           }
         // Regular objects
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
                       id: Unqualified((_, {name: "$ReadOnlyArray"})),
                       targs:
                         Some((
                           _,
                           {arguments: [(_, Object({properties}))]},
                         )),
                     }),
                   ),
                   id: (_, {name: typeName}),
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
                       Object(
                         properties
                         |> makeObjShape(~state, ~path=["fragment"]),
                       ),
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
                     foundInUnion: false,
                     originalFlowTypeName: Some(typeName),
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
                   right: (
                     _,
                     Union({
                       types: (
                         (_, StringLiteral({value: firstMember})),
                         maybeSecondMember,
                         maybeMore,
                       ),
                     }),
                   ),
                   id: (_, {name: typeName}),
                 }),
               )),
           }) =>
           let enum = ref({Types.name: typeName, values: [firstMember]});

           let addValue = v =>
             enum := {...enum^, values: List.concat([enum^.values, [v]])};

           [maybeSecondMember, ...maybeMore]
           |> Tablecloth.List.iter(
                ~f=(
                     (
                       _,
                       member:
                         Flow_parser__Flow_ast.Type.t'(
                           Flow_parser__Loc.t,
                           Flow_parser__Loc.t,
                         ),
                     ),
                   ) =>
                switch (member) {
                | StringLiteral({value: v}) when v != "%%future added value" =>
                  addValue(v)
                | _ => ()
                }
              );

           setState(state => {...state, enums: [enum^, ...state.enums]});
         | _ => ()
         }
       )
  | (_, _errors) => Console.log("Parse error.")
  };

  state^ |> StateTransformer.intermediateToFull;
};
