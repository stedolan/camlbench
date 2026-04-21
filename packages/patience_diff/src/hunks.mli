open! Core

type 'a t = 'a Hunk.t list

val unified : 'a t -> 'a t
[@@ocaml.doc
  " [unified t] converts all Replace ranges in [t] to an Prev range followed by a Next\n\
  \    range. "]

val ranges : 'a t -> 'a Range.t list
[@@ocaml.doc " [ranges t] concatenates all the ranges of all hunks together *"]

val concat_map_ranges : 'a t -> f:('a Range.t -> 'b Range.t list) -> 'b t

module Stable : sig
  module V2 : sig
    type nonrec 'a t = 'a t [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
      include Bin_prot.Binable.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]
  end

  module V1 : sig
    type nonrec 'a t [@@deriving sexp, bin_io]

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
      include Bin_prot.Binable.S1 with type 'a t := 'a t
    end
    [@@ocaml.doc "@inline"] [@@merlin.hide]

    val to_v2 : 'a t -> 'a V2.t
    val of_v2_no_moves_exn : 'a V2.t -> 'a t
  end
end
