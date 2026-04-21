let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"patdiff_core.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "patdiff_core.ml.before-ppx"
;;

open! Core
open! Import
include Patdiff_kernel.Patdiff_core

include Private.Make (struct
    let implementation : Output.t -> (module Output.S) = function
      | Ansi -> (module Patdiff_kernel.Ansi_output)
      | Ascii -> (module Patdiff_kernel.Ascii_output)
      | Html -> (module Html_output)
    ;;

    let console_width () =
      if am_running_test
      then Ok 80
      else
        let open Or_error.Let_syntax in
        Let_syntax.bind Linux_ext.get_terminal_size ~f:(fun get_size ->
          Let_syntax.map
            (Or_error.try_with (fun () -> get_size `Controlling))
            ~f:(fun (_, width) -> width))
    ;;
  end)

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
