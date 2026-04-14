open! Import
include Time_ns_intf.Span

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving hash, equal, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_int63able.With_stable_witness.S with type t := t
    include Diffable.S_atomic with type t := t
  end

  module Option : sig
    module V1 : sig
      include Stable_int63able.With_stable_witness.S with type t = t
      include Diffable.S_atomic with type t := t
    end

    module V2 : sig
      include Stable_int63able.With_stable_witness.S with type t = t
      include Diffable.S with type t := t and type Diff.t = t
    end
  end

  module V2 : sig
    type nonrec t = t [@@deriving hash, equal, sexp_grammar, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    type nonrec comparator_witness = comparator_witness

    include
      Stable_int63able.With_stable_witness.S
      with type t := t
      with type comparator_witness := comparator_witness

    include
      Comparable.Stable.V1.With_stable_witness.S
      with type comparable := t
      with type comparator_witness := comparator_witness

    include Stringable.S with type t := t
    include Diffable.S_atomic with type t := t
  end
end
