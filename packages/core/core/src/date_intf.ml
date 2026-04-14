let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"date_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "date_intf.ml.before-ppx"
;;

module type Date = sig
  type t = Date0.t

  include module type of Date0 with type t := t [@@ocaml.doc " @inline "]

  val of_time : Time_float.t -> zone:Time_float.Zone.t -> t
  val today : zone:Time_float.Zone.t -> t

  [@@@ocaml.text " Deprecations "]

  val format : [ `Use_Date_unix ] [@@deprecated "[since 2021-03] Use [Date_unix]"]
  val of_tm : [ `Use_Date_unix ] [@@deprecated "[since 2021-03] Use [Date_unix]"]
  val parse : [ `Use_Date_unix ] [@@deprecated "[since 2021-03] Use [Date_unix]"]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
