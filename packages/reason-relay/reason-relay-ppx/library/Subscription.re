open Ppxlib;
open Util;

/**
 * Check out the comments for makeFragment, this does the same thing but for subscriptions.
 */
let make = (~loc, ~moduleName) =>
  Ast_helper.Mod.mk(
    Pmod_structure([
      [%stri module Operation = [%m makeModuleNameAst(~loc, ~moduleName)]],
      [%stri include Operation.Utils],
      [%stri module Types = Operation.Types],
      [%stri
        let subscribe:
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
            ~onCompleted: unit => unit=?,
            ~onError: Js.Exn.t => unit=?,
            ~onNext: Types.response => unit=?,
            ~updater: ReasonRelay.updaterFn(Types.response)=?,
            unit
          ) =>
          ReasonRelay.Disposable.t =
          (
            ~environment: ReasonRelay.Environment.t,
            ~variables: Types.variables,
            ~onCompleted: option(unit => unit)=?,
            ~onError: option(Js.Exn.t => unit)=?,
            ~onNext: option(Types.response => unit)=?,
            ~updater: option(ReasonRelay.updaterFn(Types.response))=?,
            (),
          ) =>
            ReasonRelay.internal_requestSubscription(
              environment,
              ReasonRelay.subscriptionConfigRaw(
                ~subscription=Operation.node,
                ~variables=
                  variables
                  ->Operation.Internal.convertVariables
                  ->ReasonRelay.internal_cleanVariablesRaw,
                ~onCompleted?,
                ~onError?,
                ~onNext=?
                  switch (onNext) {
                  | None => None
                  | Some(onNext) =>
                    Some(r => onNext(r->Operation.Internal.convertResponse))
                  },
                ~updater=?
                  switch (updater) {
                  | None => None
                  | Some(updater) =>
                    Some(
                      (store, r) =>
                        updater(
                          store,
                          Operation.Internal.convertResponse(r),
                        ),
                    )
                  },
                (),
              ),
            )
      ],
    ]),
  );
