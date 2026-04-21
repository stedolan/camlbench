let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_ns_unix.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_ns_unix.ml.before-ppx"
;;

open! Core
open! Int.Replace_polymorphic_compare
module Unix = Core_unix
module Time = Time_float_unix
include Time_ns
module Zone = Time.Zone
module Span = Time_ns.Span

let nanosleep t = Span.of_sec (Unix.nanosleep (Span.to_sec t))

let pause_for t =
  let time_remaining = nanosleep (Span.min t (Span.scale Span.day 100.)) in
  if Span.( > ) time_remaining Span.zero then `Remaining time_remaining else `Ok
;;

let rec pause span =
  match pause_for span with
  | `Remaining span -> pause span
  | `Ok -> ()
[@@ocaml.doc " Pause and don't allow events to interrupt. "]
;;

let interruptible_pause = pause_for [@@ocaml.doc " Pause but allow events to interrupt. "]

let rec pause_forever () =
  pause Span.day;
  pause_forever ()
;;

let to_string t = to_string_abs t ~zone:(Lazy.force Zone.local)

exception Time_string_not_absolute of string [@@deriving sexp]

include struct
  let () =
    Sexplib0.Sexp_conv.Exn_converter.add
      [%extension_constructor Time_string_not_absolute]
      (function
      | Time_string_not_absolute arg0__001_ ->
        let res0__002_ = sexp_of_string arg0__001_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "time_ns_unix.ml.before-ppx.Time_string_not_absolute"
          ; res0__002_
          ]
      | _ -> assert false)
  ;;
end [@@ocaml.doc "@inline"] [@@merlin.hide]

let of_string_gen ~if_no_timezone s =
  let default_zone () =
    match if_no_timezone with
    | `Fail -> raise (Time_string_not_absolute s)
    | `Local -> Lazy.force Zone.local
    | `Use_this_one zone -> zone
  in
  of_string_gen ~default_zone ~find_zone:Zone.find_exn s
;;

let of_string_abs s = of_string_gen ~if_no_timezone:`Fail s
let of_string s = of_string_gen ~if_no_timezone:`Local s
let arg_type = Core.Command.Arg_type.create of_string_abs

let to_tm t ~zone : Unix.tm =
  let date, ofday = to_date_ofday t ~zone in
  let parts = Ofday.to_parts ofday in
  { tm_year = Date.year date - 1900
  ; tm_mon = Month.to_int (Date.month date) - 1
  ; tm_mday = Date.day date
  ; tm_hour = parts.hr
  ; tm_min = parts.min
  ; tm_sec = parts.sec
  ; tm_isdst = false
  ; tm_wday = Day_of_week.to_int (Date.day_of_week date)
  ; tm_yday = Date.diff date (Date.create_exn ~y:(Date.year date) ~m:Jan ~d:1)
  }
;;

let format (t : t) s ~zone = Unix.strftime (to_tm t ~zone) s

let of_tm tm ~zone =
  let ({ tm_year
       ; tm_mon
       ; tm_mday
       ; tm_hour
       ; tm_min
       ; tm_sec
       ; tm_isdst = _
       ; tm_wday = _
       ; tm_yday = _
       }
        : Unix.tm)
    =
    tm
  in
  let date =
    Date.create_exn ~y:(tm_year + 1900) ~m:(Month.of_int_exn (tm_mon + 1)) ~d:tm_mday
  in
  let ofday = Ofday.create ~hr:tm_hour ~min:tm_min ~sec:tm_sec () in
  of_date_ofday ~zone date ofday
;;

let parse ?allow_trailing_input s ~fmt ~zone =
  of_tm ~zone (Unix.strptime ?allow_trailing_input ~fmt s)
;;

module Ofday = struct
  include Time_ns.Ofday

  let arg_type = Core.Command.Arg_type.create of_string

  let of_ofday_float_round_nearest_microsecond core =
    of_span_since_start_of_day_exn
      (Span.of_span_float_round_nearest_microsecond
         (Time.Ofday.to_span_since_start_of_day core))
  ;;

  let of_ofday_float_round_nearest core =
    of_span_since_start_of_day_exn
      (Span.of_span_float_round_nearest (Time.Ofday.to_span_since_start_of_day core))
  ;;

  let of_time time ~zone = to_ofday time ~zone

  let to_ofday_float_round_nearest_microsecond t =
    Time.Ofday.of_span_since_start_of_day_exn
      (Span.to_span_float_round_nearest_microsecond (to_span_since_start_of_day t))
  ;;

  let to_ofday_float_round_nearest t =
    Time.Ofday.of_span_since_start_of_day_exn
      (Span.to_span_float_round_nearest (to_span_since_start_of_day t))
  ;;

  let now ~zone = of_time (Time_ns.now ()) ~zone
  let to_ofday = to_ofday_float_round_nearest_microsecond
  let of_ofday = of_ofday_float_round_nearest_microsecond

  module Zoned = struct
    type t =
      { ofday : Time_ns.Ofday.t
      ; zone : Zone.t
      }
    [@@deriving bin_io, fields ~getters, compare, equal, hash]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:143:4")
            [ ( Bin_prot.Shape.Tid.of_string "t"
              , []
              , Bin_prot.Shape.record
                  [ "ofday", Time_ns.Ofday.bin_shape_t; "zone", Zone.bin_shape_t ] )
            ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t

      let bin_size_t : t Bin_prot.Size.sizer = function
        | { ofday = v1; zone = v2 } ->
          let size = 0 in
          let size = Bin_prot.Common.( + ) size (Time_ns.Ofday.bin_size_t v1) in
          Bin_prot.Common.( + ) size (Zone.bin_size_t v2)
      ;;

      let _ = bin_size_t

      let bin_write_t : t Bin_prot.Write.writer =
        fun buf ~pos -> function
        | { ofday = v1; zone = v2 } ->
          let pos = Time_ns.Ofday.bin_write_t buf ~pos v1 in
          Zone.bin_write_t buf ~pos v2
      ;;

      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t

      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
        fun _buf ~pos_ref _vint ->
        Bin_prot.Common.raise_variant_wrong_type
          "time_ns_unix.ml.before-ppx.Ofday.Zoned.t"
          !pos_ref
      ;;

      let _ = __bin_read_t__

      let bin_read_t : t Bin_prot.Read.reader =
        fun buf ~pos_ref ->
        let v_ofday = Time_ns.Ofday.bin_read_t buf ~pos_ref in
        let v_zone = Zone.bin_read_t buf ~pos_ref in
        { ofday = v_ofday; zone = v_zone }
      ;;

      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t
      let zone _r__ = _r__.zone
      let _ = zone
      let ofday _r__ = _r__.ofday
      let _ = ofday

      let compare =
        (fun a__003_ b__004_ ->
           if Stdlib.( == ) a__003_ b__004_
           then 0
           else (
             match Time_ns.Ofday.compare a__003_.ofday b__004_.ofday with
             | 0 -> Zone.compare a__003_.zone b__004_.zone
             | n -> n)
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__005_ b__006_ ->
           if Stdlib.( == ) a__005_ b__006_
           then true
           else
             Stdlib.( && )
               (Time_ns.Ofday.equal a__005_.ofday b__006_.ofday)
               (Zone.equal a__005_.zone b__006_.zone)
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        let hsv =
          let hsv = hsv in
          Time_ns.Ofday.hash_fold_t hsv arg.ofday
        in
        Zone.hash_fold_t hsv arg.zone
      ;;

      let _ = hash_fold_t

      let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func arg =
          Ppx_hash_lib.Std.Hash.get_hash_value
            (let hsv = Ppx_hash_lib.Std.Hash.create () in
             hash_fold_t hsv arg)
        in
        fun x -> func x
      ;;

      let _ = hash
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type sexp_repr = Time_ns.Ofday.t * Zone.t [@@deriving sexp]

    include struct
      let _ = fun (_ : sexp_repr) -> ()

      let sexp_repr_of_sexp =
        (let error_source__013_ = "time_ns_unix.ml.before-ppx.Ofday.Zoned.sexp_repr" in
         function
         | Sexplib0.Sexp.List [ arg0__008_; arg1__009_ ] ->
           let res0__010_ = Time_ns.Ofday.t_of_sexp arg0__008_
           and res1__011_ = Zone.t_of_sexp arg1__009_ in
           res0__010_, res1__011_
         | sexp__012_ ->
           Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
             error_source__013_
             2
             sexp__012_
         : Sexplib0.Sexp.t -> sexp_repr)
      ;;

      let _ = sexp_repr_of_sexp

      let sexp_of_sexp_repr =
        (fun (arg0__014_, arg1__015_) ->
           let res0__016_ = Time_ns.Ofday.sexp_of_t arg0__014_
           and res1__017_ = Zone.sexp_of_t arg1__015_ in
           Sexplib0.Sexp.List [ res0__016_; res1__017_ ]
         : sexp_repr -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_sexp_repr
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let sexp_of_t t = (sexp_of_sexp_repr [@merlin.hide]) (t.ofday, t.zone)

    let t_of_sexp sexp =
      let ofday, zone = (sexp_repr_of_sexp [@merlin.hide]) sexp in
      { ofday; zone }
    ;;

    let to_time_ns t date = of_date_ofday ~zone:(zone t) date (ofday t)
    let create ofday zone = { ofday; zone }
    let create_local ofday = create ofday (Lazy.force Zone.local)

    let of_string string : t =
      match String.split string ~on:' ' with
      | [ ofday; zone ] ->
        { ofday = Time_ns.Ofday.of_string ofday; zone = Zone.of_string zone }
      | _ -> failwithf "Ofday.Zoned.of_string %s" string ()
    ;;

    let to_string (t : t) : string =
      String.concat [ Time_ns.Ofday.to_string t.ofday; " "; Zone.to_string t.zone ]
    ;;

    let arg_type = Core.Command.Arg_type.create of_string

    module With_nonchronological_compare = struct
      type nonrec t = t [@@deriving bin_io, compare, equal, sexp, hash]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:176:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_t
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let compare =
          (fun a__018_ b__019_ -> compare a__018_ b__019_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__020_ b__021_ -> equal a__020_ b__021_ : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end

    include Pretty_printer.Register (struct
        type nonrec t = t

        let to_string = to_string
        let module_name = "Time_ns_unix.Ofday.Zoned"
      end)

    module Stable = struct
      module V1 = struct
        let compare = With_nonchronological_compare.compare

        module Bin_repr = struct
          type nonrec t = t =
            { ofday : Time_ns.Stable.Ofday.V1.t
            ; zone : Timezone.Stable.V1.t
            }
          [@@deriving bin_io, stable_witness]

          include struct
            let _ = fun (_ : t) -> ()

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:191:10")
                  [ ( Bin_prot.Shape.Tid.of_string "t"
                    , []
                    , Bin_prot.Shape.record
                        [ "ofday", Time_ns.Stable.Ofday.V1.bin_shape_t
                        ; "zone", Timezone.Stable.V1.bin_shape_t
                        ] )
                  ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t

            let bin_size_t : t Bin_prot.Size.sizer = function
              | { ofday = v1; zone = v2 } ->
                let size = 0 in
                let size =
                  Bin_prot.Common.( + ) size (Time_ns.Stable.Ofday.V1.bin_size_t v1)
                in
                Bin_prot.Common.( + ) size (Timezone.Stable.V1.bin_size_t v2)
            ;;

            let _ = bin_size_t

            let bin_write_t : t Bin_prot.Write.writer =
              fun buf ~pos -> function
              | { ofday = v1; zone = v2 } ->
                let pos = Time_ns.Stable.Ofday.V1.bin_write_t buf ~pos v1 in
                Timezone.Stable.V1.bin_write_t buf ~pos v2
            ;;

            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t

            let __bin_read_t__ : (int -> t) Bin_prot.Read.reader =
              fun _buf ~pos_ref _vint ->
              Bin_prot.Common.raise_variant_wrong_type
                "time_ns_unix.ml.before-ppx.Ofday.Zoned.Stable.V1.Bin_repr.t"
                !pos_ref
            ;;

            let _ = __bin_read_t__

            let bin_read_t : t Bin_prot.Read.reader =
              fun buf ~pos_ref ->
              let v_ofday = Time_ns.Stable.Ofday.V1.bin_read_t buf ~pos_ref in
              let v_zone = Timezone.Stable.V1.bin_read_t buf ~pos_ref in
              { ofday = v_ofday; zone = v_zone }
            ;;

            let _ = bin_read_t

            let bin_reader_t =
              ({ read = bin_read_t; vtag_read = __bin_read_t__ }
               : _ Bin_prot.Type_class.reader)
            ;;

            let _ = bin_reader_t

            let bin_t =
              ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
               : _ Bin_prot.Type_class.t)
            ;;

            let _ = bin_t

            let stable_witness =
              (Ppx_stable_witness_runtime.Stable_witness.assert_stable
               : t Ppx_stable_witness_runtime.Stable_witness.t)

            and __stable_witness_checks_for_t__ () =
              let _
                : Time_ns.Stable.Ofday.V1.t Ppx_stable_witness_runtime.Stable_witness.t
                =
                Time_ns.Stable.Ofday.V1.stable_witness
              and _ : Timezone.Stable.V1.t Ppx_stable_witness_runtime.Stable_witness.t =
                Timezone.Stable.V1.stable_witness
              in
              ()
            ;;

            let _ = stable_witness
            and _ = __stable_witness_checks_for_t__
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end

        include
          Binable.Of_binable_without_uuid [@alert "-legacy"]
            (Bin_repr)
            (struct
              type nonrec t = t

              let to_binable t : Bin_repr.t = { ofday = ofday t; zone = zone t }
              let of_binable (repr : Bin_repr.t) = create repr.ofday repr.zone
            end)

        type nonrec t = t [@@deriving hash]

        include struct
          let _ = fun (_ : t) -> ()

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg -> hash_fold_t hsv arg

          and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func = hash in
            fun x -> func x
          ;;

          let _ = hash_fold_t
          and _ = hash
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let stable_witness : t Stable_witness.t = Bin_repr.stable_witness

        type sexp_repr = Time_ns.Stable.Ofday.V1.t * Timezone.Stable.V1.t
        [@@deriving sexp]

        include struct
          let _ = fun (_ : sexp_repr) -> ()

          let sexp_repr_of_sexp =
            (let error_source__029_ =
               "time_ns_unix.ml.before-ppx.Ofday.Zoned.Stable.V1.sexp_repr"
             in
             function
             | Sexplib0.Sexp.List [ arg0__024_; arg1__025_ ] ->
               let res0__026_ = Time_ns.Stable.Ofday.V1.t_of_sexp arg0__024_
               and res1__027_ = Timezone.Stable.V1.t_of_sexp arg1__025_ in
               res0__026_, res1__027_
             | sexp__028_ ->
               Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                 error_source__029_
                 2
                 sexp__028_
             : Sexplib0.Sexp.t -> sexp_repr)
          ;;

          let _ = sexp_repr_of_sexp

          let sexp_of_sexp_repr =
            (fun (arg0__030_, arg1__031_) ->
               let res0__032_ = Time_ns.Stable.Ofday.V1.sexp_of_t arg0__030_
               and res1__033_ = Timezone.Stable.V1.sexp_of_t arg1__031_ in
               Sexplib0.Sexp.List [ res0__032_; res1__033_ ]
             : sexp_repr -> Sexplib0.Sexp.t)
          ;;

          let _ = sexp_of_sexp_repr
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let sexp_of_t t = (sexp_of_sexp_repr [@merlin.hide]) (ofday t, zone t)

        let t_of_sexp sexp =
          let ofday, zone = (sexp_repr_of_sexp [@merlin.hide]) sexp in
          create ofday zone
        ;;
      end
    end
  end

  module Option = struct
    type ofday = t [@@deriving sexp, compare]

    include struct
      let _ = fun (_ : ofday) -> ()
      let ofday_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> ofday)
      let _ = ofday_of_sexp
      let sexp_of_ofday = (sexp_of_t : ofday -> Sexplib0.Sexp.t)
      let _ = sexp_of_ofday

      let compare_ofday =
        (fun a__035_ b__036_ -> compare a__035_ b__036_
         : ofday -> (ofday[@merlin.hide]) -> int)
      ;;

      let _ = compare_ofday
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    type t = Span.Option.t [@@deriving bin_io, compare, equal, hash, typerep]

    include struct
      [@@@ocaml.warning "-60"]

      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:227:4")
            [ Bin_prot.Shape.Tid.of_string "t", [], Span.Option.bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = Span.Option.bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = Span.Option.bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = Span.Option.__bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = Span.Option.bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let compare =
        (fun a__037_ b__038_ -> Span.Option.compare a__037_ b__038_
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let equal =
        (fun a__039_ b__040_ -> Span.Option.equal a__039_ b__040_
         : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg -> Span.Option.hash_fold_t hsv arg

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        let func = Span.Option.hash in
        fun x -> func x
      ;;

      let _ = hash_fold_t
      and _ = hash

      module Typename_of_t = Typerep_lib.Std.Make_typename.Make0 (struct
          type nonrec t = t

          let name = "time_ns_unix.ml.before-ppx.Ofday.Option.t"
          let _ = name
        end)

      let typename_of_t = Typename_of_t.typename_of_t
      let _ = typename_of_t

      let typerep_of_t =
        let name_of_t = Typename_of_t.named in
        Typerep_lib.Std.Typerep.Named (name_of_t, Some (lazy Span.Option.typerep_of_t))
      ;;

      let _ = typerep_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]

    let none = Span.Option.none
    let some t = Span.Option.some (to_span_since_start_of_day t)
    let is_none = Span.Option.is_none
    let is_some = Span.Option.is_some

    let some_is_representable t =
      Span.Option.some_is_representable (to_span_since_start_of_day t)
    ;;

    let value t ~default =
      Bool.select
        (is_none t)
        default
        (of_span_since_start_of_day_unchecked (Span.Option.unchecked_value t))
    ;;

    let of_span_since_start_of_day span =
      if span_since_start_of_day_is_valid span then Span.Option.some span else none
    ;;

    let value_exn t =
      if is_some t
      then of_span_since_start_of_day_unchecked (Span.Option.unchecked_value t)
      else
        raise_s
          (let ppx_sexp_message () =
             Ppx_sexp_conv_lib.Sexp.List
               [ Ppx_sexp_conv_lib.Conv.sexp_of_string "time_ns_unix.ml.before-ppx:252:29"
               ; Ppx_sexp_conv_lib.Conv.sexp_of_string
                   "Time_ns_unix.Ofday.Option.value_exn none"
               ]
               [@@ocaml.inline never] [@@ocaml.local never] [@@ocaml.specialise never]
           in
           (ppx_sexp_message () [@nontail]))
    ;;

    let unchecked_value t =
      of_span_since_start_of_day_unchecked (Span.Option.unchecked_value t)
    ;;

    let of_option = function
      | None -> none
      | Some t -> some t
    ;;

    let to_option t = if is_none t then None else Some (value_exn t)

    let quickcheck_generator : t Quickcheck.Generator.t =
      Quickcheck.Generator.map
        ~f:of_option
        (Core.Option.quickcheck_generator
           (Quickcheck.Generator.filter
              ~f:some_is_representable
              Time_ns.Ofday.quickcheck_generator))
    ;;

    let quickcheck_shrinker : t Quickcheck.Shrinker.t =
      Quickcheck.Shrinker.map
        ~f:of_option
        ~f_inverse:to_option
        (Core.Option.quickcheck_shrinker
           (Base_quickcheck.Shrinker.filter
              ~f:some_is_representable
              Time_ns.Ofday.quickcheck_shrinker))
    ;;

    let quickcheck_observer = Span.Option.quickcheck_observer

    module Optional_syntax = struct
      module Optional_syntax = struct
        let is_none = is_none
        let unsafe_value = unchecked_value
      end
    end

    module Stable = struct
      module V1 = struct
        module T = struct
          type nonrec t = t [@@deriving compare, equal, bin_io]

          include struct
            let _ = fun (_ : t) -> ()

            let compare =
              (fun a__041_ b__042_ -> compare a__041_ b__042_
               : t -> (t[@merlin.hide]) -> int)
            ;;

            let _ = compare

            let equal =
              (fun a__043_ b__044_ -> equal a__043_ b__044_
               : t -> (t[@merlin.hide]) -> bool)
            ;;

            let _ = equal

            let bin_shape_t =
              let _group =
                Bin_prot.Shape.group
                  (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:300:10")
                  [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
              in
              (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
            ;;

            let _ = bin_shape_t
            let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
            let _ = bin_size_t
            let bin_write_t : t Bin_prot.Write.writer = bin_write_t
            let _ = bin_write_t

            let bin_writer_t =
              ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
            ;;

            let _ = bin_writer_t
            let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
            let _ = __bin_read_t__
            let bin_read_t : t Bin_prot.Read.reader = bin_read_t
            let _ = bin_read_t

            let bin_reader_t =
              ({ read = bin_read_t; vtag_read = __bin_read_t__ }
               : _ Bin_prot.Type_class.reader)
            ;;

            let _ = bin_reader_t

            let bin_t =
              ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
               : _ Bin_prot.Type_class.t)
            ;;

            let _ = bin_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]

          let stable_witness : t Stable_witness.t = Stable_witness.assert_stable

          let sexp_of_t t =
            ((fun x__045_ -> sexp_of_option Time_ns.Stable.Ofday.V1.sexp_of_t x__045_)
               [@merlin.hide])
              (to_option t)
          ;;

          let t_of_sexp s =
            of_option
              (((fun x__046_ -> option_of_sexp Time_ns.Stable.Ofday.V1.t_of_sexp x__046_)
                  [@merlin.hide])
                 s)
          ;;

          let to_int63 t = Span.Option.Stable.V1.to_int63 t
          let of_int63_exn t = Span.Option.Stable.V1.of_int63_exn t
        end

        include T
        include Comparator.Stable.V1.Make (T)

        include Diffable.Atomic.Make (struct
            type nonrec t = t [@@deriving sexp, bin_io, equal]

            include struct
              let _ = fun (_ : t) -> ()
              let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
              let _ = t_of_sexp
              let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
              let _ = sexp_of_t

              let bin_shape_t =
                let _group =
                  Bin_prot.Shape.group
                    (Bin_prot.Shape.Location.of_string
                       "time_ns_unix.ml.before-ppx:313:10")
                    [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
                in
                (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
              ;;

              let _ = bin_shape_t
              let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
              let _ = bin_size_t
              let bin_write_t : t Bin_prot.Write.writer = bin_write_t
              let _ = bin_write_t

              let bin_writer_t =
                ({ size = bin_size_t; write = bin_write_t }
                 : _ Bin_prot.Type_class.writer)
              ;;

              let _ = bin_writer_t
              let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
              let _ = __bin_read_t__
              let bin_read_t : t Bin_prot.Read.reader = bin_read_t
              let _ = bin_read_t

              let bin_reader_t =
                ({ read = bin_read_t; vtag_read = __bin_read_t__ }
                 : _ Bin_prot.Type_class.reader)
              ;;

              let _ = bin_reader_t

              let bin_t =
                ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
                 : _ Bin_prot.Type_class.t)
              ;;

              let _ = bin_t

              let equal =
                (fun a__048_ b__049_ -> equal a__048_ b__049_
                 : t -> (t[@merlin.hide]) -> bool)
              ;;

              let _ = equal
            end [@@ocaml.doc "@inline"] [@@merlin.hide]
          end)
      end
    end

    let sexp_of_t = Stable.V1.sexp_of_t
    let t_of_sexp = Stable.V1.t_of_sexp

    include Identifiable.Make (struct
        type nonrec t = t [@@deriving sexp, compare, bin_io, hash]

        include struct
          let _ = fun (_ : t) -> ()
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t

          let compare =
            (fun a__051_ b__052_ -> compare a__051_ b__052_
             : t -> (t[@merlin.hide]) -> int)
          ;;

          let _ = compare

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:322:6")
                [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t
          let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
          let _ = bin_size_t
          let bin_write_t : t Bin_prot.Write.writer = bin_write_t
          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t
          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
          let _ = __bin_read_t__
          let bin_read_t : t Bin_prot.Read.reader = bin_read_t
          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let hash_fold_t
            : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
            =
            fun hsv arg -> hash_fold_t hsv arg

          and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
            let func = hash in
            fun x -> func x
          ;;

          let _ = hash_fold_t
          and _ = hash
        end [@@ocaml.doc "@inline"] [@@merlin.hide]

        let module_name = "Time_ns_unix.Ofday.Option"

        include Sexpable.To_stringable (struct
            type nonrec t = t [@@deriving sexp]

            include struct
              let _ = fun (_ : t) -> ()
              let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
              let _ = t_of_sexp
              let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
              let _ = sexp_of_t
            end [@@ocaml.doc "@inline"] [@@merlin.hide]
          end)
      end)

    include (Span.Option : Core.Comparisons.S with type t := t)

    include Diffable.Atomic.Make (struct
        type nonrec t = t [@@deriving sexp, bin_io, equal]

        include struct
          let _ = fun (_ : t) -> ()
          let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
          let _ = t_of_sexp
          let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
          let _ = sexp_of_t

          let bin_shape_t =
            let _group =
              Bin_prot.Shape.group
                (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:334:6")
                [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
            in
            (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
          ;;

          let _ = bin_shape_t
          let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
          let _ = bin_size_t
          let bin_write_t : t Bin_prot.Write.writer = bin_write_t
          let _ = bin_write_t

          let bin_writer_t =
            ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
          ;;

          let _ = bin_writer_t
          let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
          let _ = __bin_read_t__
          let bin_read_t : t Bin_prot.Read.reader = bin_read_t
          let _ = bin_read_t

          let bin_reader_t =
            ({ read = bin_read_t; vtag_read = __bin_read_t__ }
             : _ Bin_prot.Type_class.reader)
          ;;

          let _ = bin_reader_t

          let bin_t =
            ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
             : _ Bin_prot.Type_class.t)
          ;;

          let _ = bin_t

          let equal =
            (fun a__055_ b__056_ -> equal a__055_ b__056_
             : t -> (t[@merlin.hide]) -> bool)
          ;;

          let _ = equal
        end [@@ocaml.doc "@inline"] [@@merlin.hide]
      end)
  end
end

let get_sexp_zone = Time.get_sexp_zone
let set_sexp_zone = Time.set_sexp_zone

let t_of_sexp_gen ~if_no_timezone sexp =
  try
    match sexp with
    | Sexp.List [ Sexp.Atom date; Sexp.Atom ofday; Sexp.Atom tz ] ->
      of_date_ofday ~zone:(Zone.find_exn tz) (Date.of_string date) (Ofday.of_string ofday)
    | Sexp.List [ Sexp.Atom date; Sexp.Atom ofday_and_possibly_zone ] ->
      of_string_gen ~if_no_timezone (date ^ " " ^ ofday_and_possibly_zone)
    | Sexp.Atom datetime -> of_string_gen ~if_no_timezone datetime
    | _ -> of_sexp_error "Time.t_of_sexp" sexp
  with
  | Of_sexp_error _ as e -> raise e
  | e -> of_sexp_error (sprintf "Time.t_of_sexp: %s" (Exn.to_string e)) sexp
;;

let t_of_sexp sexp = t_of_sexp_gen sexp ~if_no_timezone:(`Use_this_one (get_sexp_zone ()))
let t_of_sexp_abs sexp = t_of_sexp_gen sexp ~if_no_timezone:`Fail

let t_sexp_grammar : t Sexplib.Sexp_grammar.t =
  { untyped =
      Union
        [ String
        ; List (Cons (String, Cons (String, Empty)))
        ; List (Cons (String, Cons (String, Cons (String, Empty))))
        ]
  }
;;

let sexp_of_t_abs t ~zone =
  Sexp.List (List.map (Time_ns.to_string_abs_parts ~zone t) ~f:(fun s -> Sexp.Atom s))
;;

let sexp_of_t t = sexp_of_t_abs ~zone:(get_sexp_zone ()) t
let of_date_ofday_zoned date ofday_zoned = Ofday.Zoned.to_time_ns ofday_zoned date

let to_date_ofday_zoned t ~zone =
  let date, ofday = to_date_ofday t ~zone in
  date, Ofday.Zoned.create ofday zone
;;

let to_ofday_zoned t ~zone =
  let ofday = to_ofday t ~zone in
  Ofday.Zoned.create ofday zone
;;

include Diffable.Atomic.Make (struct
    type nonrec t = t [@@deriving bin_io, equal, sexp]

    include struct
      let _ = fun (_ : t) -> ()

      let bin_shape_t =
        let _group =
          Bin_prot.Shape.group
            (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:389:2")
            [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
        in
        (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
      ;;

      let _ = bin_shape_t
      let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
      let _ = bin_size_t
      let bin_write_t : t Bin_prot.Write.writer = bin_write_t
      let _ = bin_write_t

      let bin_writer_t =
        ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
      ;;

      let _ = bin_writer_t
      let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
      let _ = __bin_read_t__
      let bin_read_t : t Bin_prot.Read.reader = bin_read_t
      let _ = bin_read_t

      let bin_reader_t =
        ({ read = bin_read_t; vtag_read = __bin_read_t__ } : _ Bin_prot.Type_class.reader)
      ;;

      let _ = bin_reader_t

      let bin_t =
        ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
         : _ Bin_prot.Type_class.t)
      ;;

      let _ = bin_t

      let equal =
        (fun a__057_ b__058_ -> equal a__057_ b__058_ : t -> (t[@merlin.hide]) -> bool)
      ;;

      let _ = equal
      let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
      let _ = sexp_of_t
    end [@@ocaml.doc "@inline"] [@@merlin.hide]
  end)

module Stable0 = struct
  module V1 = struct
    module T0 = struct
      type nonrec t = t [@@deriving bin_io, compare, equal, hash, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:397:6")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_t
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let compare =
          (fun a__060_ b__061_ -> compare a__060_ b__061_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let equal =
          (fun a__062_ b__063_ -> equal a__062_ b__063_ : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash

        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let stable_witness : t Stable_witness.t = Stable_witness.assert_stable
      let of_int63_exn t = of_span_since_epoch (Span.of_int63_ns t)
      let to_int63 t = to_int63_ns_since_epoch t
    end

    module T = struct
      include T0
      module Comparator = Comparator.Stable.V1.Make (T0)
      include Comparator
    end

    include T
    include Comparable.Stable.V1.With_stable_witness.Make (T)
    include Diffable.Atomic.Make (T)
  end
end

include Stable0.V1.Comparator

module Option = struct
  include Time_ns.Option

  module Stable = struct
    module V1 = struct
      module T = struct
        include Stable.V1

        let sexp_of_t t =
          ((fun x__065_ -> sexp_of_option Stable0.V1.sexp_of_t x__065_) [@merlin.hide])
            (to_option t)
        ;;

        let t_of_sexp s =
          of_option
            (((fun x__066_ -> option_of_sexp Stable0.V1.t_of_sexp x__066_) [@merlin.hide])
               s)
        ;;
      end

      include T
      include Comparator.Stable.V1.Make (T)

      include Diffable.Atomic.Make (struct
          include T

          let equal (_x__067_ : t) _x__068_ =
            (match
               (fun (a__069_ : t) ((b__070_ : t) [@merlin.hide]) ->
                  (compare a__069_ b__070_ [@merlin.hide]))
                 _x__067_
                 _x__068_
             with
             | 0 -> true
             | _ -> false)
            [@merlin.hide]
          ;;
        end)
    end
  end

  let sexp_of_t = Stable.V1.sexp_of_t
  let t_of_sexp = Stable.V1.t_of_sexp

  include Identifiable.Make (struct
      type nonrec t = t [@@deriving sexp, compare, bin_io, hash]

      include struct
        let _ = fun (_ : t) -> ()
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t

        let compare =
          (fun a__072_ b__073_ -> compare a__072_ b__073_ : t -> (t[@merlin.hide]) -> int)
        ;;

        let _ = compare

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:445:4")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_t
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
          fun hsv arg -> hash_fold_t hsv arg

        and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
          let func = hash in
          fun x -> func x
        ;;

        let _ = hash_fold_t
        and _ = hash
      end [@@ocaml.doc "@inline"] [@@merlin.hide]

      let module_name = "Time_ns_unix.Option"

      include Sexpable.To_stringable (struct
          type nonrec t = t [@@deriving sexp]

          include struct
            let _ = fun (_ : t) -> ()
            let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
            let _ = t_of_sexp
            let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
            let _ = sexp_of_t
          end [@@ocaml.doc "@inline"] [@@merlin.hide]
        end)
    end)

  include (Time_ns.Option : Core.Comparisons.S with type t := t)

  include Diffable.Atomic.Make (struct
      type nonrec t = t [@@deriving bin_io, equal, sexp]

      include struct
        let _ = fun (_ : t) -> ()

        let bin_shape_t =
          let _group =
            Bin_prot.Shape.group
              (Bin_prot.Shape.Location.of_string "time_ns_unix.ml.before-ppx:458:4")
              [ Bin_prot.Shape.Tid.of_string "t", [], bin_shape_t ]
          in
          (Bin_prot.Shape.top_app _group (Bin_prot.Shape.Tid.of_string "t")) []
        ;;

        let _ = bin_shape_t
        let bin_size_t : t Bin_prot.Size.sizer = bin_size_t
        let _ = bin_size_t
        let bin_write_t : t Bin_prot.Write.writer = bin_write_t
        let _ = bin_write_t

        let bin_writer_t =
          ({ size = bin_size_t; write = bin_write_t } : _ Bin_prot.Type_class.writer)
        ;;

        let _ = bin_writer_t
        let __bin_read_t__ : (int -> t) Bin_prot.Read.reader = __bin_read_t__
        let _ = __bin_read_t__
        let bin_read_t : t Bin_prot.Read.reader = bin_read_t
        let _ = bin_read_t

        let bin_reader_t =
          ({ read = bin_read_t; vtag_read = __bin_read_t__ }
           : _ Bin_prot.Type_class.reader)
        ;;

        let _ = bin_reader_t

        let bin_t =
          ({ writer = bin_writer_t; reader = bin_reader_t; shape = bin_shape_t }
           : _ Bin_prot.Type_class.t)
        ;;

        let _ = bin_t

        let equal =
          (fun a__075_ b__076_ -> equal a__075_ b__076_ : t -> (t[@merlin.hide]) -> bool)
        ;;

        let _ = equal
        let t_of_sexp = (t_of_sexp : Sexplib0.Sexp.t -> t)
        let _ = t_of_sexp
        let sexp_of_t = (sexp_of_t : t -> Sexplib0.Sexp.t)
        let _ = sexp_of_t
      end [@@ocaml.doc "@inline"] [@@merlin.hide]
    end)
end

let to_string_fix_proto zone t =
  Time.to_string_fix_proto zone (to_time_float_round_nearest_microsecond t)
;;

let of_string_fix_proto zone s =
  of_time_float_round_nearest_microsecond (Time.of_string_fix_proto zone s)
;;

include Identifiable.Make_using_comparator (struct
    include Stable0.V1

    let module_name = "Time_ns_unix"
    let of_string, to_string = of_string, to_string
  end)

include (Core.Time_ns : Core.Comparisons.S with type t := t)

module Stable = struct
  module Option = Option.Stable

  module Span = struct
    include Span.Stable
    module Option = Span.Option.Stable
  end

  module Ofday = struct
    include Time_ns.Stable.Ofday
    module Zoned = Ofday.Zoned.Stable
    module Option = Ofday.Option.Stable
  end

  module Zone = Timezone.Stable
  include Stable0
  module Alternate_sexp = Core.Time_ns.Stable.Alternate_sexp
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
