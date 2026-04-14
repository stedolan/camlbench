[@@@ocaml.text
  " This interface compares float-like objects with a small tolerance.\n\n\
  \    For example [=.]  returns true if the floats are almost but not quite equal, and \
   [>.]\n\
  \    returns false if the floats are almost equal. The tolerance is intended to be about\n\
  \    right for human-entered values like prices and seconds. "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"robustly_comparable.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "robustly_comparable.ml.before-ppx"
;;

module type S = sig
  type t

  val ( >=. ) : t -> t -> bool
  val ( <=. ) : t -> t -> bool
  val ( =. ) : t -> t -> bool
  val ( >. ) : t -> t -> bool
  val ( <. ) : t -> t -> bool
  val ( <>. ) : t -> t -> bool
  val robustly_compare : t -> t -> int
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
