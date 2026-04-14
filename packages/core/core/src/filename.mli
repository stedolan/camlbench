open! Import
open! Std_internal
include module type of Filename_base
include Binable.S_local with type t := t
include Comparable.S with type t := t and type comparator_witness := comparator_witness
include Hashable.S with type t := t

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving bin_io ~localize, equal, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

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
