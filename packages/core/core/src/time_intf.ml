let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"time_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "time_intf.ml.before-ppx"
;;

open! Import
open! Std_internal
module Date = Date0

module type Zone = sig
  module Time : Time0_intf.S
  include Zone.S with type t = Zone.t and module Time_in_seconds := Time

  val abbreviation : t -> Time.t -> string
  [@@ocaml.doc
    " [abbreviation t time] returns the abbreviation name (such as EDT, EST, JST) of given\n\
    \      zone [t] at [time]. This string conversion is one-way only, and cannot \
     reliably be\n\
    \      turned back into a [t]. This function reads and writes the zone's cached \
     index. "]

  val absolute_time_of_date_and_ofday : t -> Time.Date_and_ofday.t -> Time.t
  [@@ocaml.doc
    " [absolute_time_of_date_and_ofday] and [date_and_ofday_of_absolute_time] convert\n\
    \      between absolute times and date + ofday forms. These are low level functions \
     not\n\
    \      intended for most clients. These functions read and write the zone's cached \
     index.\n\
    \  "]

  val date_and_ofday_of_absolute_time : t -> Time.t -> Time.Date_and_ofday.t

  val next_clock_shift : t -> strictly_after:Time.t -> (Time.t * Time.Span.t) option
  [@@ocaml.doc
    " Takes a [Time.t] and returns the next [Time.t] strictly after it, if any, that the\n\
    \      time zone UTC offset changes, and by how much it does so. "]

  val prev_clock_shift : t -> at_or_before:Time.t -> (Time.t * Time.Span.t) option
  [@@ocaml.doc " As [next_clock_shift], but *at or before* the given time. "]
end

module type Basic = sig
  module Time : Time0_intf.S

  include module type of struct
    include Time
  end [@ocaml.remove_aliases]

  val now : unit -> t
  [@@ocaml.doc " [now ()] returns a [t] representing the current time "]

  module Zone : Zone with module Time := Time

  [@@@ocaml.text " {6 Basic operations on times} "]

  val add : t -> Span.t -> t
  [@@ocaml.doc
    " [add t s] adds the span [s] to time [t] and returns the resulting time.\n\n\
    \      NOTE: adding spans as a means of adding days is not accurate, and may run \
     into trouble\n\
    \      due to shifts in daylight savings time, float arithmetic issues, and leap \
     seconds.\n\
    \      See the comment at the top of Zone.mli for a more complete discussion of some \
     of\n\
    \      the issues of time-keeping.  For spans that cross date boundaries, use date \
     functions\n\
    \      instead.\n\
    \  "]

  val sub : t -> Span.t -> t
  [@@ocaml.doc
    " [sub t s] subtracts the span [s] from time [t] and returns the\n\
    \      resulting time.  See important note for [add]. "]

  val diff : t -> t -> Span.t
  [@@ocaml.doc " [diff t1 t2] returns time [t1] minus time [t2]. "]

  val abs_diff : t -> t -> Span.t
  [@@ocaml.doc
    " [abs_diff t1 t2] returns the absolute span of time [t1] minus time [t2]. "]
end

module type Shared = sig
  type t

  include Quickcheck.S_range with type t := t

  module Span : sig
    type t
  end

  module Ofday : sig
    type t
  end

  [@@@ocaml.text " {6 Comparisons} "]

  val is_earlier : t -> than:t -> bool
  val is_later : t -> than:t -> bool

  [@@@ocaml.text " {6 Conversions} "]

  val of_date_ofday : zone:Zone.t -> Date.t -> Ofday.t -> t

  val of_date_ofday_precise
    :  Date.t
    -> Ofday.t
    -> zone:Zone.t
    -> [ `Once of t | `Twice of t * t | `Never of t ]
  [@@ocaml.doc
    " Because timezone offsets change throughout the year (clocks go forward or back) some\n\
    \      local times can occur twice or not at all.  In the case that they occur \
     twice, this\n\
    \      function gives [`Twice] with both occurrences in order; if they do not occur \
     at all,\n\
    \      this function gives [`Never] with the time at which the local clock skips \
     over the\n\
    \      desired time of day.\n\n\
    \      Note that this is really only intended to work with DST transitions and not \
     unusual or\n\
    \      dramatic changes, like the calendar change in 1752 (run \"cal 9 1752\" in a \
     shell to\n\
    \      see).  In particular it makes the assumption that midnight of each day is \
     unambiguous.\n\n\
    \      Most callers should use {!of_date_ofday} rather than this function.  In the \
     [`Twice]\n\
    \      and [`Never] cases, {!of_date_ofday} will return reasonable times for most \
     uses. "]

  val to_date_ofday : t -> zone:Zone.t -> Date.t * Ofday.t

  val to_date_ofday_precise
    :  t
    -> zone:Zone.t
    -> Date.t * Ofday.t * [ `Only | `Also_at of t | `Also_skipped of Date.t * Ofday.t ]
  [@@ocaml.doc
    " Always returns the [Date.t * Ofday.t] that [to_date_ofday] would have returned, \
     and in\n\
    \      addition returns a variant indicating whether the time is associated with a \
     time zone\n\
    \      transition.\n\n\
    \      {v\n\
    \      - `Only         -> there is a one-to-one mapping between [t]'s and\n\
    \                         [Date.t * Ofday.t] pairs\n\
    \      - `Also_at      -> there is another [t] that maps to the same [Date.t * \
     Ofday.t]\n\
    \                         (this date/time pair happened twice because the clock fell \
     back)\n\
    \      - `Also_skipped -> there is another [Date.t * Ofday.t] pair that never \
     happened (due\n\
    \                         to a jump forward) that [of_date_ofday] would map to the \
     same\n\
    \                         [t].\n\
    \    v}\n\
    \  "]

  val to_date : t -> zone:Zone.t -> Date.t
  val to_ofday : t -> zone:Zone.t -> Ofday.t

  val reset_date_cache : unit -> unit
  [@@ocaml.doc
    " For performance testing only; [reset_date_cache ()] resets an internal cache used to\n\
    \      speed up [to_date] and related functions when called repeatedly on times that \
     fall\n\
    \      within the same day. "]

  [@@@ocaml.text
    " Unlike [Time_ns], this module purposely omits [max_value] and [min_value]:\n\
    \      1. They produce unintuitive corner cases because most people's mental models \
     of time\n\
    \      do not include +/- infinity as concrete values\n\
    \      2. In practice, when people ask for these values, it is for questionable \
     uses, e.g.,\n\
    \      as null values to use in place of explicit options. "]

  val epoch : t [@@ocaml.doc " midnight, Jan 1, 1970 in UTC "]

  val convert : from_tz:Zone.t -> to_tz:Zone.t -> Date.t -> Ofday.t -> Date.t * Ofday.t
  [@@ocaml.doc
    " It's unspecified what happens if the given date/ofday/zone correspond to more than\n\
    \      one date/ofday pair in the other zone. "]

  val utc_offset : t -> zone:Zone.t -> Span.t

  [@@@ocaml.text " {6 Other string conversions}  "]

  include
    Stringable with type t := t
  [@@ocaml.doc
    " The [{to,of}_string] functions in [Time] convert to UTC time, because a local time\n\
    \      zone is not necessarily available.  They are generous in what they will read \
     in. "]

  val to_filename_string : t -> zone:Zone.t -> string
  [@@ocaml.doc
    " [to_filename_string t ~zone] converts [t] to string with format\n\
    \      YYYY-MM-DD_HH-MM-SS.mmm which is suitable for using in filenames. "]

  val of_filename_string : string -> zone:Zone.t -> t
  [@@ocaml.doc
    " [of_filename_string s ~zone] converts [s] that has format YYYY-MM-DD_HH-MM-SS.mmm \
     into\n\
    \      time. "]

  val to_string_abs : t -> zone:Zone.t -> string
  [@@ocaml.doc
    " [to_string_abs ~zone t] is the same as [to_string t] except that it uses the given\n\
    \      time zone. "]

  val to_string_abs_trimmed : t -> zone:Zone.t -> string
  [@@ocaml.doc
    " [to_string_abs_trimmed] is the same as [to_string_abs], but drops trailing seconds\n\
    \      and milliseconds if they are 0. "]

  val to_string_abs_parts : t -> zone:Zone.t -> string list

  val to_string_trimmed : t -> zone:Zone.t -> string
  [@@ocaml.doc
    " Same as [to_string_abs_trimmed], except it leaves off the timezone, so won't\n\
    \      reliably round trip. "]

  val to_sec_string : t -> zone:Zone.t -> string
  [@@ocaml.doc
    " Same as [to_string_abs], but without milliseconds and the timezone. May raise if\n\
    \      [zone] offsets move the apparent value beyond [min_value_representable] and\n\
    \      [max_value_representable]. "]

  val to_sec_string_with_zone : t -> zone:Zone.t -> string
  [@@ocaml.doc " Same as [to_sec_string] but includes timezone "]

  val of_localized_string : zone:Zone.t -> string -> t
  [@@ocaml.doc
    " [of_localized_string ~zone str] read in the given string assuming that it represents\n\
    \      a time in zone and return the appropriate Time.t "]

  val of_string_gen
    :  default_zone:(unit -> Zone.t)
    -> find_zone:(string -> Zone.t)
    -> string
    -> t
  [@@ocaml.doc
    " [of_string_gen ~default_zone ~find_zone s] attempts to parse [s] as a [t], calling\n\
    \      out to [default_zone] and [find_zone] as needed. "]

  val to_string_iso8601_basic : t -> zone:Zone.t -> string
  [@@ocaml.doc
    " [to_string_iso8601_basic] return a string representation of the following form:\n\
    \      %Y-%m-%dT%H:%M:%S.%s%Z\n\
    \      e.g.\n\
    \      [ to_string_iso8601_basic ~zone:Time.Zone.utc epoch = \
     \"1970-01-01T00:00:00.000000Z\" ]\n\
    \  "]

  val occurrence
    :  [ `First_after_or_at | `Last_before_or_at ]
    -> t
    -> ofday:Ofday.t
    -> zone:Zone.t
    -> t
  [@@ocaml.doc
    " [occurrence side time ~ofday ~zone] returns a [Time.t] that is the occurrence of\n\
    \      ofday (in the given [zone]) that is the latest occurrence (<=) [time] or the\n\
    \      earliest occurrence (>=) [time], according to [side].\n\n\
    \      NOTE: If the given time converted to wall clock time in the given zone is \
     equal to\n\
    \      ofday then the t returned will be equal to the t given.\n\
    \  "]
end

module type S = sig
  include Basic
  include Shared with type t := t with module Span := Span with module Ofday := Ofday

  val of_string : string -> t
  [@@deprecated
    "[since 2021-04] Use [of_string_with_utc_offset] or [Time_float_unix.of_string]"]

  val of_string_with_utc_offset : string -> t
  [@@ocaml.doc
    " [of_string_with_utc_offset] requires its input to have an explicit\n\
    \      UTC offset, e.g. [2000-01-01 12:34:56.789012-23], or use the UTC zone, \"Z\",\n\
    \      e.g. [2000-01-01 12:34:56.789012Z]. "]

  val to_string : t -> string
  [@@deprecated "[since 2021-04] Use [to_string_utc] or [Time_float_unix.to_string]"]

  val to_string_utc : t -> string
  [@@ocaml.doc
    " [to_string_utc] generates a time string with the UTC zone, \"Z\", e.g. [2000-01-01\n\
    \      12:34:56.789012Z]. "]
end

module type Time = sig
  module type S = S

  module Make : functor (Time : Time0_intf.S) -> S with module Time := Time
end

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
