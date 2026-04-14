let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"stable_int63able.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "stable_int63able.ml.before-ppx"
;;

open! Import

module type S = sig
  include Stable_module_types.S0

  val to_int63 : t -> Int63.t
  [@@ocaml.doc
    " [to_int63] and [of_int63_exn] encode [t] for use in wire protocols; they are\n\
    \      intended to avoid allocation on 64-bit machines and should be implemented\n\
    \      efficiently.  [of_int63_exn (to_int63 t) = t] for all [t]; [of_int63_exn] \
     raises for\n\
    \      inputs not produced by [to_int63]. "]

  val of_int63_exn : Int63.t -> t
end

module With_stable_witness = struct
  module type S = sig
    include Stable_module_types.With_stable_witness.S0

    val to_int63 : t -> Int63.t
    val of_int63_exn : Int63.t -> t
  end
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
