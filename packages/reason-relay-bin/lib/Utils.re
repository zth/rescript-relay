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

let makeRecordName = (path: list(string)) =>
  path |> Tablecloth.List.reverse |> Tablecloth.String.join(~sep="_");

let getWithDefault = (def, value) =>
  switch (value) {
  | Some(v) => v
  | None => def
  };

let isModuleName = name =>
  name
  |> Tablecloth.String.split(~on=".")
  |> Tablecloth.List.last
  |> getWithDefault("")
  |> Tablecloth.String.isCapitalized;

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
    |> List.iter(v =>
         switch (v) {
         | FragmentRef(_) => ()
         | Prop(_, {propType}) => propType |> traverseProp
         }
       );
  };

  findObj(obj);
  objects^;
};

let rec mapPropType = (~path, propType: propType): propType =>
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
      |> List.map(v =>
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
