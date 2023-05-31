open Ppxlib
open Util

let make ~loc ~moduleName ~refetchableQueryName ~extractedConnectionInfo
    ~hasInlineDirective =
  let typeFromGeneratedModule = makeTypeAccessor ~loc ~moduleName in
  let valFromGeneratedModule = makeExprAccessor ~loc ~moduleName in
  let moduleIdentFromGeneratedModule = makeModuleIdent ~loc ~moduleName in
  let hasConnection = extractedConnectionInfo in
  Ast_helper.Mod.mk
    (Pmod_structure
       (List.concat
          [
            FragmentUtils.makeGeneratedModuleImports ~loc
              ~moduleIdentFromGeneratedModule;
            FragmentUtils.makeInternalExternals ~loc ~typeFromGeneratedModule;
            FragmentUtils.makeRefetchableAssets ~loc ~refetchableQueryName
              ~typeFromGeneratedModule ~makeTypeAccessor ~makeExprAccessor
              ~valFromGeneratedModule;
            [
              [%stri module Operation = [%m moduleIdentFromGeneratedModule []]];
              [%stri
                let use fRef :
                    [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                  let data =
                    internal_useFragment
                      [%e valFromGeneratedModule ["node"]]
                      (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                  in
                  RescriptRelay_Internal.internal_useConvertedValue
                    [%e valFromGeneratedModule ["Internal"; "convertFragment"]]
                    data
                  [@@ocaml.doc
                    "React hook for getting the data of this fragment. Pass \
                     the `fragmentRefs` of any object where you've spread your \
                     fragment into this and get the fragment data back.\n\n\
                     ### Fragment data outside of React's render\n\
                     If you're looking for a way to use fragments _outside_ of \
                     render (for regular function calls for instance, like for \
                     logging etc), look in to adding `@inline` to your \
                     fragment definition (like `fragment SomeFragment_user on \
                     User @inline {...}`) and then use `Fragment.readInline`. \
                     This will allow you to get the fragment data, but outside \
                     of React's render."]
                  [@@live]];
              [%stri
                let useOpt opt_fRef :
                    [%t typeFromGeneratedModule ["Types"; "fragment"]] option =
                  let fr =
                    match opt_fRef with
                    | Some fRef ->
                      Some
                        (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                    | None -> None
                  in
                  let nullableFragmentData :
                      [%t typeFromGeneratedModule ["Types"; "fragment"]]
                      Js.Nullable.t =
                    internal_useFragmentOpt
                      [%e valFromGeneratedModule ["node"]]
                      (match fr with
                      | Some fr -> Some fr |. Js.Nullable.fromOption
                      | None -> Js.Nullable.null)
                  in
                  let data = nullableFragmentData |. Js.Nullable.toOption in
                  RescriptRelay_Internal.internal_useConvertedValue
                    (fun rawFragment ->
                      match rawFragment with
                      | Some rawFragment ->
                        Some
                          (rawFragment
                          |. [%e
                               valFromGeneratedModule
                                 ["Internal"; "convertFragment"]])
                      | None -> None)
                    data
                  [@@ocaml.doc
                    "A version of `Fragment.use` that'll allow you to pass \
                     `option<fragmentRefs>` and get `option<'fragmentData>` \
                     back. Useful for scenarios where you don't have the \
                     fragmentRefs yet."]
                  [@@live]];
              (match hasInlineDirective with
              | true ->
                [%stri
                  let readInline fRef :
                      [%t typeFromGeneratedModule ["Types"; "fragment"]] =
                    internal_readInlineData
                      [%e valFromGeneratedModule ["node"]]
                      (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                    |. [%e
                         valFromGeneratedModule ["Internal"; "convertFragment"]]
                    [@@ocaml.doc
                      "This lets you get the data for this fragment _outside \
                       of React's render_. Useful for letting functions with \
                       with fragments too, for things like logging etc."]
                    [@@live]]
              | false -> [%stri ()]);
              (match (hasConnection, refetchableQueryName) with
              | true, Some queryName ->
                [%stri
                  let usePagination fr : paginationFragmentReturn =
                    let p =
                      internal_usePaginationFragment
                        [%e valFromGeneratedModule ["node"]]
                        ([%e valFromGeneratedModule ["getFragmentRef"]] fr)
                    in
                    let data =
                      RescriptRelay_Internal.internal_useConvertedValue
                        [%e
                          valFromGeneratedModule ["Internal"; "convertFragment"]]
                        p.data
                    in
                    {
                      data;
                      loadNext =
                        React.useMemo1
                          (fun () ~count ?onComplete () ->
                            (p.loadNext count
                               {
                                 onComplete =
                                   onComplete
                                   |. RescriptRelay_Internal
                                      .internal_nullableToOptionalExnHandler;
                               } [@bs]))
                          [|p.loadNext|];
                      loadPrevious =
                        React.useMemo1
                          (fun () ~count ?onComplete () ->
                            (p.loadPrevious count
                               {
                                 onComplete =
                                   onComplete
                                   |. RescriptRelay_Internal
                                      .internal_nullableToOptionalExnHandler;
                               } [@bs]))
                          [|p.loadPrevious|];
                      hasNext = p.hasNext;
                      hasPrevious = p.hasPrevious;
                      isLoadingNext = p.isLoadingNext;
                      isLoadingPrevious = p.isLoadingPrevious;
                      refetch =
                        React.useMemo1
                          (fun ()
                               ~(variables :
                                  [%t
                                    makeTypeAccessor ~loc ~moduleName:queryName
                                      ["Types"; "refetchVariables"]])
                               ?fetchPolicy ?onComplete () ->
                            (p.refetch
                               (variables
                               |. [%e
                                    makeExprAccessor ~loc ~moduleName:queryName
                                      ["Internal"; "convertVariables"]]
                               |. RescriptRelay_Internal
                                  .internal_cleanObjectFromUndefinedRaw)
                               (internal_makeRefetchableFnOpts ?onComplete
                                  ?fetchPolicy ()) [@bs]))
                          [|p.refetch|];
                    }
                    [@@ocaml.doc
                      "React hook for paginating a fragment. Paginating with \
                       this hook will _not_ cause your component to suspend. \
                       If you want pagination to trigger suspense, look into \
                       using `Fragment.useBlockingPagination`."]
                    [@@live]]
              | _ -> [%stri ()]);
              (match (hasConnection, refetchableQueryName) with
              | true, Some queryName ->
                [%stri
                  let useBlockingPagination fRef :
                      paginationBlockingFragmentReturn =
                    let p =
                      internal_useBlockingPaginationFragment
                        [%e valFromGeneratedModule ["node"]]
                        (fRef |. [%e valFromGeneratedModule ["getFragmentRef"]])
                    in
                    let data =
                      RescriptRelay_Internal.internal_useConvertedValue
                        [%e
                          valFromGeneratedModule ["Internal"; "convertFragment"]]
                        p.data
                    in
                    {
                      data;
                      loadNext =
                        React.useMemo1
                          (fun () ~count ?onComplete () ->
                            (p.loadNext count
                               {
                                 onComplete =
                                   onComplete
                                   |. RescriptRelay_Internal
                                      .internal_nullableToOptionalExnHandler;
                               } [@bs]))
                          [|p.loadNext|];
                      loadPrevious =
                        React.useMemo1
                          (fun () ~count ?onComplete () ->
                            (p.loadPrevious count
                               {
                                 onComplete =
                                   onComplete
                                   |. RescriptRelay_Internal
                                      .internal_nullableToOptionalExnHandler;
                               } [@bs]))
                          [|p.loadPrevious|];
                      hasNext = p.hasNext;
                      hasPrevious = p.hasPrevious;
                      refetch =
                        React.useMemo1
                          (fun ()
                               ~(variables :
                                  [%t
                                    makeTypeAccessor ~loc ~moduleName:queryName
                                      ["Types"; "refetchVariables"]])
                               ?fetchPolicy ?onComplete () ->
                            (p.refetch
                               (variables
                               |. [%e
                                    makeExprAccessor ~loc ~moduleName:queryName
                                      ["Internal"; "convertVariables"]]
                               |. RescriptRelay_Internal
                                  .internal_cleanObjectFromUndefinedRaw)
                               (internal_makeRefetchableFnOpts ?onComplete
                                  ?fetchPolicy ()) [@bs]))
                          [|p.refetch|];
                    }
                    [@@ocaml.doc
                      "Like `Fragment.usePagination`, but calling the \
                       pagination function will trigger suspense. Useful for \
                       all-at-once pagination."]
                    [@@live]]
              | _ -> [%stri ()]);
              (match (refetchableQueryName, hasConnection) with
              | Some queryName, _ ->
                [%stri
                  let makeRefetchVariables =
                    [%e
                      makeExprAccessor ~loc ~moduleName:queryName
                        ["Types"; "makeRefetchVariables"]]
                    [@@ocaml.doc "A helper to make refetch variables. "]
                    [@@live]]
              | _ -> [%stri ()]);
            ];
          ]))
