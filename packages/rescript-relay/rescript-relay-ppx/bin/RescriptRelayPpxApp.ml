open Ppxlib

let () =
  Driver.add_arg "-uncurried"
    (Arg.Unit (fun () -> RescriptRelayPpxLibrary.UncurriedUtils.enabled := true))
    ~doc:"Run in uncurried mode"

let _ = Driver.run_as_ppx_rewriter ()
