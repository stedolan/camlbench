[@@@ocaml.text
  " A splittable pseudo-random number generator (SPRNG) functions like a PRNG in that it\n\
  \    can be used as a stream of random values; it can also be \"split\" to produce a \
   second,\n\
  \    independent stream of random values.\n\n\
  \    This module implements a splittable pseudo-random number generator that sacrifices\n\
  \    cryptographic-quality randomness in favor of performance.\n\n\
  \    The primary difference between [Splittable_random] and {!Random} is the [split]\n\
  \    operation for generating new pseudo-random states.  While it is easy to simulate\n\
  \    [split] using [Random], the result has undesirable statistical properties; the\n\
  \    new state does not behave independently of the original.  It is better to switch to\n\
  \    [Splittable_random] if you need an operation like [split], as this module has\n\
  \    been implemented with the statistical properties of splitting in mind.  For most \
   other\n\
  \    purposes, [Random] is likely a better choice, as its implementation passes all \
   Diehard\n\
  \    tests, while [Splittable_random] fails some Diehard tests.\n"]

open! Base

type t

val create : Random.State.t -> t
[@@ocaml.doc
  " Create a new [t] seeded from the given random state. This allows nondeterministic\n\
  \    initialization, for example in the case that the input state was created using\n\
  \    [Random.make_self_init].\n\n\
  \    Constructors like [create] and [of_int] should be called once at the start of a\n\
  \    randomized computation and the resulting state should be threaded through.\n\
  \    Repeatedly creating splittable random states from seeds in the middle of \
   computation\n\
  \    can defeat the SPRNG's splittable properties. "]

val of_int : int -> t
[@@ocaml.doc
  " Create a new [t] that will return identical results to any other [t] created with\n\
  \    that integer. "]

val perturb : t -> int -> unit
[@@ocaml.doc " [perturb t salt] adds the entropy of [salt] to [t]. "]

val copy : t -> t
[@@ocaml.doc " Create a copy of [t] that will return the same random samples as [t]. "]

val split : t -> t
[@@ocaml.doc
  " [split t] produces a new state that behaves deterministically (i.e. only depending\n\
  \    on the state of [t]), but pseudo-independently from [t]. This operation mutates\n\
  \    [t], i.e., [t] will return different values than if this hadn't been called. "]

module State : sig
  type nonrec t = t

  val create : Random.State.t -> t
  val of_int : int -> t
  val perturb : t -> int -> unit
  val copy : t -> t
  val split : t -> t
end
[@@ocaml.doc " Legacy aliases for the preceding definitions. "]
[@@deprecated
  "[since 2023-10] There is no longer any need to use [Splittable_random.State]. Its \
   definitions are now included directly in [Splittable_random]."]

val bool : t -> bool [@@ocaml.doc " Produces a random, fair boolean. "]

val int : t -> lo:int -> hi:int -> int
[@@ocaml.doc
  " Produce a random number uniformly distributed in the given inclusive range.  (In the\n\
  \    case of [float], [hi] may or may not be attainable, depending on rounding.)  "]

val int32 : t -> lo:int32 -> hi:int32 -> int32
val int63 : t -> lo:Int63.t -> hi:Int63.t -> Int63.t
val int64 : t -> lo:int64 -> hi:int64 -> int64
val nativeint : t -> lo:nativeint -> hi:nativeint -> nativeint
val float : t -> lo:float -> hi:float -> float

val unit_float : t -> float
[@@ocaml.doc
  " [unit_float state = float state ~lo:0. ~hi:1.], but slightly more efficient (and\n\
  \    right endpoint is exclusive). "]

module Log_uniform : sig
  val int : t -> lo:int -> hi:int -> int
  [@@ocaml.doc
    " Produce a random number in the given inclusive range, where the number of bits in\n\
    \      the representation is chosen uniformly based on the given range, and then the \
     value\n\
    \      is chosen uniformly within the range restricted to the chosen bit width. \
     Raises if\n\
    \      [lo < 0 || hi < lo].\n\n\
    \      These functions are useful for choosing numbers that are weighted low within \
     a given\n\
    \      range. "]

  val int32 : t -> lo:int32 -> hi:int32 -> int32
  val int63 : t -> lo:Int63.t -> hi:Int63.t -> Int63.t
  val int64 : t -> lo:int64 -> hi:int64 -> int64
  val nativeint : t -> lo:nativeint -> hi:nativeint -> nativeint
end
