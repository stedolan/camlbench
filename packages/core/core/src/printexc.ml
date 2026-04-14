let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"printexc.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "printexc.ml.before-ppx"
;;

open! Import

let to_string _ = `Deprecated_use_Exn_to_string_instead
let print _ = `Deprecated_use_Exn_to_string_instead
let catch _ _ = `Deprecated_use_Exn_handle_uncaught_instead
let print_backtrace = Stdlib.Printexc.print_backtrace
let get_backtrace = Stdlib.Printexc.get_backtrace
let record_backtrace = Stdlib.Printexc.record_backtrace
let backtrace_status = Stdlib.Printexc.backtrace_status
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
