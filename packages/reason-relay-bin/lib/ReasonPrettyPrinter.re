exception Pp_error;

module RE = Reason_toolchain.RE;

let setup_lexbuf = (~parser, str) =>
  try({
    let lexbuf = Lexing.from_string(str);
    Location.init(lexbuf, str);
    parser(lexbuf);
  }) {
  | Reason_errors.Reason_error(_) as rexn => raise(rexn)
  | _ => raise(Pp_error)
  };

let parse_implementation = str => {
  let omp_ast = setup_lexbuf(~parser=RE.implementation, str);
  Reason_toolchain.To_current.copy_structure(omp_ast);
};

let format = (~parser, ~printer, filename) => {
  let parse_result = setup_lexbuf(~parser, filename);
  let buf = Buffer.create(4096);
  let fmt = Format.formatter_of_buffer(buf);
  printer(fmt, parse_result);
  Buffer.contents(buf);
};

let format_implementation = str =>
  format(
    ~parser=RE.implementation_with_comments,
    ~printer=RE.print_implementation_with_comments,
    str,
  );
