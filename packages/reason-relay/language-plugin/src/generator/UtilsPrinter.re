open Types;

let printConnectionTraverser =
    (
      ~connectionPropNullable,
      ~edgesPropNullable,
      ~edgesNullable,
      ~nodeNullable,
    ) => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;
  let strEnd = ref("");
  let addToStrEnd = s => strEnd := s ++ strEnd^;

  if (connectionPropNullable) {
    addToStr("switch(connection) { ");
    addToStr("| None => [||] ");
    addToStr("| Some(connection) => ");
    addToStrEnd("}");
  };

  if (edgesPropNullable) {
    addToStr("switch(connection.edges) { ");
    addToStr("| None => [||] ");
    addToStr("| Some(edges) => edges");
    addToStrEnd("}");
  } else {
    addToStr("connection.edges");
  };

  if (edgesNullable) {
    addToStr("->Belt.Array.keepMap(edge => switch(edge) { ");
    addToStr("| None => None ");
    addToStr("| Some(edge) => ");
    addToStrEnd("})");
  } else {
    addToStr("->Belt.Array.keepMap(edge => ");
    addToStrEnd(")");
  };

  if (nodeNullable) {
    addToStr("switch(edge.node) { ");
    addToStr("| None => None ");
    addToStr("| Some(node) => Some(node)");
    addToStrEnd("}");
  } else {
    addToStr("Some(edge.node)");
  };

  str^ ++ strEnd^;
};

let printFullGetConnectionNodesFnDefinition =
    (
      ~functionName,
      ~connectionPropNullable,
      ~connectionTypeName,
      ~nodeTypeName,
      ~edgesPropNullable,
      ~edgesNullable,
      ~nodeNullable,
    ) =>
  "let "
  ++ functionName
  ++ ": "
  ++ (connectionPropNullable ? "option(" : "")
  ++ connectionTypeName
  ++ (connectionPropNullable ? ")" : "")
  ++ " => array("
  ++ nodeTypeName
  ++ ") = connection => "
  ++ printConnectionTraverser(
       ~connectionPropNullable,
       ~edgesPropNullable,
       ~edgesNullable,
       ~nodeNullable,
     )
  ++ ";";

let printGetConnectionNodesFunction =
    (
      ~functionName,
      ~state: fullState,
      ~connectionLocation: string,
      obj: object_,
    )
    : string => {
  let str = ref("");
  let addToStr = s => str := str^ ++ s;

  obj.values
  |> Tablecloth.Array.forEach(~f=v =>
       switch (v) {
       | Prop(
           name,
           {nullable, propType: Object({values, atPath: connectionAtPath})},
         )
           when name == connectionLocation =>
         let connectionPropNullable = nullable;

         values
         |> Tablecloth.Array.forEach(~f=v =>
              switch (v) {
              | Prop(
                  "edges",
                  {
                    nullable,
                    propType:
                      Array({
                        nullable: arrayNullable,
                        propType: Object({values}),
                      }),
                  },
                ) =>
                let edgesPropNullable = nullable;
                let edgesNullable = arrayNullable;

                values
                |> Tablecloth.Array.forEach(~f=v =>
                     switch (v) {
                     | Prop(
                         "node",
                         {
                           nullable,
                           propType:
                             Object({atPath: nodeAtPath}) |
                             Union({atPath: nodeAtPath}),
                         },
                       ) =>
                       let nodeNullable = nullable;

                       switch (
                         state.objects
                         |> Tablecloth.List.find(~f=o =>
                              o.atPath == nodeAtPath
                            ),
                         state.unions
                         ->Tablecloth.List.find(~f=u =>
                             u.union.atPath == nodeAtPath
                           ),
                         state.objects
                         |> Tablecloth.List.find(~f=o =>
                              o.atPath == connectionAtPath
                            ),
                       ) {
                       | (
                           Some({recordName: Some(nodeTypeName)}),
                           None,
                           Some({recordName: Some(connectionTypeName)}),
                         ) =>
                         addToStr(
                           printFullGetConnectionNodesFnDefinition(
                             ~functionName,
                             ~connectionPropNullable,
                             ~connectionTypeName,
                             ~nodeTypeName,
                             ~edgesPropNullable,
                             ~edgesNullable,
                             ~nodeNullable,
                           ),
                         )
                       | (
                           None,
                           Some(union),
                           Some({recordName: Some(connectionTypeName)}),
                         ) =>
                         addToStr(
                           printFullGetConnectionNodesFnDefinition(
                             ~functionName,
                             ~connectionPropNullable,
                             ~connectionTypeName,
                             ~nodeTypeName=
                               Printer.printLocalUnionName(union.union),
                             ~edgesPropNullable,
                             ~edgesNullable,
                             ~nodeNullable,
                           ),
                         )
                       | _ => ()
                       };

                     | _ => ()
                     }
                   );
              | _ => ()
              }
            );
       | _ => ()
       }
     );

  str^;
};

type instruction =
  | ConvertNullableProp
  | ConvertNullableArrayContents
  | ConvertEnum(string)
  | ConvertUnion(string)
  | ConvertCustomField(string)
  | RootObject(string)
  | HasFragments
  | ConvertTopLevelNodeField(string);

type instructionContainer = {
  atPath: list(string),
  instruction,
};

type converterInstructions = Js.Dict.t(Js.Dict.t(string));

type allConverterInstructions = Js.Dict.t(converterInstructions);

type objectAssets = {
  converterInstructions: allConverterInstructions,
  convertersDefinition: string,
};

let printConvertersMap = (map: Js.Dict.t(string)): string =>
  if (map->Js.Dict.keys->Belt.Array.length == 0) {
    "()";
  } else {
    let str = ref("{");
    let addToStr = s => str := str^ ++ s;

    map->Js.Dict.entries
    |> Tablecloth.Array.forEach(~f=((key, value)) => {
         addToStr("\"" ++ key ++ "\": " ++ value ++ ",")
       });

    addToStr("};");
    str^;
  };

type conversionDirection =
  | Wrap
  | Unwrap;

let definitionToAssets =
    (
      ~rootObjects: list(finalizedObj),
      ~direction=Unwrap,
      definition: rootStructure,
    )
    : objectAssets => {
  let instructions: array(instructionContainer) = [||];
  let addInstruction = i => instructions |> Js.Array.push(i) |> ignore;

  let inputObjectInstructions: Js.Dict.t(converterInstructions) =
    Js.Dict.empty();

  let addInputObjInstruction = (name, instructions) =>
    inputObjectInstructions->Js.Dict.set(name, instructions);

  let converters = Js.Dict.empty();

  let rec traversePropType =
          (
            ~converters,
            ~inRootObject,
            ~addInstruction,
            ~propName,
            ~currentPath,
            propType: propType,
          ) =>
    switch (propType) {
    | DataId
    | Scalar(_)
    | FragmentRefValue(_) => ()
    | TypeReference(name) =>
      switch (
        rootObjects->Tablecloth.List.find(
          ~f=
            fun
            | {recordName} when recordName == Some(name) => true
            | _ => false,
        ),
        inputObjectInstructions->Js.Dict.get(name),
      ) {
      | (Some(obj), None) =>
        addInstruction({atPath: currentPath, instruction: RootObject(name)});

        if (inRootObject != Some(name)) {
          // Claim this instruction spot for the current input object. It'll be overwritten below with the real instructions.
          // If we don't do this, `makeRootObjectInstruction` below would put us in an endless loop if this input object has
          // circular dependencies on other input objects.
          addInputObjInstruction(name, Js.Dict.empty());

          obj.definition
          |> makeRootObjectInstruction(~name, ~converters)
          |> addInputObjInstruction(name);
        };
      | (Some(_), Some(_)) =>
        addInstruction({atPath: currentPath, instruction: RootObject(name)})
      | (None, Some(_) | None) =>
        // If none of the above matches, this might be a custom field/custom module supplied by the user. We use a heuristic
        // (is this a module and not a regular type?) to determine.
        if (name->Utils.isModuleName) {
          addInstruction({
            atPath: currentPath,
            instruction: ConvertCustomField(name),
          });

          converters->Js.Dict.set(
            name,
            switch (direction) {
            | Wrap => name ++ ".serialize"
            | Unwrap => name ++ ".parse"
            },
          );
        }
      }
    | Enum({name}) =>
      converters->Js.Dict.set(
        Printer.printEnumName(name),
        switch (direction) {
        | Wrap => Printer.printEnumWrapFnReference(name)
        | Unwrap => Printer.printEnumUnwrapFnReference(name)
        },
      );

      addInstruction({atPath: currentPath, instruction: ConvertEnum(name)});
    | Union({atPath, members} as union) =>
      converters->Js.Dict.set(
        Printer.makeUnionName(atPath),
        switch (direction) {
        | Wrap => union->Printer.printUnionWrapFnReference
        | Unwrap => union->Printer.printUnionUnwrapFnReference
        },
      );

      addInstruction({
        atPath: currentPath,
        instruction: ConvertUnion(Printer.makeUnionName(atPath)),
      });

      members->Belt.List.forEach(member => {
        member.shape.values
        |> traverseProps(
             ~converters,
             ~inRootObject,
             ~addInstruction,
             ~currentPath=[
               member.name |> Tablecloth.String.toLower,
               ...currentPath,
             ],
           )
      });
    | Array({nullable, propType}) =>
      if (nullable) {
        addInstruction({
          atPath: currentPath,
          instruction: ConvertNullableArrayContents,
        });
      };

      propType
      |> traversePropType(
           ~inRootObject,
           ~addInstruction,
           ~propName,
           ~currentPath,
           ~converters,
         );
    | TopLevelNodeField(name, {values}) =>
      addInstruction({
        atPath: currentPath,
        instruction: ConvertTopLevelNodeField(name),
      });

      values
      |> traverseProps(
           ~converters,
           ~inRootObject,
           ~addInstruction,
           ~currentPath,
         );
    | Object({values}) =>
      values
      |> traverseProps(
           ~converters,
           ~inRootObject,
           ~addInstruction,
           ~currentPath,
         )
    }
  and traverseProps =
      (
        ~currentPath,
        ~addInstruction,
        ~converters,
        ~inRootObject: option(string),
        propValues,
      ) => {
    let hasFragments = ref(false);

    propValues
    |> Tablecloth.Array.forEach(~f=p =>
         switch (p) {
         | FragmentRef(_) => hasFragments := true
         | Prop(name, {nullable, propType}) =>
           let newPath = [name, ...currentPath];

           if (nullable) {
             addInstruction({
               atPath: newPath,
               instruction: ConvertNullableProp,
             });
           };

           propType
           |> traversePropType(
                ~converters,
                ~inRootObject,
                ~addInstruction,
                ~currentPath=newPath,
                ~propName=name,
              );
         }
       );

    if (hasFragments^) {
      addInstruction({atPath: currentPath, instruction: HasFragments});
    };
  }
  and makeRootObjectInstruction = (~name, ~converters, obj: object_) => {
    let instructions: array(instructionContainer) = [||];
    let addInstruction = i => instructions |> Js.Array.push(i) |> ignore;

    let () =
      obj.values
      ->traverseProps(
          ~converters,
          ~inRootObject=Some(name),
          ~addInstruction,
          ~currentPath=[],
        );

    instructions->makeConverterInstructions;
  }
  and makeConverterInstructions = instructions => {
    let dict: converterInstructions = Js.Dict.empty();

    instructions
    |> Tablecloth.Array.forEach(~f=instruction => {
         let key =
           instruction.atPath
           |> Tablecloth.List.reverse
           |> Tablecloth.String.join(~sep="_");

         let action =
           switch (instruction.instruction) {
           | ConvertNullableProp => ("n", "")
           | ConvertNullableArrayContents => ("na", "")
           | ConvertEnum(name) => ("e", Printer.printEnumName(name))
           | ConvertUnion(name) => ("u", name)
           | ConvertCustomField(name) => ("c", name)
           | RootObject(name) => ("r", name)
           | ConvertTopLevelNodeField(typeName) => ("tnf", typeName)
           | HasFragments => ("f", "")
           };

         switch (dict->Js.Dict.get(key)) {
         | Some(d) =>
           let (actionName, value) = action;
           d->Js.Dict.set(actionName, value);
         | None => dict->Js.Dict.set(key, Js.Dict.fromList([action]))
         };
       });

    dict;
  };

  switch (definition) {
  | Object(obj) =>
    obj.values
    |> traverseProps(
         ~converters,
         ~inRootObject=None,
         ~addInstruction,
         ~currentPath=[],
       )
  | Union(union) =>
    converters->Js.Dict.set(
      Printer.makeUnionName(union.atPath),
      switch (direction) {
      | Wrap => union->Printer.printUnionWrapFnReference
      | Unwrap => union->Printer.printUnionUnwrapFnReference
      },
    );

    addInstruction({
      atPath: [],
      instruction: ConvertUnion(Printer.makeUnionName(union.atPath)),
    });
    union.members
    ->Belt.List.forEach(obj =>
        obj.shape.values
        |> traverseProps(
             ~converters,
             ~inRootObject=None,
             ~addInstruction,
             ~currentPath=[],
           )
      );
  };

  let rootInstructions = makeConverterInstructions(instructions);

  {
    converterInstructions:
      switch (rootInstructions->Js.Dict.keys->Belt.Array.length) {
      | 0 => Js.Dict.empty()
      | _ =>
        Js.Dict.fromList([
          ("__root", rootInstructions),
          ...inputObjectInstructions
             ->Js.Dict.entries
             ->Belt.List.fromArray
             ->Belt.List.sort(((key, _), (key2, _)) =>
                 String.compare(key, key2)
               ),
        ])
      },
    convertersDefinition: printConvertersMap(converters),
  };
};
