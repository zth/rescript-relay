open Ppxlib
open Ast_helper

class mapper =
  object (self)
    inherit Ast_traverse.map
    method! signature signature =
      signature |> List.map (fun v -> [v]) |> List.concat
    method! structure structure =
      structure
      |> List.map (fun v ->
             match v with
             | {pstr_desc = Pstr_value (_, [{pvb_attributes}])}
               when pvb_attributes
                    |> List.exists (fun (name : attribute) ->
                           name.attr_name.txt = "relay.deferredComponent") ->
               [
                 v;
                 Str.mk
                   (Pstr_module
                      {
                        pmb_name =
                          {
                            txt = Some "ExportedForDynamicImport__";
                            loc = Location.none;
                          };
                        pmb_expr =
                          Mod.structure
                            [
                              Str.value Nonrecursive
                                [
                                  Vb.mk
                                    (Pat.var
                                       {txt = "make"; loc = Location.none})
                                    (Exp.ident
                                       {
                                         txt = Lident "make";
                                         loc = Location.none;
                                       });
                                ];
                            ];
                        pmb_attributes = [];
                        pmb_loc = Location.none;
                      });
               ]
             | _ -> [v])
      |> List.concat
  end

let structure_mapper s = (new mapper)#structure s
let signature_mapper s = (new mapper)#signature s