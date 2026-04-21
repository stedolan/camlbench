let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"output.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "output.ml.before-ppx"
;;

open! Core
open! Import
include Output_intf

type t =
  | Ansi
  | Ascii
  | Html
[@@deriving compare, sexp]

include struct
  let _ = fun (_ : t) -> ()

  let compare =
    (fun a__001_ b__002_ -> Stdlib.compare a__001_ b__002_
     : t -> (t[@merlin.hide]) -> int)
  ;;

  let _ = compare

  let t_of_sexp =
    (let error_source__005_ = "output.ml.before-ppx.t" in
     function
     | Sexplib0.Sexp.Atom ("ansi" | "Ansi") -> Ansi
     | Sexplib0.Sexp.Atom ("ascii" | "Ascii") -> Ascii
     | Sexplib0.Sexp.Atom ("html" | "Html") -> Html
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ansi" | "Ansi") :: _) as sexp__006_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__005_ sexp__006_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("ascii" | "Ascii") :: _) as sexp__006_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__005_ sexp__006_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("html" | "Html") :: _) as sexp__006_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__005_ sexp__006_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__005_ sexp__004_
     | Sexplib0.Sexp.List [] as sexp__004_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__005_ sexp__004_
     | sexp__004_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag error_source__005_ sexp__004_
     : Sexplib0.Sexp.t -> t)
  ;;

  let _ = t_of_sexp

  let sexp_of_t =
    (function
     | Ansi -> Sexplib0.Sexp.Atom "Ansi"
     | Ascii -> Sexplib0.Sexp.Atom "Ascii"
     | Html -> Sexplib0.Sexp.Atom "Html"
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let implies_unrefined t =
  match t with
  | Ansi | Html -> false
  | Ascii -> true
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
