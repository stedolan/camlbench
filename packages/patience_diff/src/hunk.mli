[@@@ocaml.text
  " In diff terms, a hunk is a unit of consecutive ranges with some [Same] context before\n\
  \    and after [Next], [Prev], and [Replace] ranges.  Each hunk contains information \
   about\n\
  \    the original arrays, specifically the starting indexes and the number of elements \
   in\n\
  \    both arrays to which the hunk refers.\n\n\
  \    Furthermore, a diff is essentially a list of hunks.  The simplest case is a diff \
   with\n\
  \    infinite context, consisting of exactly one hunk. "]

open! Core

type 'a t =
  { prev_start : int
  ; prev_size : int
  ; next_start : int
  ; next_size : int
  ; ranges : 'a Range.t list
  }
[@@deriving fields ~getters, sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val ranges : 'a t -> 'a Range.t list
  val next_size : 'a t -> int
  val next_start : 'a t -> int
  val prev_size : 'a t -> int
  val prev_start : 'a t -> int
  val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val all_same : 'a t -> bool
[@@ocaml.doc " [all_same t] returns true if [t] contains only Same ranges. "]

val concat_map : 'a t -> f:('a Range.t -> 'b Range.t list) -> 'b t
[@@ocaml.doc " [concat_map t ~f] applies [List.concat_map] on [t.ranges]. "]

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
