let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_ns_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_ns_intf.ml.before-ppx"
;;

open! Import

module Rounding_direction = struct
  type t =
    | Down
    | Nearest
    | Up
    | Zero
  [@@deriving equal, enumerate, sexp_of]

  include struct
    let _ = fun (_ : t) -> ()

    let equal =
      (fun a__001_ b__002_ -> Stdlib.( = ) a__001_ b__002_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal
    let all = ([ Down; Nearest; Up; Zero ] : t list)
    let _ = all

    let sexp_of_t =
      (function
       | Down -> Sexplib0.Sexp.Atom "Down"
       | Nearest -> Sexplib0.Sexp.Atom "Nearest"
       | Up -> Sexplib0.Sexp.Atom "Up"
       | Zero -> Sexplib0.Sexp.Atom "Zero"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module type Span = sig
  type t = private Int63.t
  [@@ocaml.doc
    " [t] is immediate on 64bit boxes and so plays nicely with the GC write barrier. "]
  [@@deriving hash]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Span_intf.S with type underlying = Int63.t and type t := t

  val of_sec_with_microsecond_precision : float -> t
  val of_int_us : int -> t
  val of_int_ms : int -> t
  val to_int_us : t -> int
  val to_int_ms : t -> int
  val to_int_sec : t -> int

  [@@@ocaml.text
    " Approximations of float conversions using multiplication instead of division. "]

  val to_us_approx : t -> float
  val to_ms_approx : t -> float
  val to_sec_approx : t -> float
  val to_min_approx : t -> float
  val to_hr_approx : t -> float
  val to_day_approx : t -> float

  val min_value_representable : t [@@ocaml.doc " The minimum representable time span. "]

  val max_value_representable : t [@@ocaml.doc " The maximum representable time span. "]

  val min_value_for_1us_rounding : t
  [@@ocaml.doc
    " The minimum span that rounds to a [Time.Span.t] with microsecond precision. "]

  val max_value_for_1us_rounding : t
  [@@ocaml.doc
    " The maximum span that rounds to a [Time.Span.t] with microsecond precision. "]

  val min_value : t
  [@@ocaml.doc " An alias for [min_value_for_1us_rounding]. "]
  [@@deprecated
    "[since 2019-02] use [min_value_representable] or [min_value_for_1us_rounding] \
     instead"]

  val max_value : t
  [@@ocaml.doc " An alias for [max_value_for_1us_rounding]. "]
  [@@deprecated
    "[since 2019-02] use [max_value_representable] or [max_value_for_1us_rounding] \
     instead"]

  val scale_int : t -> int -> t [@@ocaml.doc " overflows silently "]

  val scale_int63 : t -> Int63.t -> t [@@ocaml.doc " overflows silently "]

  val div : t -> t -> Int63.t
  [@@ocaml.doc " Rounds down, and raises unless denominator is positive. "]

  val to_int63_ns : t -> Int63.t
  [@@ocaml.doc " Fast, implemented as the identity function. "]

  val of_int63_ns : Int63.t -> t
  [@@ocaml.doc " Fast, implemented as the identity function. "]

  val to_int_ns : t -> int
  [@@ocaml.doc " Will raise on 32-bit platforms.  Consider [to_int63_ns] instead. "]

  val of_int_ns : int -> t
  val since_unix_epoch : unit -> t
  val random : ?state:Random.State.t -> unit -> t

  val to_span : t -> Span_float.t
  [@@ocaml.doc
    " WARNING!!! [to_span] and [of_span] both round to the nearest 1us.\n\n\
    \      Around 135y magnitudes [to_span] and [of_span] raise.\n\
    \  "]
  [@@deprecated
    "[since 2019-01] use [to_span_float_round_nearest] or \
     [to_span_float_round_nearest_microsecond]"]

  val of_span : Span_float.t -> t
  [@@deprecated
    "[since 2019-01] use [of_span_float_round_nearest] or \
     [of_span_float_round_nearest_microsecond]"]

  [@@@ocaml.text
    " [*_round_nearest] vs [*_round_nearest_microsecond]: If you don't know that you need\n\
    \      microsecond precision, use the [*_round_nearest] version.\n\
    \      [*_round_nearest_microsecond] is for historical purposes. "]

  val to_span_float_round_nearest : t -> Span_float.t
  val to_span_float_round_nearest_microsecond : t -> Span_float.t
  val of_span_float_round_nearest : Span_float.t -> t
  val of_span_float_round_nearest_microsecond : Span_float.t -> t

  module Rounding_direction = Rounding_direction

  [@@@ocaml.text
    " These operations round the span to the nearest whole-number of the given factor. "]

  val round_up : t -> to_multiple_of:t -> t
  val round_down : t -> to_multiple_of:t -> t
  val round_nearest : t -> to_multiple_of:t -> t
  val round_towards_zero : t -> to_multiple_of:t -> t
  val round : t -> dir:Rounding_direction.t -> to_multiple_of:t -> t

  module Alternate_sexp : sig
    type nonrec t = t [@@deriving sexp, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " Note that we expose a sexp format that is not the one exposed in [Core]. "]
  [@@deprecated "[since 2018-04] use [Span.sexp_of_t] and [Span.t_of_sexp] instead"]

  val arg_type : t Command.Arg_type.t

  module O : sig
    val ( / ) : t -> float -> t
    val ( // ) : t -> t -> float
    val ( + ) : t -> t -> t
    val ( - ) : t -> t -> t

    val ( ~- ) : t -> t [@@ocaml.doc " alias for [neg] "]

    val ( *. ) : t -> float -> t [@@ocaml.doc " alias for [scale] "]

    val ( * ) : t -> int -> t [@@ocaml.doc " alias for [scale_int] "]

    include Comparisons.Infix with type t := t
  end

  module Option : sig
    include Immediate_option.S_int63 with type value := t
    include Identifiable.S with type t := t
    include Diffable.S_atomic with type t := t
    include Quickcheck.S with type t := t

    module Stable : sig
      module V1 : sig
        include Stable_int63able.With_stable_witness.S with type t = t
        include Diffable.S_atomic with type t := t
      end

      module V2 : sig
        include Stable_int63able.With_stable_witness.S with type t = t
        include Diffable.S_atomic with type t := t
      end
    end
  end
  [@@ocaml.doc
    " [Span.Option.t] is like [Span.t option], except that the value is immediate on\n\
    \      architectures where [Int63.t] is immediate.  This module should mainly be \
     used to\n\
    \      avoid allocations. "]

  module Stable : sig
    module V1 : sig
      type nonrec t = t [@@deriving hash, equal, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Stable_int63able.With_stable_witness.S with type t := t
      include Diffable.S_atomic with type t := t
    end

    module V2 : sig
      type nonrec t = t [@@deriving hash, equal, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      type nonrec comparator_witness = comparator_witness

      include
        Stable_int63able.With_stable_witness.S
        with type t := t
        with type comparator_witness := comparator_witness

      include
        Comparable.Stable.V1.With_stable_witness.S
        with type comparable := t
        with type comparator_witness := comparator_witness

      include Stringable.S with type t := t
      include Diffable.S_atomic with type t := t
    end
  end

  module Private : sig
    val of_parts : Parts.t -> t
    val to_parts : t -> Parts.t
  end
end

module type Ofday = sig
  module Span : Span

  type t = private Int63.t
  [@@ocaml.doc
    " [t] is immediate on 64bit boxes and so plays nicely with the GC write barrier. "]

  include
    Ofday_intf.S with type underlying = Int63.t and type t := t and module Span := Span
  [@@ocaml.doc
    " String and sexp output takes the form 'HH:MM:SS.sssssssss'; see\n\
    \      {!Core.Ofday_intf} for accepted input. If input includes more than 9 decimal\n\
    \      places in seconds, rounds to the nearest nanosecond, with the midpoint \
     rounded up.\n\
    \      Allows 60[.sss...] seconds for leap seconds but treats it as exactly 60s \
     regardless\n\
    \      of fractional part. "]

  val approximate_end_of_day : t
  [@@ocaml.doc
    " The largest representable value below [start_of_next_day], i.e. one nanosecond\n\
    \      before midnight. "]

  val add_exn : t -> Span.t -> t
  [@@ocaml.doc
    " [add_exn t span] shifts the time of day [t] by [span]. It raises if the result is\n\
    \      not in the same 24-hour day. Daylight savings shifts are not accounted for. "]

  val sub_exn : t -> Span.t -> t
  [@@ocaml.doc
    " [sub_exn t span] shifts the time of day [t] back by [span]. It raises if the result\n\
    \      is not in the same 24-hour day. Daylight savings shifts are not accounted \
     for. "]

  val every : Span.t -> start:t -> stop:t -> t list Or_error.t
  [@@ocaml.doc
    " [every span ~start ~stop] returns a sorted list of all [t]s that can be expressed as\n\
    \      [start + (i * span)] without overflow, and satisfying [t >= start && t <= \
     stop].\n\n\
    \      If [span <= Span.zero || start > stop], returns an Error.\n\n\
    \      The result never crosses the midnight boundary. Constructing a list crossing\n\
    \      midnight, e.g. every hour from 10pm to 2am, requires multiple calls to \
     [every]. "]

  val to_microsecond_string : t -> string

  module Stable : sig
    module V1 : sig
      type nonrec t = t [@@deriving equal, hash, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include
        Stable_int63able.With_stable_witness.S
        with type t := t
         and type comparator_witness = comparator_witness

      include Diffable.S_atomic with type t := t
    end
  end

  val arg_type : [ `Use_Time_ns_unix ] [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
  val now : [ `Use_Time_ns_unix ] [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val of_ofday_float_round_nearest : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val of_ofday_float_round_nearest_microsecond : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val to_ofday_float_round_nearest : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val to_ofday_float_round_nearest_microsecond : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  module Option : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
  module Zoned : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
end

module type Time_ns = sig
  module Span : Span
  module Ofday : Ofday with module Span := Span

  type t = private Int63.t [@@deriving hash, typerep, bin_io]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
    include Typerep_lib.Typerepable.S with type t := t
    include Bin_prot.Binable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparisons.S with type t := t

  module Alternate_sexp : sig
    type nonrec t = t [@@deriving bin_io, compare, equal, hash, sexp, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparable.S with type t := t
    include Diffable.S_atomic with type t := t
  end
  [@@ocaml.doc
    " Note that we expose a sexp format that is not the one exposed in [Time_ns_unix]. The\n\
    \      sexp is a single atom rendered as with [to_string_utc], except that all \
     trailing\n\
    \      zeros are trimmed, rather than trimming in groups of three. "]

  module Option : sig
    type value := t
    type t = private Span.Option.t [@@deriving compare, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Immediate_option.S_int63 with type value := value with type t := t
    include Quickcheck.S with type t := t

    module Stable : sig
      module V1 : sig
        type nonrec t = t [@@deriving compare, bin_io, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Ppx_compare_lib.Comparable.S with type t := t
          include Bin_prot.Binable.S with type t := t

          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        val to_int63 : t -> Int63.t
        val of_int63_exn : Int63.t -> t
      end
    end

    val sexp_of_t : [ `Use_Time_ns_unix ]
    [@@deprecated "[since 2023-09] Use [Time_ns_unix.Option]"]

    include Comparisons.S with type t := t

    module Alternate_sexp : sig
      type nonrec t = t [@@deriving bin_io, compare, equal, hash, sexp, sexp_grammar]

      include sig
        [@@@ocaml.warning "-32"]

        include Bin_prot.Binable.S with type t := t
        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Ppx_hash_lib.Hashable.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@ocaml.doc "@inline"] [@@merlin.hide]

      include Comparable.S with type t := t
      include Diffable.S_atomic with type t := t
    end
    [@@ocaml.doc
      " Just like [Time_ns.Alternate_sexp], this is different from the sexp format exposed\n\
      \        in [Time_ns_unix].  See the comment above. "]
  end
  [@@ocaml.doc
    " [Option.t] is like [t option], except that the value is immediate.  This module\n\
    \      should mainly be used to avoid allocations. "]

  include
    Time_intf.Shared with type t := t with module Span := Span with module Ofday := Ofday

  val of_string : string -> t
  [@@deprecated
    "[since 2021-04] Use [of_string_with_utc_offset] or [Time_ns_unix.of_string]"]

  val of_string_with_utc_offset : string -> t
  [@@ocaml.doc
    " [of_string_with_utc_offset] requires its input to have an explicit\n\
    \      UTC offset, e.g. [2000-01-01 12:34:56.789012-23], or use the UTC zone, \"Z\",\n\
    \      e.g. [2000-01-01 12:34:56.789012Z]. "]

  val to_string : t -> string
  [@@deprecated "[since 2021-04] Use [to_string_utc] or [Time_ns_unix.to_string]"]

  val to_string_utc : t -> string
  [@@ocaml.doc
    " [to_string_utc] generates a time string with the UTC zone, \"Z\", e.g. [2000-01-01\n\
    \      12:34:56.789012Z]. "]

  val epoch : t [@@ocaml.doc " Unix epoch (1970-01-01 00:00:00 UTC) "]

  val min_value_representable : t [@@ocaml.doc " The minimum representable time. "]

  val max_value_representable : t [@@ocaml.doc " The maximum representable time. "]

  val min_value_for_1us_rounding : t
  [@@ocaml.doc " The minimum time that rounds to a [Time.t] with microsecond precision. "]

  val max_value_for_1us_rounding : t
  [@@ocaml.doc " The maximum time that rounds to a [Time.t] with microsecond precision. "]

  val min_value : t
  [@@ocaml.doc " An alias for [min_value_for_1us_rounding]. "]
  [@@deprecated
    "[since 2019-02] use [min_value_representable] or [min_value_for_1us_rounding] \
     instead"]

  val max_value : t
  [@@ocaml.doc " An alias for [max_value_for_1us_rounding]. "]
  [@@deprecated
    "[since 2019-02] use [max_value_representable] or [max_value_for_1us_rounding] \
     instead"]

  val now : unit -> t [@@ocaml.doc " The current time. "]

  val add : t -> Span.t -> t [@@ocaml.doc " overflows silently "]

  val add_saturating : t -> Span.t -> t
  [@@ocaml.doc
    " As [add]; rather than over/underflowing, clamps the result to the closed interval\n\
    \      between [min_value_representable] and [max_value_representable]. "]

  val sub_saturating : t -> Span.t -> t
  [@@ocaml.doc
    " As [sub]; rather than over/underflowing, clamps the result to the closed interval\n\
    \      between [min_value_representable] and [max_value_representable]. "]

  val sub : t -> Span.t -> t [@@ocaml.doc " overflows silently "]

  val next : t -> t [@@ocaml.doc " overflows silently "]

  val prev : t -> t [@@ocaml.doc " overflows silently "]

  val diff : t -> t -> Span.t [@@ocaml.doc " overflows silently "]

  val abs_diff : t -> t -> Span.t [@@ocaml.doc " overflows silently "]

  val to_span_since_epoch : t -> Span.t
  val of_span_since_epoch : Span.t -> t
  val to_int63_ns_since_epoch : t -> Int63.t
  val of_int63_ns_since_epoch : Int63.t -> t

  val to_int_ns_since_epoch : t -> int
  [@@ocaml.doc
    " Will raise on 32-bit platforms.  Consider [to_int63_ns_since_epoch] instead. "]

  val of_int_ns_since_epoch : int -> t

  val next_multiple
    :  ?can_equal_after:(bool[@ocaml.doc " default is [false] "])
    -> base:t
    -> after:t
    -> interval:Span.t
    -> unit
    -> t
  [@@ocaml.doc
    " [next_multiple ~base ~after ~interval] returns the smallest [time] of the form:\n\n\
    \      {[\n\
    \        time = base + k * interval\n\
    \      ]}\n\n\
    \      where [k >= 0] and [time > after].  It is an error if [interval <= 0].\n\n\
    \      Supplying [~can_equal_after:true] allows the result to satisfy [time >= \
     after].\n\n\
    \      This function is useful for finding linear time intervals, like every 30 \
     minutes or\n\
    \      every 24 hours. This is different from rounding to apparent clock-face \
     internvals,\n\
    \      like \"every hour at :00 and :30\" or \"every day at noon\", because time \
     zone and\n\
    \      daylight savings transitions may cause linear intervals and apparent clock-face\n\
    \      intervals to differ.\n\n\
    \      Time zone offsets (in the tzdata time zone database, at least) are expressed in\n\
    \      seconds, so rounding to units of seconds or smaller is not affected by time \
     zones.\n\
    \      The [round*] functions below provide some straightforward cases. For other \
     small\n\
    \      units that evenly divide into a second, call with [base = epoch], [after] as \
     the\n\
    \      time to round, and [interval] as the unit span you are rounding to. "]

  val prev_multiple
    :  ?can_equal_before:(bool[@ocaml.doc " default is [false] "])
    -> base:t
    -> before:t
    -> interval:Span.t
    -> unit
    -> t
  [@@ocaml.doc
    " [prev_multiple ~base ~before ~interval] returns the largest [time] of the form:\n\n\
    \      {[\n\
    \        time = base + k * interval\n\
    \      ]}\n\n\
    \      where [k >= 0] and [time < before].  It is an error if [interval <= 0].\n\n\
    \      Supplying [~can_equal_before:true] allows the result to satisfy [time <= \
     before].\n\n\
    \      This function is useful for finding linear time intervals, like every 30 \
     minutes or\n\
    \      every 24 hours. This is different from rounding to apparent clock-face \
     internvals,\n\
    \      like \"every hour at :00 and :30\" or \"every day at noon\", because time \
     zone and\n\
    \      daylight savings transitions may cause linear intervals and apparent clock-face\n\
    \      intervals to differ.\n\n\
    \      Time zone offsets (in the tzdata time zone database, at least) are expressed in\n\
    \      seconds, so rounding to units of seconds or smaller is not affected by time \
     zones.\n\
    \      The [round*] functions below provide some straightforward cases. For other \
     small\n\
    \      units that evenly divide into a second, call with [base = epoch], [after] as \
     the\n\
    \      time to round, and [interval] as the unit span you are rounding to. "]

  val round_up_to_us : t -> t
  [@@ocaml.doc " [round_up_to_us t] returns [t] rounded up to the next microsecond. "]

  val round_up_to_ms : t -> t
  [@@ocaml.doc " [round_up_to_ms t] returns [t] rounded up to the next millisecond. "]

  val round_up_to_sec : t -> t
  [@@ocaml.doc " [round_up_to_sec t] returns [t] rounded up to the next second. "]

  val round_down_to_us : t -> t
  [@@ocaml.doc
    " [round_down_to_us t] returns [t] rounded down to the previous microsecond. "]

  val round_down_to_ms : t -> t
  [@@ocaml.doc
    " [round_down_to_ms t] returns [t] rounded down to the previous millisecond. "]

  val round_down_to_sec : t -> t
  [@@ocaml.doc " [round_down_to_sec t] returns [t] rounded down to the previous second. "]

  val random : ?state:Random.State.t -> unit -> t

  val of_time : Time_float.t -> t
  [@@deprecated
    "[since 2019-01] use [of_time_float_round_nearest] or \
     [of_time_float_round_nearest_microsecond]"]

  val to_time : t -> Time_float.t
  [@@deprecated
    "[since 2019-01] use [to_time_float_round_nearest] or \
     [to_time_float_round_nearest_microsecond]"]

  [@@@ocaml.text
    " [*_round_nearest] vs [*_round_nearest_microsecond]: If you don't know that you need\n\
    \      microsecond precision, use the [*_round_nearest] version.\n\
    \      [*_round_nearest_microsecond] is for historical purposes. "]

  val to_time_float_round_nearest : t -> Time_float.t
  val to_time_float_round_nearest_microsecond : t -> Time_float.t
  val of_time_float_round_nearest : Time_float.t -> t
  val of_time_float_round_nearest_microsecond : Time_float.t -> t

  module Utc : sig
    val to_date_and_span_since_start_of_day : t -> Date0.t * Span.t
    [@@ocaml.doc
      " [to_date_and_span_since_start_of_day] computes the date and intraday-offset of a\n\
      \        time in UTC.  It may be slower than [Core.Time_ns.to_date_ofday], as this\n\
      \        function does not cache partial results while the latter does. "]

    val of_date_and_span_since_start_of_day : Date0.t -> Span.t -> t
    [@@ocaml.doc " The inverse of [to_date_and_span_since_start_of_day]. "]
  end

  module O : sig
    val ( + ) : t -> Span.t -> t [@@ocaml.doc " alias for [add] "]

    val ( - ) : t -> t -> Span.t [@@ocaml.doc " alias for [diff] "]

    include Comparisons.Infix with type t := t
  end

  module Stable : sig
    module V1 : sig end
    [@@deprecated "[since 2021-03] Use [Time_ns_unix] or [Time_ns.Alternate_sexp]"]

    module Option : sig
      module V1 : sig
        type nonrec t = Option.t [@@deriving compare, bin_io, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Ppx_compare_lib.Comparable.S with type t := t
          include Bin_prot.Binable.S with type t := t

          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        val to_int63 : t -> Int63.t
        val of_int63_exn : Int63.t -> t
      end

      module Alternate_sexp : sig
        module V1 : sig
          type nonrec t = Option.Alternate_sexp.t
          [@@deriving bin_io, compare, hash, sexp, sexp_grammar, stable_witness]

          include sig
            [@@@ocaml.warning "-32"]

            include Bin_prot.Binable.S with type t := t
            include Ppx_compare_lib.Comparable.S with type t := t
            include Ppx_hash_lib.Hashable.S with type t := t
            include Sexplib0.Sexpable.S with type t := t

            val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
            val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
          end
          [@@ocaml.doc "@inline"] [@@merlin.hide]

          include
            Comparator.Stable.V1.S
            with type t := t
             and type comparator_witness = Option.Alternate_sexp.comparator_witness

          include
            Comparable.Stable.V1.With_stable_witness.S
            with type comparable := t
            with type comparator_witness := comparator_witness

          include Diffable.S_atomic with type t := t
        end
      end
    end

    module Alternate_sexp : sig
      module V1 : sig
        type t = Alternate_sexp.t
        [@@deriving bin_io, compare, equal, hash, sexp, sexp_grammar, stable_witness]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S with type t := t
          include Ppx_compare_lib.Comparable.S with type t := t
          include Ppx_compare_lib.Equal.S with type t := t
          include Ppx_hash_lib.Hashable.S with type t := t
          include Sexplib0.Sexpable.S with type t := t

          val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
          val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        include
          Comparator.Stable.V1.S
          with type t := t
           and type comparator_witness = Alternate_sexp.comparator_witness

        include
          Comparable.Stable.V1.With_stable_witness.S
          with type comparable := t
          with type comparator_witness := comparator_witness

        include Diffable.S_atomic with type t := t
      end
    end

    module Span : sig
      module V1 : sig
        type nonrec t = Span.t [@@deriving hash, equal, sexp_grammar]

        include sig
          [@@@ocaml.warning "-32"]

          include Ppx_hash_lib.Hashable.S with type t := t
          include Ppx_compare_lib.Equal.S with type t := t

          val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        include Stable_int63able.With_stable_witness.S with type t := t
        include Diffable.S_atomic with type t := t
      end

      module Option : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

      module V2 : sig
        type t = Span.t [@@deriving hash, equal, sexp_grammar]

        include sig
          [@@@ocaml.warning "-32"]

          include Ppx_hash_lib.Hashable.S with type t := t
          include Ppx_compare_lib.Equal.S with type t := t

          val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        type nonrec comparator_witness = Span.comparator_witness

        include
          Stable_int63able.With_stable_witness.S
          with type t := t
          with type comparator_witness := comparator_witness

        include
          Comparable.Stable.V1.With_stable_witness.S
          with type comparable := t
          with type comparator_witness := comparator_witness

        include Stringable.S with type t := t
        include Diffable.S_atomic with type t := t
      end
    end

    module Ofday : sig
      module V1 : sig
        type t = Ofday.t [@@deriving equal, hash, sexp_grammar]

        include sig
          [@@@ocaml.warning "-32"]

          include Ppx_compare_lib.Equal.S with type t := t
          include Ppx_hash_lib.Hashable.S with type t := t

          val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        include
          Stable_int63able.With_stable_witness.S
          with type t := t
           and type comparator_witness = Ofday.comparator_witness

        include Diffable.S_atomic with type t := t
      end

      module Option : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
      module Zoned : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
    end
  end

  module Hash_queue : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
  module Hash_set : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
  module Map : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  module Replace_polymorphic_compare : sig end
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  module Set : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
  module Table : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
  module Zone : sig end [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val arg_type : [ `Use_Time_ns_unix ] [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val comparator : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val get_sexp_zone : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val interruptible_pause : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val of_date_ofday_zoned : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val of_string_abs : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val of_string_fix_proto : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val pause : [ `Use_Time_ns_unix ] [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val pause_forever : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val pp : [ `Use_Time_ns_unix ] [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val set_sexp_zone : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val sexp_of_t : [ `Use_Time_ns_unix_or_Time_ns_alternate_sexp ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix] or [Time_ns.Alternate_sexp]"]

  val sexp_of_t_abs : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val t_of_sexp : [ `Use_Time_ns_unix_or_Time_ns_alternate_sexp ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix] or [Time_ns.Alternate_sexp]"]

  val t_of_sexp_abs : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val to_date_ofday_zoned : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val to_ofday_zoned : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val to_string_fix_proto : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val validate_bound : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val validate_lbound : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]

  val validate_ubound : [ `Use_Time_ns_unix ]
  [@@deprecated "[since 2021-03] Use [Time_ns_unix]"]
end
[@@ocaml.doc
  " Time represented as an [Int63.t] number of nanoseconds since the epoch.\n\n\
  \    See {!Time_ns_unix} for important user documentation.\n\n\
  \    Internally, arithmetic is not overflow-checked. Instead, overflows are silently\n\
  \    ignored as for [int] arithmetic, unless specifically documented otherwise. \
   Conversions\n\
  \    may (or may not) raise if prior arithmetic operations overflowed. "]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
