open Ppxlib
open Util

(* This file is a mess, I know. *)

let lazyExtension =
  Extension.declare "relay.deferredComponent" Extension.Context.module_expr
    (let open Ast_pattern in
    single_expr_payload
      (pexp_ident __
      ||| map (pexp_construct __ none) ~f:(fun f ident ->
              f (Ldot (ident, "make")))))
    (fun ~loc ~path:_ ident ->
      match ident with
      | Ldot (Lident moduleName, "make") ->
        let identAst = Ppxlib.Ast_helper.Exp.ident {loc; txt = ident} in
        Ast_helper.Mod.mk
          (Pmod_structure
             (List.concat
                [
                  [
                    [%stri let loadComponent () = Js.import [%e identAst]]
                    |> UncurriedUtils.wrapAsUncurriedFn ~arity:1;
                    [%stri let preload () = ignore (loadComponent ())]
                    |> UncurriedUtils.wrapAsUncurriedFn ~arity:1;
                    [%stri
                      let preload () =
                        RelayRouter__Types.Component
                          {
                            chunk = [%e makeStringExpr ~loc moduleName];
                            load = preload;
                          }
                        [@@live]]
                    |> UncurriedUtils.wrapAsUncurriedFn ~arity:1;
                    [%stri let make = React.lazy_ loadComponent];
                  ];
                ]
             |> List.map UncurriedUtils.mapStructureItem))
      | _ ->
        Location.raise_errorf ~loc
          "Please provide a reference either to the make function of a top \
           level React component module you want to import (MyComponent.make), \
           or the React component module itself (MyComponent).")
