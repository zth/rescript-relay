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
            ([
               [%stri [@@@ocaml.warning "-32-34-60"]];
               [%stri include [%m moduleIdentFromGeneratedModule ["Utils"]]];
               [%stri module Operation = [%m moduleIdentFromGeneratedModule []]];
               [%stri
                 module Types = [%m moduleIdentFromGeneratedModule ["Types"]]];
               [%stri
                 let convertVariables :
                     [%t typeFromGeneratedModule ["Types"; "variables"]] ->
                     [%t typeFromGeneratedModule ["Types"; "variables"]] =
                   [%e valFromGeneratedModule ["Internal"; "convertVariables"]]];
               [%stri
                 let convertResponse :
                     [%t typeFromGeneratedModule ["Types"; "response"]] ->
                     [%t typeFromGeneratedModule ["Types"; "response"]] =
                   [%e valFromGeneratedModule ["Internal"; "convertResponse"]]];
               [%stri
                 let convertWrapRawResponse :
                     [%t typeFromGeneratedModule ["Types"; "rawResponse"]] ->
                     [%t typeFromGeneratedModule ["Types"; "rawResponse"]] =
                   [%e
                     valFromGeneratedModule
                       ["Internal"; "convertWrapRawResponse"]]];
               [%stri
                 let commitMutation =
                   (if !NonReactUtils.enabled then
                      RescriptRelay_MutationNonReact.commitMutation
                    else RescriptRelay_Mutation.commitMutation)
                     ~convertVariables ~convertResponse
                     ~convertWrapRawResponse
                     ~node:[%e valFromGeneratedModule ["node"]]];
             ]
            @
            if not !NonReactUtils.enabled then
              [
                [%stri
                  let use =
                    RescriptRelay_Mutation.useMutation ~convertVariables
                      ~convertResponse ~convertWrapRawResponse
                      ~node:[%e valFromGeneratedModule ["node"]]];
              ]
            else []);
          ]
       |> List.map UncurriedUtils.mapStructureItem))
