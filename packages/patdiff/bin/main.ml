let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"main.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "main.ml.before-ppx"
;;

open Core

let () =
  let result = Result.try_with (fun () -> Command_unix.run Compare.command) in
  match result with
  | Ok () -> ()
  | Error exn ->
    eprintf "%s\n%!" (Exn.to_string exn);
    exit 2
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
