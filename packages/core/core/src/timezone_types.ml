let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"timezone_types.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "timezone_types.ml.before-ppx"
;;

open! Base

module Regime = struct
  type t =
    { utc_offset_in_seconds : Int63.t
    ; is_dst : bool
    ; abbrv : string
    }
  [@@ocaml.doc
    " When used from javascript, daylight savings and abbreviation information\n\
    \      aren't available, so on that platform, [is_dst] is always false, and\n\
    \      [abbrv] is always the empty string. "]
end

module Transition = struct
  type t =
    { start_time_in_seconds_since_epoch : Int63.t
    ; new_regime : Regime.t
    }
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
