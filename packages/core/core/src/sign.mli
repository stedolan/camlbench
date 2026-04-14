[@@@ocaml.text " This module extends {{!Base.Sign}[Base.Sign]} with bin_io. "]

open! Import

type t = Base.Sign.t =
  | Neg
  | Zero
  | Pos
[@@deriving typerep]

include sig
  [@@@ocaml.warning "-32"]

  include Typerep_lib.Typerepable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include module type of Base.Sign with type t := t [@@ocaml.doc " @inline "]

include
  Identifiable.S with type t := t and type comparator_witness := comparator_witness
[@@ocaml.doc
  " This provides [to_string]/[of_string], sexp/bin_io conversion, Map, Hashtbl, etc. "]

module Stable : sig
  module V1 : sig
    type nonrec t = t =
      | Neg
      | Zero
      | Pos
    [@@deriving bin_io, compare, hash, sexp]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
