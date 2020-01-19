open Types;

let makeAddToStr = (container, newStr) => container := container^ ++ newStr;
let makeAddToList = (container, newMember) =>
  container := [newMember, ...container^];

/**
 * To avoid having to pattern match on module access of arbitrary
 * length (read: using dots in value of custom scalar), we mask dots
 * in custom scalar values here and then unmask them when adding the
 * type reference in Reason.
 */

[@gentype]
let maskDots = str =>
  Tablecloth.String.(str |> split(~on=".") |> join(~sep="__oo__"));

[@gentype]
let unmaskDots = str =>
  Tablecloth.String.(str |> split(~on="__oo__") |> join(~sep="."));

let makeObjName = (next, current) => current ++ "_" ++ next;

exception Unique_name_creation_failed(int);

/**
 * This tries to find the simplest unique name given a list of existing names
 * and a path. It's used to create the names of the records produced by the type
 * generator, since they need to be unique (but still make sense to the developer
 * as you occasionally may need to reference them).
 */
let findAppropriateObjName =
    (~usedRecordNames: list(string), ~path: list(string), ~prefix) => {
  let getName = n =>
    switch (prefix) {
    | Some(prefix) => prefix ++ "_" ++ n
    | None => n
    };

  let isUnique = name => !List.exists(n => n == name, usedRecordNames);

  switch (path) {
  | [] => raise(Unique_name_creation_failed(1))
  | [name, ..._] when isUnique(getName(name)) => getName(name)
  | [initialName, ...rest] =>
    let currentName = ref(initialName);
    let uniqueName = ref(None);

    rest
    |> List.iter(name => {
         switch (uniqueName^) {
         | Some(_) => ()
         | None =>
           currentName := makeObjName(currentName^, name);

           if (isUnique(currentName^ |> getName)) {
             uniqueName := Some(currentName^ |> getName);
           };
         }
       });

    switch (uniqueName^) {
    | Some(name) => name
    | None => raise(Unique_name_creation_failed(3))
    };
  };
};

[@gentype]
let findObjName = (~usedRecordNames: array(string), ~path: array(string)) =>
  findAppropriateObjName(
    ~usedRecordNames=Tablecloth.Array.toList(usedRecordNames),
    ~path=Tablecloth.Array.toList(path),
  );

let extractNestedObjects = (obj: object_): list(object_) => {
  let objects = ref([]);
  let addObject = o => objects := [o, ...objects^];

  let rec traverseProp = prop =>
    switch (prop) {
    | Array({propType: Object(obj)})
    | Object(obj) =>
      addObject(obj);
      findObj(obj);
    | _ => ()
    }
  and findObj = (o: Types.object_) => {
    o.values
    |> Tablecloth.Array.forEach(~f=v =>
         switch (v) {
         | FragmentRef(_) => ()
         | Prop(_, {propType}) => propType |> traverseProp
         }
       );
  };

  findObj(obj);
  objects^;
};

let rec mapPropType = (~path, propType) =>
  switch (propType) {
  | Object(obj) =>
    let newObj = {...obj, atPath: path} |> adjustObjectPath(~path);
    Object(newObj);
  | Array({propType: Object(obj)} as pv) =>
    let newObj = {...obj, atPath: path} |> adjustObjectPath(~path);
    Array({...pv, propType: Object(newObj)});
  | v => v
  }
and adjustObjectPath = (~path: list(string), obj: object_): object_ => {
  {
    atPath: path,
    values:
      obj.values
      ->Belt.Array.map(v =>
          switch (v) {
          | Prop(name, {propType} as pv) =>
            Prop(
              name,
              {
                ...pv,
                propType: mapPropType(~path=[name, ...path], propType),
              },
            )
          | v => v
          }
        ),
  };
};