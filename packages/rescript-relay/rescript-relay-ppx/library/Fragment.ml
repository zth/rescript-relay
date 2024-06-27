open Ppxlib
open Util

let make ~loc ~moduleName ~refetchableQueryName ~extractedConnectionInfo
    ~hasInlineDirective ~isPlural =
  let typeFromGeneratedModule = makeTypeAccessor ~loc ~moduleName in
  let valFromGeneratedModule = makeExprAccessor ~loc ~moduleName in
  let moduleIdentFromGeneratedModule = makeModuleIdent ~loc ~moduleName in
  let hasConnection = extractedConnectionInfo in
  Ast_helper.Mod.mk
    (Pmod_structure
       (List.concat
          [
            [
              [%stri [@@@warning "-32-34-60"]];
              [%stri include [%m moduleIdentFromGeneratedModule ["Utils"]]];
              [%stri
                module Types = [%m moduleIdentFromGeneratedModule ["Types"]]];
              [%stri module Operation = [%m moduleIdentFromGeneratedModule []]];
              [%stri
                let convertFragment :
                    [%t typeFromGeneratedModule ["Types"; "fragment"]] ->
                    [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                  [%e valFromGeneratedModule ["Internal"; "convertFragment"]]];
            ];
            (match hasInlineDirective with
            | false ->
              [
                [%stri
                  let use fRef :
                      [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                    RescriptRelay_Fragment.useFragment ~convertFragment
                      ~fRef:
                        (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                      ~node:[%e valFromGeneratedModule ["node"]]];
                [%stri
                  let useOpt fRef :
                      [%t typeFromGeneratedModule ["Types"; "fragment"]] option
                      =
                    RescriptRelay_Fragment.useFragmentOpt ~convertFragment
                      ~fRef:
                        (match fRef with
                        | Some fRef ->
                          Some
                            (fRef
                            |. [%e valFromGeneratedModule ["getFragmentRef"]])
                        | None -> None)
                      ~node:[%e valFromGeneratedModule ["node"]]];
                (if isPlural then
                   [%stri
                     let readResolverFragment fRef :
                         [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                       let fRef =
                         fRef
                         |. RescriptRelay_Internal
                            .internal_resolverFragmentRefsToFragmentRefsPlural
                       in
                       RescriptRelay_Fragment.read ~convertFragment
                         ~fRef:
                           (fRef
                           |. [%e valFromGeneratedModule ["getFragmentRef"]])
                         ~node:[%e valFromGeneratedModule ["node"]]]
                 else
                   [%stri
                     let readResolverFragment fRef :
                         [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                       let fRef =
                         fRef
                         |. RescriptRelay_Internal
                            .internal_resolverFragmentRefsToFragmentRefs
                       in
                       RescriptRelay_Fragment.read ~convertFragment
                         ~fRef:
                           (fRef
                           |. [%e valFromGeneratedModule ["getFragmentRef"]])
                         ~node:[%e valFromGeneratedModule ["node"]]]);
              ]
            | true -> []);
            (match hasInlineDirective with
            | true ->
              [
                [%stri
                  let readInline fRef :
                      [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                    RescriptRelay_Fragment.readInlineData ~convertFragment
                      ~fRef:
                        (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                      ~node:[%e valFromGeneratedModule ["node"]]];
              ]
            | false -> []);
            (match refetchableQueryName with
            | None -> []
            | Some refetchableQueryName ->
              let typeFromRefetchableModule =
                makeTypeAccessor ~loc ~moduleName:refetchableQueryName
              in
              let valFromRefetchableModule =
                makeExprAccessor ~loc ~moduleName:refetchableQueryName
              in
              [
                [%stri
                  let makeRefetchVariables =
                    [%e
                      valFromRefetchableModule ["Types"; "makeRefetchVariables"]]
                  [@@ocaml.doc "A helper to make refetch variables. "] [@@live]];
                [%stri
                  let convertRefetchVariables :
                      [%t
                        typeFromRefetchableModule ["Types"; "refetchVariables"]] ->
                      [%t
                        typeFromRefetchableModule ["Types"; "refetchVariables"]]
                      =
                    [%e
                      valFromRefetchableModule ["Internal"; "convertVariables"]]];
                [%stri
                  let useRefetchable fRef =
                    RescriptRelay_Fragment.useRefetchableFragment
                      ~convertFragment ~convertRefetchVariables
                      ~fRef:
                        (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                      ~node:[%e valFromGeneratedModule ["node"]]];
              ]
              @
              if hasConnection then
                [
                  [%stri
                    let usePagination fRef =
                      RescriptRelay_Fragment.usePaginationFragment
                        ~convertFragment ~convertRefetchVariables
                        ~fRef:
                          (fRef
                          |. [%e valFromGeneratedModule ["getFragmentRef"]])
                        ~node:[%e valFromGeneratedModule ["node"]]];
                  [%stri
                    let useBlockingPagination fRef =
                      RescriptRelay_Fragment.useBlockingPaginationFragment
                        ~convertFragment ~convertRefetchVariables
                        ~fRef:
                          (fRef
                          |. [%e valFromGeneratedModule ["getFragmentRef"]])
                        ~node:[%e valFromGeneratedModule ["node"]]];
                ]
              else []);
          ]
       |> List.map UncurriedUtils.mapStructureItem))
