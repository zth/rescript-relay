open Ppxlib
open Util

let make ~loc ~moduleName ~refetchableQueryName
    ~(connectionInfo : connectionInfo option) ~hasInlineDirective ~isPlural
    ~hasAutocodesplitDirective =
  let typeFromGeneratedModule = makeTypeAccessor ~loc ~moduleName in
  let valFromGeneratedModule = makeExprAccessor ~loc ~moduleName in
  let moduleIdentFromGeneratedModule = makeModuleIdent ~loc ~moduleName in
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
            (match
               (NonReactUtils.enabled.contents, hasAutocodesplitDirective)
             with
            | true, _ -> []
            | false, true ->
              [
                [%stri
                  module CodesplitComponents =
                    [%m
                    moduleIdentFromGeneratedModule ["CodesplitComponents"]]];
              ]
            | false, false -> []);
            [
              (if NonReactUtils.enabled.contents then
                 [%stri
                   let waitForFragmentData ~environment fRef =
                     RescriptRelay_FragmentNonReact.waitForFragmentData
                       ~environment ~convertFragment
                       ~fRef:
                         (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                       ~node:[%e valFromGeneratedModule ["node"]]]
               else
                 [%stri
                   let waitForFragmentData ~environment fRef =
                     RescriptRelay_Fragment.waitForFragmentData ~environment
                       ~convertFragment
                       ~fRef:
                         (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                       ~node:[%e valFromGeneratedModule ["node"]]]);
            ];
            (match (NonReactUtils.enabled.contents, hasInlineDirective) with
            | true, _ -> []
            | false, false ->
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
              ]
            | false, true -> []);
            (match hasInlineDirective with
            | false ->
              [
                (if isPlural then
                   if NonReactUtils.enabled.contents then
                     [%stri
                       let readResolverFragment fRef :
                           [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                         let fRef =
                           fRef
                           |. RescriptRelay_Internal
                              .internal_resolverFragmentRefsToFragmentRefsPlural
                         in
                         RescriptRelay_FragmentNonReact.read ~convertFragment
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
                              .internal_resolverFragmentRefsToFragmentRefsPlural
                         in
                         RescriptRelay_Fragment.read ~convertFragment
                           ~fRef:
                             (fRef
                             |. [%e valFromGeneratedModule ["getFragmentRef"]])
                           ~node:[%e valFromGeneratedModule ["node"]]]
                 else if NonReactUtils.enabled.contents then
                   [%stri
                     let readResolverFragment fRef :
                         [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                       let fRef =
                         fRef
                         |. RescriptRelay_Internal
                            .internal_resolverFragmentRefsToFragmentRefs
                       in
                       RescriptRelay_FragmentNonReact.read ~convertFragment
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
            (match (NonReactUtils.enabled.contents, hasInlineDirective) with
            | true, _ -> []
            | false, true ->
              [
                (if NonReactUtils.enabled.contents then
                   [%stri
                     let readInline fRef :
                         [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                       RescriptRelay_FragmentNonReact.readInlineData_
                         ~convertFragment
                         ~fRef:
                           (fRef
                           |. [%e valFromGeneratedModule ["getFragmentRef"]])
                         ~node:[%e valFromGeneratedModule ["node"]]]
                 else
                   [%stri
                     let readInline fRef :
                         [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                       RescriptRelay_Fragment.readInlineData ~convertFragment
                         ~fRef:
                           (fRef
                           |. [%e valFromGeneratedModule ["getFragmentRef"]])
                         ~node:[%e valFromGeneratedModule ["node"]]]);
              ]
            | false, false -> []);
            (match (NonReactUtils.enabled.contents, refetchableQueryName) with
            | true, _ | false, None -> []
            | false, Some refetchableQueryName -> (
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
              match connectionInfo with
              | Some {prefetchable_pagination = false} ->
                [
                  [%stri
                    let usePagination fRef =
                      RescriptRelay_Fragment.usePaginationFragment
                        ~convertFragment ~convertRefetchVariables
                        ~fRef:
                          (fRef
                          |. [%e valFromGeneratedModule ["getFragmentRef"]])
                        ~node:[%e valFromGeneratedModule ["node"]]];
                ]
              | Some {prefetchable_pagination = true} ->
                let edgesModuleName = moduleName ^ "__edges" in
                let typeFromEdgesModule =
                  makeTypeAccessor ~loc ~moduleName:edgesModuleName
                in
                let valFromEdgesModule =
                  makeExprAccessor ~loc ~moduleName:edgesModuleName
                in

                [
                  [%stri
                    let convertEdges :
                        [%t typeFromEdgesModule ["Types"; "fragment"]] ->
                        [%t typeFromEdgesModule ["Types"; "fragment"]] =
                      [%e valFromEdgesModule ["Internal"; "convertFragment"]]];
                  [%stri
                    let usePrefetchableForwardPagination ~bufferSize
                        ?initialSize ?prefetchingLoadMoreOptions
                        ?minimumFetchSize fRef =
                      RescriptRelay_Fragment.usePrefetchableForwardPagination
                        ~convertFragment ~convertEdges ~convertRefetchVariables
                        ~fRef:
                          (fRef
                          |. [%e valFromGeneratedModule ["getFragmentRef"]])
                        ~node:[%e valFromGeneratedModule ["node"]]
                        ~bufferSize ?initialSize ?prefetchingLoadMoreOptions
                        ?minimumFetchSize];
                ]
              | None -> []));
          ]
       |> List.map UncurriedUtils.mapStructureItem))
