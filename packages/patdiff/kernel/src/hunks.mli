open! Core
open! Import

type t = string Patience_diff.Hunk.t list [@@deriving sexp_of]

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@ocaml.doc "@inline"] [@@merlin.hide]

val iter'
  :  f_hunk_break:(string Patience_diff.Hunk.t -> unit)
  -> f_line:(string -> unit)
  -> t
  -> unit

val iter
  :  f_hunk_break:(int * int -> int * int -> unit)
  -> f_line:(string -> unit)
  -> t
  -> unit
