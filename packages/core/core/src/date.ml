let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"date.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "date.ml.before-ppx"
;;

include Date0

let of_time time ~zone = Time_float.to_date ~zone time
let today ~zone = of_time (Time_float.now ()) ~zone
let format = `Use_Date_unix
let of_tm = `Use_Date_unix
let parse = `Use_Date_unix
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
