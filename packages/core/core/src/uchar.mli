[@@@ocaml.text
  " This module extends {{!Base.Uchar}[Base.Uchar]}, adding [Comparable] and [Hashable]\n\
  \    functionality, [bin_io] support, and [Quickcheckable] to facilitate automated \
   testing\n\
  \    with pseudorandom data. "]

type t = Base.Uchar.t [@@deriving bin_io]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[@@@ocaml.text " {2 The signature included from [Base.Uchar]} "]

include module type of struct
    include Base.Uchar
  end
  with type t := t
[@@ocaml.doc " @inline "]

include
  Comparable.S_binable with type t := t and type comparator_witness := comparator_witness

include Hashable.S_binable with type t := t

[@@@ocaml.text " {2 Quickcheck Support} "]

include Quickcheckable.S with type t := t

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving bin_io, equal, hash, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
      with type comparator_witness = comparator_witness

    include Hashable.Stable.V1.With_stable_witness.S with type key := t
  end
end
