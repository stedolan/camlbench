let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"diffable.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "diffable.ml.before-ppx"
;;

include Basic_diffs
include Diffable_intf
module Diff = Diff_intf
module Atomic = Atomic
module Optional_diff = Optional_diff
module Tuples = Tuples
module Set_diff = Set_diff
module Map_diff = Map_diff

module For_ppx = struct
  include Basic_diffs
  include Tuples
  module Of_variant = Of_variant
  module Optional_diff = Optional_diff
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
