let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"html_output.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "html_output.ml.before-ppx"
;;

open! Core
open! Import
module Unix = Core_unix

include Patdiff_kernel.Html_output.Private.Make (struct
    let mtime file =
      Or_error.Let_syntax.Let_syntax.map
        (Or_error.try_with (fun () -> Unix.stat (File_name.real_name_exn file)))
        ~f:(fun stats ->
          Time_float.of_span_since_epoch (Time_float.Span.of_sec stats.st_mtime))
    ;;
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
