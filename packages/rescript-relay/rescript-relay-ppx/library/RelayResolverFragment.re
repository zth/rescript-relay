open Ppxlib;
open Util;

let make = (~loc, ~moduleName) => {
  let typeFromGeneratedModule = makeTypeAccessor(~loc, ~moduleName);
  let valFromGeneratedModule = makeExprAccessor(~loc, ~moduleName);
  let moduleIdentFromGeneratedModule = makeModuleIdent(~loc, ~moduleName);

  Ast_helper.Mod.mk(
    Pmod_structure(
      List.concat([
        FragmentUtils.makeGeneratedModuleImports(
          ~loc,
          ~moduleIdentFromGeneratedModule,
        ),
        [
          [%stri
            %private
            [@live] [@module "relay-runtime/lib/store/ResolverFragments"]
            external readFragment:
              (
                [%t typeFromGeneratedModule(["operationType"])],
                [%t typeFromGeneratedModule(["fragmentRef"])]
              ) =>
              [%t typeFromGeneratedModule(["Types", "fragment"])] =
              "readFragment"
          ],
          [%stri
            let makeRelayResolver =
                (
                  resolver:
                    [%t typeFromGeneratedModule(["Types", "fragment"])] =>
                    option(t),
                ) => {
              let relayResolver = key => {
                let data: [%t typeFromGeneratedModule(["Types", "fragment"])] =
                  readFragment([%e valFromGeneratedModule(["node"])], key)
                  ->[%e
                      valFromGeneratedModule(["Internal", "convertFragment"])
                    ];

                resolver(data);
              };

              relayResolver;
            }
          ],
        ],
      ]),
    ),
  );
};
