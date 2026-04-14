let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"env_var.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "env_var.ml.before-ppx"
;;

open! Base
open! Import

type t =
  | COMMAND_OUTPUT_INSTALLATION_BASH
  | COMMAND_OUTPUT_HELP_SEXP
  | COMP_CWORD
[@@deriving compare, enumerate, sexp_of]

include struct
  let _ = fun (_ : t) -> ()

  let compare =
    (fun a__001_ b__002_ -> Stdlib.compare a__001_ b__002_
     : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare

  let all =
    ([ COMMAND_OUTPUT_INSTALLATION_BASH; COMMAND_OUTPUT_HELP_SEXP; COMP_CWORD ] : t list)
  ;;

  let _ = all

  let sexp_of_t =
    (function
     | COMMAND_OUTPUT_INSTALLATION_BASH ->
       Sexplib0.Sexp.Atom "COMMAND_OUTPUT_INSTALLATION_BASH"
     | COMMAND_OUTPUT_HELP_SEXP -> Sexplib0.Sexp.Atom "COMMAND_OUTPUT_HELP_SEXP"
     | COMP_CWORD -> Sexplib0.Sexp.Atom "COMP_CWORD"
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let to_string t = Sexp.to_string (sexp_of_t t)
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
