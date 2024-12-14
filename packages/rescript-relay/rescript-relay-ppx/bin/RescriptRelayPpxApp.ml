open Ppxlib

let () =
  Driver.add_arg "-uncurried"
    (Arg.Unit (fun () -> RescriptRelayPpxLibrary.UncurriedUtils.enabled := true))
    ~doc:"Run in uncurried mode"

let () =
  Driver.add_arg "-non-react"
    (Arg.Unit (fun () -> RescriptRelayPpxLibrary.NonReactUtils.enabled := true))
    ~doc:"Run non-React mode"

let _ = Driver.run_as_ppx_rewriter ()
