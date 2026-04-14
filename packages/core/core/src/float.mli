[@@@ocaml.text " Floating-point numbers. "]

open! Import

include module type of struct
  include Base.Float
end
[@@ocaml.doc " @inline "]

type t = float [@@deriving typerep, bin_io ~localize]

include sig
  [@@@ocaml.warning "-32"]

  include Typerep_lib.Typerepable.S with type t := t
  include Bin_prot.Binable.S_local with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Robust_compare : sig
  module type S = sig
    val robust_comparison_tolerance : float
    [@@ocaml.doc " intended to be a tolerance on human-entered floats "]

    include Robustly_comparable.S with type t := float
  end

  module Make : functor
      (T : sig
         val robust_comparison_tolerance : float
       end)
      -> S
end

include
  Robust_compare.S
[@@ocaml.doc
  " So-called \"robust\" comparisons, which include a small tolerance, so that float that\n\
  \    differ by a small amount are considered equal.\n\n\
  \    Note that the results of robust comparisons on [nan] should be considered\n\
  \    undefined. "]

module O : sig
  include module type of struct
    include Base.Float.O
  end

  include Robustly_comparable.S with type t := t
end

module Robustly_comparable : Robust_compare.S

module Terse : sig
  type nonrec t = t [@@deriving bin_io ~localize]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include module type of struct
      include Base.Float.Terse
    end
    with type t := t
end

include
  Identifiable.S
  with type t := t
   and type comparator_witness := Base.Float.comparator_witness

include Comparable.Validate_with_zero with type t := t

val validate_ordinary : t Validate.check
[@@ocaml.doc " [validate_ordinary] fails if class is [Nan] or [Infinite]. "]

val to_string_12 : t -> string
[@@ocaml.doc
  " [to_string_12 x] builds a string representing [x] using up to 12 significant digits.\n\
  \    It loses precision.  You can use [\"%{Float#12}\"] in formats, but consider \
   [\"%.12g\"],\n\
  \    [\"%{Float#hum}\"], or [\"%{Float}\"] as alternatives.  "]

val to_string : t -> string
[@@ocaml.doc
  " [to_string x] builds a string [s] representing the float [x] that guarantees the round\n\
  \    trip, i.e., [Float.equal x (Float.of_string s)].\n\n\
  \    It usually yields as few significant digits as possible.  That is, it won't print\n\
  \    [3.14] as [3.1400000000000001243].  The only exception is that occasionally it will\n\
  \    output 17 significant digits when the number can be represented with just 16 (but\n\
  \    not 15 or fewer) of them. "]

include Quickcheckable.S with type t := t

val sign : t -> Sign.t
[@@deprecated "[since 2016-01] Replace [sign] with [robust_sign] or [sign_exn]"]

val robust_sign : t -> Sign.t
[@@ocaml.doc
  " (Formerly [sign]) Uses robust comparison (so sufficiently small numbers are mapped\n\
  \    to [Zero]).  Also maps NaN to [Zero]. Using this function is weakly discouraged. "]

val gen_uniform_excl : t -> t -> t Quickcheck.Generator.t
[@@ocaml.doc
  " [gen_uniform_excl lo hi] creates a Quickcheck generator producing finite [t] values\n\
  \    between [lo] and [hi], exclusive.  The generator approximates a uniform \
   distribution\n\
  \    over the interval (lo, hi).  Raises an exception if [lo] is not finite, [hi] is not\n\
  \    finite, or the requested range is empty.\n\n\
  \    The implementation chooses values uniformly distributed between 0 (inclusive) and 1\n\
  \    (exclusive) up to 52 bits of precision, then scales that interval to the requested\n\
  \    range.  Due to rounding errors and non-uniform floating point precision, the \
   resulting\n\
  \    distribution may not be precisely uniform and may not include all values between \
   [lo]\n\
  \    and [hi].\n"]

val gen_incl : t -> t -> t Quickcheck.Generator.t
[@@ocaml.doc
  " [gen_incl lo hi] creates a Quickcheck generator that produces values between [lo] and\n\
  \    [hi], inclusive, approximately uniformly distributed, with extra weight given to\n\
  \    generating the endpoints [lo] and [hi].  Raises an exception if [lo] is not finite,\n\
  \    [hi] is not finite, or the requested range is empty. "]

val gen_finite : t Quickcheck.Generator.t
[@@ocaml.doc
  " [gen_finite] produces all finite [t] values, excluding infinities and all NaN\n\
  \    values. "]

val gen_positive : t Quickcheck.Generator.t
[@@ocaml.doc " [gen_positive] produces all (strictly) positive finite [t] values. "]

val gen_negative : t Quickcheck.Generator.t
[@@ocaml.doc " [gen_negative] produces all (strictly) negative finite [t] values. "]

val gen_without_nan : t Quickcheck.Generator.t
[@@ocaml.doc
  " [gen_without_nan] produces all finite and infinite [t] values, excluding all NaN\n\
  \    values. "]

val gen_infinite : t Quickcheck.Generator.t
[@@ocaml.doc " [gen_infinite] produces both infinite values "]

val gen_nan : t Quickcheck.Generator.t
[@@ocaml.doc " [gen_nan] produces all NaN values. "]

val gen_normal : t Quickcheck.Generator.t
[@@ocaml.doc " [gen_normal] produces all normal values "]

val gen_subnormal : t Quickcheck.Generator.t
[@@ocaml.doc " [gen_subnormal] produces all subnormal values "]

val gen_zero : t Quickcheck.Generator.t
[@@ocaml.doc " [gen_zero] produces both zero values "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving equal, hash, sexp_grammar, typerep, globalize]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Typerep_lib.Typerepable.S with type t := t

      val globalize : t -> t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
       and type comparator_witness = comparator_witness
  end
end
[@@ocaml.doc
  " Note that [float] is already stable by itself, since as a primitive type it is an\n\
  \    integral part of the sexp / bin_io protocol. [Float.Stable] exists only to \
   introduce\n\
  \    [Float.Stable.Set] and [Float.Stable.Map], and provide interface uniformity with \
   other\n\
  \    stable types. "]
