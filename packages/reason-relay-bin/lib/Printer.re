open Types;

exception Could_not_find_matching_record_definition(string);
exception Invalid_top_level_shape;

let printQuoted = propName => "\"" ++ propName ++ "\"";
let makeUnionName = path =>
  path |> List.rev |> Tablecloth.String.join(~sep="_");

let makeEnumName = enumName => "enum_" ++ enumName;
let makeUnwrapEnumFnName = enumName => "unwrap_" ++ makeEnumName(enumName);
let makeWrapEnumFnName = enumName => "wrap_" ++ makeEnumName(enumName);

let printComment = (comment: option(string)) =>
  switch (comment) {
  | Some(comment) => "@ocaml.doc(\"" ++ comment ++ "\") "
  | None => ""
  };

let printRecordPropComment = (propValue: Types.propValue) =>
  printComment(propValue.comment);

let printRecordComment = (obj: Types.object_) => printComment(obj.comment);

let printRecordPropName = propName =>
  switch (
    ReservedKeywords.reservedKeywords
    |> Tablecloth.Array.find(~f=w => w == propName)
  ) {
  | Some(_) => "@as(\"" ++ propName ++ "\") " ++ propName ++ "_"
  | None => propName
  };

let printSafeName = propName =>
  switch (
    ReservedKeywords.reservedKeywords
    |> Tablecloth.Array.find(~f=w => w == propName)
  ) {
  | Some(_) => propName ++ "_"
  | None => propName
  };
let printEnumName = name => "enum_" ++ name;
let getObjName = name => "obj_" ++ name;
let printEnumTypeName = name => makeEnumName(name);
let printEnumUnwrapFnReference = name => makeUnwrapEnumFnName(name);
let printEnumWrapFnReference = name => makeWrapEnumFnName(name);

let printLocalUnionName = (union: union) =>
  union.atPath |> Utils.makeRecordName;
let printUnionUnwrapFnReference = (union: union) =>
  "unwrap_" ++ (union.atPath |> Utils.makeRecordName);
let printUnionWrapFnReference = (union: union) =>
  "wrap_" ++ (union.atPath |> Utils.makeRecordName);
let printFragmentRef = name =>
  Tablecloth.String.capitalize(name) ++ "_graphql.t";
let printAnyType = () => "ReasonRelay.any";

let printScalar = scalarValue =>
  switch (scalarValue) {
  | String => "string"
  | Int => "int"
  | Float => "float"
  | Boolean => "bool"
  | CustomScalar(str) => str
  | Any => printAnyType()
  };

let printStringLiteral = (~literal, ~needsEscaping) =>
  "[ | #"
  ++ (needsEscaping ? Format.sprintf("\"%s\"", literal) : literal)
  ++ "]";

let printDataIdType = () => "ReasonRelay.dataId";

let getEnumFutureAddedValueName = (enum: fullEnum) =>
  switch (enum.values |> List.find_opt(e => e === "FutureAddedValue")) {
  | Some(_) => "FutureAddedValue_"
  | None => "FutureAddedValue"
  };

let printEnumDefinition = (enum: fullEnum): string => {
  let enumName = makeEnumName(enum.name);

  let str = ref("type " ++ enumName ++ " = private [>");

  let addToStr = s => str := str^ ++ s;

  enum.values |> List.iter(v => addToStr("\n  | #" ++ printSafeName(v)));

  addToStr("\n]\n");

  str^;
};

let objHasPrintableContents = (obj: object_) =>
  obj.values
  |> List.exists(
       fun
       | Prop(_) => true
       | _ => false,
     );

let rec printTypeReference = (~state: option(fullState), typeName: string) =>
  switch (state) {
  | Some(state) =>
    switch (
      state.enums
      |> Tablecloth.List.find(~f=(enum: fullEnum) => enum.name == typeName),
      state.objects
      |> Tablecloth.List.find(~f=(obj: finalizedObj) =>
           obj.originalFlowTypeName == Some(typeName)
         ),
    ) {
    | (Some(enum), _) => printEnumName(enum.name)
    | (_, Some(_)) => Tablecloth.String.uncapitalize(typeName)
    | _ =>
      // If this doesn't match any existing types in the state, and if it's a module name
      // (decided by being uppercased), we'll go ahead and assume this is a custom field.

      typeName |> Utils.isModuleName ? typeName ++ ".t" : typeName
    }
  | None => typeName |> Utils.isModuleName ? typeName ++ ".t" : typeName
  }
and printPropType = (~propType, ~state: Types.fullState) =>
  switch (propType) {
  | DataId => printDataIdType()
  | Scalar(scalar) => printScalar(scalar)
  | StringLiteral(literal) =>
    printStringLiteral(~literal, ~needsEscaping=false)
  | StringLiteralNeedsEscaping(literal) =>
    printStringLiteral(~literal, ~needsEscaping=true)
  | Object(obj) => printRecordReference(~obj, ~state)
  | TopLevelNodeField(_, obj) => printRecordReference(~obj, ~state)
  | Array(propValue) => printArray(~propValue, ~state)
  | Enum(enum) => printEnumName(enum.name)
  | Union(union) =>
    printUnionTypeDefinition(
      union,
      ~prefixWithTypesModule=false,
      ~extraIndent=true,
    )
  | FragmentRefValue(name) => printFragmentRef(name)
  | TypeReference(name) => printTypeReference(~state=Some(state), name)
  }
and printPropValue = (~propValue, ~state) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  if (propValue.nullable) {
    addToStr("option<");
  };

  printPropType(~propType=propValue.propType, ~state) |> addToStr;

  if (propValue.nullable) {
    addToStr(">");
  };

  str^;
}
and printObject = (~obj: object_, ~state, ~ignoreFragmentRefs=false, ()) => {
  switch (obj.values |> List.length) {
  | 0 => "unit"
  | _ =>
    let str = ref("");
    let addToStr = s => str := str^ ++ s;

    let hasFragments =
      obj.values
      |> List.exists(
           fun
           | FragmentRef(_) => true
           | Prop(_) => false,
         );

    let hasProps =
      obj.values
      |> List.exists(
           fun
           | FragmentRef(_) => false
           | Prop(_) => true,
         );

    // Return an empty JS object if we are ignoring fragment refs and have no props
    switch (ignoreFragmentRefs, hasProps) {
    | (true, false) => addToStr("ReasonRelay.allFieldsMasked")
    | _ =>
      addToStr("{");

      obj.values
      |> List.filter(
           fun
           | FragmentRef(_) => false
           | Prop(_) => true,
         )
      |> List.iter(p => {
           addToStr(
             switch (p) {
             | Prop(name, propValue) =>
               "\n  "
               ++ printRecordPropComment(propValue)
               ++ printRecordPropName(name)
               ++ ": "
               ++ printPropValue(~propValue, ~state)
               ++ ","
             | FragmentRef(_) => ""
             },
           )
         });

      if (hasFragments && !ignoreFragmentRefs) {
        addToStr(
          printRecordPropName("\n  fragmentRefs")
          ++ ": "
          ++ (obj |> printFragmentRefs),
        );
      };

      addToStr("\n}");
    };

    str^;
  };
}
and printFragmentRefs = (obj: object_) => {
  let str = ref("ReasonRelay.fragmentRefs<");
  let addToStr = s => str := str^ ++ s;

  obj.values
  |> List.filter(v =>
       switch (v) {
       | FragmentRef(_) => true
       | Prop(_) => false
       }
     )
  |> List.iteri((index, p) => {
       index == 0 ? addToStr("[") : ();

       addToStr(
         switch (p) {
         | FragmentRef(name) => " | #" ++ name
         | Prop(_) => ""
         },
       );
     });

  addToStr("]>");

  str^;
}
and printArray = (~propValue, ~state) =>
  "array<" ++ printPropValue(~propValue, ~state) ++ ">"
and printRecordReference = (~state: fullState, ~obj: object_) => {
  switch (
    state.objects |> Tablecloth.List.find(~f=o => {o.atPath == obj.atPath})
  ) {
  | Some({recordName: Some(recordName)}) =>
    Tablecloth.String.uncapitalize(recordName)
  | Some(_)
  | None =>
    raise(
      Could_not_find_matching_record_definition(
        obj.atPath
        |> Tablecloth.List.reverse
        |> Tablecloth.String.join(~sep="_"),
      ),
    )
  };
}
and printObjectMaker = (obj: object_, ~targetType, ~name) => {
  let hasContents = obj |> objHasPrintableContents;

  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  addToStr("let " ++ name ++ " = (");

  if (hasContents) {
    obj.values
    |> List.iteri((index, p) => {
         addToStr(
           switch (p) {
           | Prop(name, {nullable}) =>
             (index > 0 ? "," : "")
             ++ "\n  ~"
             ++ printSafeName(name)
             ++ (nullable ? "=?" : "")
           | FragmentRef(_) => ""
           },
         )
       });

    let shouldAddUnit =
      obj.values
      |> List.exists(
           fun
           | Prop(_, {nullable}) => nullable
           | _ => false,
         );

    addToStr(
      (shouldAddUnit ? ",\n  ()" : "") ++ "\n): " ++ targetType ++ " => {",
    );

    obj.values
    |> List.iteri((index, p) => {
         addToStr(
           switch (p) {
           | Prop(name, _) =>
             (index > 0 ? "," : "")
             ++ "\n  "
             ++ printSafeName(name)
             ++ ": "
             ++ printSafeName(name)
           | FragmentRef(_) => ""
           },
         )
       });

    addToStr("\n}");
  } else {
    addToStr("\n) => Js.Obj.empty()");
  };

  addToStr("\n");
  str^;
}
and printRefetchVariablesMaker = (obj: object_, ~state) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  let optionalObj = {
    comment: None,
    atPath: [],
    values:
      obj.values
      |> List.map(value =>
           switch (value) {
           | Prop(name, {nullable: false} as propValue) =>
             Prop(name, {...propValue, nullable: true})
           | a => a
           }
         ),
  };

  addToStr("type refetchVariables = ");
  addToStr(printObject(~state, ~obj=optionalObj, ()));
  addToStr("\n");

  addToStr(
    printObjectMaker(
      optionalObj,
      ~targetType="refetchVariables",
      ~name="makeRefetchVariables",
    ),
  );

  str^;
}
and printRootType =
    (~recursiveMode=None, ~state: fullState, ~ignoreFragmentRefs, rootType) => {
  switch (rootType) {
  | Operation(Object(obj)) =>
    printRecordComment(obj)
    ++ "type response = "
    ++ printObject(~obj, ~state, ~ignoreFragmentRefs, ())
    ++ "\n"
  | RawResponse(Some(Object(obj))) =>
    printRecordComment(obj)
    ++ "type rawResponse = "
    ++ printObject(~obj, ~state, ~ignoreFragmentRefs, ())
    ++ "\n"
  | RawResponse(None) => "type rawResponse = response\n"
  | RawResponse(Some(Union(_)))
  | Operation(Union(_)) => raise(Invalid_top_level_shape)
  | Variables(Object(obj)) =>
    printRecordComment(obj)
    ++ "type variables = "
    ++ printObject(~obj, ~state, ~ignoreFragmentRefs, ())
    ++ "\n"
  | Variables(Union(_)) => raise(Invalid_top_level_shape)
  | RefetchVariables(obj) =>
    switch (obj.values |> List.length) {
    | 0 => ""
    | _ => printRefetchVariablesMaker(~state, obj) ++ "\n"
    }

  | Fragment(Object(obj)) =>
    printRecordComment(obj)
    ++ "type fragment = "
    ++ printObject(~obj, ~state, ~ignoreFragmentRefs, ())
    ++ "\n"
  | Fragment(Union(union)) =>
    printComment(union.comment)
    ++ "type fragment = "
    ++ printUnionTypeDefinition(
         union,
         ~prefixWithTypesModule=false,
         ~extraIndent=false,
       )
    ++ "\n"
  | ObjectTypeDeclaration({name, definition}) =>
    let typeDef =
      Tablecloth.String.uncapitalize(name)
      ++ (
        switch (definition.values |> List.length) {
        | 0 => ""
        | _ =>
          " = "
          ++ printObject(~obj=definition, ~state, ~ignoreFragmentRefs, ())
          ++ "\n"
        }
      );

    let (prefix, suffix) =
      switch (recursiveMode) {
      | None => ("type ", "\n")
      | Some(`Head) => ("type rec ", "")
      | Some(`Member) => (" and ", "")
      | Some(`Tail) => (" and ", "\n\n")
      };

    printRecordComment(definition) ++ prefix ++ typeDef ++ suffix;
  | PluralFragment(Object(obj)) =>
    "type fragment_t = "
    ++ printObject(~obj, ~state, ~ignoreFragmentRefs, ())
    ++ "\n"
    ++ printRecordComment(obj)
    ++ "type fragment = array<fragment_t>\n"
  | PluralFragment(Union(union)) =>
    "type fragment_t = "
    ++ printUnionTypeDefinition(
         union,
         ~prefixWithTypesModule=false,
         ~extraIndent=false,
       )
    ++ "\n"
    ++ printComment(union.comment)
    ++ "type fragment = array<fragment_t>\n"
  };
}
and printUnionTypeDefinition =
    (union, ~prefixWithTypesModule, ~extraIndent): string => {
  let futureAddedValueName =
    switch (
      union.members
      |> Tablecloth.List.find(~f=(m: Types.unionMember) =>
           m.name === "UnselectedUnionMember"
         )
    ) {
    | Some(_) => "UnselectedUnionMember_"
    | None => "UnselectedUnionMember"
    };

  "["
  ++ (
    union.members
    |> List.map(({name, shape: {atPath}}) =>
         "\n  "
         ++ (extraIndent ? "  " : "")
         ++ "| #"
         ++ name
         ++ "("
         ++ (prefixWithTypesModule ? "Types." : "")
         ++ Utils.makeRecordName(atPath)
         ++ ")"
       )
    |> Tablecloth.String.join(~sep="\n")
  )
  ++ "\n  "
  ++ (extraIndent ? "  " : "")
  ++ "| #"
  ++ futureAddedValueName
  ++ "(string)"
  ++ (extraIndent ? "\n  " : "\n")
  ++ "]";
};

let printUnionConverters = (union: union) => {
  let str = ref("");
  let addToStr = Utils.makeAddToStr(str);

  let futureAddedValueName =
    switch (
      union.members
      |> Tablecloth.List.find(~f=(m: Types.unionMember) =>
           m.name === "UnselectedUnionMember"
         )
    ) {
    | Some(_) => "UnselectedUnionMember_"
    | None => "UnselectedUnionMember"
    };

  let unionName = union.atPath |> Utils.makeRecordName;

  // Unwrap
  addToStr(
    "let unwrap_"
    ++ unionName
    ++ ": {. \"__typename\": string } => "
    ++ printUnionTypeDefinition(
         union,
         ~prefixWithTypesModule=true,
         ~extraIndent=false,
       )
    ++ " = u => switch u[\"__typename\"] {",
  );
  union.members
  |> List.iter((member: Types.unionMember) => {
       addToStr(
         "\n | \""
         ++ member.name
         ++ "\" => #"
         ++ member.name
         ++ "(u->Obj.magic) ",
       )
     });
  addToStr("\n | v => #" ++ futureAddedValueName ++ "(v)");
  addToStr("\n}\n\n");

  // Wrap
  addToStr(
    "let wrap_"
    ++ unionName
    ++ ": "
    ++ printUnionTypeDefinition(
         union,
         ~prefixWithTypesModule=true,
         ~extraIndent=false,
       )
    ++ " => {. \"__typename\": string } = v => switch v {",
  );
  union.members
  |> List.iter((member: Types.unionMember) => {
       addToStr("\n | #" ++ member.name ++ "(v) => v->Obj.magic ")
     });
  addToStr("\n | #" ++ futureAddedValueName ++ "(v) => {\"__typename\": v} ");
  addToStr("\n}\n\n");
  str^;
};

let printUnionTypes = (~state, ~printName, union: union) => {
  let typeDefs = ref("");
  let addToTypeDefs = Utils.makeAddToStr(typeDefs);

  union.members
  |> List.iter(({shape}: Types.unionMember) => {
       let allObjects: list(Types.finalizedObj) =
         Tablecloth.List.append(shape |> Utils.extractNestedObjects, [shape])
         |> List.map((definition: Types.object_) =>
              {
                originalFlowTypeName: None,
                recordName: {
                  Some(definition.atPath |> Utils.makeRecordName);
                },
                atPath: definition.atPath,
                foundInUnion: true,
                definition,
              }
            );

       let definitions =
         allObjects
         |> List.rev
         |> Tablecloth.List.map(~f=(definition: Types.finalizedObj) =>
              ObjectTypeDeclaration({
                name:
                  Tablecloth.Option.withDefault(
                    ~default="",
                    definition.recordName,
                  ),
                atPath: definition.atPath,
                definition: definition.definition,
              })
            );

       let stateWithUnionDefinitions = {...state, objects: allObjects};

       definitions
       |> List.rev
       |> Tablecloth.List.iter(~f=definition => {
            definition
            |> printRootType(
                 ~state=stateWithUnionDefinitions,
                 ~ignoreFragmentRefs=false,
               )
            |> addToTypeDefs
          });
     });

  let typeT =
    "type "
    ++ Utils.makeRecordName(union.atPath)
    ++ " = "
    ++ printUnionTypeDefinition(
         union,
         ~prefixWithTypesModule=false,
         ~extraIndent=false,
       )
    ++ "\n";

  typeDefs^ ++ "\n" ++ (printName ? typeT : "");
};

let printEnumToStringFn = (enum: fullEnum): string =>
  "external "
  ++ Tablecloth.String.uncapitalize(enum.name)
  ++ "_toString:\n  Types."
  ++ printEnumName(enum.name)
  ++ " => string = \"%identity\"";

let printEnum = (enum: fullEnum): string => printEnumDefinition(enum);

let fragmentRefAssets = (~plural=false, fragmentName) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  addToStr("type t\n");
  addToStr("type fragmentRef\n");

  addToStr(
    "external getFragmentRef:\n  "
    ++ (plural ? "array<" : "")
    ++ "ReasonRelay.fragmentRefs<[> | #"
    ++ fragmentName
    ++ "]>"
    ++ (plural ? ">" : "")
    ++ " => fragmentRef = \"%identity\"",
  );

  str^;
};

let operationType = (operationType: Types.operationType) => {
  let opType =
    switch (operationType) {
    | Fragment(_) => "fragment"
    | Query(_) => "query"
    | Mutation(_) => "mutation"
    | Subscription(_) => "subscription"
    };

  "type relayOperationNode\ntype operationType = ReasonRelay."
  ++ opType
  ++ "Node<relayOperationNode>\n";
};

let printType = typeText => {j|type $typeText;|j};

let printCode: string => string = str => str;
