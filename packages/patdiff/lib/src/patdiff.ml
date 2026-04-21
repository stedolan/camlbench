let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"patdiff.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "patdiff.ml.before-ppx"
;;

include struct
  open Import
  module Ansi_output = Ansi_output
  module Diff_input = Diff_input
  module File_name = File_name
  module Format = Format
  module Hunks = Hunks
  module Output = Output
end

module Compare_core = Compare_core
module Configuration = Configuration
module Patdiff_core = Patdiff_core

module Private = struct
  module Is_binary = Import.Is_binary
  module Should_keep_whitespace = Import.Should_keep_whitespace
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
