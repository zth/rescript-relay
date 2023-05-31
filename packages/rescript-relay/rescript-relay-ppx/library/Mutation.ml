open Ppxlib
open Util

let make ~loc ~moduleName =
  let typeFromGeneratedModule = makeTypeAccessor ~loc ~moduleName in
  let valFromGeneratedModule = makeExprAccessor ~loc ~moduleName in
  let moduleIdentFromGeneratedModule = makeModuleIdent ~loc ~moduleName in
  Ast_helper.Mod.mk
    (Pmod_structure
       [
         [%stri [@@@ocaml.warning "-32-34-60"]];
         [%stri include [%m moduleIdentFromGeneratedModule ["Utils"]]];
         [%stri module Operation = [%m moduleIdentFromGeneratedModule []]];
         [%stri module Types = [%m moduleIdentFromGeneratedModule ["Types"]]];
         [%stri
           type updaterFn =
             RescriptRelay.RecordSourceSelectorProxy.t ->
             [%t typeFromGeneratedModule ["Types"; "response"]] ->
             unit
           [@@live]];
         [%stri
           type optimisticUpdaterFn =
             RescriptRelay.RecordSourceSelectorProxy.t -> unit
           [@@live]];
         [%stri
           type useMutationConfig = {
             onError: (RescriptRelay.mutationError -> unit) option;
             onCompleted:
               ([%t typeFromGeneratedModule ["Types"; "response"]] ->
               RescriptRelay.mutationError array option ->
               unit)
               option;
             onUnsubscribe: (unit -> unit) option;
             optimisticResponse:
               [%t typeFromGeneratedModule ["Types"; "rawResponse"]] option;
             optimisticUpdater: optimisticUpdaterFn option;
             updater: updaterFn option;
             variables: [%t typeFromGeneratedModule ["Types"; "variables"]];
             uploadables: RescriptRelay.uploadables option;
           }
           [@@live]];
         [%stri
           type useMutationConfigRaw = {
             onError: (RescriptRelay.mutationError -> unit) option;
             onCompleted:
               ([%t typeFromGeneratedModule ["Types"; "response"]] ->
               RescriptRelay.mutationError array Js.Nullable.t ->
               unit)
               option;
             onUnsubscribe: (unit -> unit) option;
             optimisticResponse:
               [%t typeFromGeneratedModule ["Types"; "rawResponse"]] option;
             optimisticUpdater: optimisticUpdaterFn option;
             updater: updaterFn option;
             variables: [%t typeFromGeneratedModule ["Types"; "variables"]];
             uploadables: RescriptRelay.uploadables option;
           }
           [@@live]];
         [%stri
           [%%private
           external internal_useMutation :
             [%t typeFromGeneratedModule ["relayOperationNode"]]
             RescriptRelay.mutationNode ->
             (useMutationConfigRaw -> RescriptRelay.Disposable.t) * bool
             = "useMutation"
             [@@module "react-relay"] [@@live]]];
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
             [%e valFromGeneratedModule ["Internal"; "convertWrapRawResponse"]]];
         [%stri
           let commitMutation =
             RescriptRelay_Migrate.Mutation.commitMutation ~convertVariables
               ~convertResponse ~convertWrapRawResponse
               ~node:[%e valFromGeneratedModule ["node"]]];
         [%stri
           let use :
               unit ->
               (?onError:(RescriptRelay.mutationError -> unit) ->
               ?onCompleted:
                 ([%t typeFromGeneratedModule ["Types"; "response"]] ->
                 RescriptRelay.mutationError array option ->
                 unit) ->
               ?onUnsubscribe:(unit -> unit) ->
               ?optimisticResponse:
                 [%t typeFromGeneratedModule ["Types"; "rawResponse"]] ->
               ?optimisticUpdater:optimisticUpdaterFn ->
               ?updater:
                 (RescriptRelay.RecordSourceSelectorProxy.t ->
                 [%t typeFromGeneratedModule ["Types"; "response"]] ->
                 unit) ->
               variables:[%t typeFromGeneratedModule ["Types"; "variables"]] ->
               ?uploadables:RescriptRelay.uploadables ->
               unit ->
               RescriptRelay.Disposable.t)
               * bool =
            fun () ->
             let mutate, mutating =
               internal_useMutation [%e valFromGeneratedModule ["node"]]
             in
             ( React.useMemo1
                 (fun () ?onError ?onCompleted ?onUnsubscribe
                      ?optimisticResponse ?optimisticUpdater ?updater ~variables
                      ?uploadables () ->
                   mutate
                     {
                       onError;
                       onCompleted =
                         (match onCompleted with
                         | Some fn ->
                           Some
                             (fun r errors ->
                               fn
                                 (r
                                 |. [%e
                                      valFromGeneratedModule
                                        ["Internal"; "convertResponse"]])
                                 (Js.Nullable.toOption errors))
                         | None -> None);
                       optimisticResponse =
                         (match optimisticResponse with
                         | None -> None
                         | Some r ->
                           Some
                             (r
                             |. [%e
                                  valFromGeneratedModule
                                    ["Internal"; "convertWrapRawResponse"]]));
                       onUnsubscribe;
                       variables =
                         variables
                         |. [%e
                              valFromGeneratedModule
                                ["Internal"; "convertVariables"]];
                       optimisticUpdater;
                       uploadables;
                       updater =
                         (match updater with
                         | None -> None
                         | Some updater ->
                           Some
                             (fun store r ->
                               updater store
                                 (r
                                 |. [%e
                                      valFromGeneratedModule
                                        ["Internal"; "convertResponse"]])));
                     })
                 [|mutate|],
               mutating )
            [@@ocaml.doc
              "React hook for commiting this mutation.\n\n\
               ### Optimistic updates\n\
               Remember to annotate your mutation with `@raw_response_type` if \
               you want to do optimistic updates. That'll make Relay emit the \
               required type information for covering everything needed when \
               doing optimistic updates."]
            [@@live]];
       ])
  [@@ocaml.doc
    "\n\
    \ * Check out the comments for makeFragment, this does the same thing but \
     for mutations.\n\
    \ "]
