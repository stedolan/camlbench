let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"span_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "span_intf.ml.before-ppx"
;;

open! Import
open Std_internal

module type Parts = sig
  type t = private
    { sign : Sign.t
    ; hr : int
    ; min : int
    ; sec : int
    ; ms : int
    ; us : int
    ; ns : int
    }
  [@@deriving compare, sexp, sexp_grammar]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end
[@@ocaml.doc
  " Parts represents the individual parts of a Span as if it were written out (it is the\n\
  \    counterpart to [Span.create]). For example, 90 seconds is represented by:\n\n\
  \    {[\n\
  \      {sign = Pos; hr = 0; min = 1; sec = 30; ms = 0; ns = 0}\n\
  \    ]}\n\n\
  \    The fields will always be non-negative, and will never be large enough to form the\n\
  \    next larger unit (e.g., [min < 60]). "]

module type S = sig
  type underlying
  [@@ocaml.doc
    " Span.t represents a span of time (e.g. 7 minutes, 3 hours, 12.8 days).  The span\n\
    \      may be positive or negative. "]

  type t = private underlying [@@deriving bin_io, hash, sexp, sexp_grammar, typerep]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

    include Typerep_lib.Typerepable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Parts : Parts
  include Comparable_binable with type t := t
  include Comparable.With_zero with type t := t
  include Hashable_binable with type t := t
  include Diffable.S_atomic with type t := t
  include Pretty_printer.S with type t := t
  include Robustly_comparable with type t := t
  include Quickcheck.S_range with type t := t

  val to_string : t -> string
  [@@ocaml.doc
    " Time spans are denominated as a float suffixed by a unit of time; the valid suffixes\n\
    \      are listed below:\n\n\
    \      d  - days\n\
    \      h  - hours\n\
    \      m  - minutes\n\
    \      s  - seconds\n\
    \      ms - milliseconds\n\
    \      us - microseconds\n\
    \      ns - nanoseconds\n\n\
    \      [to_string] and [sexp_of_t] use a mixed-unit format, which breaks the input \
     span\n\
    \      into parts and concatenates them in descending order of unit size. For \
     example, pi\n\
    \      days is rendered as \"3d3h23m53.60527015815s\". If the span is negative, a \
     single \"-\"\n\
    \      precedes the entire string. For extremely large (>10^15 days) or small (<1us) \
     spans,\n\
    \      a unit may be repeated to ensure the string conversion round-trips.\n\n\
    \      [of_string] and [t_of_sexp] accept any combination of (nonnegative float\n\
    \      string)(unit of time suffix) in any order, without spaces, and sums up the \
     durations\n\
    \      of each of the parts for the magnitude of the span. The input may be prefixed \
     by \"-\"\n\
    \      for negative spans.\n\n\
    \      String and sexp conversions round-trip precisely, that is:\n\n\
    \      {[ Span.of_string (Span.to_string t) = t ]}\n\
    \  "]

  val of_string : string -> t

  [@@@ocaml.text " {6 values} "]

  val nanosecond : t
  val microsecond : t
  val millisecond : t
  val second : t
  val minute : t
  val hour : t
  val day : t

  val robust_comparison_tolerance : t
  [@@ocaml.doc
    " 10^-6 seconds, used in robustly comparable operators (<., >., =., ...) to determine\n\
    \      equality "]

  val zero : t

  val create
    :  ?sign:Sign.t
    -> ?day:int
    -> ?hr:int
    -> ?min:int
    -> ?sec:int
    -> ?ms:int
    -> ?us:int
    -> ?ns:int
    -> unit
    -> t
  [@@ocaml.doc
    " [?sign] defaults to positive. Setting it to negative is equivalent to negating all\n\
    \      the integers. "]

  val to_parts : t -> Parts.t

  [@@@ocaml.text " {6 converters} "]

  [@@@ocaml.text " conversions to and from [float] "]

  val of_ns : float -> t
  val of_us : float -> t
  val of_ms : float -> t
  val of_sec : float -> t
  val of_min : float -> t
  val of_hr : float -> t
  val of_day : float -> t
  val to_ns : t -> float
  val to_us : t -> float
  val to_ms : t -> float
  val to_sec : t -> float
  val to_min : t -> float
  val to_hr : t -> float
  val to_day : t -> float

  [@@@ocaml.text " conversions from [int] "]

  val of_int_ns : int -> t
  val of_int_us : int -> t
  val of_int_ms : int -> t
  val of_int_sec : int -> t
  val of_int_min : int -> t
  val of_int_hr : int -> t
  val of_int_day : int -> t

  [@@@ocaml.text " conversions from other size integer types for seconds "]

  val of_int32_seconds : Int32.t -> t
  val of_int63_seconds : Int63.t -> t

  val to_int63_seconds_round_down_exn : t -> Int63.t
  [@@ocaml.doc
    " [to_int63_seconds_round_down_exn t] returns the number of seconds represented by\n\
    \      [t], rounded down, raising if the result is not representable as an \
     [Int63.t]. "]

  val to_proportional_float : t -> float
  [@@ocaml.doc
    " The only condition [to_proportional_float] is supposed to satisfy is that for all\n\
    \      [t1, t2 : t]: [to_proportional_float t1 /. to_proportional_float t2 = t1 // \
     t2]. "]

  [@@@ocaml.text
    " {6 Basic operations on spans}\n\n\
    \      The arithmetic operations rely on the behavior of the underlying \
     representation of a\n\
    \      span. For example, if addition overflows with float-represented spans, the \
     result is\n\
    \      an infinite span; with fixed-width integer-represented spans, the result \
     silently\n\
    \      wraps around as in two's-complement arithmetic. "]

  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t

  val abs : t -> t [@@ocaml.doc " absolute value "]

  val neg : t -> t [@@ocaml.doc " negation "]

  val scale : t -> float -> t
  val ( / ) : t -> float -> t
  val ( // ) : t -> t -> float

  val next : t -> t
  [@@ocaml.doc
    " [next t] is the smallest representable span greater than [t] (and therefore\n\
    \      representation-dependent) "]

  val prev : t -> t
  [@@ocaml.doc
    " [prev t] is the largest representable span less than [t] (and therefore\n\
    \      representation-dependent) "]

  val to_short_string : t -> string
  [@@ocaml.doc
    " [to_short_string t] pretty-prints approximate time span using no more than\n\
    \      five characters if the span is positive, and six if the span is negative.\n\
    \      Examples\n\
    \      {ul\n\
    \      {li [\"4h\"] = 4 hours}\n\
    \      {li [\"5m\"] = 5 minutes}\n\
    \      {li [\"4s\"] = 4 seconds}\n\
    \      {li [\"10ms\"] = 10 milliseconds}\n\
    \      }\n\n\
    \      only the most significant denomination is shown.\n\
    \  "]

  val to_unit_of_time : t -> Unit_of_time.t
  [@@ocaml.doc
    " [to_unit_of_time t] = [Day] if [abs t >= day], [Hour] if [abs t >= hour], and so on\n\
    \      down to [Microsecond] if [abs t >= microsecond], and [Nanosecond] otherwise. "]

  val of_unit_of_time : Unit_of_time.t -> t
  [@@ocaml.doc
    " [of_unit_of_time unit_of_time] produces a [t] representing the corresponding span. "]

  val to_string_hum
    :  ?delimiter:(char[@ocaml.doc " defaults to ['_'] "])
    -> ?decimals:(int[@ocaml.doc " defaults to 3 "])
    -> ?align_decimal:(bool[@ocaml.doc " defaults to [false] "])
    -> ?unit_of_time:(Unit_of_time.t[@ocaml.doc " defaults to [to_unit_of_time t] "])
    -> t
    -> string
  [@@ocaml.doc
    " [to_string_hum t ~delimiter ~decimals ~align_decimal ~unit_of_time] formats [t] \
     using\n\
    \      the given unit of time, or the largest appropriate units if none is \
     specified, among\n\
    \      \"d\"=day, \"h\"=hour, \"m\"=minute, \"s\"=second, \"ms\"=millisecond, \
     \"us\"=microsecond, or\n\
    \      \"ns\"=nanosecond.  The magnitude of the time span in the chosen unit is \
     formatted by:\n\n\
    \      [Float.to_string_hum ~delimiter ~decimals ~strip_zero:(not align_decimal)]\n\n\
    \      If [align_decimal] is true, the single-character suffixes are padded with an \
     extra\n\
    \      space character.  In combination with not stripping zeroes, this means that the\n\
    \      decimal point will occur a fixed number of characters from the end of the \
     string. "]

  val randomize : ?state:Random.State.t -> t -> percent:Percent.t -> t
  [@@ocaml.doc
    " [randomize t ~percent] returns a span +/- percent * original span.  Percent must be\n\
    \      between 0% and 100% inclusive, and must be positive. "]
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
