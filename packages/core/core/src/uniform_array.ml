let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"uniform_array.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "uniform_array.ml.before-ppx"
;;

open! Import
include Base.Uniform_array

include
  Binable.Of_binable1_without_uuid [@alert "-legacy"]
    (Array)
    (struct
      type nonrec 'a t = 'a t

      let to_binable = to_array
      let of_binable = of_array
    end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
