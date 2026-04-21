[@@@ocaml.text
  " A specialized priority queue for a set of time-based alarms.\n\n\
  \    A timing wheel is a data structure that maintains a clock with the current time \
   and a\n\
  \    set of alarms scheduled to fire in the future.  One can add and remove alarms, and\n\
  \    advance the clock to cause alarms to fire.  There is nothing asynchronous about a\n\
  \    timing wheel.  Alarms only fire in response to an [advance_clock] call.\n\n\
  \    When one [create]s a timing wheel, one supplies an initial time, [start], and an\n\
  \    [alarm_precision].  The timing wheel breaks all time from the epoch onwards into\n\
  \    half-open intervals of size [alarm_precision], with the bottom half of each \
   interval\n\
  \    closed, and the top half open.  Alarms in the same interval fire in the same call \
   to\n\
  \    [advance_clock], as soon as [now t] is greater than all the times in the interval.\n\
  \    When an alarm [a] fires on a timing wheel [t], the implementation guarantees \
   that:\n\n\
  \    {[\n\
  \      Alarm.at a < now t\n\
  \    ]}\n\n\
  \    That is, alarms never fire early.  Furthermore, the implementation guarantees that\n\
  \    alarms don't go off too late.  More precisely, for all alarms [a] in [t]:\n\n\
  \    {[\n\
  \      interval_start t (Alarm.at a) >= interval_start t (now t)\n\
  \    ]}\n\n\
  \    This implies that for all alarms [a] in [t]:\n\n\
  \    {[\n\
  \      Alarm.at a > now t - alarm_precision t\n\
  \    ]}\n\n\
  \    Of course, an [advance_clock] call can advance the clock to an arbitrary time in \
   the\n\
  \    future, and thus alarms may fire at a clock time arbitrarily far beyond the time \
   for\n\
  \    which they were set.  But the implementation has no control over the times \
   supplied to\n\
  \    [advance_clock]; it can only guarantee that alarms will fire when [advance_clock] \
   is\n\
  \    called with a time at least [alarm_precision] greater than their scheduled time.\n\n\
  \    {2 Implementation}\n\n\
  \    A timing wheel is implemented using a specialized priority queue in which the\n\
  \    half-open intervals from the epoch onwards are numbered 0, 1, 2, etc.  Each time is\n\
  \    stored in the priority queue with the key of its interval number.  Thus all alarms\n\
  \    with a time in the same interval get the same key, and hence fire at the same\n\
  \    time. More specifically, an alarm is fired when the clock reaches or passes the \
   time\n\
  \    at the start of the next interval.\n\n\
  \    Alarms that fire in the same interval will fire in the order in which they were \
   added\n\
  \    to the timing wheel, rather than the time they were set to go off.  This is \
   consistent\n\
  \    with the guarantees of timing wheel mentioned above, but may nontheless be \
   surprising\n\
  \    to users.\n\n\
  \    The priority queue is implemented with an array of levels of decreasing precision,\n\
  \    with the lowest level having the most precision and storing the closest upcoming\n\
  \    alarms, while the highest level has the least precision and stores the alarms \
   farthest\n\
  \    in the future.  As time increases, the timing wheel does a lazy radix sort of the\n\
  \    alarm keys.\n\n\
  \    This implementation makes [add_alarm] and [remove_alarm] constant time, while\n\
  \    [advance_clock] takes time proportional to the amount of time the clock is \
   advanced.\n\
  \    With a sufficient number of alarms, this is more efficient than a log(N) heap\n\
  \    implementation of a priority queue.\n\n\
  \    {2 Representable times}\n\n\
  \    A timing wheel [t] can only handle a (typically large) bounded range of times as\n\
  \    determined by the current time, [now t], and the [level_bits] and [alarm_precision]\n\
  \    arguments supplied to [create].  Various functions raise if they are supplied a \
   time\n\
  \    smaller than [now t] or [> max_allowed_alarm_time t].  This situation likely \
   indicates\n\
  \    a misconfiguration of the [level_bits] and/or [alarm_precision].  Here is the \
   duration\n\
  \    of [max_allowed_alarm_time t - now t] using the default [level_bits].\n\n\
  \    {v\n\
  \      | # intervals | alarm_precision | duration |\n\
  \      +-------------+-----------------+----------|\n\
  \      |        2^61 | nanosecond      | 73 years |\n\
  \    v} "]

let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.set "ppx_inline_test_lib_1"

let () =
  Ppx_expect_runtime.Current_file.set
    ~filename_rel_to_project_root:"timing_wheel_intf.ml.before-ppx"
;;

let () =
  Ppx_inline_test_lib.set_lib_and_partition
    "ppx_inline_test_lib_1"
    "timing_wheel_intf.ml.before-ppx"
;;

open! Core
open! Import

module type Interval_num = sig
  module Span : sig
    type t = private Int63.t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparable.S with type t := t

    val max : t -> t -> t
    val zero : t
    val one : t
    val max_value : t
    val of_int63 : Int63.t -> t
    val to_int63 : t -> Int63.t
    val of_int : int -> t
    val to_int_exn : t -> int
    val scale_int : t -> int -> t
    val pred : t -> t
    val succ : t -> t
    val ( + ) : t -> t -> t
  end

  type t = private Int63.t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S with type t := t
  include Hashable.S with type t := t

  val max : t -> t -> t
  val min : t -> t -> t
  val zero : t
  val one : t
  val min_value : t
  val max_value : t
  val of_int63 : Int63.t -> t
  val to_int63 : t -> Int63.t
  val of_int : int -> t
  val to_int_exn : t -> int
  val add : t -> Span.t -> t
  val sub : t -> Span.t -> t
  val diff : t -> t -> Span.t
  val succ : t -> t
  val pred : t -> t
  val rem : t -> Span.t -> Span.t
end
[@@ocaml.doc
  " An [Interval_num.t] is an index of one of the intervals into which a timing-wheel\n\
  \    partitions time. "]

module type Alarm_precision = sig
  type t [@@deriving compare, sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S with type t := t

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Equal.S with type t := t

  val of_span : Time_ns.Span.t -> t
  [@@deprecated "[since 2018-01] Use [of_span_floor_pow2_ns]"]

  val of_span_floor_pow2_ns : Time_ns.Span.t -> t
  [@@ocaml.doc
    " [of_span_floor_pow2_ns span] returns the largest alarm precision less than or equal\n\
    \      to [span] that is a power of two number of nanoseconds. "]

  val to_span : t -> Time_ns.Span.t
  val one_nanosecond : t

  [@@@ocaml.text
    " Constants that are the closest power of two number of nanoseconds to the stated\n\
    \      span. "]

  val about_one_day : t [@@ocaml.doc " ~19.5 h  "]

  val about_one_microsecond : t [@@ocaml.doc " 1024 us "]

  val about_one_millisecond : t [@@ocaml.doc " ~1.05 ms "]

  val about_one_second : t [@@ocaml.doc " ~1.07 s  "]

  val mul : t -> pow2:int -> t
  [@@ocaml.doc
    " [mul t ~pow2] is [t * 2^pow2].  [pow2] may be negative, but [mul] does not check for\n\
    \      overflow or underflow. "]

  val div : t -> pow2:int -> t
  [@@ocaml.doc
    " [div t ~pow2] is [t / 2^pow2].  [pow2] may be negative, but [div] does not check\n\
    \      for overflow or underflow. "]

  module Unstable : sig
    type nonrec t = t [@@deriving bin_io, compare, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
  [@@ocaml.doc
    " The unstable bin and sexp format is that of [Time_ns.Span], with the caveat that\n\
    \      deserialization implicitly floors the time span to the nearest power of two\n\
    \      nanoseconds.  This ensures that the alarm precision that is used is at least as\n\
    \      precise than the alarm precision that is stated. "]
end
[@@ocaml.doc
  " An [Alarm_precision] is a time span that is a power of two number of nanoseconds, used\n\
  \    to specify the precision of a timing wheel. "]

module type Timing_wheel = sig
  module Alarm_precision : Alarm_precision

  type 'a t [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  type 'a timing_wheel = 'a t

  type 'a t_now = 'a t
  [@@ocaml.doc " [<:sexp_of< _ t_now >>] displays only [now t], not all the alarms. "]
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t_now : ('a -> Sexplib0.Sexp.t) -> 'a t_now -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  module Interval_num : Interval_num

  module Alarm : sig
    type 'a t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val null : unit -> _ t
    [@@ocaml.doc
      " [null ()] returns an alarm [t] such that [not (mem timing_wheel t)] for all\n\
      \        [timing_wheel]s. "]

    val at : 'a timing_wheel -> 'a t -> Time_ns.t
    [@@ocaml.doc
      " All [Alarm] functions will raise if [not (Timing_wheel.mem timing_wheel t)]. "]

    val interval_num : 'a timing_wheel -> 'a t -> Interval_num.t
    val value : 'a timing_wheel -> 'a t -> 'a
  end

  include Invariant.S1 with type 'a t := 'a t

  module Level_bits : sig
    type t
    [@@ocaml.doc
      " The timing-wheel implementation uses an array of \"levels\", where level [i] is an\n\
      \        array of length [2^b_i], where the [b_i] are the \"level bits\" specified \
       via\n\
      \        [Level_bits.create_exn [b_0, b_1; ...]].\n\n\
      \        A timing wheel can handle approximately [2 ** num_bits t] intervals/keys \
       beyond\n\
      \        the current minimum time/key, where [num_bits t = b_0 + b_1 + ...].\n\n\
      \        One can use a [Level_bits.t] to trade off run time and space usage of a \
       timing\n\
      \        wheel.  For a fixed [num_bits], as the number of levels increases, the \
       length of\n\
      \        the levels decreases and the timing wheel uses less space, but the \
       constant factor\n\
      \        for the running time of [add] and [increase_min_allowed_key] increases. "]
    [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Invariant.S with type t := t

    val max_num_bits : int
    [@@ocaml.doc
      " [max_num_bits] is how many bits in a key the timing wheel can use, i.e. 61.  We\n\
      \        subtract 3 for the bits in the word that we won't use:\n\n\
      \        - for the tag bit\n\
      \        - for negative numbers\n\
      \        - so we can do arithmetic around the bound without worrying about \
       overflow "]

    val create_exn
      :  ?extend_to_max_num_bits:(bool[@ocaml.doc " default is [false] "])
      -> int list
      -> t
    [@@ocaml.doc
      " In [create_exn bits], it is an error if any of the [b_i] in [bits] has [b_i <= 0],\n\
      \        or if the sum of the [b_i] in [bits] is greater than [max_num_bits].  With\n\
      \        [~extend_to_max_num_bits:true], the resulting [t] is extended with \
       sufficient [b_i\n\
      \        = 1] so that [num_bits t = max_num_bits]. "]

    val default : t
    [@@ocaml.doc
      " [default] returns the default value of [level_bits] used by [Timing_wheel.create]\n\
      \        and [Timing_wheel.Priority_queue.create].\n\n\
      \        {[\n\
      \          default = [11; 10; 10; 10; 10; 10]\n\
      \        ]}\n\n\
      \        This default uses 61 bits, i.e. [max_num_bits], and less than 10k words of\n\
      \        memory. "]

    val num_bits : t -> int [@@ocaml.doc " [num_bits t] is the sum of the [b_i] in [t]. "]
  end

  module Config : sig
    type t [@@deriving sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Invariant.S with type t := t

    val create
      :  ?capacity:(int[@ocaml.doc " default is [1] "])
      -> ?level_bits:Level_bits.t
      -> alarm_precision:Alarm_precision.t
      -> unit
      -> t
    [@@ocaml.doc " [create] raises if [alarm_precision <= 0]. "]

    val alarm_precision : t -> Time_ns.Span.t [@@ocaml.doc " accessors "]

    val level_bits : t -> Level_bits.t

    val durations : t -> Time_ns.Span.t list
    [@@ocaml.doc " [durations t] returns the durations of the levels in [t] "]

    val microsecond_precision : unit -> t
    [@@ocaml.doc
      " [microsecond_precision ()] returns a reasonable configuration for a timing wheel\n\
      \        with microsecond [alarm_precision], and level durations of 1ms, 1s, 1m, \
       1h, 1d.\n\
      \        See the relevant expect test in [Core_test] library. "]
  end

  val create : config:Config.t -> start:Time_ns.t -> 'a t
  [@@ocaml.doc
    " [create ~config ~start] creates a new timing wheel with current time [start].\n\
    \      [create] raises if [start < Time_ns.epoch].  For a fixed [level_bits], a \
     smaller\n\
    \      (i.e. more precise) [alarm_precision] decreases the representable range of\n\
    \      times/keys and increases the constant factor for [advance_clock]. "]

  val alarm_precision : _ t -> Time_ns.Span.t [@@ocaml.doc " Accessors "]

  val now : _ t -> Time_ns.t
  val start : _ t -> Time_ns.t

  [@@@ocaml.text
    " One can think of a timing wheel as a set of alarms.  Here are various container\n\
    \      functions along those lines. "]

  val is_empty : _ t -> bool
  val length : _ t -> int
  val iter : 'a t -> f:('a Alarm.t -> unit) -> unit

  val interval_num : _ t -> Time_ns.t -> Interval_num.t
  [@@ocaml.doc
    " [interval_num t time] returns the number of the interval that [time] is in, where\n\
    \      [0] is the interval that starts at [Time_ns.epoch].  [interval_num] raises if\n\
    \      [Time_ns.( < ) time Time_ns.epoch]. "]

  val now_interval_num : _ t -> Interval_num.t
  [@@ocaml.doc " [now_interval_num t = interval_num t (now t)]. "]

  val interval_num_start : _ t -> Interval_num.t -> Time_ns.t
  [@@ocaml.doc
    " [interval_num_start t n] is the start of the [n]'th interval in [t], i.e.\n\
    \      [n * alarm_precision t] after the epoch.\n\n\
    \      [interval_start t time] is the start of the half-open interval containing \
     [time],\n\
    \      i.e.:\n\n\
    \      {[\n\
    \        interval_num_start t (interval_num t time)\n\
    \      ]} "]

  val interval_start : _ t -> Time_ns.t -> Time_ns.t
  [@@ocaml.doc " [interval_start] raises in the same cases that [interval_num] does. "]

  val advance_clock : 'a t -> to_:Time_ns.t -> handle_fired:('a Alarm.t -> unit) -> unit
  [@@ocaml.doc
    " [advance_clock t ~to_ ~handle_fired] advances [t]'s clock to [to_].  It fires and\n\
    \      removes all alarms [a] in [t] with [Time_ns.(<) (Alarm.at t a) \
     (interval_start t\n\
    \      to_)], applying [handle_fired] to each such [a].\n\n\
    \      If [to_ <= now t], then [advance_clock] does nothing.\n\n\
    \      [advance_clock] fails if [to_] is too far in the future to represent.\n\n\
    \      Behavior is unspecified if [handle_fired] accesses [t] in any way other than\n\
    \      [Alarm] functions. "]

  val advance_clock_stop_at_next_alarm
    :  'a t
    -> to_:Time_ns.t
    -> handle_fired:('a Alarm.t -> unit)
    -> unit
  [@@ocaml.doc
    " Advance to the time [to_] or the time of the next alarm, whichever is earlier.\n\
    \      This function should be functionally equivalent to\n\
    \      [advance_clock t ~to_:(Time.min to_ (min_alarm_time_in_min_interval t))],\n\
    \      with potentially better performance.\n\n\
    \      [handle_fired] may still fire multiple times, if there are multiple alarms \
     scheduled\n\
    \      at the same time. "]

  val fire_past_alarms : 'a t -> handle_fired:('a Alarm.t -> unit) -> unit
  [@@ocaml.doc
    " [fire_past_alarms t ~handle_fired] fires and removes all alarms [a] in [t] with\n\
    \      [Time_ns.( <= ) (Alarm.at t a) (now t)], applying [handle_fired] to each such \
     [a].\n\n\
    \      [fire_past_alarms] visits all alarms in interval [now_interval_num], to check \
     their\n\
    \      [Alarm.at].\n\n\
    \      Behavior is unspecified if [handle_fired] accesses [t] in any way other than\n\
    \      [Alarm] functions. "]

  val max_allowed_alarm_time : _ t -> Time_ns.t
  [@@ocaml.doc
    " [max_allowed_alarm_time t] returns the greatest [at] that can be supplied to [add].\n\
    \      [max_allowed_alarm_time] is not constant; its value increases as [now t]\n\
    \      increases. "]

  val min_allowed_alarm_interval_num : _ t -> Interval_num.t
  [@@ocaml.doc " [min_allowed_alarm_interval_num t = now_interval_num t] "]

  val max_allowed_alarm_interval_num : _ t -> Interval_num.t
  [@@ocaml.doc
    " [max_allowed_alarm_interval_num t = interval_num t (max_allowed_alarm_time t)] "]

  val add : 'a t -> at:Time_ns.t -> 'a -> 'a Alarm.t
  [@@ocaml.doc
    " [add t ~at a] adds a new value [a] to [t] and returns an alarm that can later be\n\
    \      supplied to [remove] the alarm from [t].  [add] raises if [interval_num t at <\n\
    \      now_interval_num t || at > max_allowed_alarm_time t]. "]

  val add_at_interval_num : 'a t -> at:Interval_num.t -> 'a -> 'a Alarm.t
  [@@ocaml.doc
    " [add_at_interval_num t ~at a] is equivalent to [add t ~at:(interval_num_start t at)\n\
    \      a]. "]

  val mem : 'a t -> 'a Alarm.t -> bool

  val remove : 'a t -> 'a Alarm.t -> unit
  [@@ocaml.doc
    " [remove t alarm] removes [alarm] from [t].  [remove] raises if [not (mem t\n\
    \      alarm)]. "]

  val reschedule : 'a t -> 'a Alarm.t -> at:Time_ns.t -> unit
  [@@ocaml.doc
    " [reschedule t alarm ~at] mutates [alarm] so that it will fire at [at], i.e. so that\n\
    \      [Alarm.at t alarm = at].  [reschedule] raises if [not (mem t alarm)] or if \
     [at] is\n\
    \      an invalid time for [t], in the same situations that [add] raises. "]

  val reschedule_at_interval_num : 'a t -> 'a Alarm.t -> at:Interval_num.t -> unit
  [@@ocaml.doc
    " [reschedule_at_interval_num t alarm ~at] is equivalent to:\n\
    \      {[\n\
    \        reschedule t alarm ~at:(interval_num_start t at)\n\
    \      ]} "]

  val clear : _ t -> unit [@@ocaml.doc " [clear t] removes all alarms from [t]. "]

  val min_alarm_interval_num : _ t -> Interval_num.t option
  [@@ocaml.doc
    " [min_alarm_interval_num t] is the minimum [Alarm.interval_num] of all alarms in\n\
    \      [t]. "]

  val min_alarm_interval_num_exn : _ t -> Interval_num.t
  [@@ocaml.doc
    " [min_alarm_interval_num_exn t] is like [min_alarm_interval_num], except it raises if\n\
    \      [is_empty t]. "]

  val max_alarm_time_in_min_interval : 'a t -> Time_ns.t option
  [@@ocaml.doc
    " [max_alarm_time_in_min_interval t] returns the maximum [Alarm.at] over all alarms in\n\
    \      [t] whose [Alarm.interval_num] is [min_alarm_interval_num t].  This function is\n\
    \      useful for advancing to the [min_alarm_interval_num] of a timing wheel and then\n\
    \      calling [fire_past_alarms] to fire the alarms in that interval.  That is \
     useful when\n\
    \      simulating time, to ensure that alarms are processed in order. "]

  val min_alarm_time_in_min_interval : 'a t -> Time_ns.t option
  [@@ocaml.doc
    " [min_alarm_time_in_min_interval t] returns the minimum [Alarm.at] over all alarms in\n\
    \      [t].  This function is useful for advancing to the exact time when the next \
     alarm\n\
    \      is scheduled to fire. "]

  val max_alarm_time_in_min_interval_exn : 'a t -> Time_ns.t
  [@@ocaml.doc
    " [max_alarm_time_in_min_interval_exn t] is like [max_alarm_time_in_min_interval],\n\
    \      except that it raises if [is_empty t]. "]

  val min_alarm_time_in_min_interval_exn : 'a t -> Time_ns.t
  [@@ocaml.doc
    " [min_alarm_time_in_min_interval_exn t] is like [min_alarm_time_in_min_interval],\n\
    \      except that it raises if [is_empty t]. "]

  val next_alarm_fires_at : _ t -> Time_ns.t option
  [@@ocaml.doc
    " The name of this function is misleading: it does not take into account events that\n\
    \      can fire due to [fire_past_alarms].\n\n\
    \      [next_alarm_fires_at t] returns the minimum time to which the clock can be \
     advanced\n\
    \      such that an alarm will be fired by [advance_clock], or [None] if [t] has no \
     alarms\n\
    \      (or all alarms are in the max interval, and hence cannot fire by \
     [advance_clock]).\n\
    \      If [next_alarm_fires_at t = Some next], then for the minimum alarm time [min] \
     that\n\
    \      occurs in [t], it is guaranteed that: [next - alarm_precision t <= min < next].\n\
    \  "]

  val next_alarm_fires_at_exn : _ t -> Time_ns.t
  [@@ocaml.doc
    " [next_alarm_fires_at_exn] is like [next_alarm_fires_at], except that it raises if\n\
    \      [is_empty t]. "]

  module Private : sig
    val max_time : Time_ns.t

    val interval_num_internal
      :  time:Time_ns.t
      -> alarm_precision:Alarm_precision.t
      -> Interval_num.t

    module Num_key_bits : sig
      type t

      include Invariant.S with type t := t

      val zero : t
    end
  end
end
[@@ocaml.doc " A timing wheel can be thought of as a set of alarms. "]

let () = Ppx_inline_test_lib.unset_lib "ppx_inline_test_lib_1"
let () = Ppx_expect_runtime.Current_file.unset ()
let () = Ppx_bench_lib.Benchmark_accumulator.Current_libname.unset ()
