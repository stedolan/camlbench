[@@@ocaml.text
  " An alias to the [Float.t] type that causes the sexp and bin-io serializers to fail\n\
  \    when provided with [nan] or [infinity].\n\n\
  \    Note that while it makes sense to use this on the definition of a type in the ml\n\
  \    file, where it will influence the construction of the sexp and bin-io \
   serializers, it\n\
  \    does {e not} make sense to use this in an mli, since it makes no guarantee at that\n\
  \    level.\n"]

open! Import

type t = float [@@deriving bin_io, sexp, sexp_grammar, compare, hash, equal]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
  include Ppx_compare_lib.Equal.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Stable : sig
  module V1 : sig
    type nonrec t = t
    [@@deriving bin_io, sexp, sexp_grammar, compare, hash, equal, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
