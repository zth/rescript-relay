open Types;

exception Could_not_find_matching_record_definition(string);

let printQuoted = propName => "\"" ++ propName ++ "\"";
let makeUnionName = path =>
  path |> Tablecloth.List.reverse |> Tablecloth.String.join(~sep="_");

let printRecordPropName = propName => propName;
let printEnumName = name => "enum_" ++ name;
let getObjName = name => "obj_" ++ name;
let printEnumTypeName = name => "SchemaAssets.Enum_" ++ name ++ ".t";
let printEnumUnwrapFnReference = name =>
  "SchemaAssets.Enum_" ++ name ++ ".unwrap";
let printEnumWrapFnReference = name => "SchemaAssets.Enum_" ++ name ++ ".wrap";
let printUnionName = name => "Union_" ++ name;
let printUnionTypeName = name => "Union_" ++ name ++ ".t";
let printLocalUnionName = (union: union) =>
  "union_" ++ (union.atPath |> makeUnionName);
let printUnionUnwrapFnReference = name => "Union_" ++ name ++ ".unwrap";
let printUnionWrapFnReference = name => "Union_" ++ name ++ ".wrap";
let printFragmentRef = name =>
  Tablecloth.String.capitalize(name) ++ "_graphql.t";
let getFragmentRefName = name => "__$fragment_ref__" ++ name;
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
    | _ => typeName
    }
  | None => typeName
  }
and printPropType = (~propType, ~state: Types.fullState) =>
  switch (propType) {
  | Scalar(scalar) => printScalar(scalar)
  | Object(obj) => printRecordReference(~obj, ~state)
  | ObjectReference(objName) =>
    objName |> getObjName |> printTypeReference(~state=None)
  | Array(propValue) => printArray(~propValue, ~state)
  | Enum({name}) => printEnumName(name)
  | Union(union) => union |> printLocalUnionName
  | FragmentRefValue(name) => printFragmentRef(name)
  | TypeReference(name) => printTypeReference(~state=Some(state), name)
  }
and printPropValue = (~propValue, ~state) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  if (propValue.nullable) {
    addToStr("option(");
  };

  printPropType(~propType=propValue.propType, ~state) |> addToStr;

  if (propValue.nullable) {
    addToStr(")");
  };

  str^;
}
and printObject = (~obj: object_, ~printAs: objectPrintAs=Record, ~state, ()) => {
  switch (obj.values |> Array.length, printAs) {
  | (_, OnlyFragmentRefs) =>
    let str = ref("{.");
    let addToStr = s => str := str^ ++ s;

    obj.values
    |> Tablecloth.Array.filter(~f=v =>
         switch (v) {
         | FragmentRef(_) => true
         | Prop(_) => false
         }
       )
    |> Array.iteri((index, p) => {
         if (index > 0) {
           addToStr(",");
         };

         addToStr(
           switch (p) {
           | FragmentRef(name) =>
             (name |> getFragmentRefName |> printQuoted)
             ++ ": "
             ++ printFragmentRef(name)
           | Prop(_) => ""
           },
         );
       });

    addToStr("}");
    str^;
  | (0, _) => "unit"
  | (_, Record) =>
    let str = ref("{");
    let addToStr = s => str := str^ ++ s;

    obj.values
    |> Array.iteri((index, p) => {
         if (index > 0) {
           addToStr(",");
         };

         addToStr(
           switch (p) {
           | Prop(name, propValue) =>
             printRecordPropName(name)
             ++ ": "
             ++ printPropValue(~propValue, ~state)
           | FragmentRef(name) =>
             "__wrappedFragment__"
             ++ name
             ++ ": ReasonRelay.wrappedFragmentRef"
           },
         );
       });

    addToStr("}");
    str^;
  };
}
and printArray = (~propValue, ~state) =>
  "array(" ++ printPropValue(~propValue, ~state) ++ ")"
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
};

let printRefetchVariablesMaker = (obj: object_, ~state) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  addToStr("type refetchVariables = ");
  addToStr(
    printObject(
      ~state,
      ~obj={
        atPath: [],
        connection: None,
        values:
          obj.values
          |> Array.map(value =>
               switch (value) {
               | Prop(name, {nullable: false} as propValue) =>
                 Prop(name, {...propValue, nullable: true})
               | a => a
               }
             ),
      },
      (),
    ),
  );
  addToStr(";");

  addToStr("let makeRefetchVariables = (");

  obj.values
  |> Array.iteri((index, p) => {
       if (index > 0) {
         addToStr(",");
       };

       addToStr(
         switch (p) {
         | Prop(name, _) => "~" ++ name ++ "=?"
         | FragmentRef(_) => ""
         },
       );
     });

  addToStr(", ()): refetchVariables => {");

  obj.values
  |> Array.iteri((index, p) => {
       if (index > 0) {
         addToStr(",");
       };

       addToStr(
         switch (p) {
         | Prop(name, _) => name ++ ": " ++ name
         | FragmentRef(_) => ""
         },
       );
     });

  addToStr("}");
  str^;
};

let printRootType = (~state: fullState, rootType) =>
  switch (rootType) {
  | Operation(obj) =>
    "type response = " ++ printObject(~obj, ~state, ()) ++ ";"
  | Variables(obj) =>
    "type variables = " ++ printObject(~obj, ~state, ()) ++ ";"
  | RefetchVariables(obj) =>
    switch (obj.values |> Array.length) {
    | 0 => ""
    | _ => printRefetchVariablesMaker(~state, obj) ++ ";"
    }

  | Fragment(obj) =>
    "type fragment = " ++ printObject(~obj, ~state, ()) ++ ";"
  | ObjectTypeDeclaration({name, definition}) =>
    "type "
    ++ Tablecloth.String.uncapitalize(name)
    ++ (
      // Because generated records can be empty if the object only contain fragment
      // references, we'll need to print empty records as abstract types here,
      // in the name of type safety!
      switch (
        definition.values
        |> Tablecloth.Array.filter(~f=v =>
             switch (v) {
             | Prop(_) => true
             | FragmentRef(_) => false
             }
           )
        |> Tablecloth.Array.length
      ) {
      | 0 => ""
      | _ => " = " ++ printObject(~obj=definition, ~state, ())
      }
    )
    ++ ";"
  | PluralFragment(obj) =>
    "type fragment_t = "
    ++ printObject(~obj, ~state, ())
    ++ ";\n"
    ++ "type fragment = array(fragment_t);"
  };

let printFragmentExtractor = (~obj: object_, ~state, ~printMode, name) => {
  let fnName = "unwrapFragment_" ++ name;
  let signature =
    name ++ " => " ++ printObject(~obj, ~state, ~printAs=OnlyFragmentRefs, ());

  switch (printMode) {
  | Full => "external " ++ fnName ++ ": " ++ signature ++ " = \"%identity\";"
  | Signature => "let " ++ fnName ++ ": " ++ signature ++ ";"
  };
};

let printObjectDefinition = (~name, ~state, ~printMode, definition: object_) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  switch (
    definition.values
    |> Tablecloth.Array.filter(~f=v =>
         switch (v) {
         | FragmentRef(_) => true
         | Prop(_) => false
         }
       )
    |> Tablecloth.Array.length
  ) {
  | 0 => ()
  | _ =>
    addToStr("\n");
    addToStr(
      name |> printFragmentExtractor(~state, ~printMode, ~obj=definition),
    );
  };

  str^;
};

let printRootObjectTypeConverters =
    (~state: fullState, ~printMode: objectPrintMode=Full, rootType) => {
  let assets =
    switch (rootType) {
    | Operation(definition) => Some(("response", definition))
    | PluralFragment(definition)
    | Fragment(definition) => Some(("fragment", definition))
    | Variables(definition) => Some(("variables", definition))
    | ObjectTypeDeclaration({name, definition}) => Some((name, definition))
    | RefetchVariables(_) => None
    };

  switch (assets) {
  | Some((name, definition)) =>
    definition |> printObjectDefinition(~name, ~state, ~printMode)
  | None => ""
  };
};

let printUnionTypeDefinition = (~printMemberTypeName, union): string => {
  "["
  ++ (
    union.members
    ->Belt.List.map(({name}) =>
        " | `" ++ name ++ "(" ++ printMemberTypeName(name) ++ ")"
      )
    |> Tablecloth.String.join(~sep="\n")
  )
  ++ " | `UnmappedUnionMember "
  ++ "];";
};

let printUnion = (~state, union: union) => {
  let prefix = "module ";
  let unionName = union.atPath |> makeUnionName |> printUnionName;

  let unwrapUnion = "external __unwrap_union: wrapped => {. \"__typename\": string } = \"%identity\";";

  let typeDefs = ref("type wrapped;\n");
  let addToTypeDefs = Utils.makeAddToStr(typeDefs);

  let typeT =
    "type t = "
    ++ union->printUnionTypeDefinition(
         ~printMemberTypeName=Tablecloth.String.uncapitalize,
       );

  let signature = ref("");
  let addToSignature = Utils.makeAddToStr(signature);

  let impl = ref("");
  let addToImpl = Utils.makeAddToStr(impl);

  let unwrappers = ref("");
  let addToUnwrappers = Utils.makeAddToStr(unwrappers);

  union.members
  |> List.iter(({name, shape}: Types.unionMember) => {
       let usedRecordNames: ref(list(string)) = ref([]);
       let addUsedRecordName = Utils.makeAddToList(usedRecordNames);
       let unionTypeName = Tablecloth.String.uncapitalize(name);

       let allObjects: list(Types.finalizedObj) =
         Tablecloth.List.append(shape |> Utils.extractNestedObjects, [shape])
         |> List.map((definition: Types.object_) =>
              {
                originalFlowTypeName: None,
                recordName: {
                  let name =
                    Utils.findAppropriateObjName(
                      ~prefix=None,
                      ~usedRecordNames=usedRecordNames^,
                      ~path=definition.atPath,
                    );

                  addUsedRecordName(name);
                  Some(name);
                },
                atPath: definition.atPath,
                foundInUnion: true,
                definition,
              }
            );

       let definitions =
         allObjects
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
       |> Tablecloth.List.iter(~f=definition => {
            definition
            |> printRootType(~state=stateWithUnionDefinitions)
            |> addToTypeDefs;

            definition
            |> printRootObjectTypeConverters(
                 ~state=stateWithUnionDefinitions,
                 ~printMode=Signature,
               )
            |> addToSignature;

            definition
            |> printRootObjectTypeConverters(
                 ~state=stateWithUnionDefinitions,
                 ~printMode=Full,
               )
            |> addToImpl;
          });

       addToUnwrappers(
         "external __unwrap_"
         ++ unionTypeName
         ++ ": wrapped => "
         ++ unionTypeName
         ++ " = \"%identity\";",
       );
     });

  let unwrapFnImpl =
    ref(
      {|
  let unwrap = wrapped => {
    let unwrappedUnion = wrapped |> __unwrap_union;
    switch (unwrappedUnion##__typename) {
  |},
    );

  let addToUnwrapFnImpl = Utils.makeAddToStr(unwrapFnImpl);

  union.members
  |> List.iter(({name}: Types.unionMember) =>
       addToUnwrapFnImpl(
         "| \""
         ++ name
         ++ "\" => `"
         ++ name
         ++ "(wrapped |> __unwrap_"
         ++ Tablecloth.String.uncapitalize(name)
         ++ ")",
       )
     );

  addToUnwrapFnImpl({|
      | _ => `UnmappedUnionMember
    };
  };
  |});

  prefix
  ++ unionName
  ++ ": {"
  ++ typeDefs^
  ++ typeT
  ++ signature^
  ++ "let unwrap: wrapped => t;"
  ++ "} = { "
  ++ typeDefs^
  ++ unwrapUnion
  ++ typeT
  ++ unwrappers^
  ++ unwrapFnImpl^
  ++ impl^
  ++ "};";
};

let printEnum = (enum: fullEnum): string => {
  let str = ref("type enum_" ++ enum.name ++ " = [");
  let addToStr = s => str := str^ ++ s;

  enum.values
  ->Belt.Array.concat([|"FUTURE_ADDED_VALUE__"|])
  ->Belt.Array.forEach(v => addToStr(" | `" ++ v ++ " "));

  addToStr("];");

  str^;
};

let fragmentRefAssets = (~plural=false, fragmentName) => {
  let fref = fragmentName |> getFragmentRefName;

  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  addToStr("type t;");
  addToStr("type fragmentRef;");
  addToStr("type fragmentRefSelector('a) = ");

  if (plural) {
    addToStr("array(");
  };

  addToStr("{.. \"" ++ fref ++ "\": t} as 'a");

  if (plural) {
    addToStr(")");
  };

  addToStr(";");

  addToStr(
    "external getFragmentRef: fragmentRefSelector('a) => fragmentRef = \"%identity\";",
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

  "type operationType = ReasonRelay." ++ opType ++ "Node;";
};

let printType = typeText => {j|type $typeText;|j};

[@genType]
let printCode = str => str |> Reason.parseRE |> Reason.printRE;