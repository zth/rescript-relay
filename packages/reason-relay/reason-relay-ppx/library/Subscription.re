open Ppxlib;
open Util;

/**
 * Check out the comments for makeFragment, this does the same thing but for subscriptions.
 */
let make = (~loc, ~moduleName) => {
  let typeFromGeneratedModule = makeTypeAccessor(~loc, ~moduleName);
  let valFromGeneratedModule = makeExprAccessor(~loc, ~moduleName);
  let moduleIdentFromGeneratedModule = makeModuleIdent(~loc, ~moduleName);

  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri [@ocaml.warning "-32"]],
      [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
      [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
      [%stri
        type updaterFn =
          (
            ReasonRelay.RecordSourceSelectorProxy.t,
            [%t typeFromGeneratedModule(["Types", "response"])]
          ) =>
          unit
      ],
      [%stri
        [@deriving abstract]
        type subscriptionConfig = {
          subscription:
            ReasonRelay.subscriptionNode(
              [%t typeFromGeneratedModule(["relayOperationNode"])],
            ),
          variables: [%t typeFromGeneratedModule(["Types", "variables"])],
          [@optional]
          onCompleted: unit => unit,
          [@optional]
          onError: Js.Exn.t => unit,
          [@optional]
          onNext: [%t typeFromGeneratedModule(["Types", "response"])] => unit,
          [@optional]
          updater: updaterFn,
        }
      ],
      [%stri
        %private
        [@module "relay-runtime"]
        external internal_requestSubscription:
          (ReasonRelay.Environment.t, subscriptionConfig) =>
          ReasonRelay.Disposable.t =
          "requestSubscription"
      ],
      [%stri
        let subscribe:
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
            ~onCompleted: unit => unit=?,
            ~onError: Js.Exn.t => unit=?,
            ~onNext: [%t typeFromGeneratedModule(["Types", "response"])] =>
                     unit
                       =?,
            ~updater: updaterFn=?,
            unit
          ) =>
          ReasonRelay.Disposable.t =
          (
            ~environment,
            ~variables,
            ~onCompleted=?,
            ~onError=?,
            ~onNext=?,
            ~updater=?,
            (),
          ) =>
            internal_requestSubscription(
              environment,
              subscriptionConfig(
                ~subscription=[%e valFromGeneratedModule(["node"])],
                ~variables=
                  variables->[%e
                               valFromGeneratedModule([
                                 "Internal",
                                 "convertVariables",
                               ])
                             ],
                ~onCompleted?,
                ~onError?,
                ~onNext=?
                  switch (onNext) {
                  | None => None
                  | Some(onNext) =>
                    Some(
                      r =>
                        onNext(
                          r->[%e
                               valFromGeneratedModule([
                                 "Internal",
                                 "convertResponse",
                               ])
                             ],
                        ),
                    )
                  },
                ~updater=?
                  switch (updater) {
                  | None => None
                  | Some(updater) =>
                    Some(
                      (store, r) =>
                        updater(
                          store,
                          r->[%e
                               valFromGeneratedModule([
                                 "Internal",
                                 "convertResponse",
                               ])
                             ],
                        ),
                    )
                  },
                (),
              ),
            )
      ],
    ]),
  );
};
