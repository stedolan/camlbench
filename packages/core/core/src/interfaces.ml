[@@@ocaml.text " Various interface exports. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"interfaces.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "interfaces.ml.before-ppx"
;;

open! Import

module type Applicative = Applicative.S
module type Binable = Binable0.S
module type Comparable = Comparable.S
module type Comparable_binable = Comparable.S_binable
module type Floatable = Floatable.S
module type Hashable = Hashable.S
module type Hashable_binable = Hashable.S_binable
module type Identifiable = Identifiable.S
module type Infix_comparators = Comparable.Infix
module type Intable = Intable.S
module type Monad = Monad.S
module type Quickcheckable = Quickcheckable.S
module type Robustly_comparable = Robustly_comparable.S
module type Sexpable = Sexpable.S
module type Stable = Stable_module_types.S0
module type Stable_int63able = Stable_int63able.S
module type Stable_without_comparator = Stable_module_types.S0_without_comparator
module type Stable1 = Stable_module_types.S1
module type Stable2 = Stable_module_types.S2
module type Stable3 = Stable_module_types.S3
module type Stable4 = Stable_module_types.S4
module type Stringable = Stringable.S
module type Unit = Unit.S
module type Stable_with_witness = Stable_module_types.With_stable_witness.S0
module type Stable_int63able_with_witness = Stable_int63able.With_stable_witness.S

module type Stable_without_comparator_with_witness =
  Stable_module_types.With_stable_witness.S0_without_comparator

module type Stable1_with_witness = Stable_module_types.With_stable_witness.S1
module type Stable2_with_witness = Stable_module_types.With_stable_witness.S2
module type Stable3_with_witness = Stable_module_types.With_stable_witness.S3
module type Stable4_with_witness = Stable_module_types.With_stable_witness.S4

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
