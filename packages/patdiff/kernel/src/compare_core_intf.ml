let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"compare_core_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "compare_core_intf.ml.before-ppx"
;;

open! Core
open! Import

module type S = sig
  val diff_strings
    :  ?print_global_header:bool
    -> Configuration.t
    -> prev:Diff_input.t
    -> next:Diff_input.t
    -> [ `Different of string | `Same ]

  module Private : sig
    val compare_lines
      :  Configuration.t
      -> prev:string array
      -> next:string array
      -> string Patience_diff.Hunks.t
  end
end

module type Compare_core = sig
  module type S = S

  module Make : functor (Patdiff_core : Patdiff_core.S) -> S
  module Without_unix : S
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
