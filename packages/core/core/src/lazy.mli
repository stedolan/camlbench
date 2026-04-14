[@@@ocaml.text " This module extends {{!Base.Lazy}[Base.Lazy]}. "]

open! Import

type 'a t = 'a Base.Lazy.t
[@@deriving
  bin_io ~localize, compare ~localize, hash, quickcheck, sexp, sexp_grammar, typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S_local1 with type 'a t := 'a t
  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Comparable.S_local1 with type 'a t := 'a t
  include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
  include Ppx_quickcheck_runtime.Quickcheckable.S1 with type 'a t := 'a t
  include Sexplib0.Sexpable.S1 with type 'a t := 'a t

  val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

  include Typerep_lib.Typerepable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of Base.Lazy with type 'a t := 'a t [@@ocaml.doc " @inline "]

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t [@@deriving bin_io ~localize, equal, sexp_grammar]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S_local1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Comparable.S_local1 with type 'a t := 'a t
  end
end
