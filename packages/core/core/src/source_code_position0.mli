open! Import

include module type of struct
  include Base.Source_code_position
end

type t = Base.Source_code_position.t =
  { pos_fname : string
  ; pos_lnum : int
  ; pos_bol : int
  ; pos_cnum : int
  }
[@@deriving bin_io, compare, fields ~getters, hash, sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Bin_prot.Binable.S with type t := t
  include Ppx_compare_lib.Comparable.S with type t := t

  val pos_cnum : t -> int
  val pos_bol : t -> int
  val pos_lnum : t -> int
  val pos_fname : t -> string

  include Ppx_hash_lib.Hashable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving bin_io, compare, equal, hash, sexp, stable_witness]

    include sig
      [@@@ocaml.warning "-32"]

      include Bin_prot.Binable.S with type t := t
      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val stable_witness : t Ppx_stable_witness_runtime.Stable_witness.t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Comparator.Stable.V1.S with type t := t
  end
end
