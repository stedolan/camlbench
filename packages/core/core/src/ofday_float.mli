open! Import
include Ofday_intf.S with type underlying = float and module Span := Span_float

module Stable : sig
  module V1 : sig
    type nonrec t = t
    [@@deriving bin_io, compare, hash, sexp, sexp_grammar, stable_witness, diff]

    include sig
      [@@@ocaml.warning "-32-60"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t

      module Diff : sig
        open! Diffable.For_ppx

        type derived_on = t
        type t = Diff.t [@@deriving bin_io, sexp]

        include sig
          [@@@ocaml.warning "-32"]

          include Bin_prot.Binable.S with type t := t
          include Sexplib0.Sexpable.S with type t := t
        end
        [@@ocaml.doc "@inline"] [@@merlin.hide]

        val get
          :  from:derived_on
          -> to_:derived_on
          -> (t Optional_diff.t[@jane.erasable.mode local])

        val apply_exn : derived_on -> t -> derived_on
        val of_list_exn : t list -> (t Optional_diff.t[@jane.erasable.mode local])
      end
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
