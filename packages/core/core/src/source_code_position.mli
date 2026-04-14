[@@@ocaml.text
  " This module extends {{!Base.Source_code_position}[Base.Source_code_position]}. "]

include module type of struct
  include Base.Source_code_position
end
[@@ocaml.doc " @inline "]

type t = Base.Source_code_position.t =
  { pos_fname : string
  ; pos_lnum : int
  ; pos_bol : int
  ; pos_cnum : int
  }
[@@deriving fields ~getters]

include sig
  [@@@ocaml.warning "-32"]

  val pos_cnum : t -> int
  val pos_bol : t -> int
  val pos_lnum : t -> int
  val pos_fname : t -> string
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

include Comparable.S with type t := t and type comparator_witness := comparator_witness
include Hashable.S with type t := t

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving equal]

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Equal.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    include Stable_module_types.With_stable_witness.S0 with type t := t
  end
end
