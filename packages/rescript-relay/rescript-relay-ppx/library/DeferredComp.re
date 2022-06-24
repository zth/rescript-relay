open Ppxlib;
open Util;

let lazyExtension =
  Extension.declare(
    "relay.deferredComponent",
    Extension.Context.module_expr,
    /**
     * This matches both SomeModule and SomeModule.make by mapping SomeModule to
       SomeModule.make.
     */
    Ast_pattern.(
      single_expr_payload(
        pexp_ident(__)
        ||| map(pexp_construct(__, none), ~f=(f, ident) =>
              f(Ldot(ident, "make"))
            ),
      )
    ),
    (~loc, ~path as _, ident) => {
    switch (ident) {
    | Ldot(Lident(moduleName), "make") =>
      let realLoc = loc;
      let loc = Ppxlib.Location.none

      let moduleIdent =
        Ppxlib.Ast_helper.Mod.ident(~loc, {txt: Lident(moduleName), loc});
      
      let moduleIdentWithCorrectLoc =
        Ppxlib.Ast_helper.Mod.ident(~loc, {txt: Lident(moduleName), loc: realLoc});

      Ast_helper.Mod.mk(
        Pmod_structure([
          // We use a trick here to ensure that jump-to-definition for the
          // entire PPX node still points to the _original_ dynamically imported
          // module. By ensuring there's a reference to the imported module
          // (module M below), and ensuring that's the only thing that gets the
          // _real_ loc from the PPX (by assigning that to realLoc, and
          // everything else to the `none` location), we ensure that jump to
          // definition, hover etc all point to the dynamically imported module
          // rather than what the PPX produces.
          [%stri module M = [%m moduleIdentWithCorrectLoc]],
          [%stri module type T = (module type of [%m moduleIdent])],
          [%stri
            [@val]
            external import_:
              (
                [@as [%e makeStringExpr(~loc, "@rescriptModule/" ++ moduleName)]] _,
                unit
              ) =>
              Js.Promise.t(module T) =
              "import"
          ],
          [%stri type withDefault('t) = {default: 't}],
          [%stri
            [@module "react"]
            external lazy_:
              (unit => Js.Promise.t(withDefault(React.component('props)))) =>
              React.component('props) =
              "lazy"
          ],
          [%stri
            let loadReactComponent = () =>
              import_()
              ->Js.Promise.then_(
                  m => {
                    let (module M): (module T) = m;
                    Js.Promise.resolve({default: M.make});
                  },
                  _,
                )
          ],
          [%stri
            let eagerPreload = () => {
              let _ = import_()
            } 
          ],
          [%stri
            [@live] let preload = () => {
              RelayRouterTypes.Component({
                moduleName: [%e makeStringExpr(~loc, moduleName)], 
                chunk: [%e makeStringExpr(~loc, moduleName)],
                eagerPreloadFn: eagerPreload
              })
            }
          ],
          [%stri let%private unsafePlaceholder: module T = [%raw {|{}|}]],
          [%stri module UnsafePlaceholder = (val unsafePlaceholder)],
          [%stri let makeProps = UnsafePlaceholder.makeProps],
          [%stri let component =  lazy_(loadReactComponent)],
          [%stri let make = (props) => {
            RelayRouter.useRegisterPreloadedAsset(
              RelayRouterTypes.Component({
                moduleName: [%e makeStringExpr(~loc, moduleName)], 
                chunk: [%e makeStringExpr(~loc, moduleName)],
                eagerPreloadFn: eagerPreload
              })
            )
            React.createElement(component, props)
          }],
        ]),
      );
    | _ =>
      Location.raise_errorf(
        ~loc,
        "Please provide a reference either to the make function of a top level React component module you want to import (MyComponent.make), or the React component module itself (MyComponent).",
      )
    }
  });
