let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"ofday_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "ofday_intf.ml.before-ppx"
;;

open! Import
open Std_internal

module type S = sig
  type underlying
  [@@ocaml.doc
    " Time of day.\n\n\
    \      [t] represents a clock-face time of day. Usually this is equivalent to a \
     time-offset\n\
    \      from midnight, and each [t] occurs exactly once in each calendar day. \
     However, when\n\
    \      daylight saving time begins or ends, some clock face times (and therefore \
     [t]'s) can\n\
    \      occur more than once per day or not at all, and e.g. 04:00 can occur three or \
     five\n\
    \      hours after midnight, so knowing your current offset from midnight is *not* in\n\
    \      general equivalent to knowing the current [t].\n\n\
    \      (See {!Zone} for tools to help you cope with DST.)\n\n\
    \      There is one nonstandard representable value, [start_of_next_day], which can be\n\
    \      thought of as \"24:00:00\" in 24-hour time. It is essentially \"00:00:00\" on \
     the next\n\
    \      day. By having this value, we allow comparisons against a strict upper bound \
     on [t]\n\
    \      values. However, it has some odd properties; for example, [Time.of_date_ofday \
     ~zone\n\
    \      date start_of_next_day |> Time.to_date ~zone] yields a different date.\n\n\
    \      Any [ofday] will satisfy [start_of_day <= ofday <= start_of_next_day]. "]

  type t = private underlying [@@deriving bin_io, sexp, sexp_grammar, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable_binable with type t := t
  include Hashable_binable with type t := t
  include Diffable.S_atomic with type t := t
  include Pretty_printer.S with type t := t
  include Robustly_comparable with type t := t
  include Quickcheck.S_range with type t := t
  module Span : Span_intf.S

  include
    Stringable with type t := t
  [@@ocaml.doc
    " [of_string] supports and correctly interprets 12h strings with the following \
     suffixes:\n\n\
    \      {v\n\
    \      \"A\", \"AM\", \"A.M.\", \"A.M\"\n\
    \      \"P\", \"PM\", \"P.M.\", \"P.M\"\n\
    \    v}\n\n\
    \      as well as the lowercase and space-prefixed versions of these suffixes.\n\n\
    \      [of_string] also fully supports 24h wall-clock times.\n\n\
    \      [to_string] only produces the 24h format. "]

  val create
    :  ?hr:int
    -> ?min:int
    -> ?sec:int
    -> ?ms:int
    -> ?us:int
    -> ?ns:int
    -> unit
    -> t

  val to_parts : t -> Span.Parts.t

  val start_of_day : t [@@ocaml.doc " Smallest valid ofday. "]

  val start_of_next_day : t
  [@@ocaml.doc
    " Largest representable ofday; see notes above on how [start_of_next_day] behaves\n\
    \      differently from other ofday values. "]

  val approximate_end_of_day : t
  [@@ocaml.doc
    " A time very close to the end of a day. Not necessarily the largest representable\n\
    \      value before [start_of_next_day], but as close as possible such that using this\n\
    \      ofday with [Time.of_date_ofday] and [Time.to_date] should round-trip to the \
     same\n\
    \      date. With floating-point representations of time, this may not be possible for\n\
    \      dates extremely far from epoch.\n\n\
    \      The clock-face time represented by [approximate_end_of_day] may vary with \
     different\n\
    \      time and ofday representations, depending on their precision. "]

  val to_span_since_start_of_day : t -> Span.t
  [@@ocaml.doc
    " Note that these names are only really accurate on days without DST transitions. When\n\
    \      clocks move forward or back, [of_span_since_start_of_day_exn s] will not \
     necessarily\n\
    \      occur [s] after that day's midnight. "]

  val of_span_since_start_of_day_exn : Span.t -> t

  val of_span_since_start_of_day : Span.t -> t
  [@@deprecated "[since 2018-04] use [of_span_since_start_of_day_exn] instead"]

  val span_since_start_of_day_is_valid : Span.t -> bool
  [@@ocaml.doc
    " Reports whether a span represents a valid time since the start of the day, i.e.\n\
    \      whether [of_span_since_start_of_day_exn span] would succeed. "]

  val of_span_since_start_of_day_unchecked : Span.t -> t
  [@@ocaml.doc
    " [of_span_since_start_of_day_unchecked] does not validate that the [Span] represents\n\
    \      a valid [Ofday].\n\n\
    \      Behavior of other [Ofday] accessors is unspecified, but still safe (e.g., won't\n\
    \      segfault), if the input does not satisfy [span_since_start_of_day_is_valid]. "]

  val add : t -> Span.t -> t option
  [@@ocaml.doc
    " [add t s] shifts the time of day [t] by the span [s].  It returns [None] if the\n\
    \      result is not in the same 24-hour day. "]

  val sub : t -> Span.t -> t option

  val next : t -> t option
  [@@ocaml.doc " [next t] return the next [t] (next t > t) or None if [t] = end of day. "]

  val prev : t -> t option
  [@@ocaml.doc
    " [prev t] return the previous [t] (prev t < t) or None if [t] = start of day. "]

  val diff : t -> t -> Span.t
  [@@ocaml.doc
    " [diff t1 t2] returns the difference in time between two ofdays, as if they occurred\n\
    \      on the same 24-hour day. "]

  val small_diff : t -> t -> Span.t
  [@@ocaml.doc
    " Returns the time-span separating the two of-days, ignoring the hour information, and\n\
    \      assuming that the of-days represent times that are within a half-hour of each \
     other.\n\
    \      This is useful for comparing two ofdays in unknown time-zones. "]

  val to_string_trimmed : t -> string
  [@@ocaml.doc
    " Trailing groups of zeroes are trimmed such that the output is printed in terms of\n\
    \      the smallest non-zero units among nanoseconds, microseconds, milliseconds, or\n\
    \      seconds; or minutes if all of the above are zero. "]

  val to_sec_string : t -> string
  [@@ocaml.doc
    " HH:MM:SS, without any subsecond components. Seconds appear even if they are zero. "]

  val of_string_iso8601_extended : ?pos:int -> ?len:int -> string -> t
  [@@ocaml.doc
    " 24-hour times according to the ISO 8601 standard. This function can raise. "]

  val to_millisecond_string : t -> string [@@ocaml.doc " with milliseconds "]

  val to_millisec_string : t -> string
  [@@deprecated "[since 2018-04] use [to_millisecond_string] instead"]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
