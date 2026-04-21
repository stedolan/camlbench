let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"html_output_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "html_output_intf.ml.before-ppx"
;;

open! Core
open! Import

module type Mtime = sig
  val mtime : File_name.t -> Time_float.t Or_error.t
end

module type Html_output = sig
  module Private : sig
    module Make : functor (Mtime : Mtime) -> Output.S
  end

  module Without_mtime : Output.S
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
