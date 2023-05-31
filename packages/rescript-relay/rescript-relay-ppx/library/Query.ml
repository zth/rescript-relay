open Ppxlib
open Util

let make ~loc ~moduleName ~hasRawResponseType =
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
           [%%private
           external internal_createOperationDescriptor :
             [%t typeFromGeneratedModule ["relayOperationNode"]]
             RescriptRelay.queryNode ->
             [%t typeFromGeneratedModule ["Types"; "variables"]] ->
             RescriptRelay.operationDescriptor = "createOperationDescriptor"
             [@@module "relay-runtime"] [@@live]]];
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
           external mkQueryRefOpt :
             [%t typeFromGeneratedModule ["queryRef"]] option ->
             [%t typeFromGeneratedModule ["queryRef"]] option = "%identity"];
         [%stri
           external mkQueryRef :
             [%t typeFromGeneratedModule ["queryRef"]] ->
             [%t typeFromGeneratedModule ["queryRef"]] = "%identity"];
         [%stri
           let use =
             RescriptRelay_Migrate.Query.useQuery ~convertVariables
               ~convertResponse
               ~node:[%e valFromGeneratedModule ["node"]]];
         [%stri
           let useLoader =
             RescriptRelay_Migrate.Query.useLoader ~convertVariables
               ~mkQueryRef:mkQueryRefOpt
               ~node:[%e valFromGeneratedModule ["node"]]];
         [%stri
           let usePreloaded =
             RescriptRelay_Migrate.Query.usePreloaded ~convertResponse
               ~mkQueryRef
               ~node:[%e valFromGeneratedModule ["node"]]];
         [%stri
           let fetch =
             RescriptRelay_Migrate.Query.fetch ~convertResponse
               ~convertVariables
               ~node:[%e valFromGeneratedModule ["node"]]];
         [%stri
           let fetchPromised =
             RescriptRelay_Migrate.Query.fetchPromised ~convertResponse
               ~convertVariables
               ~node:[%e valFromGeneratedModule ["node"]]];
         [%stri
           let retain ~(environment : RescriptRelay.Environment.t)
               ~(variables :
                  [%t typeFromGeneratedModule ["Types"; "variables"]]) =
             let operationDescriptor =
               internal_createOperationDescriptor
                 [%e valFromGeneratedModule ["node"]]
                 (variables
                 |. [%e valFromGeneratedModule ["Internal"; "convertVariables"]]
                 )
             in
             (environment |. RescriptRelay.Environment.retain)
               operationDescriptor
             [@@ocaml.doc
               "Calling with a set of variables will make Relay _disable \
                garbage collection_ of this query (+ variables) until you \
                explicitly dispose the `Disposable.t` you get back from this \
                call.\n\n\
                Useful for queries and data you know you want to keep in the \
                store regardless of what happens (like it not being used by \
                any view and therefore potentially garbage collected)."]
             [@@live]];
         (match hasRawResponseType with
         | true ->
           [%stri
             let commitLocalPayload ~(environment : RescriptRelay.Environment.t)
                 ~(variables :
                    [%t typeFromGeneratedModule ["Types"; "variables"]])
                 ~(payload :
                    [%t typeFromGeneratedModule ["Types"; "rawResponse"]]) =
               let operationDescriptor =
                 internal_createOperationDescriptor
                   [%e valFromGeneratedModule ["node"]]
                   (variables
                   |. [%e
                        valFromGeneratedModule ["Internal"; "convertVariables"]]
                   )
               in
               (environment |. RescriptRelay.Environment.commitPayload)
                 operationDescriptor
                 (payload
                 |. [%e
                      valFromGeneratedModule
                        ["Internal"; "convertWrapRawResponse"]])
               [@@ocaml.doc
                 "This commits a payload into the store _locally only_. Useful \
                  for driving client-only state via Relay for example, or \
                  priming the cache with data you don't necessarily want to \
                  hit the server for."]
               [@@live]]
         | false -> [%stri ()]);
       ])
