open! Core

type t =
  { prev_start : int
  ; next_start : int
  ; length : int
  }

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
