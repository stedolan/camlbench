let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"error.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "error.ml.before-ppx"
;;

include Base.Error
include Info.Extend (Base.Error)

let failwiths ?strict ~here message a sexp_of_a =
  raise (create ?strict ~here message a sexp_of_a)
;;

let failwithp ?strict here message a sexp_of_a =
  raise (create ?strict ~here message a sexp_of_a)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
