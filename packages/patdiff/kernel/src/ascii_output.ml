let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"ascii_output.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "ascii_output.ml.before-ppx"
;;

open! Core
open! Import

module Rule = struct
  let apply s ~rule ~refined:_ =
    Ansi_output.Rule.apply s ~rule:(Format.Rule.strip_styles rule) ~refined:false
  ;;
end

let print ~print_global_header ~file_names ~rules ~print ~location_style hunks =
  let rules = Format.Rules.strip_styles rules in
  Ansi_output.print ~print_global_header ~file_names ~rules ~print ~location_style hunks
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
