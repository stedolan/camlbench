let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"patdiff_kernel.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "patdiff_kernel.ml.before-ppx"
;;

module Ansi_output = Ansi_output
module Ascii_output = Ascii_output
module Compare_core = Compare_core
module Comparison_result = Comparison_result
module Configuration = Configuration
module Diff_input = Diff_input
module File_helpers = File_helpers
module File_name = File_name
module Float_tolerance = Float_tolerance
module Format = Format
module Html_output = Html_output
module Hunks = Hunks
module Import = Import
module Is_binary = Is_binary
module Output = Output
module Patdiff_core = Patdiff_core
module Should_keep_whitespace = Should_keep_whitespace

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
