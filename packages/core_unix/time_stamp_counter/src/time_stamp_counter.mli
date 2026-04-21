[@@@ocaml.text
  " High-performance timing.\n\n\
  \    This module provides the fast function [now ()] which is our best effort\n\
  \    high-performance cycle counter for a given platform.  For x86 systems this \
   retrieves\n\
  \    the CPU's internal time stamp counter using the RDTSC instruction.  For systems \
   that\n\
  \    do not have a RDTSC instruction, we fallback to using\n\
  \    [clock_gettime(CLOCK_MONOTONIC)].\n\n\
  \    Here is a benchmark of execution time in nanos and allocations in words:\n\n\
  \    {v\n\
  \      Name                         Time/Run   mWd/Run\n\
  \     ---------------------------- ---------- ---------\n\
  \      Time.now                      27.99ns     2.00w\n\
  \      Time_ns.now                   25.21ns\n\
  \      TSC.Calibrator.calibrate      68.61ns\n\
  \      TSC.now                        6.87ns\n\
  \      TSC.to_time                    4.30ns     2.00w\n\
  \      TSC.to_time (TSC.now ())       8.75ns     2.00w\n\
  \      TSC.to_time_ns                 4.70ns\n\
  \      TSC.to_time_ns(TSC.now ())     9.56ns\n\
  \      id                             2.86ns\n\
  \      TSC.Span.of_ns                11.66ns\n\
  \      TSC.Span.to_ns                 3.84ns\n\
  \    v}\n\n\
  \    Type [t] is an [Int63.t] and consequently has no allocation overhead (on 64-bit\n\
  \    machines), unlike [Time.now ()] which returns a boxed float.\n\n\
  \    Functions are also provided to estimate the relationship of CPU time-stamp-counter\n\
  \    frequency to real time, thereby allowing one to convert from [t] to [Time.t].  \
   There\n\
  \    are some caveats to this that are worth noting:\n\n\
  \    - The conversion to [Time.t] depends on an estimate of the time-stamp-counter\n\
  \      frequency.  This frequency may be volatile on some systems, thereby reducing the\n\
  \      utility of this conversion.  See the [Calibrator] module below for details.\n\n\
  \    - The captured [t] can only be converted to a [Time.t] if one also has a\n\
  \      recently calibrated [Calibrator.t] from the same machine.\n\n\
  \    - Put another way, it would not make sense to send a sexp of [t] from one box to\n\
  \      another and then convert it to a [Time.t], because [t] counts the number of \
   cycles\n\
  \      since reset. So the measure only makes sense in the context of a single \
   machine.\n\n\
  \    - Note that a cursory search for information about time stamp counter usage may \
   give a\n\
  \      false impression of its unreliability. Early processor implementations of TSC \
   could\n\
  \      be skewed by clock frequency changes (C-states) and by small differences \
   between the\n\
  \      startup time of each processor on a multi-processor machine. Modern hardware can\n\
  \      usually be assumed to have an \"invariant\" tsc, and Linux has support to \
   synchronize\n\
  \      the initial counters at boot time when multiple processors are present.\n\n\
  \    See also: {:http://en.wikipedia.org/wiki/Time_Stamp_Counter}\n"]

open! Core
open! Import

type t = private Int63.t [@@deriving bin_io, compare, sexp, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
  include Ppx_compare_lib.Comparable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t
  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Comparisons.S with type t := t

module Calibrator : sig
    type tsc
    type t [@@deriving bin_io, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create : unit -> t
    [@@ocaml.doc
      " [create ()] creates an uninitialized calibrator instance.  Creating a calibrator\n\
      \      takes about 3ms.  One needs a recently calibrated [Calibrator.t] and the \
       TSC value\n\
      \      from the same machine to meaningfully convert the TSC value to a [Time.t]. "]

    val calibrate : t -> unit
    [@@ocaml.doc
      " [calibrate t] updates [t] by measuring the current value of the TSC and\n\
      \      [Time.now]. "]

    val cpu_mhz : (t -> float) Or_error.t
    [@@ocaml.doc
      " Returns the estimated MHz of the CPU's time-stamp-counter based on the TSC and\n\
      \      [Time.now ()].  This function is undefined on 32-bit machines. "]

    [@@@ocaml.text "/*"]

    module Private : sig
      val create_using : tsc:tsc -> time:float -> samples:(tsc * float) list -> t
      val calibrate_using : t -> tsc:tsc -> time:float -> am_initializing:bool -> unit
      val initialize : t -> (tsc * float) list -> unit
      val nanos_per_cycle : t -> float
    end
  end
  with type tsc := t
[@@ocaml.doc
  " A calibrator contains a snapshot of machine-specific information that is used to\n\
  \    convert between TSC values and clock time.  This information needs to be calibrated\n\
  \    periodically such that it stays updated w.r.t. changes in the CPU's \
   time-stamp-counter\n\
  \    frequency, which can vary depending on load, heat, etc.  (Also see the comment in \
   the\n\
  \    [.ml] file.)\n\n\
  \    Calibration at the rate of 0.1, 1 or 2 secs produces errors (measured as the\n\
  \    difference between [Time.now] and the reported time here) on the order of 1-2us.\n\
  \    Given the precision of 52-bit float mantissa values, this is very close to the \
   least\n\
  \    error one can have on these values.  Calibration once per 10sec produces errors \
   that\n\
  \    are +/-4us. Calibration once per minute produces errors that are +/-15us and\n\
  \    calibration once in 3mins produces errors +/-30us.  (It is worth remarking that the\n\
  \    error has a positive bias of 1us -- i.e., the error dances around the 1us mark, \
   rather\n\
  \    than around 0. It is unclear where this bias is introduced, though it probably does\n\
  \    not matter for most applications.)\n\n\
  \    This module maintains an instance of [t] internal to the module.  The internal\n\
  \    instance of [t] can be updated via calls to [calibrate ()], i.e., without \
   specifying\n\
  \    the [t] parameter.  In all the functions below that take an optional [Calibrator.t]\n\
  \    argument, the internal instance is used when no calibrator is explicitly specified.\n"]

module Span : sig
  type t = private Int63.t [@@deriving bin_io, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable with type t := t
  include Intable with type t := t

  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val zero : t
  val to_ns : t -> calibrator:Calibrator.t -> Int63.t
  val of_ns : Int63.t -> calibrator:Calibrator.t -> t
  val to_time_ns_span : t -> calibrator:Calibrator.t -> Time_ns.Span.t
  val of_time_ns_span : Time_ns.Span.t -> calibrator:Calibrator.t -> t

  [@@@ocaml.text "/*"]

  module Private : sig
    val of_int63 : Int63.t -> t
    val to_int63 : t -> Int63.t
  end
end
[@@ocaml.doc " [Span] indicates some integer number of cycles. "]

val now : unit -> t
val diff : t -> t -> Span.t
val add : t -> Span.t -> t
val to_int63 : t -> Int63.t
val zero : t

val calibrator : Calibrator.t Lazy.t
[@@ocaml.doc
  " A default calibrator for the current process. Most programs can just use this\n\
  \    calibrator; use others if collecting data from other processes / machines.\n\n\
  \    The first time this lazy value is forced, it spends approximately 3ms \
   calibrating.\n\n\
  \    While the [Async] scheduler is running, this value is recalibrated regularly.\n\
  \    IF NOT USING THE ASYNC SCHEDULER, you must have some other means of making\n\
  \    sure recalibration occurs.\n"]

val to_time : t -> calibrator:Calibrator.t -> Time_float.t
[@@ocaml.doc
  "\n\n\
  \   It is guaranteed that repeated calls will return nondecreasing [Time.t] values. "]

val to_time_ns : t -> calibrator:Calibrator.t -> Time_ns.t

[@@@ocaml.text "/*"]

module Private : sig
  val ewma : alpha:float -> old:float -> add:float -> float
  val of_int63 : Int63.t -> t
  val max_percent_change_from_real_slope : float
  val to_nanos_since_epoch : t -> calibrator:Calibrator.t -> t
end
