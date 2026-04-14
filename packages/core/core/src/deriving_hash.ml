let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"deriving_hash.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "deriving_hash.ml.before-ppx"
;;

open! Import
include Deriving_hash_intf

module Of_deriving_hash
    (Repr : S)
    (M : sig
       type t

       val to_repr : t -> Repr.t
     end) =
struct
  let hash_fold_t state t = Repr.hash_fold_t state (M.to_repr t)
  let hash = Ppx_hash_lib.Std.Hash.of_fold hash_fold_t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
