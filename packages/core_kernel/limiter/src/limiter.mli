[@@@ocaml.text
  " Implements a token-bucket-based throttling rate limiter. This module is useful for\n\
  \    limiting network clients to a sensible query rate, or in any case where you have \
   jobs\n\
  \    that consume a scarce but replenishable resource.\n\n\
  \    In a standard token bucket there is an infinite incoming supply of tokens that \
   fill a\n\
  \    single bucket.\n\n\
  \    This version implements a closed system where tokens move through three possible\n\
  \    states:\n\n\
  \    {ul\n\
  \    {- in hopper}\n\
  \    {- in bucket}\n\
  \    {- in flight}}\n\n\
  \    Tokens \"drop\" from the hopper into the bucket at a set rate, and can be taken \
   from\n\
  \    the bucket by clients and put into flight. Once the client is finished with \
   whatever\n\
  \    tokens are required for its task, it is responsible for moving them from \"in \
   flight\"\n\
  \    back into the hopper.\n\n\
  \    Most use cases are covered by the [Token_bucket], [Throttle], and\n\
  \    [Throttled_rate_limiter] modules, but the [Expert] module provides full access\n\
  \    to the module internals.\n\n\
  \    This interface is the simple, non-concurrent interface, and requires machinery on \
   top\n\
  \    to implement a specific strategy.  See [Limiter_async] for an async-friendly\n\
  \    implementation on top of this module.\n\n\
  \    Most functions in this interface take an explicit time as an argument. [now] is\n\
  \    expected to be monotonically increasing. [now]'s that are set in the past are\n\
  \    effectively moved up to the current time of the bucket. "]

open! Core
open! Import

type t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

type limiter = t [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_limiter : limiter -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Infinite_or_finite : sig
  type 'a t =
    | Infinite
    | Finite of 'a
  [@@deriving sexp, bin_io, compare]

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
    include Bin_prot.Binable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Try_take_result : sig
  type t =
    | Taken
    | Unable
    | Asked_for_more_than_bucket_limit
end

module Try_return_to_bucket_result : sig
  type t =
    | Returned_to_bucket
    | Unable
end

module Tokens_may_be_available_result : sig
  type t =
    | At of Time_ns.t
    | Never_because_greater_than_bucket_limit
    | When_return_to_hopper_is_called
end

module Try_reconfigure_result : sig
  type t =
    | Reconfigured
    | Unable
  [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]
end

module Token_bucket : sig
  type t = private limiter [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create_exn
    :  now:Time_ns.t
    -> burst_size:int
    -> sustained_rate_per_sec:float
    -> ?initial_bucket_level:int
    -> unit
    -> t
  [@@ocaml.doc " @param initial_bucket_level defaults to zero. "]

  val try_take : t -> now:Time_ns.t -> int -> Try_take_result.t

  module Starts_full : sig
    type nonrec t = private t [@@deriving sexp_of]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val create_exn : now:Time_ns.t -> burst_size:int -> sustained_rate_per_sec:float -> t
    [@@ocaml.doc
      " A [Token_bucket.Starts_full.t] is a [Token_bucket.t] that is statically guaranteed\n\
      \        to have been called with [initial_bucket_level] equal to [burst_size].  The\n\
      \        advantage of such a guarantee is that there's a clear semantics for \
       increasing the\n\
      \        bucket limit (implemented in [try_increase_bucket_limit]).\n\n\
      \        This is not to say that other subtypes of [Limiter.t] don't have reasonable\n\
      \        semantics for increasing their limits in some way, but [Limiter.t] is \
       general\n\
      \        enough that they should probably be considered on a case-by-case basis. "]

    val try_reconfigure
      :  t
      -> burst_size:int
      -> sustained_rate_per_sec:float
      -> allow_limit_decrease:bool
      -> Try_reconfigure_result.t
    [@@ocaml.doc
      " Increases the [bucket_limit] and the current [bucket_level] by the difference\n\
      \        between the current and new bucket limits. Decreasing the bucket_limit \
       may cause\n\
      \        the [bucket_level] to become negative, breaking an invariant. If the new \
       limit\n\
      \        would cause [bucket_level] to become negative, [Unable] is returned. "]
  end
end
[@@ocaml.doc
  " Implements a basic token-bucket-based rate limiter. Users of the throttle\n\
  \    must successfully call [try_take] before doing work. "]

module Throttle : sig
  type t = private limiter [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create_exn : now:Time_ns.t -> max_concurrent_jobs:int -> t
  val try_start_job : t -> now:Time_ns.t -> [ `Start | `Max_concurrent_jobs_running ]
  val finish_job : t -> now:Time_ns.t -> unit
end
[@@ocaml.doc
  " Implements a basic throttle.  Users of the throttle must successfully call [start_job]\n\
  \    before beginning work and must call [finish_job] once, and only once, when a job is\n\
  \    completed. "]

module Throttled_rate_limiter : sig
  type t = private limiter [@@deriving sexp_of]

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  val create_exn
    :  now:Time_ns.t
    -> burst_size:int
    -> sustained_rate_per_sec:float
    -> max_concurrent_jobs:
         (int
         [@ocaml.doc
           " Limits concurrency per time quantum.  Any job started during a time quantum\n\
           \        ([try_start_job ~now]) or earlier and not stopped in an earlier \
            quantum counts\n\
           \        toward the concurrency limit.\n\n\
           \        In particular, [finish_job ~now] never prevents a job from counting \
            toward\n\
           \        [~now]'s concurrency limit. "])
    -> t

  val try_start_job
    :  t
    -> now:Time_ns.t
    -> [ `Start | `Max_concurrent_jobs_running | `Unable_until_at_least of Time_ns.t ]

  val finish_job : t -> now:Time_ns.t -> unit
  [@@ocaml.doc
    " Return a token to the {e hopper} (not the bucket).  Thus, [max_concurrent_jobs]\n\
    \      limits not only the number of open [try_start_job]-[finish_job] pairs across \
     time,\n\
    \      but also applies to the number of jobs run during the same (1ns) quantum time\n\
    \      [now] - whether they finished [now] or not, and regardless of what order\n\
    \      [finish_job] is called for the same time [now]. "]
end
[@@ocaml.doc
  " A [Throttled_rate_limiter] combines a [Token_bucket] and a [Throttle].  Unlike a\n\
  \    [Token_bucket], jobs cannot consume variable numbers of tokens, but the number of\n\
  \    outstanding jobs is also limited to [max_concurrent_jobs].  Like a [Throttle],\n\
  \    [finish_job] must be called once, and only once, when a job is completed. "]

[@@@ocaml.text " {2 Common read-only operations} "]

val bucket_limit : t -> int

val in_bucket : t -> now:Time_ns.t -> int
[@@ocaml.doc " Tokens available to immediately take. "]

val in_hopper : t -> now:Time_ns.t -> int Infinite_or_finite.t
[@@ocaml.doc " Tokens waiting to drop at the [hopper_to_bucket_rate_per_sec]. "]

val in_flight : t -> now:Time_ns.t -> int
[@@ocaml.doc " Tokens that have been taken, but not yet returned. "]

val in_limiter : t -> now:Time_ns.t -> int Infinite_or_finite.t
[@@ocaml.doc " Total number of tokens in the limiter [in_hopper + in_bucket]. "]

val in_system : t -> now:Time_ns.t -> int Infinite_or_finite.t
[@@ocaml.doc
  " Total number of tokens in the entire system [in_hopper + in_bucket + in_flight]. "]

val hopper_to_bucket_rate_per_sec : t -> float Infinite_or_finite.t
[@@ocaml.doc
  " Note that this isn't guaranteed to be equal to the [rate_per_sec] that was passed in\n\
  \    to the constructor, due to floating point error. "]

module Expert : sig
  val create_exn
    :  now:Time_ns.t
    -> hopper_to_bucket_rate_per_sec:float Infinite_or_finite.t
    -> bucket_limit:int
    -> in_flight_limit:int Infinite_or_finite.t
    -> initial_bucket_level:int
    -> initial_hopper_level:int Infinite_or_finite.t
    -> t
  [@@ocaml.doc
    " @param now is the reference time that other time-accepting functions will use when\n\
    \      they adjust [now]. It is almost always correct to set this to [Time_ns.now].\n\n\
    \      @param hopper_to_bucket_rate_per_sec bounds the maximum rate at which tokens \
     fall\n\
    \      from the hopper into the bucket where they can be taken.\n\n\
    \      @param bucket_limit bounds the number of tokens that the lower bucket can hold.\n\
    \      This corresponds to the maximum burst in a standard token bucket setup.\n\n\
    \      @param in_flight_limit bounds the number of tokens that can be in flight. This\n\
    \      corresponds to a running job limit/throttle.\n\n\
    \      @param initial_hopper_level sets the number of tokens placed into the hopper \
     when\n\
    \      the [Limiter] is created.\n\n\
    \      @param initial_bucket_level sets the number of tokens placed into the bucket \
     when\n\
    \      the [Limiter] is created. If this amount exceeds the bucket size it will be \
     silently\n\
    \      limited to [bucket_limit].\n\n\
    \      These tunables can be combined in several ways:\n\n\
    \      {ul\n\n\
    \      {- to produce a simple rate limiter, where the hopper is given an infinite \
     number of\n\
    \      tokens and clients simply take tokens as they are delivered to the bucket.}\n\n\
    \      {- to produce a rate limiter that respects jobs that are more than \
     instantaneous.\n\
    \      In this case [initial_hopper_level + initial_bucket_level] should be bounded \
     and\n\
    \      clients hold tokens for the duration of their work.}\n\n\
    \      {- to produce a throttle that doesn't limit the rate of jobs at all, but always\n\
    \      keeps a max of n jobs running. In this case [hopper_to_bucket_rate_per_sec] \
     should\n\
    \      be infinite but [in_flight_limit] should be bounded to the upper job rate.}}\n\n\
    \      In every case above, throttling and rate limiting combine nicely when the \
     unit of\n\
    \      work for both is the same (e.g., one token per message). If the unit of work is\n\
    \      different (e.g., rate limit based on a number of tokens equal to message \
     size, but\n\
    \      throttle based on simple message count) then a single [t] probably cannot be \
     used to\n\
    \      get the correct behavior, and two instances should be used with tokens taken \
     from\n\
    \      both. "]

  val tokens_may_be_available_when
    :  t
    -> now:Time_ns.t
    -> int
    -> Tokens_may_be_available_result.t
  [@@ocaml.doc
    " Returns the earliest time when the requested number of tokens could possibly be\n\
    \      delivered. There is no guarantee that the requested number of tokens will \
     actually\n\
    \      be available at this time. You must call [try_take] to actually attempt to \
     take the\n\
    \      tokens. "]

  val try_take : t -> now:Time_ns.t -> int -> Try_take_result.t
  [@@ocaml.doc
    " Attempts to take the given number of tokens from the bucket. [try_take t ~now n]\n\
    \      succeeds iff [in_bucket t ~now >= n]. "]

  val return_to_hopper : t -> now:Time_ns.t -> int -> unit
  [@@ocaml.doc
    " Returns the given number of tokens to the hopper. These tokens will fill the\n\
    \      tokens available to [try_take] at the [fill_rate]. Note that if [return] is\n\
    \      called on more tokens than have actually been removed, it can cause the number\n\
    \      of concurrent jobs to exceed [max_concurrent_jobs]. "]

  val try_return_to_bucket : t -> now:Time_ns.t -> int -> Try_return_to_bucket_result.t
  [@@ocaml.doc
    " Returns the given number of tokens directly to the bucket. If the amount\n\
    \      is negative, is more than is currently in flight, or if moving the amount would\n\
    \      cause the bucket to surpass its [bucket_limit], [Unable] is returned. "]
end
[@@ocaml.doc " Expert operations. "]

include Invariant.S with type t := t
