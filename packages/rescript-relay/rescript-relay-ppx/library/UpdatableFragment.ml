open Ppxlib
open Util
let make ~loc ~moduleName =
  let valFromGeneratedModule = makeExprAccessor ~loc ~moduleName in
  let moduleIdentFromGeneratedModule = makeModuleIdent ~loc ~moduleName in
  Ast_helper.Mod.mk
    (Pmod_structure
       (List.concat
          [
            [
              [%stri [@@@warning "-32-34-60"]];
              [%stri
                module Types = [%m moduleIdentFromGeneratedModule ["Types"]]];
              [%stri
                let readUpdatableFragment = [%e valFromGeneratedModule ["readUpdatableFragment"]]];
            ];
          ]
       |> List.map UncurriedUtils.mapStructureItem))
