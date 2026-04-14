let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"no_polymorphic_compare.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "no_polymorphic_compare.ml.before-ppx"
;;

open! Import

type compare =
  [ `no_polymorphic_compare ]
  -> [ `no_polymorphic_compare ]
  -> [ `no_polymorphic_compare ]

let compare _ _ = `no_polymorphic_compare
let ( < ) _ _ = `no_polymorphic_compare
let ( <= ) _ _ = `no_polymorphic_compare
let ( > ) _ _ = `no_polymorphic_compare
let ( >= ) _ _ = `no_polymorphic_compare
let ( = ) _ _ = `no_polymorphic_compare
let ( <> ) _ _ = `no_polymorphic_compare
let equal _ _ = `no_polymorphic_compare
let min _ _ = `no_polymorphic_compare
let max _ _ = `no_polymorphic_compare
let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
