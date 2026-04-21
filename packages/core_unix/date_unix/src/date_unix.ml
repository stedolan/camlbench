let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"date_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "date_unix.ml.before-ppx"
;;

open! Core
open! Date_unix_intf
module Time = Time_float_unix

let of_tm (tm : Unix.tm) =
  Date.create_exn
    ~y:(tm.tm_year + 1900)
    ~m:(Month.of_int_exn (tm.tm_mon + 1))
    ~d:tm.tm_mday
;;

let format date pat =
  let zone = force Time.Zone.local in
  let time = Time.of_date_ofday ~zone date Time.Ofday.start_of_day in
  Time.format time pat ~zone
;;

let parse ?allow_trailing_input ~fmt s =
  of_tm (Unix.strptime ?allow_trailing_input ~fmt s)
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
