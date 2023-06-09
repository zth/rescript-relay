open Ppxlib
open Util
let lazyExtension =
  Extension.declare "relay.deferredComponent" Extension.Context.module_expr
    (let open Ast_pattern in
    single_expr_payload
      (pexp_ident __
      ||| map (pexp_construct __ none) ~f:(fun f ident ->
              f (Ldot (ident, "make") ))))
    (fun ~loc ~path:_ ident ->
      match ident with
      | ((Ldot (((Lident moduleName) ), "make"))
      ) ->
        let realLoc = loc in
        let loc = Ppxlib.Location.none in
        let moduleIdentExported =
          Ppxlib.Ast_helper.Mod.ident ~loc
            {
              txt =
                Ldot
                  ( (Lident moduleName ),
                    "ExportedForDynamicImport__" )
                ;
              loc;
            }
        in
        let moduleIdentWithCorrectLoc =
          Ppxlib.Ast_helper.Mod.ident ~loc
            {txt = Lident moduleName ; loc = realLoc}
        in
        Ast_helper.Mod.mk
          (Pmod_structure
             [
               [%stri module M = [%m moduleIdentWithCorrectLoc]]
               [@ocaml.doc
                 " We use a trick here to ensure that jump-to-definition for the\n\
                 \          entire PPX node still points to the _original_ \
                  dynamically imported\n\
                 \          module. By ensuring there's a reference to the \
                  imported module\n\
                 \          (module M below), and ensuring that's the only \
                  thing that gets the\n\
                 \          _real_ loc from the PPX (by assigning that to \
                  realLoc, and\n\
                 \          everything else to the `none` location), we ensure \
                  that jump to\n\
                 \          definition, hover etc all point to the dynamically \
                  imported module\n\
                 \          rather than what the PPX produces. "];
               [%stri module type T = module type of [%m moduleIdentExported]];
               [%stri
                 external import_ :
                   (_
                   [@as
                     [%e makeStringExpr ~loc ("@rescriptModule/" ^ moduleName)]]) ->
                   unit ->
                   (module T) Js.Promise.t = "import"
                   [@@val]];
               [%stri type 't withDefault = {default: 't}];
               [%stri
                 external lazy_ :
                   (unit -> 'props React.component withDefault Js.Promise.t) ->
                   'props React.component = "lazy"
                   [@@module "react"]];
               [%stri
                 let loadReactComponent () =
                   import_ () |. fun __x ->
                   Js.Promise.then_
                     (fun m ->
                       let (module M : T) = m in
                       Js.Promise.resolve {default = M.make})
                     __x];
               [%stri let loadComponent () = import_ () |. ignore];
               [%stri
                 let preload () =
                   (RelayRouter__Types.Component
                      {
                        chunk = [%e makeStringExpr ~loc moduleName];
                        load = loadComponent;
                      }
                   )
                   [@@live]];
               [%stri let component = lazy_ loadReactComponent];
               [%stri
                 let make props =
                   RelayRouter.useRegisterPreloadedAsset
                     (RelayRouter__Types.Component
                        {
                          chunk = [%e makeStringExpr ~loc moduleName];
                          load = loadComponent;
                        }
                     );
                   React.createElement component props];
             ]
          )
      | _ ->
        Location.raise_errorf ~loc
          "Please provide a reference either to the make function of a top \
           level React component module you want to import (MyComponent.make), \
           or the React component module itself (MyComponent).")
