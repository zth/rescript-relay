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
      [%stri include [%m moduleIdentFromGeneratedModule(["Utils"])]],
      [%stri module Types = [%m moduleIdentFromGeneratedModule(["Types"])]],
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
            ~updater: ReasonRelay.updaterFn(
                        [%t typeFromGeneratedModule(["Types", "response"])],
                      )
                        =?,
            unit
          ) =>
          ReasonRelay.Disposable.t =
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: [%t typeFromGeneratedModule(["Types", "variables"])],
            ~onCompleted: option(unit => unit)=?,
            ~onError: option(Js.Exn.t => unit)=?,
            ~onNext:
               option(
                 [%t typeFromGeneratedModule(["Types", "response"])] => unit,
               )=?,
            ~updater:
               option(
                 ReasonRelay.updaterFn(
                   [%t typeFromGeneratedModule(["Types", "response"])],
                 ),
               )=?,
            (),
          ) =>
            ReasonRelay.internal_requestSubscription(
              environment,
              ReasonRelay.subscriptionConfigRaw(
                ~subscription=[%e valFromGeneratedModule(["node"])],
                ~variables=
                  variables
                  ->[%e
                      valFromGeneratedModule(["Internal", "convertVariables"])
                    ]
                  ->ReasonRelay.internal_cleanVariablesRaw,
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
