type t =
  | Move of Move_id.t
  | Within_move of Move_id.t
[@@ocaml.doc
  " If a given range is part of a move it will have a [Move_kind.t].\n\
  \    If the move is simple with no ranges there will just be two ranges:\n\
  \    One [Prev] and one [Next] that share the same [Move MOVE_INDEX]\n\
  \    where the index is used to identify a given move as the same.\n\n\
  \    If the move has modifications like additions and deletions then the\n\
  \    [Next] part of the move will have replaces with [Within_move MOVE_INDEX]\n\
  \    to denote they are just modifications to the moved code.\n"]
[@@deriving sexp]

include sig
  [@@@ocaml.warning "-32"]

  include Sexplib0.Sexpable.S with type t := t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

module Stable : sig
  module V1 : sig
    type nonrec t = t [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t
      include Bin_prot.Binable.S with type t := t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end
end
