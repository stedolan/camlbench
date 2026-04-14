let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"stable_comparable.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "stable_comparable.ml.before-ppx"
;;

module type V1 = sig
  include Stable_module_types.S0

  include
    Comparable.Stable.V1.S
    with type comparable := t
    with type comparator_witness := comparator_witness
end

module With_stable_witness = struct
  module type V1 = sig
    include Stable_module_types.With_stable_witness.S0

    include
      Comparable.Stable.V1.With_stable_witness.S
      with type comparable := t
      with type comparator_witness := comparator_witness
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
