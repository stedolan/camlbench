[@@@ocaml.text " This module extends {{!Base.Nothing}[Base.Nothing]}. "]

open! Import

include module type of struct
  include Base.Nothing
end
[@@ocaml.doc " @inline "]

include
  Identifiable.S with type t := t and type comparator_witness := comparator_witness
[@@ocaml.doc
  " It may seem weird that this is identifiable, but we're just trying to anticipate all\n\
  \    the contexts in which people may need this. It would be a crying shame if you had \
   some\n\
  \    variant type involving [Nothing.t] that you wished to make identifiable, but were\n\
  \    prevented for lack of [Identifiable.S] here.\n\n\
  \    Obviously, [of_string] and [t_of_sexp] will raise an exception. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t
    [@@deriving
      bin_io, compare, enumerate, equal, hash, sexp, stable_witness, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_enumerate_lib.Enumerable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
