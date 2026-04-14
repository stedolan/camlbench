[@@@ocaml.text
  " This module extends {{!Base.Char}[Base.Char]}, adding [Identifiable] for making char\n\
  \    identifiers and [Quickcheckable] to facilitate automated testing with pseudorandom\n\
  \    data.\n"]

type t = char [@@deriving typerep, bin_io ~localize]

include sig
  [@@@ocaml.warning "-32"]

  include Typerep_lib.Typerepable.S with type t := t
  include Bin_prot.Binable.S_local with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[@@@ocaml.text " {2 The signature included from [Base.Char]} "]

include module type of struct
    include Base.Char
  end
  with type t := t
[@@ocaml.doc " @inline "]

[@@@ocaml.text " {2 Extensions} "]

module Caseless : sig
  type nonrec t = t [@@deriving bin_io ~localize, hash, sexp]

  include sig
    [@@@ocaml.warning "-32"]

    include Bin_prot.Binable.S_local with type t := t
    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t
  end
  [@@ocaml.doc "@inline"] [@@merlin.hide]

  include Comparable.S_binable with type t := t
  include Hashable.S_binable with type t := t
end
[@@ocaml.doc
  " [Caseless] compares and hashes characters ignoring case, so that for example\n\
  \    [Caseless.equal 'A' 'a'] and [Caseless.('a' < 'B')] are [true], and\n\
  \    [Caseless.Map], [Caseless.Table] lookup and [Caseless.Set] membership is\n\
  \    case-insensitive. "]

include Identifiable.S with type t := t and type comparator_witness := comparator_witness

[@@@ocaml.text " {3 Quickcheck Support} "]

include Quickcheckable.S with type t := t

val gen_digit : t Quickcheck.Generator.t
val gen_lowercase : t Quickcheck.Generator.t
val gen_uppercase : t Quickcheck.Generator.t
val gen_alpha : t Quickcheck.Generator.t
val gen_alphanum : t Quickcheck.Generator.t
val gen_print : t Quickcheck.Generator.t
val gen_whitespace : t Quickcheck.Generator.t

val gen_uniform_inclusive : t -> t -> t Quickcheck.Generator.t
[@@ocaml.doc
  " Generates characters between the given inclusive bounds in ASCII order. Raises if\n\
  \    bounds are in decreasing order. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving equal, hash, sexp_grammar, typerep]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Typerep_lib.Typerepable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
       and type comparator_witness = comparator_witness
  end
end
