[@@@ocaml.text " This module extends {{!Base.Int63}[Base.Int63]}. "]

[@@@ocaml.text " {2 Interface from Base} "]

include module type of struct
  include Base.Int63
end
[@@ocaml.doc " @inline "]

[@@@ocaml.text " {2 Extensions} "]

include
  Int_intf.Extension with type t := t and type comparator_witness := comparator_witness
[@@ocaml.doc " @inline "]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@immediate64] [@@deriving equal, hash, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_comparable.With_stable_witness.V1
      with type t := t
       and type comparator_witness = comparator_witness
  end
end
