open! Import
include Time_ns_intf.Ofday with module Span := Span_ns

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving equal, hash, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include
      Stable_int63able.With_stable_witness.S
      with type t := t
       and type comparator_witness = comparator_witness

    include Diffable.S_atomic with type t := t
  end

  module Option : sig end [@@deprecated "[since 2021-02] Use [Time_ns_unix.Stable]"]
  module Zoned : sig end [@@deprecated "[since 2021-02] Use [Time_ns_unix.Stable]"]
end
