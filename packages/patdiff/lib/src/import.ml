let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set ~filename_rel_to_project_root:"import.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition "ppx_inline_test_lib_1" "import.ml.before-ppx"
;;

open! Core
include Composition_infix

include struct
  open Patdiff_kernel
  module Ansi_output = Ansi_output
  module Comparison_result = Comparison_result
  module Diff_input = Diff_input
  module File_helpers = File_helpers
  module File_name = File_name
  module Float_tolerance = Float_tolerance
  module Format = Format
  module Hunks = Hunks
  module Is_binary = Is_binary
  module Output = Output
  module Should_keep_whitespace = Should_keep_whitespace
end

module Patience_diff = Patience_diff_lib.Patience_diff

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
