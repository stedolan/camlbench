let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"hunks.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "hunks.ml.before-ppx"
;;

open! Core
open! Import

type t = string Patience_diff.Hunk.t list [@@deriving sexp_of]

include struct
  let _ = fun (_ : t) -> ()

  let sexp_of_t =
    (fun x__001_ -> sexp_of_list (Patience_diff.Hunk.sexp_of_t sexp_of_string) x__001_
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let iter' ~f_hunk_break ~f_line (hunks : t) =
  List.iter hunks ~f:(fun hunk ->
    f_hunk_break hunk;
    List.iter hunk.ranges ~f:(function
      | Same r -> Array.iter r ~f:(fun (_, next) -> f_line next)
      | Prev (r, _) | Next (r, _) | Unified (r, _) -> Array.iter r ~f:f_line
      | Replace (ar1, ar2, _) ->
        Array.iter ar1 ~f:f_line;
        Array.iter ar2 ~f:f_line))
;;

let iter ~f_hunk_break ~f_line (hunks : t) =
  iter' ~f_line hunks ~f_hunk_break:(fun hunk ->
    f_hunk_break (hunk.prev_start, hunk.prev_size) (hunk.next_start, hunk.next_size))
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
