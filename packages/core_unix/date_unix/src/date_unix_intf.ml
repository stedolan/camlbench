let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"date_unix_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "date_unix_intf.ml.before-ppx"
;;

open! Core
module Unix = Core_unix

module type Date_unix = sig
  type t := Core.Date.t

  val format : t -> string -> string
  [@@ocaml.doc " This formats a date using the format patterns available in [strftime]. "]

  val parse : ?allow_trailing_input:bool -> fmt:string -> string -> t
  [@@ocaml.doc " This parses a date using the format patterns available in [strptime]. "]

  val of_tm : Unix.tm -> t
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
