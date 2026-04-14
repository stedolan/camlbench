[@@@ocaml.text " This module extends {{!Base.Queue}[Base.Queue]} with bin_io. "]

open! Import

type 'a t = 'a Base.Queue.t [@@deriving sexp_of, bin_io]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t

  include Bin_prot.Binable.S1 with type 'a t := 'a t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

[@@@ocaml.text " {2 The interface from Base} "]

include module type of Base.Queue with type 'a t := 'a t [@@ocaml.doc " @inline "]

[@@@ocaml.text " {2 Extensions} "]

include Binary_searchable.S1 with type 'a t := 'a t

module Stable : sig
  module V1 : sig
    type nonrec 'a t = 'a t [@@deriving equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S1 with type 'a t := 'a t
  end
end
