let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"timezone_js_loader.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "timezone_js_loader.ml.before-ppx"
;;

open! Base
open Timezone_types

external should_use_timezone_js_loader
  :  [ `Yes ]
  -> [ `Platform_not_supported ]
  -> [ `Disabled ]
  -> [ `Yes | `Platform_not_supported | `Disabled ]
  = "should_use_timezone_js_loader"

module Instant = struct
  type t

  external from_epoch_seconds : int64 -> t = "timezone_js_loader_from_epoch_seconds"
  external epoch_seconds : t -> int64 = "timezone_js_loader_epoch_seconds"
  external now : unit -> t = "timezone_js_loader_now"
  external plus_hours : t -> int64 -> t = "timezone_js_loader_instant_plus_hours"
  external compare : t -> t -> int = "timezone_js_loader_compare_instants"
end

module Zone = struct
  type t

  external create : string -> t = "timezone_js_loader_create_zone"

  external get_offset_nanos_for
    :  t
    -> Instant.t
    -> int64
    = "timezone_js_loader_get_offset_nanos_for"

  external next_transition_or_this_time_if_none
    :  t
    -> Instant.t
    -> Instant.t
    = "timezone_js_loader_get_next_transition_or_this_time_if_none"

  let next_transition t instant =
    let transition = next_transition_or_this_time_if_none t instant in
    if phys_equal instant transition then None else Some transition
  ;;
end

type t =
  { first_transition : Timezone_types.Transition.t
  ; remaining_transitions : Timezone_types.Transition.t list
  }

let utc_offset_s_at_instant tz instant =
  let offset_ns = Zone.get_offset_nanos_for tz instant in
  let ns_per_s = 1_000_000_000L in
  let offset_ns = Int64.round_up ~to_multiple_of:ns_per_s offset_ns in
  Int63.of_int64_exn
    (let open Int64 in
     offset_ns / ns_per_s)
;;

let make_transition ~start_time_in_seconds_since_epoch ~utc_offset_in_seconds =
  let new_regime = { Regime.abbrv = ""; is_dst = false; utc_offset_in_seconds } in
  { Transition.start_time_in_seconds_since_epoch; new_regime }
;;

let load_exn s =
  let a_long_long_time_ago_s = -8_640_000_000_000L in
  let a_long_long_time_ago_instant = Instant.from_epoch_seconds a_long_long_time_ago_s in
  let about_15_years_from_now =
    let now = Instant.now () in
    Instant.plus_hours now 131_490L
  in
  let tz = Zone.create s in
  let rec build_transitions acc ~starting_at =
    if Instant.compare starting_at about_15_years_from_now > 0
    then List.rev acc
    else (
      match Zone.next_transition tz starting_at with
      | None -> List.rev acc
      | Some transition_point ->
        let transition =
          make_transition
            ~start_time_in_seconds_since_epoch:
              (Int63.of_int64_exn (Instant.epoch_seconds transition_point))
            ~utc_offset_in_seconds:(utc_offset_s_at_instant tz transition_point)
        in
        build_transitions (transition :: acc) ~starting_at:transition_point)
  in
  let first_transition =
    make_transition
      ~start_time_in_seconds_since_epoch:(Int63.of_int64_exn a_long_long_time_ago_s)
      ~utc_offset_in_seconds:(utc_offset_s_at_instant tz a_long_long_time_ago_instant)
  in
  let remaining_transitions =
    build_transitions [] ~starting_at:a_long_long_time_ago_instant
  in
  { first_transition; remaining_transitions }
;;

module Load_error = struct
  type t =
    | Disabled
    | Platform_not_supported
    | Failed of exn
  [@@deriving sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (function
       | Disabled -> Sexplib0.Sexp.Atom "Disabled"
       | Platform_not_supported -> Sexplib0.Sexp.Atom "Platform_not_supported"
       | Failed arg0__001_ ->
         let res0__002_ = sexp_of_exn arg0__001_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Failed"; res0__002_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

let load s =
  match should_use_timezone_js_loader `Yes `Platform_not_supported `Disabled with
  | `Disabled -> Error Load_error.Disabled
  | `Platform_not_supported -> Error Load_error.Platform_not_supported
  | `Yes ->
    (match load_exn s with
     | t -> Ok t
     | exception exn -> Error (Load_error.Failed exn))
;;

module For_testing = struct
  external disable : unit -> unit = "timezone_js_loader_disable_for_testing"
  external enable : unit -> unit = "timezone_js_loader_enable_for_testing"
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
