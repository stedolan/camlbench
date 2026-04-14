let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_float0.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_float0.ml.before-ppx"
;;

open! Import
open Std_internal
open! Int.Replace_polymorphic_compare
module Span = Span_float
module Ofday = Ofday_float

module Absolute = struct
  type underlying = Float.t

  include (
    Float :
    sig
      type t = float [@@deriving bin_io, hash, typerep]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Typerep_lib.Typerepable.S with type t := t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Comparable.S_common with type t := t

      include module type of struct
        include Float.O
      end
    end)

  include Float.Robust_compare.Make (struct
      let robust_comparison_tolerance = 1E-6
    end)

  let diff t1 t2 = Span.of_sec (t1 - t2)
  let add t span = t +. Span.to_sec span
  let sub t span = t -. Span.to_sec span
  let prev t = Float.one_ulp `Down t
  let next t = Float.one_ulp `Up t
  let to_span_since_epoch = Span.of_sec
  let of_span_since_epoch = Span.to_sec
end

include Absolute

module Date_and_ofday = struct
  type t = float

  let of_synthetic_span_since_epoch span = Span.to_sec span
  let to_synthetic_span_since_epoch t = Span.of_sec t

  let of_date_ofday date ofday =
    let days =
      Float.of_int (Date0.Days.diff (Date0.Days.of_date date) Date0.Days.unix_epoch)
    in
    (days *. 86400.) +. Span.to_sec (Ofday.to_span_since_start_of_day ofday)
  ;;

  let to_absolute relative ~offset_from_utc = sub relative offset_from_utc
  let of_absolute absolute ~offset_from_utc = add absolute offset_from_utc

  let assert_in_bounds ~sec_since_epoch =
    let gmtime_lower_bound = -62_167_219_200. in
    let gmtime_upper_bound = 253_402_300_799. in
    if
      Float.( >= ) sec_since_epoch (gmtime_upper_bound +. 1.)
      || Float.( < ) sec_since_epoch gmtime_lower_bound
    then failwithf "Time.gmtime: out of range (%f)" sec_since_epoch ()
  [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
  ;;

  let sec_per_day = Int63.of_int 86_400

  let to_days_from_epoch t =
    assert_in_bounds ~sec_since_epoch:t;
    let open Int63.O in
    let days_from_epoch_approx = Int63.of_float t / sec_per_day in
    if Float.( < ) t (Int63.to_float (days_from_epoch_approx * sec_per_day))
    then Int63.pred days_from_epoch_approx
    else days_from_epoch_approx
  ;;

  let ofday_of_days_from_epoch t ~days_from_epoch =
    let open Int63.O in
    let days_from_epoch_in_sec = Int63.to_float (days_from_epoch * sec_per_day) in
    let remainder = t -. days_from_epoch_in_sec in
    Ofday.of_span_since_start_of_day_exn (Span.of_sec remainder)
  ;;

  let date_of_days_from_epoch ~days_from_epoch =
    Date0.Days.to_date
      (Date0.Days.add_days Date0.Days.unix_epoch (Int63.to_int_exn days_from_epoch))
  ;;

  let to_date t =
    let days_from_epoch = to_days_from_epoch t in
    date_of_days_from_epoch ~days_from_epoch
  ;;

  let to_ofday t =
    let days_from_epoch = to_days_from_epoch t in
    ofday_of_days_from_epoch t ~days_from_epoch
  ;;

  let to_date_ofday t =
    let days_from_epoch = to_days_from_epoch t in
    let date = date_of_days_from_epoch ~days_from_epoch in
    let ofday = ofday_of_days_from_epoch t ~days_from_epoch in
    date, ofday
  ;;
end

let next_multiple_internal ~can_equal_after ~base ~after ~interval =
  if Span.( <= ) interval Span.zero
  then
    failwiths
      ~here:
        { Ppx_here_lib.pos_fname = "time_float0.ml.before-ppx"
        ; pos_lnum = 117
        ; pos_cnum = 3629
        ; pos_bol = 3617
        }
      "Time.next_multiple got nonpositive interval"
      interval
      (Span.sexp_of_t [@merlin.hide]);
  let base_to_after = diff after base in
  if Span.( < ) base_to_after Span.zero
  then base
  else (
    let next =
      add
        base
        (Span.scale
           interval
           (Float.round ~dir:`Down (Span.( // ) base_to_after interval)))
    in
    if next > after || (can_equal_after && next = after) then next else add next interval)
;;

let next_multiple ?(can_equal_after = false) ~base ~after ~interval () =
  next_multiple_internal ~can_equal_after ~base ~after ~interval
;;

let prev_multiple ?(can_equal_before = false) ~base ~before ~interval () =
  next_multiple_internal
    ~can_equal_after:(not can_equal_before)
    ~base
    ~after:(sub before interval)
    ~interval
;;

let now () =
  let float_ns = Int63.to_float (Time_now.nanoseconds_since_unix_epoch ()) in
  of_span_since_epoch (Span.of_sec (float_ns *. 1E-9))
;;

module Stable = struct
  module Span = Span.Stable
  module Ofday = Ofday.Stable
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
