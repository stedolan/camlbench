let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"file_descr.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "file_descr.ml.before-ppx"
;;

open! Core
open! Import

module M = struct
  type t = Unix.file_descr

  external to_int : t -> int = "%identity"
  external of_int : int -> t = "%identity"
  external of_int_exn : int -> t = "%identity"

  let of_string string = of_int (Int.of_string string)
  let to_string t = Int.to_string (to_int t)
  let hash t = Int.hash (to_int t)
  let compare t1 t2 = Int.compare (to_int t1) (to_int t2)
  let t_of_sexp sexp = of_int (Int.t_of_sexp sexp)

  let sexp_of_t t =
    match am_running_test && Int.( > ) (to_int t) 2 with
    | false -> (sexp_of_int [@merlin.hide]) (to_int t)
    | true -> Ppx_sexp_conv_lib.Conv.sexp_of_string "_"
  ;;
end

include M
include Hashable.Make_plain_and_derive_hash_fold_t (M)

let equal (t1 : t) t2 = phys_equal t1 t2
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
