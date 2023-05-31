open Ppxlib
open Util
let make ~loc ~moduleName =
  let typeFromGeneratedModule = makeTypeAccessor ~loc ~moduleName in
  let valFromGeneratedModule = makeExprAccessor ~loc ~moduleName in
  let moduleIdentFromGeneratedModule = makeModuleIdent ~loc ~moduleName in
  Ast_helper.Mod.mk
    (Pmod_structure
       (List.concat
          [
            FragmentUtils.makeGeneratedModuleImports ~loc
              ~moduleIdentFromGeneratedModule;
            [
              [%stri
                [%%private
                external readFragment :
                  [%t typeFromGeneratedModule ["operationType"]] ->
                  [%t typeFromGeneratedModule ["fragmentRef"]] ->
                  [%t typeFromGeneratedModule ["Types"; "fragment"]]
                  = "readFragment"
                  [@@live]
                  [@@module "relay-runtime/lib/store/ResolverFragments"]]];
              [%stri
                let makeRelayResolver
                    (resolver :
                      [%t typeFromGeneratedModule ["Types"; "fragment"]] ->
                      t option) =
                  let relayResolver key =
                    let data :
                        [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                      readFragment [%e valFromGeneratedModule ["node"]] key
                      |. [%e
                           valFromGeneratedModule
                             ["Internal"; "convertFragment"]]
                    in
                    resolver data
                  in
                  relayResolver];
            ];
          ]))
