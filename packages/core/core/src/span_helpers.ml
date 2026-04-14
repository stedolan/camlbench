let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"span_helpers.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "span_helpers.ml.before-ppx"
;;

open! Import
open Std_internal

let randomize span random_state ~percent ~scale =
  let mult = Percent.to_mult percent in
  if Float.( < ) mult 0. || Float.( > ) mult 1.
  then
    raise_s
      (let ppx_sexp_message () =
         Ppx_sexp_conv_lib.Sexp.List
           [ Ppx_sexp_conv_lib.Conv.sexp_of_string
               "Span.randomize: percent is out of range [0x, 1x]"
           ; Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Sexp.Atom "percent"
               ; (Percent.sexp_of_t [@merlin.hide]) percent
               ]
           ]
           [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
       in
       (ppx_sexp_message () [@nontail]));
  let factor =
    Random.State.float_range random_state (1. -. mult) (Float.one_ulp `Up (1. +. mult))
  in
  scale span factor
;;

let format_decimal n tenths units =
  assert (tenths >= 0 && tenths < 10);
  if n < 10 && tenths <> 0
  then sprintf "%d.%d%s" n tenths units
  else sprintf "%d%s" n units
;;

let short_string ~sign ~hr ~min ~sec ~ms ~us ~ns =
  let s =
    if hr >= 24
    then format_decimal (hr / 24) (Int.of_float (Float.of_int (hr % 24) /. 2.4)) "d"
    else if hr > 0
    then format_decimal hr (min / 6) "h"
    else if min > 0
    then format_decimal min (sec / 6) "m"
    else if sec > 0
    then format_decimal sec (ms / 100) "s"
    else if ms > 0
    then format_decimal ms (us / 100) "ms"
    else if us > 0
    then format_decimal us (ns / 100) "us"
    else sprintf "%ins" ns
  in
  match (sign : Sign.t) with
  | Neg -> "-" ^ s
  | Zero | Pos -> s
;;

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
